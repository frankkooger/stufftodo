<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _stamgegevens_save.inc 289 2015-01-04 09:09:40Z otto $
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
$p = new Params(array(
                       "adminnaam"=>""
                      ,"adminomschrijving"=>""
                      ,"lopendjaar"=>""
                      ,"periodevan"=>""
                      ,"periodetot"=>""
                      ,"periodeextra"=>""
                      ,"rkg_kapitaalprive"=>""
                      ,"rkg_kasboek"=>""
                      ,"rkg_bankboek"=>""
                      ,"rkg_debiteuren"=>""
                      ,"rkg_crediteuren"=>""
                      ,"rkg_btwinkopen"=>""
                      ,"rkg_btwinkooplaag"=>""
                      ,"rkg_btwverkoophoog"=>""
                      ,"rkg_btwverkooplaag"=>""
                      ,"rkg_verkoopverlegd"=>""
                      ,"rkg_btwprivegebruik"=>""
                      ,"rkg_betaaldebtw"=>""
                      ,"rkg_divopbrengsten"=>""
                      ,"rkg_verschillen"=>""
                      ,"rkg_priverekeningcourant"=>""
                      ,"afgeslotenperiodes"=>""
                      ,"btwverkoophoog"=>""
                      ,"btwverkooplaag"=>""
                      ,"evjournaalpost"=>""
), "_POST", $clean=true, $quote="{$GLOBALS['config']->data['db']['driver']}" );

printrc2($p, "Parms ". basename(__FILE__) .": ");

// Haal de lijst namen uit de stamtabel.
//
$valid = $stam->namenLijst();

$decimalvelden = array(
               "btwverkoophoog"
              ,"btwverkooplaag"
);

//
// Controles
//  Van elke gewijzigde val is een c_val beschikbaar; deze is in het form gezet met een onChange. 
//  Indien dat het geval is, is de value gewijzigd en wordt hij opgenomen in de
//  update string of de insert string als het een verandering betreft in een
//  boekjaar dat niet in de oorspronkelijke record staat.
//
foreach($valid AS $val) {
  // is deze val gewijzigd?
  $tmp = "c_".$val;
  if($p->$tmp) { // gewijzigd
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

/* __END__ */
