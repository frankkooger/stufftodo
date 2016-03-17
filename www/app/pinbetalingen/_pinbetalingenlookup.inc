<?php // vim: syntax=php
/**
* @version		$Id: _pinbetalingenlookup.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body .= "\n          <!-- pinbetalingenlookup.inc -->\n";
$render->subtitle[] = "pinbetalingenlookup.inc";
$render->titel = "Openstaande pinbetalingen overzicht";

// HOUSEKEEPING
//
// controleer of alle rkg koppelingen en rekeningen bestaan
//
$defaults = array("pinbetalingen" => $stam->existRekening('rkg_pinbetalingen'));

// Eerst een overzicht van pinbetalingen
// TODO in de toekomst zullen we facturen opzoeken op basis van een crediteur die
// uit een pulldown wordt geselecteer.
// Voor de korte termijn hebben we zo weinig pinbetalingen dat we alle openstaande pinbetalingen tonen.

// Eerst het totale overzicht van nog niet (volledig) betaalde pinbetalingen
// Maak daarvan vulling voor de select box of overzicht.

$stam->query = "SELECT * FROM {$stam->pinbetalingen} "
            .'WHERE "factuurbedrag" <> "voldaan" '
            .'ORDER BY "datum","relatiecode","factuurnummer"';

$stam->Do_sql(basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__);

// lees de factuurobjecten in een array
$arr = array();
while($obj = $stam->Do_object()) {
  $obj->datum = $GLOBALS['timer']->iso2norm($obj->datum);
  $obj->openstaand = $obj->factuurbedrag - $obj->voldaan;
  // is het openstaande bedrag een rest?
  $obj->restvlag = ($obj->voldaan > 0 && $obj->voldaan <> $obj->factuurbedrag) ? "<font color='red'>*</font> " : '';

  $arr[] = $obj;
}
unset($obj);

// START BUILDING BODYTEXT

  // $render->iscript[] = "/js/validation.js";

  $render->jscript .=<<<EOJ

function goBack() {
  window.resizeTo(430,670);
  var url = '/run.php?app=grbprint&dagboektype=pin&aktie=lookup#{$defaults['pinbetalingen']}' 
  window.location = url;
}


function settle(a,b,c,d,e) {
  var x = window.document.forms['frm1'];
  window.opener.document.forms['frm1'].grootboekrekening.value = a;
  window.opener.document.forms['frm1'].grootboekrekening.title = "pinbetalingen";
  window.opener.document.forms['frm1'].factuurid.value = b;
  window.opener.document.forms['frm1'].factuurnummer.value = c;
  window.opener.document.forms['frm1'].relatie.value = d;
  window.opener.document.forms['frm1'].bomschrijving.value = 'Pinbetaling';
  var bedrag=Math.round(parseFloat(e) * 100)/100;
  if(bedrag > 0)
    window.opener.document.forms['frm1'].credit.value = bedrag;
  else
    window.opener.document.forms['frm1'].debet.value = bedrag;

  window.opener.document.forms['frm1'].grootboekrekening.focus();

  window.close();
}

EOJ;

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>"lookup"
                         ) );

  $form->mainTableStart();

  // Eerste fieldblock 

    // Debiteuren/Crediteuren/Pinboekingen
    
    $form->schemaHeader("Openstaande pinbetalingen");

  // start met de arraylus openstaande facturen

  $tmp = '';

foreach($arr AS $obj) {
 
  if($tmp != $obj->datum)  // start een nieuwe relatieheader
    $form->fieldSetBridge("Datum: ".$obj->datum);

  $tmp = $obj->datum;

      $form->blockLine('',
                       array(
                             "<div class='schemarow_std'>{$obj->datum}</div>",
                             "<div class='schemarow_std'><a href='#' onClick=\"settle('{$defaults['pinbetalingen']}','{$obj->id}','{$obj->factuurnummer}','{$obj->relatiecode}','{$obj->openstaand}');\" style='color:black;text-decoration:underline;'>{$obj->relatiecode}</a></div>",
                             "<div class='schemarow_std'>{$obj->omschrijving}</div>",
                             "<div class='schemarow_std' style='white-space:nowrap;' align='right'>{$obj->restvlag}".formatbedrag($obj->openstaand)."</div>"
                             ), 
                       array("width='10%'","width='20%'","width='50%'","width='20%'") );

}

    // Buttons
    
    $form->fieldSetBridge("");

      $buttons=<<<EOT

        <input type="button" name="terug" value="terug" size="10" class='bsmall2' class='bsmall2' onClick="goBack()"/>
        <input type="button" name="printen" value="printen" size="10" class='bsmall2' class='bsmall2' onClick="window.print()"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>
EOT;

      $form->blockLine('2',array($buttons),
                           array("width='100%'") );


    $form->fieldSetEnd();

  $form->mainTableEnd();
$form->formEnd();

/* __END__ */
