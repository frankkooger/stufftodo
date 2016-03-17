<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _functions.sqlite.inc 215 2011-09-25 18:54:41Z otto $
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

// gzip path
define('GZIP', BINPATH ? BINPATH.PS."gzip" : "gzip");

// sqlite3 binary
define('SQLITE3', ($GLOBALS['config']->data['path']['sqlitebin']) ?
    '"'.$GLOBALS['config']->data['path']['sqlitebin'].PS.'sqlite3"' : 'sqlite3' );

// fullpath
$GLOBALS['config']->setValue('db', 'fullpath', $GLOBALS['config']->data['dir']['dbase'].PS.$GLOBALS['config']->data['db']['default'].'.db3');

define('DSN','sqlite:'.$GLOBALS['config']->data['db']['fullpath']);

// /////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
// /////////////////////////////////////////////////////////////////////////////////

/* ***************************************************************
 * @FUNCTION  dbaseDefault( str )
 * @SYLLABUS
 *   Om een dbase default te maken, schrijven we de naam van de default db
 *   direct in _const.inc
 *   Test voordat we een database laden, of het een valide dbase is
 *
 * ************************************************************** {{{ */
function dbaseDefault($naam) {
  // Test of de dbase een valide admin dbase is
  if(!isAdminDb($naam)) {
    $GLOBALS['msg']['red'][] = "'{$naam}.db3' is geen valide administratie database!";
    return(false);
  }
  // schrijf de nieuwe dbase als defaultdb in de config
  $conf = CONFIGDIR.PS.'_const.ini';
  if(! is_writable($conf)) {
    $GLOBALS['msg']['red'][] = "Kan de naam van database niet naar configuratie wegschrijven!";
    return(false);
  }
  // Nieuwe manier voor wegschrijven ini file
  $GLOBALS['config']->setValue('db', 'default', $naam);
  $GLOBALS['config']->save($conf);
  // laad de startpagina om de nieuwe gegevens te tonen
  print("<script language='javascript'>window.opener.location.href='{$GLOBALS['config']->data['url']['base_url']}/index.php';window.close();</script>");exit;
} // END FUNCTION dbaseDefault }}}


/* ***************************************************************
 * @FUNCTION  dbaseCreate( &object )
 * @SYLLABUS
 *   Maak een administratiedatabase
 *   deze functie is op dezelfde manier geimplementeerd als in de install
 *   procedure
 *
 * ************************************************************** {{{ */
function dbaseCreate(&$p) {
  $fullpath = fullPath($p->databasenaam);
  // maak een database door er een connectie mee te maken
  if(($connect = doConnect($p->databasenaam)) === false) 
    return(false);
  // controleer of de database is aangemaakt
  if(!file_exists($fullpath)) {
    $GLOBALS['msg']['red'][] = "Database {$p->databasenaam} is niet aangemaakt!";
    return(false);
  }

  // Indien connected met de nieuwe dbase, laad de tabellen en het gekozen schema
  if(!loadTabellen($connect)) {
    return(false);
  }
  else {
    if(!loadSchema($connect,$p->schema)) {
      return(false);
    }
  }
  // Als dit gelukt is, zet de nieuwe bedrijfsnaam
  // Doe dit alleen als er een bedrijfsnaam is meegegeven.
  if($p->bedrijfsnaam) {
    $connect->beginTransaction();
    $connect->query("UPDATE \"stamgegevens\" SET \"value\"='{$p->bedrijfsnaam}' where \"naam\"='adminnaam'");
    $connect->commit();
  }
  //
  return(true);

} // END FUNCTION dbaseCreate }}}



/* ***************************************************************
 * @FUNCTION  dbaseDelete( str )
 * @SYLLABUS
 *   Wis een administratiedatabase
 *
 * ************************************************************** {{{ */
function dbaseDelete($naam) {
  $fullpath = fullPath($naam);
  // Voor sqlite betekent dat het wissen van de databasefile.
  if(! unlink($fullpath)) {
    $GLOBALS['msg']['red'][] = "Ik kan database '{$fullpath}' niet wissen!";
    return(false);
  }
  return(true);
} // END FUNCTION dbaseDelete }}}


/* ***************************************************************
 * @FUNCTION  dbaseDump( str naam[ ,str logregel[ ,str datum]] )
 * @SYLLABUS
 *   Dump een database naar een backupfile en leg een logrecord vast
 *   $naam = de naam van de database
 *
 * ************************************************************** {{{ */
function dbaseDump($naam,$logregel='',$host='',$datum='') {
  // dumps alleen van de default geladen dbase
  $fullpath = $GLOBALS['config']->data['db']['fullpath'];
  printrc1($naam,"naam: " );
  printrc1($fullpath,"fullpath: " );
  // sqlite dbase dump options
  $PARM1='.dump';
  $DATE = ($datum) ? $datum : date("Ymd-Hi");
  // Backupfilename zonder path
  $backupfile = ($GLOBALS['config']->data['system']['gzip']) ?
    "_{$naam}.sqlite.{$GLOBALS['config']->data['system']['uname']}.{$DATE}.sql.gz" :
    "_{$naam}.sqlite.{$GLOBALS['config']->data['system']['uname']}.{$DATE}.sql";
  // backupfile met path
  $backupfile = $GLOBALS['config']->data['dir']['backup'].PS.$backupfile;
  // sqlite3 ./administratie.db3 .dump > bupfilename
  // _administratie.sqlite.unixml6.20091224-0039.sql.gz
  // controleer of de backupfile en de logfile gemaakt kunnen worden en zet de groepsrechten
  if(! setRights($backupfile)) return(false);
  if(! setRights($backupfile.".log")) return(false);
  // Worden de backupfiles ge-gzipt? 
  $bujob = ($GLOBALS['config']->data['system']['gzip']) ?
    SQLITE3." {$fullpath} {$PARM1} | ".GZIP." > {$backupfile}" :
    SQLITE3." {$fullpath} {$PARM1} > {$backupfile}";
  printrc1($bujob, "bujob: "); //die;
  // execute shellscript
  exec($bujob);
  file_put_contents($backupfile.'.log', $logregel);
  return($backupfile);
} // END FUNCTION dbaseDump }}}


/* ***************************************************************
 * @FUNCTION  dbaseLoad( str dumpfile, str dbasenaam[, bool straight=false] )
 * @SYLLABUS
 *   Laad een backupfile naar een database
 *   Indien 'straight' gebruik dan de sqlfile naam zoals wordt aangeleverd.
 *   Indien 'straight==false' gebruik het default dbasepad als path van de sqlfile
 *   (bij het terugzetten van backups die in het default dbasepath staan).
 *
 * ************************************************************** {{{ */
function dbaseLoad($sqlfile, $dbase, $straight=false) {
  // Als geen dbase is meegegeven (en de sqlfile dus in zijn eigen database
  // moet worden ingeladen), haal dan de databasenaam uit de sqlfile-naam
  // sqlfile  _administratie.sqlite.unixml6.20091224-0039.sql.gz
  !$dbase && $dbase = $GLOBALS['config']->data['db']['default'];
  $fullpath = fullPath($dbase);
  // wis de bestaande tabellen in de database
  wisTabellen($fullpath);
  // Zet terug
  if($straight) {
    $bujob = CAT." {$sqlfile} | ".SQLITE3." $fullpath";
  }
  else {
  // Is de bufile gezipt?
    $bujob = (preg_match("/\.gz$/", $sqlfile)) ?
      CAT." {$GLOBALS['config']->data['dir']['backup']}".PS."$sqlfile | ".GZIP." -d | ".SQLITE3." ".$fullpath :
      CAT." {$GLOBALS['config']->data['dir']['backup']}".PS."$sqlfile | ".SQLITE3." ".$fullpath;
  }
  printrc1($bujob, "bujob: "); //die;
  // execute shellscript
  exec($bujob);
  return($fullpath);
} // END FUNCTION dbaseLoad }}}


/* ***************************************************************
 * @FUNCTION  fullPath( str naam )
 * @SYLLABUS
 *   Maakt van een databasenaam een volledig path inclusief een extentie. Dit is van belang bij
 *   drivers waar een database als pathnaam wordt behandeld (sqlite, firebird).
 *   Deze databases staan standaard in de <fileroot>/dbase directory.
 *
 * ************************************************************** {{{ */
function fullPath($naam) {
  // controleer eerst of naam al een fullpath is
  printrc1($naam,"Is naam het fullpath: ");
  if((strpos($naam, PS)) !== false) return($naam);
  // extentie moet altijd 'db3' zijn
  // Als de naam zonder extentie is aangeleverd, zet hem erachter
  if(!preg_match("/\.[a-zA-Z0-9]{3}$/",$naam)) $ext = '.db3'; else $ext = '';
  $fullpath = $GLOBALS['config']->data['dir']['dbase'].PS.$naam.$ext;
  printrc1($fullpath,"Of Is fullpath het fullpath: ");
  return($fullpath);
} // END FUNCTION fullPath }}}


/* ***************************************************************
 * @FUNCTION  doConnect( str naam )
 * @SYLLABUS
 *   Maak een connectie met database 'naam'
 *
 * ************************************************************** {{{ */
function doConnect($naam) {
  $fullpath = fullPath($naam);
  try {
    $connect = new PDO("sqlite:".$fullpath);
  } catch (PDOException $e) {
    $GLOBALS['msg']['red'][] = "Ik kan geen connectie maken met database '{$fullpath}'!";
    return(false);
  }
  return($connect);
} // END FUNCTION doConnect }}}


/* ***************************************************************
 * @FUNCTION  isAdminDb( str naam )
 * @SYLLABUS
 *   Bepaal of een database een administratiedatabase is.
 *   Dit doen we door te bepalen of de tabel 'meta' in de database aanwezig is.
 *
 * ************************************************************** {{{ */
function isAdminDb($dbase) {
  // skip de volgende databases
  $skip = array('help');
  if(in_array($dbase,$skip)) return;
  // connect de database
  if (! $connect = doConnect($dbase)) {
    return(false);
  }
  // sqlite database bestaat en is connected, bevraag de 'meta'tabel
  if(existMeta($connect)) {
    return(true);
    // exist
  }
  return(false);
} // END FUNCTION isAdminDb }}}


/* ***************************************************************
 * @FUNCTION  existMeta( &connect )
 * @SYLLABUS
 *   Bepaal of de tabel 'meta' in de database aanwezig is.
 *   Dit is een hulpprocedure voor isAdminDb
 *
 * ************************************************************** {{{ */
function existMeta(&$connect) {
  $query = 'SELECT "name" FROM "sqlite_master" WHERE "name"=\'meta\'';
  if(($sth = $connect->query($query)) === false) {
    $GLOBALS['msg']['red'][] = "Kan geen connectie maken met de database";
    return(false);
  }
  return(($sth->fetchColumn()) ? true : false);
} // END FUNCTION existMeta }}}


/* ***************************************************************
 * @FUNCTION  wisTabellen( &object )
 * @SYLLABUS
 *   Wis alle bestaande tabellen uit een administratiedatabase.
 *   Dit doen we om een backup in een lege database terug te zetten.
 *
 * ************************************************************** {{{ */
function wisTabellen($fullpath) {
  // connect de database
  if (! $connect = doConnect($fullpath)) {
    return(false);
  }
  $query = 'SELECT "type","name" FROM "sqlite_master"';
  $arr = array();
  foreach($connect->query($query) AS $row) {
    $arr[] = array("type"=>$row['type'],"name"=>$row['name']);
  }
  // In deze array zijn tabellen en indexes. Verwijder eerst de indexes
  foreach($arr AS $ar) {
    if($ar['type'] == 'index') {
      printrc1($ar['name'], "Ik ga {$ar['type']} wissen: ");
      $connect->query("DROP INDEX ".$ar['name']);
    }
  }
  // Vervolgens de tables
  foreach($arr AS $ar) {
    if($ar['type'] == 'table') {
      printrc1($ar['name'], "Ik ga {$ar['type']} wissen: ");
      $connect->query("DROP TABLE ".$ar['name']);
    }
  }
} // END FUNCTION wisTabellen }}}


/* ***************************************************************
 * @FUNCTION  listDatabases( &object )
 * @SYLLABUS
 *   List de beschikbare:
 *     plain==false: administratiedatabases
 *     plain==true:  alle databases
 *
 * ************************************************************** {{{ */
function listDatabases($plain=false,$noextentions=true) {
  $File = new File();
  if($noextentions) {
    $arr = $File->get_files($GLOBALS['config']->data['dir']['dbase'],'','db3',false,true);
    foreach($arr AS $id=>$val) {
      if( preg_match("/^help.+$/",$val)) { unset($arr[$id]); continue; }
      $arr[$id] = preg_replace("/^(.+)\.[a-zA-Z0-9]{3}$/","$1",$val);
    }
    return($arr);
  }
  else
    return($File->get_files($GLOBALS['config']->data['dir']['dbase'],'','db3',false,true));
} // END FUNCTION listDatabases }}}


/* ***************************************************************
 * @FUNCTION  setRights( filenaam )
 * @SYLLABUS
 *   Bepaal of een file gemaakt kan worden (touch) en geef er chmod 664 aan
 *
 * ************************************************************** {{{ */
function setRights($file) {
  if(! touch($file)) return(false);
  if(! chmod($file,0664)) return(false);
  return(true);
} // END FUNCTION setRights }}}


// //////////////////////////////////////////////////////////////////
// laad de tabellen
// //////////////////////////////////////////////////////////////////

/* ***************************************************************
 * @FUNCTION  loadTabellen( &connect )
 * @SYLLABUS
 *   Creeer een tabelstructuur in een administratiedatabase
 *   Doe dit door een driver-afhankelijke structfile in te lezen.
 *
 * ************************************************************** {{{ */
function loadTabellen(&$connect) {
  // kijk eerst of het Schema bestaat
  $structfile = $GLOBALS['config']->data['dir']['struct'].PS
               .$GLOBALS['config']->data['db']['driver'].PS
               .'template.struct.'.$GLOBALS['config']->data['db']['driver'].'.php';
  if(! file_exists($structfile)) {
    $GLOBALS['msg']['red'][] = "template '{$structfile}' is er niet! Kan tabellen niet laden!";
    return(false);
  }
  elseif(! is_readable($structfile)) {
    $GLOBALS['msg']['red'][] = "Ik kan template '{$structfile}' niet lezen!";
    return(false);
  }
  else { // laad de structfile en execute die
    require($structfile);
    if(! isset($struct) || ! is_array($struct)) {
      $GLOBALS['msg']['red'][] = "Template '{$structfile}' niet in orde!";
      return(false);
    }
    return(loadSql($connect,$struct,"Tabellen niet aangemaakt!"));
  }
} // END FUNCTION loadTabellen }}}


/* ***************************************************************
 * @FUNCTION  loadSchema( &connect, str schemanaam )
 * @SYLLABUS
 *   Laad het gevraagde rekeningschema.
 *   De schema-files staan in een standaarddirectory <fileroot>/struct/schemas
 *   en hebben een standaard naamgeving
 *
 * ************************************************************** {{{ */
function loadSchema(&$connect,$schemaname) {
  // kijk eerst of het schema bestaat
  $schemafile = $GLOBALS['config']->data['dir']['struct'].PS.'schemas'.PS.'schema.'.$schemaname.'.php';
  if(! file_exists($schemafile)) {
    $GLOBALS['msg']['red'][] = "schema file '{$schemaname}' is er niet! Kan rekeningschema niet laden!";
    return(false);
  }
  else { // laad de schema file en execute die
    require($schemafile);
    if(! isset($schema) || ! is_array($schema)) {
      $GLOBALS['msg']['red'][] = "Schemafile '{$schemafile}' niet in orde!";
      return(false);
    }
    return(loadSql($connect,$schema,"Schema niet geladen!"));
  }
} // END FUNCTION loadSchema }}}


/* ***************************************************************
 * @FUNCTION  loadSql( &connect, &arr struct[, str error] )
 * @SYLLABUS
 *   Voer de sqlregels uit van de functies loadTabellen en loadStruct
 *
 * ************************************************************** {{{ */
function loadSql(&$connect,&$struct, $error='') {
  foreach($struct AS $val) {
    $connect->beginTransaction();
    // elke struct kan uit meerdere sql statements bestaan
    $ar = explode(';', $val);
    foreach($ar AS $val2) {
      // beware of lege queries
      if(empty($val2) || strlen($val2) < 5 ) continue;
      if($connect->query($val2) === false) {
        $GLOBALS['msg']['red'][] = $error;
        $connect->rollBack();
        return(false);
      }
    }
    $connect->commit();
  }
  return(true);
} // END FUNCTION loadSql }}}

/* __END__ */
