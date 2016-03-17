<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _facturenlijst.inc 123 2010-07-14 10:26:40Z otto $
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

$render->body .= "\n          <!-- facturenlijst.inc -->\n";
$render->subtitle[] = "facturenlijst.inc";
$render->titel = "Lijst verkoopfacturen";

//
// _facturenlijst.inc wordt bevraagd vanuit facturenlijst.phtml, wordt bevraagd vanuit 'index.php::Lijst inkoopfacturen'
// Het script kan zowel een facturenoverzicht van 1 of van meerdere debiteuren
// geven, afhankelijk van de WHERE criteria die in $tmp worden samengesteld.

// HOUSEKEEPING
//
if($p->aktie == 'print') // default
  $p->openstaand = true;

$checked['openstaand'] = $p->openstaand ? "checked='checked'" : '';

$tmp = '';
$tmp .= ($p->relatieid)       ? " AND c.\"id\"='{$p->relatieid}'" : '';
//$tmp .= ($p->debiteurencode) ? " AND c.\"code\"='{$p->debiteurencode}'" : '';
$tmp .= ($p->datum_van)       ? " AND f.\"datum\" >= '".$GLOBALS['timer']->norm2iso($p->datum_van)."'" : '';
$tmp .= ($p->datum_tot)       ? " AND f.\"datum\" <= '".$GLOBALS['timer']->norm2iso($p->datum_tot)."'" : '';
$tmp .= ($p->openstaand)      ? " AND f.\"factuurbedrag\" <> f.\"voldaan\"" : '';

// Gegevens ophalen
//
$arr = $debiteur->fetchFacturen($tmp);

// START BUILDING BODYTEXT
//

  $render->iscript[] = "/js/validation.js";
   
  $render->jscript .=<<<EOJ

function doLoad() {
  var x = document.forms['frm1'];
  x.submit();
}

EOJ;

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>""
                         ));

  // define buttons
  //
$button_select=<<<EOT

        <input type="submit" name="button_select" value="select" size="10" class='bsmall2' class='bsmall2' onClick="doLoad()"/>
EOT;

$button_sluiten=<<<EOT

        <input type="button" name="button_sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>
EOT;

$help = $stam->helpImg(RUBRIEK.'.facturenLijst','Facturenlijst',4);

$button_printen=<<<EOT

        <img src='/img/printer1.gif' style="cursor:pointer;" onClick="print(document);"/>
EOT;


  $form->mainTableStart();

  //
  // Eerste fieldblock indien weergeven
  // Indien ingeven 'fullname' nog niet tonen
  //
    $form->schemaHeader("Lijst verkoopfacturen");
    
    // Inputfields
    
    $form->fieldSetBridge("");

    $overzicht = $debiteur->selectFill($p->relatieid);

      $form->blockLine('',array(
                                "Debiteur: <select name='relatieid' onChange='doLoad()' >{$overzicht}</select>&nbsp;"
                                ,"Datum van: <input type='text' name='datum_van' value='".$p->datum_van."' size='12' onChange=doCheckDatum(this,'','{$GLOBALS['stam']->lopendjaar['value']}') />&nbsp;"
                                ,"Datum tot: <input type='text' name='datum_tot' value='".$p->datum_tot."' size='12' onChange=doCheckDatum(this,'','{$GLOBALS['stam']->lopendjaar['value']}') />&nbsp;"
                                ,"Openstaand: <input type='checkbox' name='openstaand' {$checked['openstaand']} onChange='doLoad()' />&nbsp;"
                                ),
                           array("width='37%'","width='20%'","width='20%'","width='13%'",) );

  // Buttonstrap
 
      $form->fieldSetBridge();

      $form->blockLine('2',array("{$button_select} {$button_sluiten} {$help}",$button_printen),
                                     array("width='90%'","width='10%' align='right'") );

$saldo = Array('omzet'=>0,'totaalopen'=>0,'grandtotaal'=>0,'in1mnd'=>0,'na1mnd'=>0,'na3mnd'=>0,'voldaan'=>0);
$tmp = '';

if($arr) 

foreach($arr AS $obj) {

  $obj->saldo = '';

  // Begin een debiteur
  //
  if($tmp != $obj->code) { 

    // Schrijf als eerste de openstaande saldi van de vorige debiteur. Als dit
    // de eerste keer is (en er dus nog geen debiteur was, schrijf dan niets.
    if($tmp != '')
      if($p->openstaand) openstaand_blok($form,$saldo);
      else               omzet_blok($form,$saldo);
    
    // de nieuwe debiteur-fieldset
    //

    $form->fieldSetBridge("<b>{$obj->naam} [{$obj->code}]</b>",'',$marginbottom=16);

    // Factuurregelsheader
    //
    $veldarr = array("width='12%'"
                    ,"width='5%' align='middle'"
                    ,"width='14%'"
                    ,"width='45%'"
                    ,"width='12%'"
                    ,"width='12%'"
                    );
  
      $form->blockLine('4',
                       array("<div class='schemarow_head'>datum</div>" 
                            ,"<div class='schemarow_head'>journaal</div>" 
                            ,"<div class='schemarow_head' align='middle'>factuurnummer</div>" 
                            ,"<div class='schemarow_head'>omschrijving</div>" 
                            ,"<div class='schemarow_head_debet' align='right'>factuurbedrag</div>" 
                            ,"<div class='schemarow_head_credit' align='right'>voldaan</div>" 
                            ), 
                       $veldarr
                       );

    $tmp = $obj->code;

  } // END begin een debiteur

    // Laat saldoberekeningen los op de factuurregel en saldeer die samen met de andere facturen van deze debiteur
    //
    // Totaalsaldo van de facturen per debiteur
    $saldo['omzet'] += ($obj->factuurbedrag);
    // Openstaande saldi van de openstaande facturen per debiteur
    if($verschil = ($obj->factuurbedrag - $obj->voldaan) <> 0) { // er is een saldo
      $saldo['voldaan'] = formatbedrag($obj->voldaan,$nul=true,$currency=true);
      // bereken tijdseenheden indien historie gewenst
      if($p->openstaand) {
        $saldo['totaalopen'] += ($obj->factuurbedrag - $obj->voldaan);
        switch($diff = $stam->Get_datediff($obj->datum)) {
          case($diff === 0)               : // moet erbij voor facturen van dezelfde dag, anders belanden ze bij na1mnd
          case($diff <= 30)               : $saldo['in1mnd'] += ($obj->factuurbedrag - $obj->voldaan); break;
          case($diff > 30 && $diff <= 90) : $saldo['na1mnd'] += ($obj->factuurbedrag - $obj->voldaan); break;
          case($diff > 90)                : $saldo['na3mnd'] += ($obj->factuurbedrag - $obj->voldaan); break;
        }
      }
    }
    else {
      $saldo['voldaan'] = $GLOBALS['timer']->iso2norm($obj->betaaldatum);
    }

      // Schrijf factuurregel
      //
      $form->blockLine('',
                       array("<div class='schemarow_std'>".$GLOBALS['timer']->iso2norm($obj->datum)."</div>" 
                            ,"<div class='schemarow_std' align='middle'>{$obj->journaalid}</div>" 
                            ,"<div class='schemarow_std' align='middle'>{$obj->factuurnummer}</div>" 
                            ,"<div class='schemarow_std' align='left'>{$obj->omschrijving}</div>" 
                            ,"<div class='schemarow_debet' align='right'>".formatbedrag($obj->factuurbedrag,$nul=false)."</div>" 
                            ,"<div class='schemarow_credit' align='right'>".formatbedrag($obj->voldaan,$nul=false)."</div>" 
                            ), 
                       $veldarr
                       );

} // END WHILE obj

    // Schrijf nog een keer de openstaande saldi van de laatste debiteur. Omdat
    // er niet meer door de vorige lus wordt gelopen bij het laatste record.
    if($p->openstaand)
      openstaand_blok($form,$saldo);
    else
      omzet_blok($form,$saldo);


    // Buttons 2nd line
    //
    $form->fieldSetBridge("");

      $form->blockLine('2',array($button_sluiten),
                           array("width='100%'") );


    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();


function openstaand_blok(&$form,&$saldo) {

    $form->blockTableEnd();
    $form->blockTableStart();

      $form->blockLine('4',
                       array("<div class='schemarow_head'>Openstaand</div>" 
                            ,"<div class='schemarow_head'>Jonger dan 1mnd</div>" 
                            ,"<div class='schemarow_head'>Ouder dan 1mnd</div>" 
                            ,"<div class='schemarow_head'>Ouder dan 3mnd</div>" 
                            ), 
                       array("width='25%'","width='25%'","width='25%'","width='25%'"
                             ) );

      $form->blockLine('',
                       array("<div class='schemarow_std'>".formatbedrag($saldo['totaalopen'],true,true)."</div>"
                            ,"<div class='schemarow_std'>".formatbedrag($saldo['in1mnd'],'',true)."</div>"
                            ,"<div class='schemarow_std'>".formatbedrag($saldo['na1mnd'],'',true)."</div>"
                            ,"<div class='schemarow_std'>".formatbedrag($saldo['na3mnd'],'',true)."</div>"
                            ), 
                       array("width='25%'"
                            ,"width='25%' style='background-color:#fffaf0'"
                            ,"width='25%' style='background-color:#edbbbb'"
                            ,"width='25%' style='background-color:#ed9f9f'"
                             ) );

    leegSaldi($saldo);

} // END function openstaand_blok


function omzet_blok(&$form,&$saldo) {

    $form->blockTableEnd();
    $form->blockTableStart();

      $form->blockLine('4',
                       array("<div class='schemarow_std'>Omzetbedrag: ".formatbedrag($saldo['omzet'],true,true)."</div>"
                            ), 
                       array("width='100%'"
                            ) );
    leegSaldi($saldo);

} // END function openstaand_blok


function leegSaldi(&$saldo) {
  // Leeg de saldi voor de volgende debiteur, bewaar het grandtotaal
  $saldo['omzet'] = $saldo['totaalopen'] = $saldo['in1mnd'] = $saldo['na1mnd'] = $saldo['na3mnd'] = 0;
} // END FUNCTION leegSaldi

?>
