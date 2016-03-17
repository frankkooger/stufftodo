<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _inkoopfacturenlookup.inc 215 2011-09-25 18:54:41Z otto $
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

// no direct access
defined('_JEXEC') or die('Restricted access');

$render->body .= "\n          <!-- inkoopfacturenlookup.inc -->\n";
$render->subtitle[] = "inkoopfacturenlookup.inc";
$render->titel = "Openstaande inkoopfacturen overzicht";


// HOUSEKEEPING
//
// controleer of alle rkg koppelingen en rekeningen bestaan en koppel deze aan defaults
//
$defaults = array("crediteuren" => $stam->existRekening('rkg_crediteuren'));
      
// Gegevens opvragen
//
// Overzicht van nog niet (volledig) betaalde facturen
// Als een leeg relatieid wordt aangeboden, komt een leeg array terug
//
$arr = $crediteur->fetchNietBetaaldeFacturen($p->relatieid);
/*
printrc1($arr);
Array
(
    [0] => stdClass Object
        (
            [crediteurid] => 3
            [code] => xs4all
            [naam] => XS4All
            [factuurid] => 46
            [journaalid] => 82
            [datum] => 07-01-2009
            [omschrijving] => ADSL Basic 6-01/6-02
            [factuurbedrag] => 64.18
            [relatiecode] => xs4all
            [relatieid] => 3
            [factuurnummer] => 26008394
            [voldaan] => 0.00
            [openstaand] => 64.18
            [restvlag] => 
        )
*/
// START BUILDING BODYTEXT
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>"facturenlookup"
                         ,"dagboektype"=>"$p->dagboektype"
                         ) );

  $form->mainTableStart();

  //
  // Eerste fieldblock 
  // Debiteuren/Crediteuren/Pinboekingen
  //
    
    $form->schemaHeader("Openstaande inkoopfacturen");

  // Crediteuren lookup
  //
  $overzicht = $crediteur->selectFill($p->relatieid);

    $form->fieldSetBridge("");

       $form->blockLine('',array(
                                 "Crediteur: <select name='relatieid' onChange='doLoad()' >{$overzicht}</select>&nbsp;"
                                ),
                           array("width='100%'") );


  // start met de arraylus openstaande facturen
  //

  $tmp = '';

foreach($arr AS $obj) {
 
  if($tmp != $obj->relatiecode)  // start een nieuwe relatieheader
    $form->fieldSetBridge("Crediteur: ".$obj->naam);

  $tmp = $obj->relatiecode;


  // INKOOPFACTURENREKENINGEN
  //

      $form->blockLine('',
                       array(
                             "<div class='schemarow_std'>{$obj->datum}</div>",
                             "<div class='schemarow_std'><a href='#' onClick=\"settle('{$defaults['crediteuren']}','{$obj->factuurid}','{$obj->factuurnummer}','{$obj->relatiecode}','{$obj->openstaand}');\" style='color:black;text-decoration:underline;'>{$obj->factuurnummer}</a></div>",
                             "<div class='schemarow_std'>{$obj->omschrijving}</div>",
                             "<div class='schemarow_std' style='white-space:nowrap;' align='right'>{$obj->restvlag}".formatbedrag($obj->openstaand)."</div>"
                             ), 
                       array("width='10%'","width='10%'","width='60%'","width='20%'") );

}

  // BUTTONS
  //
    
    $form->fieldSetBridge("");

      $buttons=<<<EOT

        <input type="button" name="terug" value="terug" size="10" class='bsmall2' class='bsmall2' onClick="goBack();"/>
        <input type="button" name="printen" value="printen" size="10" class='bsmall2' class='bsmall2' onClick="window.print()"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>
EOT;

      $form->blockLine('2',array($buttons),
                           array("width='100%'") );


    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();

// JAVASCRIPT
//
  $render->jscript .=<<<EOJ

function doLoad() {
  var x = window.document.forms['frm1'];
  x.submit();
}

  
function goBack() {
  window.resizeTo(430,670);
  var url = '/run.php?app=grbprint&dagboektype=inkoop&aktie=lookup#{$defaults['crediteuren']}';
  window.location = url;
}


function settle(a,b,c,d,e) {
  var x = window.document.forms['frm1'];
  window.opener.document.forms['frm1'].grootboekrekening.value = a;
  window.opener.document.forms['frm1'].grootboekrekening.title = "Crediteuren";
  window.opener.document.forms['frm1'].factuurid.value = b;
  window.opener.document.forms['frm1'].factuurnummer.value = c;
  window.opener.document.forms['frm1'].relatie.value = d;
  window.opener.document.forms['frm1'].bomschrijving.value = 'Factuurbetaling';
  var bedrag=Math.round(parseFloat(e) * 100)/100;

  // Een -bedrag (teruggavefactuur) wordt via onderstaande procedure weliswaar
  // in de juiste kolom geboekt maar als het daar eenmaal staat moet het
  // uiteraard geen -bedrag meer zijn. De polariteit van het bedrag komt tot
  // uitdrukking in de plaatsing in de juiste kolom.

  // Een memo boeking is doorgaans intermediair en het bedrag moet in aanzet debet worden geplaatst.
  if(x.dagboektype.value == 'memo') {
    if(bedrag > 0) window.opener.document.forms['frm1'].debet.value = bedrag;
    else           window.opener.document.forms['frm1'].credit.value = bedrag * -1;
  }
  else {
    if(bedrag > 0) window.opener.document.forms['frm1'].credit.value = bedrag;
    else           window.opener.document.forms['frm1'].debet.value = bedrag * -1;
  }

  window.opener.document.forms['frm1'].grootboekrekening.focus();

  window.close();
}

EOJ;

?>
