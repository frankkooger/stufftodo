<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _journaalschema.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body .= "\n          <!-- journaalschema.inc -->\n";
$render->subtitle[] = "journaalschema.inc";
$render->titel = "journaalgegevens schema overzicht";

// panel-helpcode : na1

// Gegevens inlezen

// Eerst het totale overzicht
// Maak daarvan vulling voor de select box

$stam->query = "SELECT * FROM {$stam->journaal} WHERE \"boekjaar\"={$stam->boekjaar} ORDER BY {$stam->boekjaar}, \"journaalpost\"";
$stam->Do_sql(basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__);

$arr = array();
while($obj = $stam->Do_object()) $arr[] = $obj;

// START BUILDING BODYTEXT

  $render->iscript[] = "/js/validation.js";

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                  array("aktie"=>"") );

  $form->mainTableStart();

  // Eerste fieldblock indien weergeven
  // Indien ingeven 'fullname' nog niet tonen

    $form->schemaHeader("Schema grootboekrekeningen");
    
    $form->fieldSetBridge("Balansrekeningen");
      
// begin met target als balans
$target = BALANS;
$rows = 0;

foreach($arr AS $obj) {
    
  // scheid balans- en resultaatrekeningen
  if($obj->type != TOTAALKAART)
    $target = $obj->type;

  if($target == RESULTAAT) continue;

  $obj->saldo = '';
   
  if($obj->type == TOTAALKAART) {
      $form->blockLine('',
                       array("<div class='schemarow_enh'>+++ {$obj->naam} &nbsp; niveau:{$obj->nivo} &nbsp; ({$obj->journaalpost})</div>",
                             "<div class='schemarow_enh'>{$obj->saldo}</div>"
                             ), 
                       array("colspan='2' width='80%'","width='20%'") );
  }
  else {
      $form->blockLine('',
                       array("<div class='schemarow_std'>{$obj->journaalpost}</div>",
                             "<div class='schemarow_std'>{$obj->naam}</div>",
                             "<div class='schemarow_std'>{$obj->saldo}</div>"
                             ), 
                       array("width='10%'","width='70%'","width='20%'") );
  }
}

    $form->fieldSetBridge("Winst/Verliesrekeningen");
      
// ga verder met target als resultaat
    //
$target = RESULTAAT;

foreach($arr AS $obj) {

  // scheid balans- en resultaatrekeningen
  if($obj->type != TOTAALKAART)
    $target = $obj->type;

  if($target == BALANS) continue;

  $obj->saldo = '';
   
  if($obj->type == TOTAALKAART) {
      $form->blockLine('',
                       array("<div class='schemarow_enh'>+++ {$obj->naam} &nbsp; niveau:{$obj->nivo} &nbsp; ({$obj->journaalpost})</div>",
                             "<div class='schemarow_enh'>{$obj->saldo}</div>"
                             ), 
                       array("colspan='2' width='80%'","width='20%'") );
  }
  else {
      $form->blockLine('',
                       array("<div class='schemarow_std'>{$obj->journaalpost}</div>",
                             "<div class='schemarow_std'>{$obj->naam}</div>",
                             "<div class='schemarow_std'>{$obj->saldo}</div>"
                             ), 
                       array("width='10%'","width='70%'","width='20%'") );
  }
 
}

    // Buttons
    
    $form->fieldSetBridge("");

      $buttons=<<<EOT

        <input type="button" name="printen" value="printen" size="10" class='bsmall2' class='bsmall2' onClick="print(document)"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>
EOT;

      $form->blockLine('2',array($buttons),
                           array("width='100%'") );


    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();

/* __END__ */
