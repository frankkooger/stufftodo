<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _functions.firebird.inc 215 2011-09-25 18:54:41Z otto $
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
  "-USER {$GLOBALS['config']->data['db']['user']} -PASSWORD {$GLOBALS['config']->data['db']['passwd']}" :
  "-USER {$GLOBALS['config']->data['db']['user']}");

// gzip path
define('GZIP', BINPATH ? BINPATH.PS."gzip" : "gzip");

// Bepaal of de Firebird command-processor 'isql-fb' (Linux) of 'isql' (Windoze) is
define('ISQLBIN', $GLOBALS['config']->data['system']['platform'] == 'windows' ? 
  'isql' : 'isql-fb');

// voor enkele functies hebben we isql nodig
define('ISQL', ($GLOBALS['config']->data['path']['firebirdbin']) ?
  '"'.$GLOBALS['config']->data['path']['firebirdbin'].'\\'.ISQLBIN.'"': ISQLBIN );

// De backup executable evt inclusief path
define('GBAK', preg_replace("/(isql-fb|isql)/", 'gbak', ISQL));

// gfix binary
define('GFIX', preg_replace("/(isql-fb|isql)/", 'gfix', ISQL));

// fullpath
$GLOBALS['config']->setValue('db', 'fullpath', $GLOBALS['config']->data['dir']['dbase'].PS.$GLOBALS['config']->data['db']['default'].'.fdb');

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
 * **************************************************************{{{ */
function dbaseDefault($naam) {
  // Test of de dbase een valide admin dbase is
  if(!isAdminDb($naam)) {
    $GLOBALS['msg']['red'][] = "'{$naam}.fdb' is geen valide administratie database!";
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
 * **************************************************************{{{ */
function dbaseCreate(&$p) {
  $fullpath = fullPath($p->databasenaam);
  // voor windows moeten we anders taggen
  $statement = ($GLOBALS['config']->data['system']['platform'] == 'windows') ?
    $statement = "CREATE DATABASE '{$fullpath}';" :
    $statement = "\"CREATE DATABASE '{$fullpath}';\"" ;
  $bujob = "echo ".$statement." | ".ISQL." ".USER;
  printrc1($bujob,"bujob in dbaseCreate: ");
  exec($bujob);
  // controleer of de database is aangemaakt
  if(!file_exists($fullpath)) {
    $GLOBALS['msg']['red'][] = "Database {$p->databasenaam} is niet aangemaakt!";
    return(false);
  }
  else { // connect met de nieuwe database
    if(($connect = doConnect($fullpath)) === false) {
      return(false);
    }
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
  if($p->bedrijfsnaam) 
    ibase_query("UPDATE \"stamgegevens\" SET \"value\"='{$p->bedrijfsnaam}' where \"naam\"='adminnaam'"); 
  //
  $GLOBALS['msg']['blue'][] = "Database {$p->databasenaam} is aangemaakt!";
  return(true);

} // END FUNCTION dbaseCreate }}}


/* ***************************************************************
 * @FUNCTION  dbaseDelete( str )
 * @SYLLABUS
 *   Wis een administratiedatabase
 *   Dit doe je door met de database te connecten en een drop sql commando te geven
 *
 * **************************************************************{{{ */
function dbaseDelete($naam) {
  if(($connect = doConnect($naam)) === false) return(false);
  if(ibase_drop_db() === false) {
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
 * **************************************************************{{{ */
function dbaseDump($naam,$logregel='',$host='',$datum='') {
  // naam van de database met volledig path en extentie indien sqlite en firebird
  // $naam = <pre>/pub/webs/openadministratie/dbase/administratie.fdb</pre>
  $fullpath = fullPath($naam);
  // firebird dbase dump options
  $PARM1='-B';
  $DATE = ($datum) ? $datum : date("Ymd-Hi");
  // Backupfilename zonder path
  $backupfile = ($GLOBALS['config']->data['system']['gzip']) ?
    "_{$naam}.firebird.{$GLOBALS['config']->data['system']['uname']}.{$DATE}.fbk.gz" :
    "_{$naam}.firebird.{$GLOBALS['config']->data['system']['uname']}.{$DATE}.fbk";
  // backupfile met path
  $backupfile = $GLOBALS['config']->data['dir']['backup'].PS.$backupfile;
  // gbak -USER SYSDBA -PASSWORD "OpenAdmin.nl" -B ./administratie.fdb ./bup.administratie2.fdb
  // _administratie.firebird.unixml6.20091224-0039.fbk.gz
  // controleer of de backupfile en de logfile gemaakt kunnen worden en zet de groepsrechten
  if(! setRights($backupfile)) return(false);
  if(! setRights($backupfile.".log")) return(false);
  // Worden de backupfiles ge-gzipt? 
  // Gebruik voor Firebird /dev/stdout als outputdevice.
  $bujob = ($GLOBALS['config']->data['system']['gzip']) ?
    GBAK." ".USER." ".$PARM1." ".$fullpath." stdout | ".GZIP." > ".$backupfile :
    GBAK." ".USER." ".$PARM1." ".$fullpath." ".$backupfile ;
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
 * **************************************************************{{{ */
function dbaseLoad($bupfile, $dbase, $straight=false) {
  // Als geen dbase is meegegeven (en de bupfile dus in zijn eigen database
  // moet worden ingeladen), haal dan de databasenaam uit de bupfile-naam
  // bupfile  _administratie.firebird.unixml6.20091224-0039.fbk.gz
  !$dbase && $dbase = preg_replace("/_?([^\.]+).*$/", "$1",  $bupfile);
  // maak van dbase weer een volledig path met extentie
  $dbase = $GLOBALS['config']->data['dir']['dbase'].PS.$dbase.'.fdb';
  // de database wordt opnieuw gecreeerd dus we hoeven de bestaande tabellen niet eerst te wissen
  //wisTabellen($dbase);
  // Lock de database
  // status for exec gbak en gfix. Indien 0: succes, Indien 1: geen succes
  $output = array();
  $status = false;
  $PARM1 = " -recreate overwrite ";
  // Zet terug
  // TODO Dit werkt niet omdat we nog een connectie met de database hebben.
  if($straight) {
    $bujob = GBAK." ".USER.$PARM1.$bupfile." ".$dbase ;
    // gbak  -USER SYSDBA -PASSWORD OpenAdmin.nl -recreate overwrite ./bup.administratie.fdb ./administratie.fdb
  }
  else {
  // Is de bufile gezipt?
    $bujob = (preg_match("/\.gz$/", $bupfile)) ?
      CAT." ".$GLOBALS['config']->data['dir']['backup'].PS.$bupfile." | ".GZIP." -d | ".GBAK." ".USER.$PARM1." stdin ".$dbase." " :
      GBAK." ".USER.$PARM1.$GLOBALS['config']->data['dir']['backup'].PS.$bupfile." ".$dbase ;
  }
  // execute shellscript
  $status = false;
  exec($bujob,$output,$status);
  printrc1($bujob, "bujob: "); //die;
  return($dbase);
} // END FUNCTION dbaseLoad }}}


/* ***************************************************************
 * @FUNCTION  fullPath( str naam )
 * @SYLLABUS
 *   Maakt van een databasenaam een volledig path inclusief een extentie. Dit is van belang bij
 *   drivers waar een database als pathnaam wordt behandeld (sqlite, firebird).
 *   Deze databases staan standaard in de <fileroot>/dbase directory.
 *
 * **************************************************************{{{ */
function fullPath($naam) {
  // controleer eerst of naam al een fullpath is
  if((strpos($naam, PS)) !== false) return($naam);
  // extentie moet altijd 'fdb' zijn
  // Als de naam zonder extentie is aangeleverd, zet hem erachter
  if(!preg_match("/\.[a-zA-Z0-9]{3}$/",$naam)) $ext = '.fdb'; else $ext = '';
  $fullpath = $GLOBALS['config']->data['dir']['dbase'].PS.$naam.$ext;
  return($fullpath);
} // END FUNCTION fullPath }}}


/* ***************************************************************
 * @FUNCTION  doConnect( str naam )
 * @SYLLABUS
 *   Maak een connectie met database 'naam'
 *
 * **************************************************************{{{ */
function doConnect($naam) {
  $fullpath = fullPath($naam);
  try {
      @$connect = ibase_connect($fullpath ,$GLOBALS['config']->data['db']['user'] ,$GLOBALS['config']->data['db']['passwd']);
    } catch(Exception $e) {
      printrc1($e,"exception: ");
    }
    if($connect === false) { // Access denied for user 'gebruiker'@'localhost' (using password: YES)
      $eriseenfout = true;
      $GLOBALS['msg']['red'][] = "De gebruiker/passwd '{$GLOBALS['config']->data['db']['user']}/{$GLOBALS['config']->data['db']['passwd']}' heeft geen toegang tot firebird";
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
 * **************************************************************{{{ */
function isAdminDb($naam) {
  if(($connect = doConnect($naam)) === false) {
    return(false);
  }
  else {
    // gebruiker heeft toegang tot firebird en de database, bevraag de tabellen
    if(existMeta($connect)) {
      // exist
      return(true);
    }
  }
  return(false);
} // END FUNCTION isAdminDb }}}


/* ***************************************************************
 * @FUNCTION  existMeta( &connect )
 * @SYLLABUS
 *   Bepaal of de tabel 'meta' in de database aanwezig is.
 *   Dit is een hulpprocedure voor isAdminDb
 *
 * **************************************************************{{{ */
function existMeta($connect) {
  $query =<<<EOT
select rdb\$relation_name
from rdb\$relations
where rdb\$view_blr is null
and (rdb\$system_flag is null or rdb\$system_flag = 0)
and rdb\$relation_name = 'meta'
EOT;
  $sth = ibase_query($query);
  return(ibase_fetch_row($sth) ? true : false);
} // END FUNCTION existMeta }}}


/* ***************************************************************
 * @FUNCTION  listDatabases( &object )
 * @SYLLABUS
 *   List de beschikbare:
 *     plain==false: administratiedatabases
 *     plain==true:  alle databases
 *
 * **************************************************************{{{ */
function listDatabases($plain=false,$noextentions=true) {
  $File = new File();
  if($noextentions) {
    $arr = $File->get_files($GLOBALS['config']->data['dir']['dbase'],'','fdb',false,true);
    for($i=0;$i<count($arr);$i++) {
      $arr[$i] = preg_replace("/^(.+)\.[a-zA-Z0-9]{3}$/","$1",$arr[$i]);
    }
    return($arr);
  }
  else
    return($File->get_files($GLOBALS['config']->data['dir']['dbase'],'','fdb',false,true));
} // END FUNCTION listDatabases }}}


/* ***************************************************************
 * @FUNCTION  setRights( filenaam )
 * @SYLLABUS
 *   Bepaal of een file gemaakt kan worden (touch) en geef er chmod 664 aan
 *
 * **************************************************************{{{ */
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
 * **************************************************************{{{ */
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
 * **************************************************************{{{ */
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
 * **************************************************************{{{ */
function loadSql(&$connect,&$struct, $error='') {
  foreach($struct AS $val) {
    ibase_trans();
    // elke struct kan uit meerdere sql statements bestaan
    $ar = explode(';', $val);
    foreach($ar AS $val2) {
      // beware of lege queries
      if(empty($val2) || strlen($val2) < 5 ) continue;
      if(ibase_query($val2) === false) {
        $GLOBALS['msg']['red'][] = $error;
        ibase_rollback();
        return(false);
      }
    }
    ibase_commit();
  }
  return(true);
} // END FUNCTION loadSql }}}

/* __END__ */
