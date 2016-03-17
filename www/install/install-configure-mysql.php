<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: install-configure-mysql.php 289 2015-01-04 09:09:40Z otto $
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

   mysql foutnummers from mysql_errno() :

   1044 : Access denied for user 'joomla'@'localhost' to database xxx
   1045 : Access denied for user 'gebruiker'@'localhost' (using password: YES)
   1049 : Unknown database 'administratie' (tijdens init-sock)
   1142 : SELECT command denied to user 'joomla'@'localhost' for table xxx
   1007 : Can't create database 'xxx'; database exists
   1146 : Table 'admlox.sqlupdates' doesn't exist

*/

require('_factory_mysql.lib');
require('_system.inc');

$eriseenfout = false;
$msg = array();
$arr = array();

// //////////////////////////////////////////////////////////////////
// 1) check of mysql draait
// 2) check of user/passwd is valide en heeft access tot mysql
// //////////////////////////////////////////////////////////////////
@$connect = mysql_connect($GLOBALS['config']->data['db']['host']
                         ,$GLOBALS['config']->data['db']['user']
                         ,$GLOBALS['config']->data['db']['passwd']
                         );
if(mysql_errno() == 1045) { // Access denied for user 'gebruiker'@'localhost' (using password: YES)
  $eriseenfout = true;
  $arr[] = redline("De gebruiker/passwd '{$GLOBALS['config']->data['db']['user']}/{$GLOBALS['config']->data['db']['passwd']}' heeft geen toegang tot mysql");
}
else if(mysql_errno() === 0){ 
  // gebruiker heeft toegang tot mysql maar hoeft nog geen toegang te hebben tot de database
  $arr[] = greenline("Gebruiker heeft toegang tot mysql.");
}
else {
  $eriseenfout = true;
  $arr[] = redline("Geen connectie mogelijk met mysql!");
}

// //////////////////////////////////////////////////////////////////
// 3) check of dbase administratie al bestaat door hem te selecteren
// //////////////////////////////////////////////////////////////////
@mysql_select_db($GLOBALS['config']->data['db']['default'], $connect);
if(mysql_errno() == 1044) { // Access denied for user 'joomla'@'localhost' to database 'administratie'
  $eriseenfout = true;
  $arr[] = redline("De gebruiker/passwd '{$GLOBALS['config']->data['db']['user']}/{$GLOBALS['config']->data['db']['passwd']}' heeft geen toegang tot database '{$GLOBALS['config']->data['db']['default']}'");
}
else if(mysql_errno() == 1049) { // Unknown database 'administratie'
  // database bestaat nog niet
  if(! tryToCreate($connect)) {
    $eriseenfout = true;
    $arr[] = redline("De database '{$GLOBALS['config']->data['db']['default']}' kan niet gemaakt worden!");
  }
  else {
    $arr[] = greenline("De database '{$GLOBALS['config']->data['db']['default']}' is aangemaakt.");
  }
}
else if(mysql_errno() === 0){ 
  $arr[] = greenline("De database '{$GLOBALS['config']->data['db']['default']}' bestaat al.");
}

// //////////////////////////////////////////////////////////////////
// Op dit punt zou de database moeten bestaan
// 3) check of de database al tabellen heeft geladen
// //////////////////////////////////////////////////////////////////
if(! $eriseenfout) {

  if(! existTable($connect)) {
    if(mysql_errno() == 1146) { // Table 'administratie.stamgegevens' doesn't exist
      if(loadTabellen($connect)) {
        $arr[] = greenline("De tabelstructuur is in database '{$GLOBALS['config']->data['db']['default']}' geladen.");
        if(loadSchema($connect)) {
          $arr[] = greenline("Het rekeningschema '{$GLOBALS['config']->data['db']['schema']}' is geladen.");
        }
        else {
          $arr[] = redline("Kan het rekeningschema '{$GLOBALS['config']->data['db']['schema']}' niet laden!");
          $eriseenfout = true;
        }
        if(loadUpdate($connect)) {
          $arr[] = greenline("De Updates zijn geladen.");
        }
        else {
          $arr[] = redline("Kan de Updates niet laden!");
          $eriseenfout = true;
        }
        if(loadViews($connect)) {
          $arr[] = greenline("De Views zijn geladen.");
        }
        else {
          $arr[] = redline("Kan de Views niet laden!");
          $eriseenfout = true;
        }
      }
      else {
        $arr[] = redline("Kan de tabelstructuur niet laden!");
        $eriseenfout = true;
      }
    } // END IF 1146
  }
  else if(mysql_errno() === 0){ 
    $arr[] = greenline("De database '{$GLOBALS['config']->data['db']['default']}' heeft tabellen.");
    $arr[] = greenline("Er wordt geen rekeningschema '{$GLOBALS['config']->data['db']['schema']}' geladen.");
  }
} // END IF !eriseenfout

// 3b2) indien ja, stop: de installatie is klaar

// //////////////////////////////////////////////////////////////////
// 3a) probeer de database aan te maken
// //////////////////////////////////////////////////////////////////
function tryToCreate($connect) {
  if(mysql_query("CREATE DATABASE IF NOT EXISTS `{$GLOBALS['config']->data['db']['default']}`", $connect)) {
    return(mysql_query("USE `{$GLOBALS['config']->data['db']['default']}`", $connect));
  }
  else return(false);
} // END FUNCTION tryToCreate


// //////////////////////////////////////////////////////////////////
// 3b) check of dbase administratie al tabellen geladen heeft
// //////////////////////////////////////////////////////////////////
function existTable($connect) {
  return(mysql_query("SELECT id FROM `{$GLOBALS['config']->data['db']['default']}`.`stamgegevens` LIMIT 1", $connect));
} // END FUNCTION existTable


// //////////////////////////////////////////////////////////////////
// 3b1) laad de tabellen
// //////////////////////////////////////////////////////////////////
function loadTabellen($connect) {
  global $arr;
  // kijk eerst of het Schema bestaat
  $file = $GLOBALS['config']->data['dir']['struct'].PS
         .$GLOBALS['config']->data['db']['driver'].PS
         .'template.struct.'.$GLOBALS['config']->data['db']['driver'].'.php';
  if(! file_exists($file)) {
    $arr[] = redline("template file '{$file}' is er niet! Kan tabellen niet laden!");
    return(false);
  }
  else { // laad de template file en execute die
    require($file);
    if(! isset($struct) || ! is_array($struct)) {
      $arr[] = redline("Template file '{$file}' niet in orde!");
      return(false);
    }
    return(loadSql($struct, "Tabellen niet aangemaakt!", $connect));
  }
} // END FUNCTION loadTabellen


// //////////////////////////////////////////////////////////////////
// 3b1) indien nee, laad het gevraagde rekeningschema
// //////////////////////////////////////////////////////////////////
function loadSchema($connect) {
  global $arr;
  // kijk eerst of het schema bestaat
  $schemafile = $GLOBALS['config']->data['dir']['struct'].PS.'schemas'.PS.'schema.'.$GLOBALS['config']->data['db']['schema'].'.php';
  if(! file_exists($schemafile)) {
    $arr[] = redline("schema file '{$schemafile}' is er niet! Kan rekeningschema niet laden!");
    return(false);
  }
  else { // laad de schema file en execute die
    require($schemafile);
    if(! isset($schema) || ! is_array($schema)) {
      $arr[] = redline("Schemafile '{$schemafile}' niet in orde!");
      return(false);
    }
    return(loadSql($schema, "Schema niet geladen!", $connect));
  }
}


// //////////////////////////////////////////////////////////////////
// 3b1) laad de updates
// //////////////////////////////////////////////////////////////////
function loadUpdates(&$connect) {
  global $arr, $config;
  // kijk eerst of het Schema bestaat
  $structfile = $config->data['dir']['struct'].PS
               .$config->data['db']['driver'].PS
               .'template.update.'.$config->data['db']['driver'].'.php';
  if(! file_exists($structfile)) {
    $arr[] = redline("template '{$structfile}' is er niet! Kan tabellen niet laden!");
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
} // END FUNCTION loadUpdates


// //////////////////////////////////////////////////////////////////
// 3b1) laad de views, dit moet na de updates omdat de updates fields van de views bevatten
// //////////////////////////////////////////////////////////////////
function loadViews(&$connect) {
  global $arr, $config;
  // kijk eerst of het Schema bestaat
  $structfile = $config->data['dir']['struct'].PS
               .$config->data['db']['driver'].PS
               .'template.views.'.$config->data['db']['driver'].'.php';
  if(! file_exists($structfile)) {
    $arr[] = redline("template '{$structfile}' is er niet! Kan tabellen niet laden!");
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
} // END FUNCTION loadViews


function loadSql(&$struct, $error='', &$connect) {
  global $arr;

  foreach($struct AS $val) {
    // elke struct kan uit meerdere sql statements bestaan
    $ar = explode(';', $val);
    foreach($ar AS $val2) {
      // beware of lege queries
      if(empty($val2) || strlen($val2) < 5 ) continue;
      if(mysql_query($val2,$connect) === false) {
        $arr[] = redline($error);
        return(false);
      }
    }
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
  printr(mysql_error(),"$msg fouttekst: ");
  printr(mysql_errno(),"$msg foutnummer: ");
}

?>
