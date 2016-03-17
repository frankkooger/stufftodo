<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: crediteuren.php 289 2015-01-04 09:09:40Z otto $
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

require("_crediteuren.lib");

$crediteur = New Crediteuren();

$p = new Params(array("aktie"=>""
                     ,"subaktie"=>""
                     ,"dagboektype"=>""
                     ,"nummervan"=>""
                     ,"nummertot"=>""
                     ,"totaalcheck"=>""
                     ,"nulperiodecheck"=>""
                     ,"nulsaldocheck"=>""
                     ,"relatieid"=>""
), "_PG", $clean=true, $quote="{$GLOBALS['config']->data['db']['driver']}" );

printrc1($p, "Parms ". basename(__FILE__) .": ");

define('RUBRIEK','Crediteuren.');

$aktie = $p->aktie;;
$printen = false;

$render->extra_styles .=<<<EOT

body {
  background-color: {$GLOBALS['config']->data['bgcolor']['crediteuren']};
}

EOT;

// START 
//
// is een uid meegegeven? 
//   - geen aktie: het crediteuren _crediteuren.inc weergeven
//   - aktie 'save': ga door _crediteuren_save.inc waar een update actie
//     plaatsvindt (er is immers een uid) en daarna naar _crediteuren.inc

switch($aktie) {
  case "facturenlookup"  :
    require("_inkoopfacturenlookup.inc");
    break;
  case "print"  :
    $printen = true;
    require("_crediteurenkaart.inc");
    break;
  case "save"   :
    require("_crediteuren_save.inc");
  case "back"   :
  default       :
    require("_crediteurenkaart.inc");
    break;
}

$render->output();

?>
