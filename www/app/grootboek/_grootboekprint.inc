<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _grootboekprint.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body .= "\n          <!-- grootboekprint.inc -->\n";
$render->subtitle[] = "grootboekprint.inc";
$render->titel = "Grootboekstamgegevens schema overzicht";

$veldarr = array("width='10%'","width='60%'","colspan='2' width='30%'");
$veldarr_enh = array("colspan='2' width='70%'","width='15%'","width='15%'");

//
// Gegevens inlezen
//
if($p->saldoweergave) {

  //
  // als we saldi willen zien is het wel een goed idee om hier al een array
  // met totaalkaartsaldi te maken
  //

  //
  // lees de totaalgrootboekrekeningen
  //
  $stam->Do_query("SELECT \"nummer\",\"type\",\"nivo\",\"saldo\" FROM {$stam->grootboekstam} WHERE \"type\"=".TOTAALKAART );

  //
  // stop het resultaat in een array zodat db weer beschikbaar komt
  //
  while($obj = $stam->Do_object())  $saldi[] = $obj;

  $totalen = array();

  foreach($saldi AS $val) {
    //
    // bepaal van deze rekening of er een voorganger is
    //
    $query = "\"type\"=3 AND \"nummer\"<{$val->nummer} AND \"nivo\">={$val->nivo} ORDER BY \"nummer\" DESC";
    $vorige = $stam->Get_field('"nummer"',$stam->grootboekstam, $query);
    empty($vorige) and $vorige=1;

    $selectie = " \"stam\".\"nummer\">{$vorige} AND \"stam\".\"nummer\"<{$val->nummer} AND \"stam\".\"type\" <> ".TOTAALKAART." ";
    $stam->Do_query("SELECT * FROM {$stam->grootboekstam} WHERE ".$selectie, basename(__FILE__).'::'.__METHOD__.'::'.__LINE__) ;
    
    $bedrag = 0;
    while($sobj = $stam->Do_object()) $bedrag += $sobj->saldo;
    $stam->Do_free();

    $totalen[$val->nummer] = $bedrag;

  } // END FOREACH

} // END IF saldoweergave

// START BUILDING BODYTEXT
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>""
                         ) );

  $form->mainTableStart();

  // Eerste fieldblock 
  //

    $form->schemaHeader("Schema grootboekrekeningen");
    
    $form->fieldSetBridge("Balansrekeningen");
      
// Lees de rekeningen eerst in een array
//
$stam->query = "SELECT \"naam\",\"nummer\",\"type\",\"nivo\" FROM {$stam->grootboekstam} ORDER BY \"nummer\"";
$stam->Do_sql(basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__);

$arr = array();
while($obj = $stam->Do_object()) $arr[] = $obj;

//
// begin met balansrekeningen al target
//

$target = BALANS;

$rows = $count = 0;
$winstsaldo = $resultaatsaldo = 0;

//
// Het balans overzicht
//

foreach($arr AS $obj) {
  printrc2($obj, "object in balans: " );
  //
  // houdt bij hoeveel rows zijn opgehaald omdat
  // de volgende while lus 1 row moet worden 
  // teruggezet.
  //
  $count++;
    
  // scheid balans- en resultaatrekeningen
  if($obj->type == RESULTAAT) continue;

  if($p->saldoweergave) {
    $saldo = formatbedrag($obj->saldo);
    if($obj->type == TOTAALKAART)
      $totalensaldo = formatbedrag($totalen[$obj->nummer]);
    else
      $winstsaldo += $obj->saldo;
  }
  else $saldo = $totalensaldo = '';
   
  if($obj->type == TOTAALKAART) {
   if($obj->nummer < $stam->omslag['value']) {
      $form->blockLine('',
                       array("<div class='schemarow_enh_darkblue'>+++ {$obj->naam} &nbsp; niveau:{$obj->nivo} &nbsp; ({$obj->nummer})</div>"
                            ,"<div class='schemarow_enh_darkblue' align='right'>{$totalensaldo}</div>"
                            ,"&nbsp;"
                             ), 
                       $veldarr_enh
                       );
   }
  }
  else {
      $form->blockLine('',
                       array("<div class='schemarow_std'>{$obj->nummer}</div>",
                             "<div class='schemarow_std'>{$obj->naam}</div>",
                             "<div class='schemarow_std' align='right'>{$saldo}</div>"
                             ), 
                       $veldarr
                       );
  }
}

if($winstsaldo) { // print een extra saldoregel

      $form->blockLine('',
                       array("<div class='schemarow_enh' align='right'>Saldo: </div>"
                            ,"&nbsp;"
                            ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($winstsaldo)."</div>"
                             ), 
                       $veldarr_enh
                       );

}

    $form->fieldSetBridge("Winst/Verliesrekeningen");
      
//
// ga verder met resultaatrekeningen als target
//
$target = RESULTAAT;

foreach($arr AS $obj) {
  p2rintrc($obj, "object in venw: " );

  //
  // scheid balans- en resultaatrekeningen
  // ! dat hoeft hier niet meer omdat we een beperkte set
  // rekeningen (niet balans) overhebben, maar zie het maar
  // als extra bescherming dat geen balansposten tussen de
  // resultaatrekeningen belanden.
  //
  if($obj->type == BALANS) continue;

  if($p->saldoweergave) {
    $saldo = formatbedrag($obj->saldo);
    if($obj->type == TOTAALKAART)
      $totalensaldo = formatbedrag($totalen[$obj->nummer]);
    else
      $resultaatsaldo += $obj->saldo;
  }
  else $saldo = $totalensaldo = '';
   
  if($obj->type == TOTAALKAART) {
   if($obj->nummer >= $stam->omslag['value']) {
      $form->blockLine('',
                       array("<div class='schemarow_enh_darkblue'>+++ {$obj->naam} &nbsp; niveau:{$obj->nivo} &nbsp; ({$obj->nummer})</div>"
                            ,"<div class='schemarow_enh_darkblue' align='right'>{$totalensaldo}</div>"
                            ,"&nbsp;"
                             ), 
                       $veldarr_enh
                       );
   }
  }
  else {
      $form->blockLine('',
                       array("<div class='schemarow_std'>{$obj->nummer}</div>",
                             "<div class='schemarow_std'>{$obj->naam}</div>",
                             "<div class='schemarow_std' align='right'>{$saldo}</div>"
                             ), 
                       $veldarr
                       );

  }
 
} // END WHILE resultaatrekeningen

if($resultaatsaldo) { // print een extra saldoregel

    if($resultaatsaldo < 0) $label = "Saldo winst: ";
    else                 $label = "Saldo verlies: ";

      $form->blockLine('',
                       array("<div class='schemarow_enh' align='right'>{$label} </div>"
                            ,"&nbsp;"
                            ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($resultaatsaldo)."</div>"
                             ), 
                       $veldarr_enh
                       );

  //
  // saldoverschil weergeven
  //

    $form->fieldSetBridge("Resultaat");

    $totaalsaldo = $winstsaldo + $resultaatsaldo;
    
    $label = 'Resultaat: ';
    
      $form->blockLine('',
                       array("<div class='schemarow_enh' align='right'>{$label} </div>"
                            ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($totaalsaldo)."</div>"
                            ,"&nbsp;"
                             ), 
                       $veldarr_enh
                       );

} // END IF resultatensaldo


  // BUTTONS
  //
    
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

$render->extra_styles .=<<<EOT

legend {
  font-weight:bold;
  padding-top: 10;
}

EOT;

?>
