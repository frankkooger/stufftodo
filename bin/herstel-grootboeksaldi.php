#!/usr/bin/php -q
<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: herstel-grootboeksaldi.php 172 2011-03-01 11:14:38Z frank $
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
 * Hulpprocedure OpenAdmin.nl
 *
 * Herstel de geconsolideerde saldi van de grootboekrekeningen.
 *
 * Loop hiervoor voor elke grootboekrekening de boekregels af en saldeer de
 * daar gevonden waarden.  Stop de eindwaarde in grootboekstam.saldo
 *
 * Doe dit niet bij totaalrekeningen, daarvoor geldt een andere procedure (die
 * nog uitgewerkt moet worden)
 *
 * @abstract
 * @package		OpenAdmin.nl
 * @since		1.0
 */

// Bepaal of we op een windoze platform draaien
//
if(preg_match("/^[c-zC-Z][:][\\\]/", __FILE__)) { // windoze
  define('PS', '\\');
  define('LIBDIR',dirname(__FILE__).'\\..\\lib');
  $includepath = '.'.PS.';'.LIBDIR;
}
else {
  define('PS', '/');
  define('LIBDIR',dirname(__FILE__).'/../lib');
  $includepath = '.'.PS.':'.LIBDIR;
}
 
define('CONFIGDIR',preg_replace("/(^.+).lib$/","$1".PS.'config',dirname(__FILE__).PS.'..'.PS.'config'));

ini_set('include_path', $includepath);

require("_oa.lib");

// Administratie en boekjaar komen uit _const.inc en stam

// Configuration loading
//
require('INIFile.class');
$config = new INIFile(CONFIGDIR."/_const.ini");
$version = new INIFile(CONFIGDIR."/_version.ini");

require("_system.inc");

// Laad de gewenste dbase factory class
//
switch($config->data['db']['driver']) {
  case 'mysql'   : require('_factory_mysql.class'); break;
  case 'sqlite'  : require('_factory_sqlite.class'); break;
  case 'postgres': require('_factory_postgres.class'); break;
  case 'firebird': require('_factory_firebird.class'); break;
  default        : die("Onjuiste of geen database-driver geladen: {$GLOBALS['ML_SYSTEM']['db']['driver']}! Exit systeem"); break;
}

require("_stam.class");
require("_grootboek.class");

$stam = new Stam();
$grootboek = new Grootboek();

$msg = array("red"=>"","blue"=>"");

#print("stam: "); print_r($stam);
#print("grootboek: "); print_r($grootboek);

expand_argv($argv, "", array("--ikweethetzeker"));

if(empty($A_ikweethetzeker)) {
  $scriptname = "./".basename($argv[0]);
  $scriptname = $argv[0];
  printnl("\n\t==================================================================\n");
  printnl("\tDeze procedure herstelt de grootboeksaldi adhv. de gedane boekingen!");
  printnl("");
  printnl("\tHerstel vindt plaats op de administratie: {$config->data['db']['default']}");
  printnl("\tAls je zeker weet dat je dit wilt doen, geef dan het commando:");
  printnl("\n\t{$scriptname} --ikweethetzeker\n");
  printnl("\t====================================================================\n");
  exit;
}

if(!$grootboek->herstelSaldi()) $msg['red'][] = 'Geen saldi hersteld';

print("msg: "); print_r($msg);

?>
