<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _functions.mysql.inc 215 2011-09-25 18:54:41Z otto $
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

define('HOST', ($GLOBALS['config']->data['db']['host'] != 'localhost') ?
  '-h '.$GLOBALS['config']->data['db']['host'] : '');

define('USER', ($GLOBALS['config']->data['db']['passwd']) ?
  "-u{$GLOBALS['config']->data['db']['user']} -p{$GLOBALS['config']->data['db']['passwd']}" :
  "-u{$GLOBALS['config']->data['db']['user']}");

// gzip path
define('GZIP', BINPATH ? BINPATH.PS."gzip" : "gzip");

// De mysql executable evt inclusief path
define('MYSQL', ($GLOBALS['config']->data['path']['mysqlbin']) ?
    '"'.$GLOBALS['config']->data['path']['mysqlbin'].PS.'mysql"' : 'mysql');

// De dump executable evt inclusief path
define('MYSQLDUMP', ($GLOBALS['config']->data['path']['mysqlbin']) ?
    '"'.$GLOBALS['config']->data['path']['mysqlbin'].PS.'mysqldump"' : 'mysqldump');

// De admin executable evt inclusief path
define('MYSQLADMIN', ($GLOBALS['config']->data['path']['mysqlbin']) ?
    '"'.$GLOBALS['config']->data['path']['mysqlbin'].PS.'mysqladmin"' : 'mysqladmin');

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
  // mysql databases hebben geen extentie
  // Test of de dbase een valide admin dbase is
  if(!isAdminDb($naam)) {
    $GLOBALS['msg']['red'][] = "'{$naam}' is geen valide administratie database!";
    return(false);
  }
  // schrijf de nieuwe dbase als defaultdb in de config
  $conf = CONFIGDIR.PS.'_const.ini';
  if(! is_writable($conf)) {
    $GLOBALS['msg']['red'][] = "Kan de naam van database niet naar configuratie wegschrijven!";
    return(false);
  }
  /*
  $str = file_get_contents($conf);
  $arr = explode("\n",$str);
  for($i=0;$i<count($arr);$i++) {
    if(preg_match("/([$]GLOBALS\['config'\->data]\['db'\]\['default'\]).+$/",$arr[$i],$ar)) {
      $arr[$i] = $ar[1]." = '{$naam}';";
    }
  }
  $str = implode("\n", $arr);
  file_put_contents($conf,$str);
  */
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
  // in mysql hebben we geen fullpath
  $bujob = "echo CREATE DATABASE $p->databasenaam | ".MYSQL.' '.HOST.' '.USER ;
  printrc1($bujob, "bujob: "); // die;
  exec($bujob);

  if(!$connect = doConnect($p->databasenaam)) {
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
    mysql_query("UPDATE \"stamgegevens\" SET \"value\"='{$p->bedrijfsnaam}' where \"naam\"='adminnaam'");
  }
  //
  return(true);
} // END FUNCTION dbaseCreate }}}


/* ***************************************************************
 * @FUNCTION  dbaseDelete( str )
 * @SYLLABUS
 *   Wis een administratiedatabase
 *   Dit doe je door met de postgres database te connecten en van daaruit een
 *   drop database commando te geven
 * ************************************************************** {{{ */
function dbaseDelete($naam) {
  // Assembleer het shell commando voor drop via mysqladmin
  $bujob = MYSQLADMIN.' '.HOST.' '.USER." drop -f {$naam}";
  printrc1($bujob, "bujob: "); //die;
  // execute shellcommando
  exec($bujob);
} // END FUNCTION dbaseDelete }}}


/* ***************************************************************
 * @FUNCTION  dbaseDump( str naam[ ,str logregel[ ,str datum]] )
 * @SYLLABUS
 *   Dump een database naar een backupfile en leg een logrecord vast
 *   $naam = de naam van de database
 *
 * ************************************************************** {{{ */
function dbaseDump($naam,$logregel='',$host='',$datum='') {
  // Mysql dbase dump options
  $OPTIONS="--skip-opt --create-options --set-charset -q -Q --add-drop-table -c ";
  // compatible mode
  $compatible = true;
  if($compatible) {
    $PARM1='--compatible=ansi --default-character-set=latin1 ';
    $PARM2='ansi';
  }
  else {
    $PARM1=' --default-character-set=utf8 ';
    $PARM2='';
  }
  // Voeg een evt hostnaam toe aan PARM2
  $PARM2 .= ($host) ? ".".$host : '';
  // Maak de datum op
  $DATE = ($datum) ? $datum : date("Ymd-Hi");
  // Volledige naam backupfile
  $backupfile =  "_{$naam}.mysql.{$GLOBALS['config']->data['system']['uname']}.{$DATE}.{$PARM2}.sql";
  // Voeg .gz toe indien gezipt
  $backupfile .= ($GLOBALS['config']->data['system']['gzip']) ? '.gz' : '';
  // backupfile met path
  $backupfile = $GLOBALS['config']->data['dir']['backup'].PS.$backupfile;
  // controleer of de backupfile en de logfile gemaakt kunnen worden en zet de groepsrechten
  if(! setRights($backupfile)) return(false);
  if(! setRights($backupfile.".log")) return(false);
  // Worden de backupfiles ge-gzipt? 
  // Is er sprake van een externe database host?
  if($host) $host = "-h ".$host." ";
  $bujob = ($GLOBALS['config']->data['system']['gzip']) ?
    MYSQLDUMP." ".USER." {$OPTIONS}  {$PARM1} {$host} {$naam} | ".GZIP." > {$backupfile}" :
    MYSQLDUMP." ".USER." {$OPTIONS}  {$PARM1} {$host} {$naam} > {$backupfile}";
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
  // sqlfile='_administratie.unixml9.20060228-0033.sql.gz'
  if(! $dbase) {
    $dbase = preg_replace("/_?([^\.]+).*$/", "$1",  $sqlfile);
  }
  if($straight) {
    $bujob = CAT." {$sqlfile} | ".MYSQL.' '.HOST.' '.USER.' '.$dbase;
  }
  else {
  // Is de bufile gezipt?
    $bujob = (preg_match("/\.gz$/", $sqlfile)) ?
      CAT." {$GLOBALS['config']->data['dir']['backup']}".PS."$sqlfile | ".GZIP." -d | ".MYSQL.' '.HOST.' '.USER.' '.$dbase :
      CAT." {$GLOBALS['config']->data['dir']['backup']}".PS."$sqlfile | ".MYSQL.' '.HOST.' '.USER.' '.$dbase;
  }
  printrc1($bujob, "bujob: "); // die;
  // Maak eerst de database leeg
  wisTabellen($dbase);
  // op dit punt zijn de bestaande tabellen uit de database verwijderd
  // execute shellscript
  exec($bujob);
  return($dbase);
} // END FUNCTION dbaseLoad }}}


/* ***************************************************************
 * @FUNCTION  doConnect( str naam )
 * @SYLLABUS
 *   Maak een connectie met database 'naam'
 *
 * ************************************************************** {{{ */
function doConnect($naam) {
  // maak een connectie met de database
  @$connect = mysql_connect($GLOBALS['config']->data['db']['host']
                           ,$GLOBALS['config']->data['db']['user']
                           ,$GLOBALS['config']->data['db']['passwd']
                           );
  if(mysql_errno() == 1045) { // Access denied for user 'gebruiker'@'localhost' (using password: YES)
    $eriseenfout = true;
    $GLOBALS['msg']['red'][] = "De gebruiker/passwd '{$GLOBALS['config']->data['db']['user']}/{$GLOBALS['config']->data['db']['passwd']}' heeft geen toegang tot mysql";
    return(false);
  }
  else if(mysql_errno() === 0){ 
    // gebruiker heeft toegang tot mysql maar hoeft nog geen toegang te hebben tot de database
    if($naam) mysql_query("USE ".$naam, $connect);
    // zet de connectie in ANSI mode
    mysql_query("set SESSION sql_mode='ANSI_QUOTES,PIPES_AS_CONCAT'");
    return($connect);
  }
  else {
    $GLOBALS['msg']['red'][] = "Kan geen connectie maken met mysql!";
    return(false);
  }
} // END FUNCTION doConnect }}}


/* ***************************************************************
 * @FUNCTION  isAdminDb( str naam )
 * @SYLLABUS
 *   Bepaal of een database een administratiedatabase is.
 *   Dit doen we door te bepalen of de tabel 'meta' in de database aanwezig is.
 *
 * ************************************************************** {{{ */
function isAdminDb($naam) {
  // skip de volgende databases
  $skip = array('mysql','test','information_schema');
  if(in_array($naam,$skip)) return;
  // connect de database
  if (! $connect = doConnect($naam)) return(false);
  // gebruiker heeft toegang tot mysql en de database, bevraag de tabellen
  if(existMeta($connect,$naam)) {
    // exist
    return(true);
  }
  else 
    return(false);
} // END FUNCTION isAdminDb }}}


/* ***************************************************************
 * @FUNCTION  existMeta( &connect )
 * @SYLLABUS
 *   Bepaal of de tabel 'meta' in de database aanwezig is.
 *   Dit is een hulpprocedure voor isAdminDb
 *
 * ************************************************************** {{{ */
function existMeta(&$connect,$naam='') {
  if($naam) mysql_query('USE '.$naam, $connect);
  $result = mysql_query('show tables', $connect);
  $arr = array();
  while($row = mysql_fetch_row($result)) $arr[] = $row[0];
  return(in_array('meta', $arr));
} // END FUNCTION existMeta }}}


/* ***************************************************************
 * @FUNCTION  wisTabellen( &object )
 * @SYLLABUS
 *   Wis alle bestaande tabellen uit een administratiedatabase.
 *   Dit doen we om een backup in een lege database terug te zetten.
 *
 * ************************************************************** {{{ */
function wisTabellen($naam) {
  // connect de database
  if (! $connect = doConnect($naam)) return(false);
  if($naam) mysql_query('USE '.$naam, $connect);
  $result = mysql_query('show tables');
  $arr = array();
  while($row = mysql_fetch_row($result)) $arr[] = $row[0];
  printrc1($arr);
  // In deze array zijn de tabellen; de indexes worden met de tabellen gewist. 
  foreach($arr AS $name) {
    $result = mysql_unbuffered_query("DROP TABLE \"{$name}\"");
    printrc1($result, "was droppen een succes: ");
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
function listDatabases($plain=false,$noextentions='') {
  // connect de database
  if (! $connect = doConnect('mysql')) return(false);
  $result = mysql_query('show databases');
  $arr = array();
  while($obj = mysql_fetch_object($result)) $arr[] = $obj->Database;
  // test welke dbases administratie dbases zijn
  $skip = array("mysql","information_schema","wega");
  foreach($arr AS $id=>$naam) {
    if(in_array($naam,$skip)) {
      unset($arr[$id]);
      continue;
    }
    if(!$plain) {
      if(!isAdminDb($naam))
        unset($arr[$id]);
    }
  }
  return($arr);
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
  $schemafile = $GLOBALS['config']->data['dir']['struct'].PS
               .'schemas'.PS.'schema.'.$schemaname.'.php';
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
    // elke struct kan uit meerdere sql statements bestaan
    $ar = explode(';', $val);
    foreach($ar AS $val2) {
      // beware of lege queries
      if(empty($val2) || strlen($val2) < 5 ) continue;
      if(mysql_query($val2) === false) {
        $GLOBALS['msg']['red'][] = $error;
        return(false);
      }
    }
  }
  return(true);
} // END FUNCTION loadSql }}}

/* __END__ */
