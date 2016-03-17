<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _stamgegevens_save.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body .= "\n          <!-- stamgegevens_save.inc -->\n";

$render->subtitle[] = "stamgegevens_save.inc";

//
// fetch alleen de post parms
//
$px = new Params(array(
), "_POST", $clean=true, $quote="{$GLOBALS['config']->data['db']['driver']}" );

printrc2($px, "Parms ". basename(__FILE__) .": ");
//
// Controles
//  Van elke gewijzigde val is een c_val beschikbaar; deze is in het form gezet met een onChange. 
//  Indien dat het geval is, is de value gewijzigd en wordt hij opgenomen in de
//  update string of de insert string als het een verandering betreft in een
//  boekjaar dat niet in de oorspronkelijke record staat.
//
  // Bepaal welke itemregels (adhv m_id) zijn gewijzigd
  //
  // Maak een array van de m_ vars die true zijn, deze staan voor gewijzigde records
  //
  $arr = Array();
  foreach($px AS $key=>$val) {
    if(preg_match("/^c_/", $key)) {
      if($val == 'true') {
        $id = substr($key,2);
        $aanuit = (isset($px->$id)) ? 1 : 0; // aan of uitgezet
/*
   We weten dat het record al bestaat in btwkeys (anders zag je het hier niet)
   We moeten nu nog weten of het een record is van dit jaar: in dat geval updaten
   of een record van een ander jaar: in dat geval een copy van het record als nieuw inserten
   met de gewijzigde parameter en het huidig jaar als boekjaar
*/
        $obj = $stam->Get_object("SELECT * FROM \"vw_btwrubrieken\" WHERE \"key\"='{$id}' ",basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__ );
        if($obj->boekjaar == $stam->lopendjaar['value']) { // update
          $stam->query =<<<EOT
UPDATE "btwkeys" SET "actief"={$aanuit}
WHERE "id"={$obj->id}
EOT;
        }
        else { // insert new
          $newid = $stam->newId('btwkeys');
          $fields = '"id","key","type","actief","ccode","acode","label","labelstam","labeldefaults","boekjaar","active"';
          //$values = "{$newid},'{$obj->key}','{$obj->type}',{$aanuit},'{$obj->ccode}','{$obj->acode}','{$obj->label}','{$obj->labelstam}','{$obj->labeldefaults}',{$stam->boekjaar},{$obj->active}";
          $values = "{$newid},'{$obj->key}','{$obj->type}',{$aanuit},'{$obj->ccode}','{$obj->acode}','{$obj->label}','{$obj->labelstam}','{$obj->labeldefaults}',{$stam->boekjaar},{$aanuit}";
          $stam->query = "INSERT INTO \"btwkeys\" ({$fields}) VALUES ({$values})";
        }

      $stam->Do_sql(basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__);
      }
    }
  }






/*
foreach($valid AS $val) {
  // is deze val gewijzigd?
  $tmp = "c_".$val;
  if($p->$tmp) { // gewijzigd
printrc2($val, 'val is gewijzigd: ');
    // prepareer de values
    if(in_array($val, $decimalvelden)) {
      $p->$val = str_replace(",",".",$p->$val);
    }
    // we moeten nu bepalen of de update naar eenzelfde boekjaar gaat of dat we
    // inmiddels in een nieuw boekjaar zitten. In het laatste geval wordt het
    // een insert ipv update
    //
    if(($recordjaar  = $stam->Get_field('MAX("boekjaar")', $stam->stam, "\"naam\"='{$val}'",basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__ )) < $p->boekjaar) {
      // haal de gegevens van het originele record
      $obj = $stam->Get_object("SELECT * FROM {$stam->stam} WHERE \"naam\"='{$val}' AND \"boekjaar\"={$recordjaar} ",basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__ );
      $newid = $stam->newId($stam->stam);
      $fields = '"id","boekjaar","code","subcode","label","naam","value","tekst"';
      $values = "{$newid},{$p->boekjaar},'{$obj->code}','{$obj->subcode}','{$obj->label}','{$obj->naam}','{$p->$val}','{$obj->tekst}'";
      $stam->query = "INSERT INTO {$stam->stam} ({$fields}) VALUES ({$values})";
//      printrc1($obj, "dit object is gefetch't: ");
//      printrc1($stam->query, "deze insert wordt gedaan: ");
//      printrc1($recordjaar, "recordjaar: ");
    }
    else {
      $stam->query = "UPDATE {$stam->stam} SET \"value\"='{$p->$val}' WHERE \"naam\"='{$val}' AND \"boekjaar\"={$p->boekjaar} ";
    }
    $stam->Do_sql(basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__);
  }
}

//
// is het journaalnummer veranderd?
//
if(!empty($p->c_evjournaalpost)) {
  // controleer of het ingegeven journaalnummer wel kan
  if(! $p->evjournaalpost > $stam->Get_field('MAX("journaalid")',$stam->journaal,'',basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__ )) 
    printbr("Het journaalnummer kan niet worden veranderd naar een nummer dat al is gebruikt!");
}

// Is het boekjaar veranderd?
// Loop de saldi boekingen na adhv boekregels waarop al is geboekt in het
// gevraagde jaar. Dit kan met de methode aanmakenSaldi omdat deze methode nieuwe (=wel
// geboekt maar nog niet een saldorecord) saldirecords aanmaakt, maar bestaande
// saldirecorde update.
//
if($p->c_lopendjaar) { // boekjaar is veranderd
  require_once('_grootboek.lib');
  $grootboek = new Grootboek();
  $stam->boekjaar = $p->lopendjaar;
  $grootboek->aanmakenSaldi();
}
*/
/* __END__ */
