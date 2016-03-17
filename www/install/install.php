<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: install.php 289 2015-01-04 09:09:40Z otto $
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

// ///////////////////////////////////////////////
// Preamble
// ///////////////////////////////////////////////

// Bepaal of we op een windoze platform draaien
//
if(preg_match("/^[c-zC-Z][:][\\\]/", __FILE__)) { // windoze
  define('PS', '\\');
  define('LIBDIR', dirname(__FILE__).PS.'..'.PS.'..'.PS.'lib');
  define('CONFIGDIR', dirname(__FILE__).PS.'..'.PS.'..'.PS.'config');
  $includepath = '.'.PS.';'.LIBDIR;
}
else {
  define('PS', '/');
  define('LIBDIR', dirname(__FILE__).PS.'..'.PS.'..'.PS.'lib');
  define('CONFIGDIR', dirname(__FILE__).PS.'..'.PS.'..'.PS.'config');
  $includepath = '.'.PS.':'.LIBDIR;
}


// ///////////////////////////////////////////////
// Init
// ///////////////////////////////////////////////

ini_set('include_path', $includepath);

ini_set('session.auto_start', '0');
ini_set('error_reporting', '2039');  // E_ALL & ~E_NOTICE
ini_set('error_reporting', '2047');  // E_ALL
ini_set('display_errors', '1');
ini_set('display_startup_errors', '0');
ini_set('max_execution_time', '60');
ini_set('register_globals', '0');

require('_oa.lib');
require("_rendering.lib");     // class voor rendering van de output paginas
require("_aform.lib");         // de formulierlayout class
require("_test.lib");          // testroutines voor schrijfrechten etc.
require("INIFile.lib");          // testroutines voor schrijfrechten etc.


// definieer de configfiles
//
define('LOGIC',CONFIGDIR.PS.'_const.ini.logic');
define('SOURCE',CONFIGDIR.PS.'_const.ini.dist');
define('DEST',CONFIGDIR.PS.'_const.ini');

$test  = new Test();             // test gebruiken we ook voor standaard file-routines

// Instantieer en load het config object
// Als DEST al bestaat, laad dan die, anders SOURCE
if($test->is_sane(DEST,1)) {
  $config = new INIFile(DEST);
}
else {
  // Laad de config-logic. Dit bestand bevat defines die we gebruiken in _const.ini.dist
  require(LOGIC);
  // Laad _config.ini.dist en instantieer een object
  $config = new INIFile(SOURCE);
}

$config->setValue('style', 'template',   "_rendering_html");
$config->setValue('meta', 'auteur',      "Frank Kooger");

// Set debug is on if an (empty) file 'debug' is present
if(is_file('debug1'))
  $config->setValue('debug', 'level', 1); // print messages
else if(is_file('debug2'))
  $config->setValue('debug', 'level', 2); // print messages

printrc2($config);

/* ***********************************
* Class Parms extends Params
* SYLLABUS:
*************************************/
Class Parms extends Params {
  public function __construct($arr="", $type="", $clean=false, $quote='', $globals=false) {
    parent::__construct($arr, $type, $clean, $quote, $globals); 
    $this->modify();
  }

  // controleer bepaalde parms in arr en corrigeer zonodig
  function modify() {
    if(isset($this->system_webadres)) {
      // verwijder evt http(s)://
      if(preg_match("/^https?:\/\/(.+)$/", $this->system_webadres, $ar))
        $this->system_webadres = $ar[1];
      // verwijder evt resterende slash aan het einde
      $this->system_webadres = str_replace("/","",$this->system_webadres);
    }
  }

}

// ///////////////////////////////////////////////
// Tests
// ///////////////////////////////////////////////

// test of CONFIGDIR is writable en indien _const.ini al bestaat, of die writable is
//
if(! $test->testWritable(CONFIGDIR)) {
  $test->msg = "<p style='padding:8 12;'>Ik kan het configuratiebestand _const.ini niet wegschrijven!</p><p style='padding:0 12 8;'>Controleer de schrijfrechten op directory: <code>&lt;fileroot&gt;/config</code> </p>";
  require('_notwritable.inc');
}
else if($test->is_sane(DEST,1)) {
  if(! $test->testWritable(DEST)) {
    $test->msg = "<p style='padding:8 12;'>Het configuratiebestand _const.ini bestaat maar ik kan het niet overschrijven!</p><p style='padding:0 12 8;'>Controleer de schrijfrechten op het bestand <code>&lt;fileroot&gt;/config/_const.ini</code></p>";
    require('_notwritable.inc');
  }
}

// ///////////////////////////////////////////////
// Logic
// ///////////////////////////////////////////////

$msg = array("red"=>"","blue"=>"");

// Laad een rendering object
$render = new Rendering();

$p = new Params(array(
                      'aktie'=>''
                     ,'driver'=>''
                     ));
/* 
Als we van een ingevuld form afkomen zien de parms er zo uit:
[style_bg] => geel
[m_style_bg] => 
Het oorspronkelijke element was style.bg dus de punt is getransformeerd naar een _.
We willen alle ingevulde elementen verzamelen en daarmee de velden dalijk weer
in te kunnen vullen. We gebruiken daarvoor de m_ parms want dit zijn zeker de
invulvelden. Zonder m_ zijn het de oorspronkelijke velden.
*/
foreach($p AS $key=>$val) {
  if(preg_match("/^m_(.+)/", $key, $ar)) {
    $x = strtr($ar[1],'_','.');
    // we zijn hier in de p->m_<parm> . Geef de nieuwe p->parm de waarde van p-><parm>
    $p->$x = $p->$ar[1];
  }
}
printrc1($p, "p: ");

// Akties
//
switch($p->aktie) {
  case 'save' : require('install-save.php'); break;
  case 'dbase' : require("install-configure-{$GLOBALS['config']->data['db']['driver']}.php"); break;
}

require('install-params.php');

// Maak formulier

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->dprint("\n<div class='container'>\n<div class='center'>\n\n");

$form->formStart('frm1', $again,
                   array(
                          "aktie"=>""
                         ,"driver"=>""
                         ) );
  $form->mainTableStart();

  // Eerste fieldblock
  // Keuzevelden: periode, dagboekcode, bestaande dagboeken

    $form->fieldSetStart("Installatie administratie");

    // messages

    $form->messagePrint();

      $tdarray = array("nowrap='nowrap', width='10%'","width='90%'");
      $harray  = array("width='100%' colspan='2' style='padding-top:8px;'","");

      $form->blockLine('',
                       array("",
                       ""
                      ),
                       $tdarray );

// Extra velden voor databaseinput
// We willen deze velden ook actief zien als een bestaande conf wordt geladen.
// Er is dan geen $p->driver.
/*
Mbt tot user en passwd hebben we een probleem als we een bestaande config
inlezen. Er is dan geen $p->db.user (die komt immers uit een ingevuld form)
maar de gegevens komen in een array (het resultaat van inlezen van
_const.ini):

ud: 
Array
(
    [db.user] => Array
        (
            [default] => webuser
            [choices] => 
            [title] => Database gebruiker
            [help] => 
        )

    [db.passwd] => Array
        (
            [default] => poedel
            [choices] => 
            [title] => Password database gebruiker
            [help] => 
        )
*/
//
switch(($p->driver) ? $p->driver : $GLOBALS['config']->data['db']['driver']) {
  case 'mysql' :
    $ud = array_merge($ud, $udb);
    $ud = array_merge($ud, $udm);
    printrc1($ud,"ud: ");
    $key = 'db.user';
    if(! isset($p->$key)) $p->$key = "root";
    $key = 'db.passwd';
    if(! isset($p->$key)) $p->$key = "";
    break;
  case 'firebird' :
    $ud = array_merge($ud, $udb);
    $ud = array_merge($ud, $udf);
    $key = 'db.user';
    if(! isset($p->$key)) $p->$key = "SYSDBA";
    $key = 'db.passwd';
    if(! isset($p->$key)) $p->$key = "masterkey";
    break;
  case 'postgres' :
    $ud = array_merge($ud, $udb);
    $ud = array_merge($ud, $udp);
    $key = 'db.user';
    if(! isset($p->$key)) $p->$key = "postgres";
    $key = 'db.passwd';
    if(! isset($p->$key)) $p->$key = "masterkey";
    break;
  case 'sqlite' :
    $ud = array_merge($ud, $udt);
    break;
  default :
    break;
}


foreach($ud AS $key=>$val) {

    $form->fieldSetBridge($val['title'],'','','',$key);

    $compare = (isset($p->$key)) ? $p->$key : $val['default'];

    if(is_array($val['choices'])) { // maak keuzelijst
      $tmp = ($key == 'db.driver') ? "onChange='getDbVelden();'" : '';
      $str = "<select {$tmp} id='id-{$key}' name='{$key}'>\n";
      foreach($val['choices'] AS $choice) {
        $str .= ($choice == $compare) ? 
          "<option selected='selected' value='{$choice}'>{$choice}</option>":
          "<option value='{$choice}'>{$choice}</option>";
      }
      $str .= "</select>\n";
    }
    else { // choices geen keuzelijst maar inputveld
      $str = "<input type='text' name='{$key}' value='{$compare}' size='45' />";
    }

    $str .= "<input type='hidden' name='m_{$key}' value='{$compare}' />";

      $form->blockLine('',
                       array(""
                            ,$str 
                            ),
                       $tdarray );

    // Extra knoppen onder de velden
    // TODO kijken of dit nodig is. Vooralsnog voeren we alle akties uit als dit scherm wordt opgeslagen

      $form->blockLine('',
                       array(
                             $val['help']
                            ),
                       $harray );

} // END FOREACH

// buttons
//
$str =<<<EOT
<a name='dbselect'></a>
<input type='button' value='gegevens opslaan' onClick='opslaan();' />

EOT;

if($p->aktie == 'save')
$str .=<<<EOT
 &nbsp;
<input type='button' value='database maken' onClick='dbase();' />

EOT;

$str .=<<<EOT
 &nbsp;
<input type='button' value='naar hoofdscherm' onClick='hoofdscherm();' />

EOT;

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
$render->iscript[] = "/js/mybic.js";

// Ajax scripts
//
$render->jscript .=<<<EOT

  var ajaxObj;
    
  function getDbVelden() {
    var x = document.forms['frm1'];
    x.aktie.value = 'changedbase';
    x.action = x.action + '#dbselect';
    x.driver.value = document.getElementById('id-db.driver').value
    x.submit();
  } // END FUNCTION getDbVelden

  function xgetDbVelden() {

    ajaxObj = new XMLHTTP("/mybic/mybic_server.php");

    // lets turn on debugging so we can see what we're sending and receiving
    ajaxObj.debug=1;

    insertDbVelden(''); 

    switch(document.getElementById('id-db.driver').value) {
      case 'mysql'   : ajaxObj.call("action=A_install_dbvelden&driver=mysql", insertDbVelden); break;
      case 'firebird': ajaxObj.call("action=A_install_dbvelden&driver=firebird", insertDbVelden); break;
      case 'postgres': ajaxObj.call("action=A_install_dbvelden&driver=postgres", insertDbVelden); break;
      case 'sqlite'  :
      default        : insertDbVelden(''); break;
    }
  }


  function insertDbVelden(resp) {
    alert(resp);
    document.getElementById('dbfields').innerHTML = resp;
  }


EOT;

// Common scripts
//
$render->jscript .=<<<EOT

function opslaan() {
  var x = document.forms['frm1'];
  x.aktie.value = 'save';
  x.driver.value = document.getElementById('id-db.driver').value
  x.submit();
}

function dbase() {
  var x = document.forms['frm1'];
  x.aktie.value = 'dbase';
  x.driver.value = document.getElementById('id-db.driver').value
  x.submit();
}

function hoofdscherm() {
  window.location="/index.php";
}

function visible() {
  return(true);
  var m1 = document.getElementById('db.host');
  var m2 = document.getElementById('db.user');
  var m3 = document.getElementById('db.passwd');
  var m4 = document.getElementById('path.mysqlbin');
  m1.style.visibility='hidden';
  m2.style.visibility='hidden';
  m3.style.visibility='hidden';
  m4.style.visibility='hidden';
}

EOT;

$render->onload = 'visible()';

// STYLES
//
$render->extra_headers .= "<link rel='stylesheet' type='text/css' href='install.css' />";

$render->output();

?>
