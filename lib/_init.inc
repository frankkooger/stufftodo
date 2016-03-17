<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: _init.inc 289 2015-01-04 09:09:40Z otto $
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

// Bepaal of we op een windoze platform draaien
//
if(preg_match("/^[c-zC-Z][:][\\\]/", __FILE__)) { // windoze
  define('PS', '\\');
  define('LIBDIR',dirname(__FILE__));
  $includepath = '.'.PS.';'.LIBDIR;
}
else {
  define('PS', '/');
  define('LIBDIR',dirname(__FILE__));
  $includepath = '.'.PS.':'.LIBDIR;
}
 
define('CONFIGDIR',preg_replace("/(^.+).lib$/","$1".PS.'config',dirname(__FILE__)));

ini_set('include_path', $includepath);

// _const.ini moet er zijn anders eerst installatie draaien
//
if(! file_exists(CONFIGDIR."/_const.ini")) {
  print("<script type='text/javascript'>window.location.href='/install/install.php'</script>");
  exit;
}

// Library met common applicatie functies en classes
// Hierin is NIET meer de mysql dbase class 'DbConnector'
//
require('_oa.lib');

// Configuration loading
//
require('INIFile.lib');
$config = new INIFile(CONFIGDIR."/_const.ini");
$version = new INIFile(CONFIGDIR."/_version.ini");

require("_system.inc");
require("_windows.inc");

//Sessions handling
//
if($config->data['sessions']['name'])
  ini_set('session.name', $config->data['sessions']['name']);
if($config->data['sessions']['dir'])
  ini_set('session.save_path', $config->data['sessions']['dir']);
ini_set('session.auto_start', '0');

// Debug handling
//

// Set debug['level'] to a level if an (empty) debug<level> is present
if(is_file(LIBDIR.'/debugd'))
  $config->setValue('debug', 'dbase', 1); // print dbase messages
if(is_file(LIBDIR.'/debug1'))
  $config->setValue('debug', 'level', 1); // print messages at debug level 1
else if(is_file(LIBDIR.'/debug2'))
  $config->setValue('debug', 'level', 2); // print messages at debug level 2

if($config->data['debug']['level'] == 2) {
#  ini_set('error_reporting', '2039');  // E_ALL & ~E_NOTICE
  ini_set('error_reporting', '2047');  // E_ALL
  ini_set('display_errors', '1');
  ini_set('display_startup_errors', '1');
}
else {
  ini_set('display_errors', '0');
  ini_set('display_startup_errors', '0');
}

// Other PHP behaviour
//
ini_set('max_execution_time', '60');
ini_set('register_globals', '0');

// ////////////////////////////////////
// Laad libraries en classes
// ////////////////////////////////////

// Laad de gewenste dbase factory class
//
switch($config->data['db']['driver']) {
  case 'mysql'   : require('_factory_mysql.lib'); break;
  case 'sqlite'  : require('_factory_sqlite.lib'); break;
  case 'postgres': require('_factory_postgres.lib'); break;
  case 'firebird': require('_factory_firebird.lib'); break;
  default        : die("Onjuiste of geen database-driver geladen: {$config->data['db']['driver']}! Exit systeem"); break;
}

require("_rendering.lib");     // class voor rendering van de output paginas
require("_aform.lib");         // de formulierlayout class
require("_stam.lib");          // stamgegevens en methods

// Laad default logic
//
require("_preload.inc");

/* __END__ */
