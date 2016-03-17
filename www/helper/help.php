<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: help.php 291 2015-01-05 10:16:48Z otto $
* @package		OpenAdmin.nl
* @author     Frank Kooger
* @copyright	Copyright (C) 2005 - 2009 Open Source Matters. All rights reserved.
* @license		GNU/GPL, see LICENSE.php
* OpenAdmin.nl is free software. This version may have been modified pursuant
* to the GNU General Public License, and as distributed it includes or
* is derivative of works licensed under the GNU General Public License or
* other free or open source software licenses.
* See COPYRIGHT.php for copyright notices and details.
*/

/**
 *
 * %%abstract%%
 *
 * @abstract
 * @package		OpenAdmin.nl
 * @since		1.0
 */
include("../../lib/_init.inc");
require("_help.lib");

$help = new Helptopic(1);

$p = new Params(array(
                      'aktie'=>''
                     ,'code'=>''
                     ,'link'=>''
                     ,'titel'=>''
                     ,'rubriek'=>''
                     ,'tekst'=>''
                     ,'oricode'=>''
                     ,'mode'=>''
                     ,'command'=>''
                     ) );

printrc1($p);
/**
 helpssysteem
 de backenduser kan ook helpteksten editen en nieuw maken
 de datastructuur van de helprecords is:

    HELPcode   	varchar(64)
    HELPrubriek varchar(32)
    HELPlink    varchar(32)
    HELPtitel  	varchar(64)
    HELPtext  	text

  - HELPcode bevat de code die bij de helpbutton in het scherm is opgeslagen
    (meestel a1, b3 etc.)

  - HELPrubriek is een veld dat gebruikt kan worden om de verzameling
    helprecords te groeperen in de Index of een print-out

  - HELPlink bevat evt de code van een ander record. Als een link is ingevuld
    wordt dat record geladen.
  
  - HELPtitel bevat de titel van het helpitem. 
  
  - Als een helpitem wordt opgevraagd gebeurt dat o.b.v. de inoud van HELPcode.
    Helaas kan dat niet anders.
  
*/

// Als command=opslaan dan komen we vanuit het edit scherm en moet het record worden ge-update.
if($p->command == 'opslaan') $p->aktie='opslaan';

// Als een code binnenkomt met een punt dan is dat een combinatie van HELPrubriek.HELPcode. Haal ze uit elkaar.
// Repareer tevens of er evt geen 2 punten in voorkomen. Dit kan per ongeluk het geval zijn.
if($ar = $help->sep($p->code)) list($p->rubriek, $p->code) = $ar;

// Akties verwerken
//
switch($p->aktie) {
  case 'index' :
    break;
  case 'verwijder' :
    if($help->delete($p))
      $help->fillGeenRecord($p);
    break;
  case 'nieuw' : 
    // is dit een opslag vanuit nieuw?
    // dan eerst het record nieuw aanmaken en vervolgens onmiddelijk met de
    // edit functie weer opvragen en in editmode beschikbaar stellen
    if($help->nieuw($p))
      $help->onbekend = false;
    break;
  case 'opslaan' : 
    // is dit een opslag vanuit edit?
    // dan eerst het aangeboden record opslaan
    if($help->save($p))
      $help->onbekend = false;
    // zet aktie leeg voor het geval dit een link is. Een link wordt niet geladen indien aktie != ''
    $p->aktie = '';
    break;
  case 'edit' :
    // laad het helpobject
    if($p->code) $help->load($p);
    // laad tinymce editor
    $render->iscript[] = "/tinymce/jscripts/tiny_mce/tiny_mce.js";
    $render->iscript[] = "/helper/tiny_mce.js";
    break;
  default : 
    // Ingeval geen aktie en wel een code aangeboden, kijk of een record met
    // die HELPcode bestaat. Zo niet dan tonen we de 'nieuw' knop.
    $help->onbekend = ($help->exists($p)) ? false : true;
    if($help->onbekend) {
      $help->fill($p);
      // Indien item locaak niet gevonden dan online kijken of het beschikbaar is
      $help->getRemote($p);
      if(!$help->HELPtext)
        $help->HELPtext = $help->Nope();
    }
    break;
}

if(!$help->onbekend) {
  $help->load($p);
}

// Index gevraagd
//
if(empty($p->code) && $p->titel=="_helpindex" ){
  $help->HELPtitel = 'Help-index';

  $help->Do_query("SELECT * FROM HELP order by HELPrubriek,HELPtitel;",'',basename(__FILE__).'::'.__METHOD__.'::'.__LINE__);
  $tmp = '';
  while($arr = $help->Do_assoc()) {
    if($arr['HELPrubriek'] != $tmp) {
      //$help->HELPtext .= ($arr['HELPrubriek'] == $p->rubriek) ?
      $help->HELPtext .= (true) ?
        "<div style='padding:12px 0px 2px;'><a name='{$arr['HELPrubriek']}' style='font-size:115%;text-decoration:none;color:black;'>{$arr['HELPrubriek']}</a></div>\r\n" :
        "<div style='padding:12px 0px 2px; font-size:115%;'>{$arr['HELPrubriek']}</div>\r\n";
    }
    $help->HELPtext .= "<div style='padding-left:10px;'><a href='{$_SERVER['PHP_SELF']}?code={$arr['HELPrubriek']}.{$arr['HELPcode']}'>{$arr['HELPtitel']}</a></div>\r\n";
    $tmp = $arr['HELPrubriek'];
  }

}
// TODO pop-up link-picker
//
// Routine om te zien of het aangeboden record een link is naar een ander
// record. Indien waar: laadt dat andere link maar sla ook de gegevens op van
// het origineel gevraagde record.
  if(! empty($help->HELPlink) && $p->aktie == '') { // is een link
    if($ar = $help->sep($help->HELPlink)) list($rubriek, $code) = $ar;
    else { // HELPlink is geen samengestelde rubriek.code dus wrsch alleen code
      $code = $help->HELPlink; $rubriek = '';
    }
    $help->orilink = $help->HELPlink;
    $help->oricode = $help->HELPrubriek.'.'.$help->HELPcode;
    if(! $obj=$help->Get_object("SELECT * FROM \"HELP\" WHERE \"HELPcode\"='{$code}' AND \"HELPrubriek\"='{$rubriek}' ",'',basename(__FILE__).'::'.__METHOD__.'::'.__LINE__) ) {
      $help->HELPtitel = 'Geen help beschikbaar';
      $help->HELPtext = "<p style='margin-top:16px;'><center><b>Sorry, het gelinkte helprecord is niet beschikbaar.</b></center></p>";
    }
    else { // Het gelinkte record is gevonden, laad dat
      $help->fill($obj);
    }
  }

// buttons

if($p->titel!="_helpindex") {
  $help->indexButton();
}

// Welke extra buttons krijgt de administrator
//
if($help->administrator) {
  if($p->aktie == "edit") {
    $help->opslaanButton($p);
    $help->terugVanWijzigButton();
    $help->verwijderButton($p);
  }
  else if($help->onbekend && $p->titel!="_helpindex") {
    // er is een code aangeboden vanuit het applicatiescherm maar het is niet gevonden in de database
    // Als tekst vanuit online wordt getoond, dan geen nieuw button tonen
    if(!$help->discardNieuw)
    $help->nieuwButton($p);
  }
  else if($p->titel=="_helpindex") {
    // de index is gevraagd, hier willen we een terug button
    $help->terugButton($p);
  }
  else {
    // er is een code aangeboden vanuit het applicatiescherm en het is gevonden in de database
    $help->wijzigButton($p);
    if($help->oricode) { 
      // dit topic is een link naar een ander scherm dat betekent dat het
      // andere record wordt geladen en gewijzigd. Deze knop is voor het
      // wijzigen van de link in het originele record.
      $help->wijzigLinkButton();
    }
  }
}

// als laatste is er altijd button sluiten
//
$help->sluitenButton();

// end buttonrow

// start output

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^?]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->dprint .= "  <div id='apDiv0'>";

$form->formStart('frm1', $again,
                   array(
                          'aktie'=>''
                         ,'rubriek'=>"{$p->rubriek}"
                         ,'code'=>"{$help->HELPcode}"
                         ,'oricode'=>"{$help->oricode}"
                         ,'orilink'=>"{$help->orilink}"
                         ) );

$form->dprint .= "  </div>";

// Print de body van een normaal of een edit-helpitem
// Om dit te doen moet de buttonstring al gevuld zijn
//
if($p->aktie == 'edit' && $p->titel!="_helpindex") {
  $help->HELPcode = (isset($help->oricode)) ? $help->HELPcode."->".$help->orilink : $help->HELPcode;
  $help->renderEditform($form);
}
else
  $help->renderNormal($form);


// JAVASCRIPT

$render->jscript =<<<EOT

function index(){
  document.location.href='help.php?aktie=index&titel=_helpindex&rubriek={$help->HELPrubriek}#{$help->HELPrubriek}';
}

function terug() {
  history.go(-1);
}

function edit(code,oricode) {
  if(code != "") {
    document.location.href='help.php?aktie=edit&code='+code+'&oricode='+oricode;
  }
}
  
function editlink(code,titel) {
  if(code != "") {
    document.location.href='help.php?aktie=edit&code='+code+'&titel='+titel+'&mode=link';
  }
}
  
function nieuw(code,titel) {
  if(code != "") {
    document.location.href='help.php?aktie=nieuw&code='+code+'&titel='+titel;
  }
}

function terugVanWijzig(code) {
  if(confirm("Als je tekst hebt gewijzigd en je gaat terug is de gewijzigde tekst verloren!\\nWeet je zeker dat je terug wilt gaan?!")) {
    if(code != "") {
      document.location.href='help.php?code='+code;
    }
    return(true);
  }
  else
    return(false);
}

function verwijder(code,titel) {
  if(confirm("Weet je zeker dat je dit record wilt verwijderen?!")) {
    if(code != "") {
      document.location.href='help.php?aktie=verwijder&code='+code+'&titel='+titel;
    }
    return(true);
  }
  else
    return(false);
}

EOT;

$render->extra_styles .=<<<EOT

#apDiv0 {
  position:relative;
  width:445px;
  height:0px;
  z-index:-1;
  background-color:blue;
}
#apDiv1 {
  position:relative;
  top:0px;
  width:450px;
  min-height:32px;
  z-index:2;
  background-color:red;
}
#apDiv2 {
  position:relative;
/*  top:35px; */
  width:445px;
  min-height:79%;
  z-index:3;
}
#apDiv3 {
  position:relative;
/*  top:372px; */
  width:445px;
  height:32px;
  z-index:4;
  background-color:blue;
}
#apDiv4 {
  position:relative;
  width:445px;
  height:18;
  z-index:5;
}

#apDiv0,#apDiv1,#apDiv2,#apDiv3,#apDiv4 {
  position:static;
  left:0px;
  width:100%;
  padding:0px;
  margin:0px;
}

#container {
  border:0px solid black;
  position:relative;
  left:0px;
  top:0px;
  width:100%;
  height:100%;
  z-index:1;
}

.innerC,.innerD {
  margin:0px;
  padding:6px;
}
.innerD {
  font-family:"Lucida Sans Unicode", "Lucida Grande", sans-serif;
  font-size: 12px;
}
body,#container,#actionForm {
  margin:0px;
  padding:0px;
}
p {
  margin:0px;
  padding:1px 4px 0px;
}
li {
  padding:0px 0px 4px;
  font-size:100%;
  list-style-type: square;
}

EOT;

$render->onload .= "window.focus();";

$render->output();

// __EOF__