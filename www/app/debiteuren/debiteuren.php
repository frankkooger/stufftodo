<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: debiteuren.php 289 2015-01-04 09:09:40Z otto $
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

require("_debiteuren.lib");

$debiteur = New Debiteuren();

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

define('RUBRIEK','Debiteuren.');

$aktie = $p->aktie;;
$printen = false;

$render->extra_styles .=<<<EOT

body {
  background-color: {$GLOBALS['config']->data['bgcolor']['debiteuren']};
}

EOT;

// START 
//
// is een uid meegegeven? 
//   - geen aktie: het debiteuren _debiteuren.inc weergeven
//   - aktie 'save': ga door _debiteuren_save.inc waar een update actie
//     plaatsvindt (er is immers een uid) en daarna naar _debiteuren.inc

switch($aktie) {
  case "facturenlookup"  :
    require("_verkoopfacturenlookup.inc");
    break;
  case "print"  :
    $printen = true;
    require("_debiteurenkaart.inc");
    # require("_debiteurenkaartprint.inc");
    break;
  case "save"   :
    require("_debiteuren_save.inc");
  case "back"   :
  default       :
    require("_debiteurenkaart.inc");
    break;
}

$render->output();

