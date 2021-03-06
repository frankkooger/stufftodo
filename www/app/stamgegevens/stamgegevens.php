<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: stamgegevens.php 215 2011-09-25 18:54:41Z otto $
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

$p = new Params(array("aktie"=>""
                     ,"uid"=>""
                     ,"filter"=>""
                     ,"soortkeuze"=>1
                     ,"zoekargument"=>""
                     ,"return"=>""
), "_PG", $clean=true, $quote="{$GLOBALS['config']->data['db']['driver']}" );

printrc1($p, "Parms ". basename(__FILE__) .": ");

define('RUBRIEK','Stamgegevens.');

$zoekargument = $p->zoekargument;;
$aktie = $p->aktie;;
$uid = $p->uid;

$d_message = $e_message = "";

// START 

// is een uid meegegeven? 
//   - geen aktie: het stamgegevens _stamgegevens.inc weergeven
//   - aktie 'save': ga door _stamgegevens_save.inc waar een update actie
//     plaatsvindt (er is immers een uid) en daarna naar _stamgegevens.inc

switch($aktie) {
  case "save"  :
    require("_stamgegevens_save.inc");
  case "back"  :
  default      :
    require("_stamgegevens.inc");
    break;
}

$render->output();

/* __END__ */
