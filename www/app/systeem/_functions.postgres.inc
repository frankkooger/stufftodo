<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _functions.postgres.inc 50 2010-01-14 00:34:37Z otto $
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

define('USER', ($GLOBALS['config']->data['db']['passwd']) ?
  "-U {$GLOBALS['config']->data['db']['user']}" :
  "-U {$GLOBALS['config']->data['db']['user']}");

// LET OP
// Omdat er geen mogelijkheid is om bij tools als psql en pg_dump een password
// op de commandline mee te geven moet het password worden aangeboden vanuit
// het environment. Als PHP in safemode staat dan worden default alleen
// ENVparms toegestaan die beginnen met PHP_. Om onderstaand te laten werken
// moet je in php.ini opnemen: 
//  safe_mode_allowed_env_vars = PHP_,PG

putenv("PGPASSWORD=".$GLOBALS['config']->data['db']['passwd']);
putenv("PGUSER=".$GLOBALS['config']->data['db']['user']);

// gzip path
define('GZIP', BINPATH ? BINPATH.PS."gzip" : "gzip");

// LET OP
// Een default postgres installatie op Linux heeft gebruikersautenticatie
// ingesteld op 'ident', dus database-gebruiker moet als OS gebruiker ingelogd
// zijn. Om exec psql en pg_dump te laten werken moet gebruiker met password
// opgegeven kunnen worden. Dit autenticatietype is 'md5' of 'password'. Zorg
// ervoor dat dit ingesteld is in 'pg_hba.conf'.
// Als 'md5' is ingesteld op tcp sockets dan moet de hostnaam worden meegegeven.

define('HOST', ($GLOBALS['config']->data['db']['host']) ?
  " -h {$GLOBALS['config']->data['db']['host']} " :
  "");

define('PORT', ($GLOBALS['config']->data['db']['port']) ?
  " -p {$GLOBALS['config']->data['db']['port']} " :
  "");

// De sqlclient executable evt inclusief path
define('PSQL', ($GLOBALS['config']->data['path']['postgresbin']) ?
    '"'.$GLOBALS['config']->data['path']['postgresbin'].PS.'psql"' : 'psql');

// De backup executable evt inclusief path
define('PGDUMP', ($GLOBALS['config']->data['path']['postgresbin']) ?
    '"'.$GLOBALS['config']->data['path']['postgresbin'].PS.'pg_dump"' : 'pg_dump');

// De restore executable evt inclusief path
define('PGRESTORE', ($GLOBALS['config']->data['path']['postgresbin']) ?
    '"'.$GLOBALS['config']->data['path']['postgresbin'].PS.'pg_restore"' : 'pg_restore');

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
    $GLOBALS['msg']['red'][] = "'{$naam}' is geen valide administratie database!";
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
  // voor windows moeten we anders taggen
  $statement = ($GLOBALS['config']->data['system']['platform'] == 'windows') ?
    $statement = "CREATE DATABASE \"{$p->databasenaam}\";" :
    $statement = "'CREATE DATABASE \"{$p->databasenaam}\";'" ;
  // statement moet via de database 'postgres' of 'template1' (die zijn er
  // altijd) worden gestuurd anders klaagt psql met 'er is geen database
  // <user>' tenzij user=postgres uiteraard, die database is er.
  $bujob = "echo ".$statement." | ".PSQL." ".HOST.PORT." postgres";
  printrc1($bujob,"bujob in dbasecreate: ");
  exec($bujob);
  // controleer of de database is aangemaakt
  $result = pg_query("SELECT \"datname\" FROM pg_database WHERE \"datname\"='{$p->databasenaam}'");
  if(!pg_num_rows($result)) {
    $GLOBALS['msg']['red'][] = "database {$p->databasenaam} is niet aangemaakt!";
    return(false);
  }
  else { // connect met de nieuwe database
    if(($connect = doConnect($p->databasenaam)) === false) {
      return(false);
    }
  }
  // indien connected met de nieuwe dbase, laad de tabellen en het gekozen schema
  if(!loadtabellen($connect)) {
    return(false);
  }
  else {
    if(!loadschema($connect,$p->schema)) {
      return(false);
    }
  }
  // als dit gelukt is, zet de nieuwe bedrijfsnaam
  // doe dit alleen als er een bedrijfsnaam is meegegeven.
  if($p->bedrijfsnaam) 
    pg_query($connect,"update \"stamgegevens\" set \"value\"='{$p->bedrijfsnaam}' where \"naam\"='adminnaam'"); 
  //
  $GLOBALS['msg']['blue'][] = "database {$p->databasenaam} is aangemaakt!";
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
  // connect naar de postgres database
  if(($connect = doConnect("postgres")) === false) return(false);
  if(pg_query($connect,"DROP DATABASE \"{$naam}\"") === false) {
    $GLOBALS['msg']['red'][] = "Kan de database '{$naam}' niet verwijderen!";
    return(false);
  }
} // END FUNCTION dbaseDelete }}}


/* ***************************************************************
 * @FUNCTION  dbaseDump( str naam[ ,str logregel[ ,str datum]] )
 * @SYLLABUS
 *   Dump een database naar een backupfile en leg een logrecord vast
 *   $naam = de naam van de database
 *
 * ************************************************************** {{{ */
function dbaseDump($naam,$logregel='',$host='',$datum='') {
  // postgres dbase dump options
  // --inserts creeert INSERT (geen full columns) commands en geen copy commands
  // -C, --create  Begin the output with a command to create the database
  // itself and reconnect to the created database. (With a script of this form,
  // it doesn't matter which database in the destination installation you
  // connect to before running the script.) If --clean is also specified, the
  // script drops and recreates the target database before reconnecting to it.
  // -c, --clean  insert commandos voor deleten van dbase objecten voor schrijven van nieuwe

  $PARM1='--inserts -C -c';
  $DATE = ($datum) ? $datum : date("Ymd-Hi");
  // Backupfilename zonder path
  $backupfile = ($GLOBALS['config']->data['system']['gzip']) ?
    "_{$naam}.postgres.{$GLOBALS['config']->data['system']['uname']}.{$DATE}.sql.gz" :
    "_{$naam}.postgres.{$GLOBALS['config']->data['system']['uname']}.{$DATE}.sql";
  // backupfile met path
  $backupfile = $GLOBALS['config']->data['dir']['backup'].PS.$backupfile;
  // _administratie.postgres.unixml6.20091224-0039.sql.gz
  // controleer of de backupfile en de logfile gemaakt kunnen worden en zet de groepsrechten
  if(! setRights($backupfile)) return(false);
  if(! setRights($backupfile.".log")) return(false);
  // Worden de backupfiles ge-gzipt? 
  // Gebruik voor Firebird /dev/stdout als outputdevice.
  $bujob = ($GLOBALS['config']->data['system']['gzip']) ?
    PGDUMP." {$PARM1} ".HOST.PORT." {$naam} | ".GZIP." > ".$backupfile :
    PGDUMP." {$PARM1} ".HOST.PORT." {$naam} > ".$backupfile ;
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
 * Een ASCII bupfile wordt teruggezet met psql en niet met pg_restore
 * Zie verder de Postgresql manuals over deze onderwerpen.
 * Het is nog niet gelukt om een -c bupfile weer in de database in te lezen.
 * Handmatig met dezelfde commando's lukte dat wel.
 *
 * !! Het is nog niet gelukt om vanuit het programma de database te
 *    droppen en weer opnieuw aan te maken, alvorens er een bupfile 
 *    in terug te kunnen lezen. Doe dat vooralsnog met de hand:
 *     # echo "DROP database administratie\;" | psql postgres
 *     # createdb administratie
 *    Er is nu een lege database waarin een bupfile kan worden teruggezet met:
 *     # cat _bupfile.gz | gzip -d | psql administratie
 *
 *    Bedenk dat voor deze functies de env.vars 'PGPASSWORD' en 'PGUSER' 
 *    moeten staan anders de commando's ermee uitbreiden:
 *     # echo "DROP database administratie\;" | psql postgres -U webuser -W
 *     # createdb administratie -U webuser -W (-W vraagt een password)
 * ************************************************************** {{{ */
function dbaseLoad($bupfile, $dbase, $straight=false) {
  // Als geen dbase is meegegeven (en de bupfile dus in zijn eigen database
  // moet worden ingeladen), haal dan de databasenaam uit de bupfile-naam
  // bupfile  _administratie.postgres.unixml6.20091224-0039.sql.gz
  !$dbase && $dbase = preg_replace("/_?([^\.]+).*$/", "$1",  $bupfile);
  // de bestaande tabellen worden gewist door commandos in de dumpfile die is gemaakt met pg_dump -c
  //
  // Lock de database
  // status for exec pg_dump. Indien 0: succes, Indien 1: geen succes
  $output = array();
  $status = false;
  // TODO shutdown de database om alle connecties te beeindigen (ook de huidige stam)
  $PARM1 = "-q";
  // Zet terug
  // TODO straight nader uitwerken (indien nog nodig)
  if($straight) {
    $bujob = '';
  }
  else {
  // Is de bufile gezipt?
    $bujob = (preg_match("/\.gz$/", $bupfile)) ?
      CAT." ".$GLOBALS['config']->data['dir']['backup'].PS.$bupfile." | ".GZIP." -d | ".PSQL." {$PARM1} ".$dbase." " :
      CAT." ".$GLOBALS['config']->data['dir']['backup'].PS.$bupfile." | ".PSQL." {$PARM1} ".$dbase." " ;
      //CAT." ".$GLOBALS['config']->data['dir']['backup'].PS.$bupfile." | ".GZIP." -d | ".PGRESTORE." -c -d ".$dbase." " :
      //CAT." ".$GLOBALS['config']->data['dir']['backup'].PS.$bupfile." | ".PGRESTORE." -c -d ".$dbase." " ;
  }
  // execute shellscript
  $status = false;
  exec($bujob,$output,$status);
  printrc1($bujob, "bujob: "); //die;
  printrc1($status, "dit is de status van psql: " );
  return($dbase);
} // END FUNCTION dbaseLoad }}}


/* ***************************************************************
 * @FUNCTION  doConnect( str naam )
 * @SYLLABUS
 *   Maak een connectie met database 'naam'
 *
 * ************************************************************** {{{ */
function doConnect($naam) {
    $cstring = "dbname={$naam} "
              ."host={$GLOBALS['config']->data['db']['host']} "
              ."port={$GLOBALS['config']->data['db']['port']} "
              ."user={$GLOBALS['config']->data['db']['user']} "
              ."password={$GLOBALS['config']->data['db']['passwd']}";
  try {
      @$connect = pg_connect($cstring);
    } catch(Exception $e) {
      printrc1($e,"exception: ");
    }
    if($connect === false) { // Kan geen connectie maken of Access denied for user 'gebruiker'@'localhost' (using password: YES)
      $eriseenfout = true;
      $GLOBALS['msg']['red'][] = "Kan geen connectie maken met de postgres database: {$naam}!";
      return(false);
    }
    else {
      return($connect);
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
  // connect met de gevraagde database
  if(($connect = doConnect($naam)) === false) {
    return(false);
  }
  // gebruiker heeft toegang tot postgres en de database, bevraag de tabellen
  if(existMeta($connect)) {
    // exist
    return(true);
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
  $sth = pg_query($connect, "SELECT \"relname\" FROM \"pg_class\" WHERE \"relname\"='meta'");
  return(pg_num_rows($sth) ? true : false);
} // END FUNCTION existMeta }}}


/* ***************************************************************
 * @FUNCTION  wisTabellen( &object )
 * @SYLLABUS
 *   Wis alle bestaande tabellen uit een administratiedatabase.
 *   Dit doen we om een backup in een lege database terug te zetten.
 *
 * ************************************************************** {{{ */
function wisTabellen($name) {
  // connect eerst aan de database
  if (! $connect = doConnect($name)) return(false);
  $query = "select * from information_schema.tables where table_schema='public' and table_type='BASE TABLE'";
  $result = pg_query($connect, $query);
  while($obj = pg_fetch_object($result)) $arr[] = $obj->table_name;
  foreach($arr AS $id=>$naam) {
    pg_query($connect, "DROP TABLE \"{$naam}\"");
  }
  return(true);
} // END FUNCTION wisTabellen }}}


/* ***************************************************************
 * @FUNCTION  listDatabases( &object )
 * @SYLLABUS
 *   List de beschikbare:
 *     plain==false: administratiedatabases
 *     plain==true:  alle databases
 *
 * ************************************************************** {{{ */
function listDatabases($plain=false) {
  // connect eerst aan postgres
  if (! $connect = doConnect('postgres')) return(false);
  $query = "SELECT \"datname\" FROM pg_database WHERE \"datname\" NOT IN ('template1','template0','postgres' )";
  $result = pg_query($query);
  $arr = array();
  while($obj = pg_fetch_object($result)) $arr[] = $obj->datname;
  // test welke dbases administratie dbases zijn
  foreach($arr AS $id=>$naam) {
    if(!$plain)
      if(!isAdminDb($naam))
        unset($arr[$id]);
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
    pg_query($connect,"START TRANSACTION");
    // elke struct kan uit meerdere sql statements bestaan
    $ar = explode(';', $val);
    foreach($ar AS $val2) {
      // beware of lege queries
      if(empty($val2) || strlen($val2) < 5 ) continue;
      if(pg_query($connect,$val2) === false) {
        $GLOBALS['msg']['red'][] = $error;
        pg_query($connect,"ROLLBACK");
        return(false);
      }
      pg_query($connect,"COMMIT");
    }
  }
  return(true);
} // END FUNCTION loadSql }}}

/* __END__ */
