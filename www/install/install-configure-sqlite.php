<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: install-configure-mysql.php 30 2009-12-23 17:04:19Z frank $
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
   1) check of mysql draait
   2) check of user/passwd is valide en heeft access tot mysql
   3) check of dbase administratie al bestaat door te bevragen met user/passwd
   3a) indien nee, probeer hem aan te maken
   3b) indien ja, check of dbase administratie al tabellen geladen heeft
   3b1) indien nee, laad het gevraagde template
   3b2) indien ja, stop: de installatie is klaar

*/

$eriseenfout = false;
$msg = array();
$arr = array();

// By default, Safe Mode does a UID compare check when
// opening files. If you want to relax this to a GID compare,
// then turn on safe_mode_gid.
ini_set('safe_mode_gid', '1');

// //////////////////////////////////////////////////////////////////
// 1) maak connectie en check of geschreven kan worden in de dbase directory
// //////////////////////////////////////////////////////////////////
$fullpath = $GLOBALS['config']->data['dir']['dbase'].PS.$GLOBALS['config']->data['db']['default'].'.db3';
$dsn = 'sqlite:'.$fullpath;

// Check of de database al bestaat. Dit is nodig voor een correcte statusmelding
if(file_exists($fullpath)) {
  $arr[] = greenline("De database '{$fullpath}' bestaat al.");
  // test of the file is writable
  if(! is__writable($fullpath)) {
    $arr[] = redline("De database '{$fullpath}' bestaat maar ik kan niet schrijven!");
    $eriseenfout = true;
  }
  else {
    try {
        $connect = new PDO($dsn);
    } catch (PDOException $e) {
      $arr[] = redline('Geen connectie met de database: ' . $e->getMessage());
      $eriseenfout = true;
    }
  }
}
else { // dbase bestand bestaat nog niet
  // test of we in de dir kunnen schrijven
  if(! is__writable($GLOBALS['config']->data['dir']['dbase'].PS)) {
    $arr[] = redline("Ik kan niet schrijven in database-directory '{$GLOBALS['config']->data['dir']['dbase']}'!");
    $eriseenfout = true;
  }
  else {
    try {
        $connect = new PDO($dsn);
        $arr[] = greenline("De database '{$fullpath}' is aangemaakt.");
    } 
    catch (PDOException $e) {
        $arr[] = redline('Geen connectie met de database: ' . $e->getMessage());
        $eriseenfout = true;
    }
  }
}

// //////////////////////////////////////////////////////////////////
// Op dit punt zou de database moeten bestaan en hebben we een connectie
// 3) check of de database al tabellen heeft geladen
// //////////////////////////////////////////////////////////////////
if(! $eriseenfout) {

  if(! existTable($connect)) {
    $arr[] = greenline("De database heeft nog geen tabelstructuur!");

      if(loadTabellen($connect)) {
        $arr[] = greenline("De tabelstructuur is in database '{$GLOBALS['config']->data['db']['default']}' geladen.");
        if(loadSchema($connect)) {
          $arr[] = greenline("Het rekeningschema '{$GLOBALS['config']->data['db']['schema']}' is geladen.");
        }
        else {
          $arr[] = redline("Kan het rekeningschema '{$GLOBALS['config']->data['db']['schema']}' niet laden!");
          $eriseenfout = true;
        }
      }
      else {
        $arr[] = redline("Kan de tabelstructuur niet laden!");
        $eriseenfout = true;
      }
  }
  else { 
    $arr[] = greenline("De database '{$GLOBALS['config']->data['db']['default']}' heeft tabellen.");
    $arr[] = greenline("Er wordt geen rekeningschema '{$GLOBALS['config']->data['db']['schema']}' geladen.");
  }
} // END IF !eriseenfout


// 3b2) indien ja, stop: de installatie is klaar

// //////////////////////////////////////////////////////////////////
// 3b) check of dbase administratie al tabellen geladen heeft
// //////////////////////////////////////////////////////////////////
function existTable(&$connect) {
  $sth = $connect->query("SELECT name FROM sqlite_master WHERE name='stamgegevens'");
  return($sth->fetchColumn() ? true : false);
} // END FUNCTION existTable


// //////////////////////////////////////////////////////////////////
// 3b1) laad de tabellen
// //////////////////////////////////////////////////////////////////
function loadTabellen(&$connect) {
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
    return(loadSql($struct,"Tabellen niet aangemaakt!",$connect));
  }
} // END FUNCTION loadTabellen


// //////////////////////////////////////////////////////////////////
// laad het gevraagde rekeningschema
// //////////////////////////////////////////////////////////////////
function loadSchema(&$connect) {
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
    return(loadSql($schema,"Schema niet geladen!",$connect));
  }
} // END FUNCTION loadSchema


function loadSql(&$struct, $error='',&$connect) {
  global $arr;

  foreach($struct AS $val) {
    $connect->beginTransaction();
    // elke struct kan uit meerdere sql statements bestaan
    $ar = explode(';', $val);
    foreach($ar AS $val2) {
      // beware of lege queries
      if(empty($val2) || strlen($val2) < 5 ) continue;
      printrc1($val2);
      if($connect->exec($val2) === false) {
        $arr[] = redline($error);
        $connect->rollBack();
        return(false);
      }
    }
    $connect->commit();
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
<p style='padding:6px;'>Het systeem maakt nu de administratie-datbase aan en laadt ook het gekozen rekeningschema.
Als alle regels hieronder groen zijn is de aktie geslaagd en kan je door naar het administratie-startscherm.
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
if($eriseenfout) {
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

?>
