<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: install-configure-firebird.php 215 2011-09-25 18:54:41Z otto $
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

/*
   De volgende akties worden uitgevoerd:
   1) check of firebird draait
   2) check of user/passwd is valide en heeft access tot firebird
   3) check of dbase administratie al bestaat door te bevragen met user/passwd
   3a) indien nee, probeer hem aan te maken
   3b) indien ja, check of dbase administratie al tabellen geladen heeft
   3b1) indien nee, laad het gevraagde template
   3b2) indien ja, stop: de installatie is klaar

*/

// By default, Safe Mode does a UID compare check when
// opening files. If you want to relax this to a GID compare,
// then turn on safe_mode_gid.
ini_set('safe_mode_gid', '1');

$fullpath = $GLOBALS['config']->data['dir']['dbase'].PS.$GLOBALS['config']->data['db']['default'].'.fdb';

// Bepaal of de Firebird command-processor 'isql-fb' (Linux) of 'isql' (Windoze) is
define('ISQLBIN', $GLOBALS['config']->data['system']['platform'] == 'windows' ? 
  'isql' : 'isql-fb');

// voor enkele functies hebben we isql nodig
define('ISQL', ($GLOBALS['config']->data['path']['firebirdbin']) ?
  '"'.$GLOBALS['config']->data['path']['firebirdbin'].'\\'.ISQLBIN.'"': ISQLBIN );

define('USER', ($GLOBALS['config']->data['db']['passwd']) ?
  "-USER {$GLOBALS['config']->data['db']['user']} -PASSWORD {$GLOBALS['config']->data['db']['passwd']}" :
  "-USER {$GLOBALS['config']->data['db']['user']}");

$eriseenfout = array();
$status = '';
$msg = array();
$arr = array();

// //////////////////////////////////////////////////////////////////
// 1) check of firebird draait
// 2) check of user/passwd is valide en heeft access tot de database
// 3) maak connectie met de database
// //////////////////////////////////////////////////////////////////
// //////////////////////////////////////////////////////////////////
// 4) check of geschreven kan worden in de dbase directory
// //////////////////////////////////////////////////////////////////

$goon = true;

// check of de ibase functions bestaan. Zo niet dan is de ibase extentie niet geladen
$goon = driverGeladen($eriseenfout);

function driverGeladen(&$eriseenfout) {
  global $arr;
  if(! function_exists('ibase_connect')) {
    $eriseenfout['10'] =<<<EOT
De PHP extentie voor Firebird/Interbase is niet geladen! <br />
Lees <a href='http://php.net/manual/en/ibase.installation.php'>hier</a> installatie instructies of vraag hulp op <a href='http://openadmin.nl/'>OpenAdmin.nl</a>.
<br /><br />
Ga terug naar het vorige scherm en:
<ul>
<li> installeer de PHP Firebase/Interbase extentie;
<li> of kies voor een andere database driver zoals 'sqlite'.
</ul>
EOT;
      return(false);
  }
  else return(true);
}

// check of de databasefile al bestaat
if($goon)
  $goon = bestaatFullpath($fullpath,$eriseenfout);

function bestaatFullpath($fullpath,&$eriseenfout) {
  global $arr;
  if(file_exists($fullpath)) {
    $eriseenfout['25'] = "De database {$fullpath} bestaat al.";
    // probeer een connect
    kanConnect($fullpath,$eriseenfout); // resultcodes: ibase_errcode/<geen>
    return(false);
  }
  else {
    $eriseenfout['35'] = "De database {$fullpath} bestaat nog niet.";
    if(createDb($fullpath,$eriseenfout)) { // resultcodes: 42/45
      // probeer een connect
      kanConnect($fullpath,$eriseenfout); // resultcodes: ibase_errcode/<geen>
    }
    return(false);
  }
  return(true);
}

function kanConnect($fullpath,&$eriseenfout) {
  global $arr;
  if(!doConnect($fullpath)) {
    $eriseenfout[ibase_errcode()] = ibase_errmsg();
    return(false);
  }
  else return('');
}

// Dit waren de testen, evalueer
$panic = '';
if(count($eriseenfout)) { // er zijn meldingen
  foreach($eriseenfout AS $code=>$msg) {
    switch($code) {
      case '-902' : 
        // -902 kan meerdere oorzaken hebben:
        //   Your user name and password are not defined. Ask your database administrator to set up a Firebird login.
        //   
        //   I/O error for file "/pub/webs/openadministratie/struct/firebird/testadministratie.fdb" # gebruiker kan inloggen maar de dbasefile is er niet.
        //   I/O error for file "/pub/webs/openadministratie/data/testadministratie.fdb" Error while trying to open file No such file or directory
        $arr[] = redline($msg);
        #$arr[] = redline("De gebruiker/passwd '{$GLOBALS['config']->data['db']['user']}/{$GLOBALS['config']->data['db']['passwd']}' heeft geen toegang tot firebird");
        $panic = 'stop';
        break;
      case '25'   : $arr[] = greenline($msg); $panic = 'load'; break;
      case '35'   : $arr[] = greenline($msg); $panic = 'create'; break;
      case '45'   : $arr[] = greenline($msg); $panic = 'load'; break;
      case '10'   : 
      case '42'   : $arr[] = redline($msg); $panic = 'stop'; break;
      default       : 
        $arr[] = redline("Kan geen contact maken met database: '{$GLOBALS['config']->data['db']['default']}!");
        $panic = 'stop'; break;
    }
    printrc1($code,"code: ");
  } // END foreach eriseenfout
}

if($panic == 'load' || $panic == '') {
  // we kunnen een connect doen
  $connect = doConnect($fullpath);
  if($connect === false) { // Access denied for user 'gebruiker'@'localhost' (using password: YES)
    $arr[] = redline("Kan geen connectie maken met database: '{$GLOBALS['config']->data['db']['default']}!");
    $panic = 'stop';
  }
  else {
    // gebruiker heeft toegang tot firebird en de database
    $arr[] = greenline("Gebruiker/passwd heeft toegang tot firebird.");
  }
} // END if panic==load


    if(false) {
      $arr[] = redline(<<<EOT
De database '{$fullpath}' bestaat niet! <br />
je zult de database zelf moeten aanmaken met <br />
<a href='http://www.firebirdsql.org/index.php?op=files&id=engine'>Firebase</a> utilities 
zoals isql (redhat, windows), fbisql (ubuntu, debian), of met de uitstekende GUI tool <a href='http://www.flamerobin.org/'>FlameRobin</a> (alle platforms).<br /><br />
Ga terug naar het vorige scherm en:
<ul>
<li> maak eerst de database aan in Firebase;
<li> of kies voor een andere database driver zoals 'sqlite'.
</ul>
EOT
);
    }

// //////////////////////////////////////////////////////////////////
// Op dit punt zou de database moeten bestaan en hebben we een connectie
// 3) check of de database al tabellen heeft geladen
// //////////////////////////////////////////////////////////////////
if($panic == 'load') {

  if(! existTable($connect)) {
    $arr[] = greenline("De database heeft nog geen tabelstructuur!");

      if(loadTabellen($connect)) {
        $arr[] = greenline("De tabelstructuur is in database '{$GLOBALS['config']->data['db']['default']}' geladen.");
        if(loadSchema($connect)) {
          $arr[] = greenline("Het rekeningschema '{$GLOBALS['config']->data['db']['schema']}' is geladen.");
          $panic = '';
        }
        else {
          $arr[] = redline("Kan het rekeningschema '{$GLOBALS['config']->data['db']['schema']}' niet laden!");
        }
      }
      else {
        $arr[] = redline("Kan de tabelstructuur niet laden!");
      }
  }
  else { 
    $arr[] = greenline("De database '{$GLOBALS['config']->data['db']['default']}' heeft tabellen.");
    $arr[] = greenline("Er wordt geen rekeningschema '{$GLOBALS['config']->data['db']['schema']}' geladen.");
    $panic = '';
  }

} // END if panic==load

// 3b2) indien ja, stop: de installatie is klaar

// //////////////////////////////////////////////////////////////////
// FUNCTIONS
// //////////////////////////////////////////////////////////////////

function doConnect($fullpath) {
  try {
    @$connect = ibase_connect($fullpath ,$GLOBALS['config']->data['db']['user'] ,$GLOBALS['config']->data['db']['passwd']);
  } catch(Exception $e) {
    printr($e);  
  }
  if($connect === false) {
    printrc1(ibase_errmsg()," foutje bedankt: " );
    printrc1(ibase_errcode()," en de code is bedankt: " );
  }
  return($connect?$connect:false);
}

function existTable($connect) {
  $query =<<<EOT
select rdb\$relation_name
from rdb\$relations
where rdb\$view_blr is null
and (rdb\$system_flag is null or rdb\$system_flag = 0)
EOT;
  $sth = ibase_query($query);
  return(ibase_fetch_row($sth) ? true : false);
} // END FUNCTION existTable


function createDb($fullpath,&$eriseenfout) {
  global $arr;
  // voor windows moeten we anders taggen
  $statement = ($GLOBALS['config']->data['system']['platform'] == 'windows') ?
    $statement = "CREATE DATABASE '{$fullpath}';" :
    $statement = "\"CREATE DATABASE '{$fullpath}';\"" ;
  $bujob = "echo ".$statement." | ".ISQL." ".USER;
  printrc1($bujob);
  exec($bujob);
  // controleer of de database is aangemaakt
  if(file_exists($fullpath)) {
    $eriseenfout['45'] = "De database '{$GLOBALS['config']->data['db']['default']} is aangemaakt!";
    return(true);
  }
  else {
    $eriseenfout['42'] = "Kan de database '{$GLOBALS['config']->data['db']['default']} niet aanmaken!";
    return(false);
  }
} // END FUNCTION createDb


// //////////////////////////////////////////////////////////////////
// 3b1) laad de tabellen
// //////////////////////////////////////////////////////////////////
function loadTabellen($connect) {
  global $arr;
  // kijk eerst of het Schema bestaat
  $structfile = $GLOBALS['config']->data['dir']['struct'].PS
               .$GLOBALS['config']->data['db']['driver'].PS
               .'template.struct.'.$GLOBALS['config']->data['db']['driver'].'.php';
  if(! file_exists($structfile)) {
    $arr[] = redline("template '{$structfile}' is er niet! Kan tabellen niet laden!");
    return(false);
  }
  elseif(! is_readable($structfile)) {
    $arr[] = redline("Ik kan template '{$structfile}' niet lezen!");
    return(false);
  }
  else { // laad de structfile en execute die
    require($structfile);
    if(! isset($struct) || ! is_array($struct)) {
      $arr[] = redline("Template '{$structfile}' niet in orde!");
      return(false);
    }
    return(loadSql($struct,"Tabellen niet aangemaakt!"));
  }
} // END FUNCTION loadTabellen


// //////////////////////////////////////////////////////////////////
// laad het gevraagde rekeningschema
// //////////////////////////////////////////////////////////////////
function loadSchema($connect) {
  global $arr;
  // kijk eerst of het schema bestaat
  $schemafile = $GLOBALS['config']->data['dir']['struct'].PS
               .'schemas'.PS.'schema.'.$GLOBALS['config']->data['db']['schema'].'.php';
  if(! file_exists($schemafile)) {
    $arr[] = redline("schema file '{$schema}' is er niet! Kan rekeningschema niet laden!");
    return(false);
  }
  else { // laad de schema file en execute die
    require($schemafile);
    if(! isset($schema) || ! is_array($schema)) {
      $arr[] = redline("Schemafile '{$schemafile}' niet in orde!");
      return(false);
    }
    return(loadSql($schema,"Schema niet geladen!"));
  }
} // END FUNCTION loadSchema


function loadSql(&$struct, $error='') {
  global $arr;

  foreach($struct AS $val) {
    ibase_trans();
    // elke struct kan uit meerdere sql statements bestaan
    $ar = explode(';', $val);
    foreach($ar AS $val2) {
      // beware of lege queries
      if(empty($val2) || strlen($val2) < 5 ) continue;
      if(ibase_query($val2) === false) {
        $arr[] = redline($error);
        ibase_rollback();
        return(false);
      }
    }
    ibase_commit();
  }
  return(true);
} // END FUNCTION loadSql


// //////////////////////////////////////////////////////////////////
// Maak formulier
// //////////////////////////////////////////////////////////////////

$form = new aForm($render->body);

$form->dprint("\n<div class='container'>\n<div class='center'>\n\n");

$form->formStart('frm1', $_SERVER['REQUEST_URI'],
                   array(
                          "aktie"=>""
                         ) );

  $form->mainTableStart();

    $tdarray = array("nowrap='nowrap', width='100'","");
    $harray  = array("width='100' colspan='2' style='padding-top:8px;'","");

    $form->fieldSetStart("Installatie administratie");

$msg =<<<EOT
<p style='padding:6px;'>Het systeem maakt nu de administratie-database aan en laadt het gekozen rekeningschema.
Als alle regels hieronder groen zijn is de aktie geslaagd en kan je door naar het hoofdscherm.
Als er nog rode messages zijn, ga dan terug naar het vorige scherm, herstel eventueel gegevens en herhaal deze aktie.</p>

<p style='padding:6px;'>Als de installatie is geslaagd is het raadzaam om de directory '&lt;webroot&gt;/install' te verwijderen.</p>
EOT;
      $form->blockLine('',
                       array(""
                            ,$msg 
                            ),
                       $tdarray );


    $form->fieldSetBridge();


      $form->blockLine('1',
                       array(""
                            ,implode($arr) 
                            ),
                       $tdarray );

    // Extra knoppen onder de velden
    // TODO kijken of dit nodig is. Vooralsnog voeren we alle akties uit als dit scherm wordt opgeslagen



// buttons
//
if($panic) {
  $str =<<<EOT
<input type='button' value='naar vorig scherm' onClick='history.go(-1);' />

EOT;
}
else {
  $str =<<<EOT
<input type='button' value='ga naar hoofdscherm' onClick='loadHome();' />

EOT;
}

    $form->fieldSetBridge();
    
      $form->blockLine('',
                       array(""
                            ,$str 
                            ),
                       $tdarray );

    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();

$form->dprint("</div></div>");

// JAVASCRIPT
//
$render->jscript =<<<EOT

function loadHome() {
  var x = document.forms['frm1'];
  window.location.href='/';
}

EOT;

// STYLES
//
$render->extra_headers .= "<link rel='stylesheet' type='text/css' href='install.css' />";

$render->output();

die();

function greenLine($msg) {
  return("<div class='greenline'>$msg</div>");
}

function redLine($msg) {
  return("<div class='redline'>$msg</div>");
}

function pFout($msg) {
  printr(PDO::errorCode(),"$msg fouttekst: ");
  printr(PDO::errorInfo(),"$msg foutnummer: ");
}

function is__writable($path) {
//will work in despite of Windows ACLs bug
//NOTE: use a trailing slash for folders!!!
//see http://bugs.php.net/bug.php?id=27609
//see http://bugs.php.net/bug.php?id=30931

    if ($path{strlen($path)-1}=='/') // recursively return a temporary file path
        return is__writable($path.uniqid(mt_rand()).'.tmp');
    else if (is_dir($path))
        return is__writable($path.'/'.uniqid(mt_rand()).'.tmp');
    // check tmp file for read/write capabilities
    $rm = file_exists($path);
    $f = @fopen($path, 'a');
    if ($f===false)
        return false;
    fclose($f);
    if (!$rm)
        unlink($path);
    return true;
}

function isDbWritable($connect, $fullpath) {
  return(true);
}

/* __END__ */
