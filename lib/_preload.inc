<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: _preload.inc 291 2015-01-05 10:16:48Z otto $
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

// 1. start een sessie, dit moet gebeuren voor elke ander functie die output kan genereren
session_start();

// 2, Laad de stamgegevens en een DbFactory behalve als een load=noload is
// meegegeven bij de opstartparms van de toepassing
if(!isset($_GET['load']))
  $stam = new Stam();

// 3. Laad een rendering object
$render = new Rendering();

// generic javascript

$render->onload .= "window.focus();";

$helpMaintenance = (! empty($config->data['help']['maintenance'])) ?
  rtrim($config->data['help']['maintenance'],'/') : '';
/*
$render->pscript .=<<<EOT

function Help(code,titel,rubriek) {
  if(!rubriek) rubriek='';
  var win = window.open('{$helpMaintenance}/helper/help.php?code='+code+'&titel='+titel+'&rubriek='+rubriek,'Help','resizable,scrollbars,status,width=520,height=430,left=40,top=160');
}

EOT;
*/

// Laad een js file met bovenstaande Help function
$render->iscript[] = '/js/help.js';

// 4. Laad een global message array

$msg = array("red"=>"","blue"=>"");

/* __END__ */
