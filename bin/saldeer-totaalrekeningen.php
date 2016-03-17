#!/usr/bin/php -q
<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: saldeer-totaalrekeningen.php 215 2011-09-25 18:54:41Z otto $
* @author     Frank Kooger
* @package		OpenAdmin.nl
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
 * Hulpprocedure
 *
 * Stel de saldi samen van de totaalrekeningen
 *
 * We moeten steeds de saldi trekken van de rekeningen tussen twee
 * totaalrekeningen van hetzelfde nivo of 0 als er geen vorige is.  Om de
 * eerstvorige rekening te vinden met hetzelfde nivo doe onderstaand (voorbeeld
 * is nivo 5).  Het resultaat hiervan is b.v. 4999.  Saldeer nu alle rekeningen
 * <8985 AND >4999 Dit is het saldoresultaat voor 8985 Als er geen vorige
 * rekening wordt gevonden dan is het alles tussen 0 en 8985
 *
 * @abstract
 * @package		OpenAdmin.nl
 * @since		1.0
 */

require("../lib/_const.inc");
require("../lib/_oa.lib");

// welke administratie?
//
$administratie = "administratie";

// open een db pointer
//
$dbb = new DbConnector("","","",$administratie);

// lees de totaalgrootboekrekeningen
//
$dbb->Do_query("SELECT nummer,type,nivo,saldo FROM {$GLOBALS['ML_SYSTEM']['view']['vw_grootboekstam']} WHERE type=".TOTAALKAART );

// stop het resultaat in een array zodat dbb weer beschikbaar komt
//
while($obj = $dbb->Do_object())  $arr[] = $obj;

foreach($arr AS $val) {

  // bepaal van deze rekening of er een voorganger is
  //
  $query = "type=3 AND nummer<{$val->nummer} AND nivo>={$val->nivo} ORDER BY nummer DESC LIMIT 1";
  $vorige = $dbb->Get_field("nummer","vw_grootboekstam", $query);
  empty($vorige) and $vorige=1;

  $selectie = " nummer>{$vorige} AND nummer<{$val->nummer} AND type NOT LIKE 3 ";
  $dbb->Do_query("SELECT nummer,saldo FROM {$GLOBALS['ML_SYSTEM']['view']['vw_grootboekstam']} WHERE ".$selectie) ;
  
  $bedrag = 0;
  while($sobj = $dbb->Do_object()) $bedrag += $sobj->saldo;
  $dbb->Do_free();
  # printnl("nummer: ". $val->nummer .", nieuw saldo: ".$bedrag);

  // het bedrag kan naar het rekeningsaldo
  //
  $dbb->Do_query("UPDATE {$GLOBALS['ML_SYSTEM']['tbl']['grootboekstam']} "
                ."SET saldo='{$bedrag}' "
                ."WHERE nummer=".$val->nummer) ;

  
} // END FOREACH

?>
