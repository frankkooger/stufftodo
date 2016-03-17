<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: run.php 269 2013-08-20 23:06:42Z otto $
* @svn        $URL: https://svn.ml-design.com/svn/openadmin/trunk/www/run.php $
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
 * Centraal entrypunt naar de applicaties
 * 
 * 
 *
 * @abstract
 * @package		OpenAdmin.nl
 * @since		1.0
 */

// Set flag that this is a parent file
define( '_JEXEC', 1 );

require('../lib/_init.inc');

switch($_GET['app']) {
  case 'administratie'   : require('app/systeem/administratie.php'); break;
  case 'journaalpost'    : require('app/journaal/journaal.php'); break;
  case 'journaaledit'    : require('app/journaal/journaaledit.php'); break;
  case 'grbprint'        : require('app/grootboek/grootboek.php'); break;
  case 'populariteit'    : require('app/grootboek/populariteit.php'); break;
  case 'saldilijsten'    : require('app/rapportage/saldilijsten.php'); break;
  case 'btw'             : require('app/btw/btw.php'); break;
  case 'ifacturenlijst'  : require('app/crediteuren/facturenlijst.php'); break;
  case 'vfacturenlijst'  : require('app/debiteuren/facturenlijst.php'); break;
  case 'grootboekstam'   : require('app/grootboek/grootboekstam.php'); break;
  case 'grootboek'       : require('app/grootboek/grootboek.php'); break;
  case 'debiteurenstam'  : require('app/debiteuren/debiteurenstam.php'); break;
  case 'debiteuren'      : require('app/debiteuren/debiteuren.php'); break;
  case 'crediteurenstam' : require('app/crediteuren/crediteurenstam.php'); break;
  case 'crediteuren'     : require('app/crediteuren/crediteuren.php'); break;
  case 'pinbetalingen'   : require('app/pinbetalingen/pinbetalingen.php'); break;
  case 'dagboeken'       : require('app/stamgegevens/dagboeken.php'); break;
  case 'dagboekenedit'   : require('app/stamgegevens/dagboekenedit.php'); break;
  case 'btwrubrieken'    : require('app/btw/btwrubrieken.php'); break;
  case 'stamgegevens'    : require('app/stamgegevens/stamgegevens.php'); break;
  case 'jaarafsluiting'  : require('app/systeem/jaarafsluiting.php'); break;
  case 'backups'         : require('app/systeem/backup.php'); break;
  case 'administraties'  : require('app/systeem/administratie.php'); break;
  default                : die("Wrong target!"); break;
}

#print haveapeek($_SERVER,false);
#print haveapeek($p);

/* __END__ */
