<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _debiteurenschema_print.inc 284 2014-08-11 18:48:04Z otto $
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

$render->body .= "\n          <!-- debiteurenschema_print.inc -->\n";
$render->subtitle[] = "debiteurenschema_print.inc";
$render->titel = "Debiteurenstamgegevens schema overzicht";

// WAAR WORDT DIT SCRIPT GEBRUIKT?????????
//
// Het wordt geactiveerd door de printknop in debiteurenstam
//

// Gegevens inlezen
//
// Eerst het totale debiteurenoverzicht
//
$stam->query = "SELECT * FROM {$stam->debiteurenstam} ORDER BY \"naam\"";
$stam->Do_sql(basename(__FILE__).'::'.__METHOD__.'::'.__LINE__);

// lees in een obj array omdat we db verderop weer nodig hebben voor facturenoverzicht
//
while($obj = $stam->Do_object()) $arr[] = $obj;

// START BUILDING BODYTEXT
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>""
                         ) );

  //
  // define buttons
  //
  $buttons=<<<EOT

        <input type="button" name="printen" value="printen" size="10" class='bsmall2' class='bsmall2' onClick="print(document)"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>

EOT;

  $form->mainTableStart();

  //
  // Eerste fieldblock indien weergeven
  // Indien ingeven 'fullname' nog niet tonen
  //
    $form->schemaHeader("Schema debiteurenrekeningen");
    
    // Buttons 1st line
    
    $form->fieldSetBridge("");

      $form->blockLine('2',array($buttons),
                           array("width='100%'") );

$rows = 0;

if(count($arr)) {

foreach($arr AS $obj) {

  $obj->saldo = '';

  $obj->contact != "" ? $contact ="{$obj->contact}"."<br />" : $contact = '';

  if($obj->telefoon != "" && $obj->fax != "") 
    $telefoon ="tel: {$obj->telefoon} &nbsp; fax: {$obj->fax}<br />";
  else if($obj->telefoon != "")
    $telefoon ="tel: {$obj->telefoon}<br />";
  else if($obj->fax != "")
    $telefoon ="fax: {$obj->fax}<br />";
  else
    $telefoon = '';
  
  $obj->email != "" ? $mail = "<a href='mailto:{$obj->email}'>".$obj->email."</a><br />" : $mail = '';
  
    $form->fieldSetBridge("");

      $form->blockLine('#ffff75',
                       array("<div class='schemarow_std'>Debiteur: $obj->naam [{$obj->id}]</div>"
                             ), 
                       array("width='100%' align='middle'") );

      $form->blockTableEnd();
      $form->blockTableStart();

      $form->blockLine('2',
                       array("<div class='schemarow_std'>Naam:</div>"
                            ,"<div class='schemarow_std'>{$obj->naam}</div>"
                             ), 
                       array("width='10%' valign='top'","width='70%'","width='20%'") );

      $form->blockLine('',
                       array("<div class='schemarow_std'>Code</div>"
                            ,"<div class='schemarow_std'>{$obj->code}</div>"
                             ), 
                       array("width='10%' valign='top'","width='70%'","width='20%'") );

      $form->blockLine('',
                       array("<div class='schemarow_std'>Contact:</div>"
                            ,"<div class='schemarow_std'>{$obj->contact}</div>"
                             ), 
                       array("width='10%' valign='top'","width='70%'","width='20%'") );

      $form->blockLine('',
                       array("<div class='schemarow_std'>Tel/fax:</div>"
                            ,"<div class='schemarow_std'>{$telefoon}</div>"
                             ), 
                       array("width='10%' valign='top'","width='70%'","width='20%'") );

      $form->blockLine('',
                       array("<div class='schemarow_std'>E-mail:</div>"
                            ,"<div class='schemarow_std'><a href='mailto:{$obj->email}'>{$obj->email}</a></div>"
                             ), 
                       array("width='10%' valign='top'","width='70%'","width='20%'") );

      $form->blockLine('',
                       array("<div class='schemarow_std'>Fact.adres:</div>"
                            ,"<div class='schemarow_std'>".nl2br($obj->adres)."</div>"
                             ), 
                       array("width='10%' valign='top'","width='70%'","width='20%'") );

      $form->blockLine('',
                       array(""), 
                       array("colspan='3'") );

  if($p->facturen) { // facturen tonen

    //
    // het facturenoverzicht heeft een $id nodig
    //
    $id = $obj->id;

    require("_facturenblok.inc");

  } // END IF facturen

} // END WHILE obj

} // END count($arr)

    //
    // Buttons 2nd line
    //
    $form->fieldSetBridge("");

      $form->blockLine('2',array($buttons),
                           array("width='100%'") );


    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();

/*___END___*/