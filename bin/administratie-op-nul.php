#!/usr/bin/php -q
<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: administratie-op-nul.php 86 2010-04-29 20:49:49Z otto $
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
 * Hulpprocedure !Alleen voor gebruik met de mysql driver!
 *
 * Verwijder alle mutaties, inkoop- verkoopfacturen, debiteuren- en
 * crediteurenstamgegevens van de administratie en zet de saldi van de
 * grootboekrekeningen op nul
 *
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

expand_argv($argv, "", array("--ikweethetzeker"));

if(empty($A_ikweethetzeker)) {
  $scriptname = "./".basename($argv[0]);
  $scriptname = $argv[0];
  printnl("\n\t==============================================================\n");
  printnl("\tDIT IS EEN LEVENSGEVAARLIJK COMMANDO!!");
  printnl("");
  printnl("\tJe staat op het punt om administratie: {$administratie}");
  printnl("\tvolledig op nul te zetten.");
  printnl("\tAls je zeker weet dat je dit wilt doen, geef dan het commando:");
  printnl("\n\t{$scriptname} --ikweethetzeker\n");
  printnl("\t==============================================================\n");
  exit;
}

// open een db pointer met adminuser voor TRUNCATE_TABLE
//
$dba = new DbConnector('localhost',$GLOBALS['ML_SYSTEM']['db']['adminuser'],$GLOBALS['ML_SYSTEM']['db']['adminpasswd'],$administratie,'debugon');


// open een logger object
$log = new Logger("administratie-op-nul.log", "", "3", "new", "header");

$log->p("Administratie: ".$administratie);

// verwijder alle boekingen uit mutatietabellen

$arr = array(
  "TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['grootboeksaldi']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['journaal']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['boekregels']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['boekregels_trash']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['eindbalansen']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['eindbalansregels']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['dagboekhistorie']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['inkoopfacturen']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['verkoopfacturen']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['pinbetalingen']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['btwaangiftes']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['crediteurenstam']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['debiteurenstam']}`;"
 ,"TRUNCATE `{$GLOBALS['ML_SYSTEM']['tbl']['eindcheck']}`;"
 ,"ALTER TABLE `{$GLOBALS['ML_SYSTEM']['tbl']['grootboeksaldi']}` AUTO_INCREMENT=1;"
 ,"ALTER TABLE `{$GLOBALS['ML_SYSTEM']['tbl']['journaal']}` AUTO_INCREMENT=1;"
 ,"ALTER TABLE `{$GLOBALS['ML_SYSTEM']['tbl']['boekregels']}` AUTO_INCREMENT=1;"
 ,"ALTER TABLE `{$GLOBALS['ML_SYSTEM']['tbl']['eindbalansen']}` AUTO_INCREMENT=1;"
 ,"ALTER TABLE `{$GLOBALS['ML_SYSTEM']['tbl']['eindbalansregels']}` AUTO_INCREMENT=1;"
 ,"ALTER TABLE `{$GLOBALS['ML_SYSTEM']['tbl']['inkoopfacturen']}` AUTO_INCREMENT=1;"
 ,"ALTER TABLE `{$GLOBALS['ML_SYSTEM']['tbl']['verkoopfacturen']}` AUTO_INCREMENT=1;"
 ,"ALTER TABLE `{$GLOBALS['ML_SYSTEM']['tbl']['pinbetalingen']}` AUTO_INCREMENT=1;"
 ,"ALTER TABLE `{$GLOBALS['ML_SYSTEM']['tbl']['btwaangiftes']}` AUTO_INCREMENT=1;"
 ,"ALTER TABLE `{$GLOBALS['ML_SYSTEM']['tbl']['crediteurenstam']}` AUTO_INCREMENT=1;"
 ,"ALTER TABLE `{$GLOBALS['ML_SYSTEM']['tbl']['debiteurenstam']}` AUTO_INCREMENT=1;"
 ,"ALTER TABLE `{$GLOBALS['ML_SYSTEM']['tbl']['eindcheck']}` AUTO_INCREMENT=1;"
);

foreach($arr AS $val) {
  $dba->Do_query($val);
  $log->p($val);
}

// zet de grootboekpopulariteit op 0
//
$query[] = "UPDATE {$GLOBALS['ML_SYSTEM']['tbl']['grootboekstam']} SET populariteit=0";

// zet evt saldi en locks in dagboeken op 0
//
$query[] = "UPDATE {$GLOBALS['ML_SYSTEM']['tbl']['dagboeken']} SET boeknummer=0,saldo='0',slot=0 ";

foreach($query AS $val) {
  $log->p($val);
  $dba->Do_query($val);
}

exit;

?>
