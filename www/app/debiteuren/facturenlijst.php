<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: facturenlijst.php 289 2015-01-04 09:09:40Z otto $
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

$debiteur = new Debiteuren();

$p = new Params(array(
                      "aktie"=>""
                     ,"subaktie"=>""
                     ,"relatieid"=>""
                     ,"datum_van"=>""
                     ,"datum_tot"=>""
                     ,"openstaand"=>""
                     ,"id"=>""
), "_PG", $clean=true, $quote="{$GLOBALS['config']->data['db']['driver']}" );

printrc1($p, "Parms ". basename(__FILE__) .": ");

define('RUBRIEK','Debiteuren');

$aktie = $p->aktie;;
$id = $p->id;

$render->extra_styles .=<<<EOT

body {
  background-color: {$GLOBALS['config']->data['bgcolor']['debiteuren']};
}

EOT;

// START 
//

switch($aktie) {
  case "print"  :
    require("_facturenlijst.inc");
    break;
  default       :
    require("_facturenlijst.inc");
    break;
}

$render->output();

?>
