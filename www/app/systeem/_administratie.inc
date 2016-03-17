<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _administratie.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body .= "\n          <!-- administratie.inc -->\n";
$render->subtitle[] = "administratie.inc";
$render->titel = "Administraties beheren";

// HOUSEKEEPING
//

//
// array met veldattributen voor blockLine
//
$veldarr = array("width='10%'","width='45%'","width='15%'","width='15%'","width='15%'");
$veldarr_saldo = array("colspan='2' width='55%'","width='15%'","width='15%'","width='15%'");

$checked = array("nulperiodecheck"=>"","nulsaldocheck"=>"","totaalcheck"=>"");

//
// positioneer de cursor
//
switch($p->subaktie) {

  case 'dbaseload'  :
    // schrijf de naam van de gewenste database in de config file en herlaad;
    dbaseDefault($p->fileselect);
    break;

  case 'dbasedelete'  :
    // Als de gevraagde database dezelfde is als de geladen database kan er niet verwijderd worden
    if($p->fileselect == $GLOBALS['config']->data['db']['default']) {
      $msg['red'][] = "Je kunt de geladen database niet verwijderen!";
    }
    else {
      // Maak eerst een backup van de te wissen database
      $host = ($GLOBALS['config']->data['db']['host'] != 'localhost') ? $GLOBALS['config']->data['db']['host'] : '';
      $p->logregel = "Database {$p->fileselect} gewist op: {$GLOBALS['timer']->maildate}";
      $backupfile = dbaseDump($p->fileselect, $p->logregel, $host);
      // Verwijder dan de database
      dbaseDelete($p->fileselect);
    }
    break;

}

// Gegevens inlezen
//
// Lees de beschikbare administraties. Voor de verschillende drivers zijn er verschillende methodes:
// - sqlite en firebird: scan de bestandsnamen in <fileroot>/dbase met resp. extenties db3 of fdb
// - mysql: scan de administraties en zoek in elk naar de tabel meta
// De functie voor het listen van de databases is opgenomen in de driver afhankelijke includes
//
$dbases = listDatabases();

$help = "&nbsp;&nbsp;&nbsp;<img src='/img/helpbubble.gif' onClick=\"Help('".RUBRIEK.".administraties','Administraties beheer');\" style='cursor:help;width:15px;'>&nbsp;";

$mess=<<<EOT

<p>Via deze pagina kan je nieuwe administraties aanmaken
en andere administraties inschakelen, bijvoorbeeld een testadministratie.{$help}</p>

<p>De huidige databasedriver is: 
<b>{$GLOBALS['config']->data['db']['driver']}</b>
</p>

EOT;

printrc2($GLOBALS['config']->data['db']);

$mess.=<<<EOT

<p>De huidige, geladen administratie is: 
<b>{$GLOBALS['config']->data['db']['default']}</b>
</p>

EOT;

if($GLOBALS['config']->data['db']['host'] != 'localhost')
$mess.=<<<EOT

<p>op host: 
<b>{$GLOBALS['config']->data['db']['host']}</b>
</p>

EOT;

// START BUILDING BODYTEXT
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
//$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);
//
// De GET parm load=noload moet wel meekomen
$again = $_SERVER['REQUEST_URI'];

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>""
                         ,"subaktie"=>""
                         ) );

  $form->mainTableStart();

    $form->schemaHeader("Administraties");
    
    $form->fieldSetBridge("");

      $form->blockLine('2',
                           array($mess
                                 ),
                           array("width='100%'") );
    // messages

    $form->messagePrint();

  // NIEUWE Administratie
  //

  if(! empty($bufile)) {

    $form->fieldSetBridge("Nieuwe administratie toegevoegd:");

      $form->blockLine('3',
                           array("<div class='schemarow_std' style='padding:8 8 8 8;font-weight:bold;font-size:110%'>".$bufile."</div>"
                                 ),
                           array("width='100%'") );

  } // END IF bufile


  // FILELIST
  //

  if(! empty($dbases)) {

    $form->fieldSetBridge("De volgende administraties zijn beschikbaar:");

      $form->blockLine('4',
                           array("<div class='schemarow_head'></div>"
                                ,"<div class='schemarow_head'><span onClick='unCheck(\"fileselect\")'>database</span></div>"
                                ,"<div class='schemarow_head' align='middle'>&nbsp;</div>"
                                ,"<div class='schemarow_head' align='middle'>&nbsp;</div>"
                                ,"<div class='schemarow_head'>&nbsp;</div>"
                                 ),
                           $veldarr );

    foreach($dbases AS $val) {
      $checked['$val'] = ($GLOBALS['config']->data['db']['default'] == $val) ? "checked='checked'" : '';

      $form->blockLine('',
                           array("<div class='schemarow_std'><input type='radio' name='fileselect' value='{$val}' {$checked['$val']} /></div>"
                                ,"<div class='schemarow_std'>{$val}</div>"
                                ,"<div class='schemarow_std' align='middle'></div>"
                                ,"<div class='schemarow_std' align='middle'></div>"
                                ,"<div class='schemarow_head'>&nbsp;</div>"
                                 ),
                           $veldarr );

    } // END FOREACH backupfiles

  } // END IF filelistmsg
  

  // BUTTONS
  //
    
    $form->fieldSetBridge("");

      $buttons=<<<EOT

        <input type='button' name='nieuwbutton' value='nieuw' size='10' class='bsmall2' class='bsmall2' onClick="doNieuw();"/>
        <input type='button' name='sluiten' value='sluiten' size='10' class='bsmall2' class='bsmall2' onClick="window.close();"/>
EOT;

      $buttons2=<<<EOT

        <input type='button' name='omschakelbutton' value='activeren' size='10' class='bsmall2' class='bsmall2' onClick="doLaden();"/>
        <input type='button' name='verwijderbutton' value='verwijderen' size='10' class='bsmall2' class='bsmall2' onClick="doWissen();"/>
EOT;

      $form->blockLine('2',array($buttons,"Database acties: ".$buttons2),
                           array("width='30%'","width='70%' align='right'") );



    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();


$render->extra_styles .=<<<EOT

p {
  padding:0 4 8 4;
}

legends {
  font-weight:bold;
  padding-top: 10;
}

EOT;


// START BUILDING JAVASCRIPT
//

  $render->jscript .=<<<EOJ

function doNieuw() {
  var x = document.forms['frm1'];

  x.aktie.value = 'nieuw';
  x.submit();
}

function checkfileselected() {
  var x = document.forms['frm1'];
  var c = 'fileselect';
  var y = x.elements[c].length;
  for(i=0; i<y; i++) 
    if(x[c][i].checked) 
      var filename = x[c][i].value;

  if(! filename) { 
    alert("Selecteer een database!"); 
    return(false); 
  }
  else {
    //var   msg = "Je gaat de administratie '" + filename + "' nu activeren!\\n";
    //if(!confirm(msg)) return(false);
    return(filename);
  }
}

function doLaden() {
  var x = document.forms['frm1'];
  if(! checkfileselected()) return(false);
  // var   msg = "Je gaat de administratie '" + filename + "' nu activeren!\\n";
  // if(!confirm(msg)) return(false);
  //else {
    x.subaktie.value = 'dbaseload';
    x.submit();
  //}
}

function doWissen() {
  var x = document.forms['frm1'];
  filename = checkfileselected();
  if(! filename) return(false);
  //else if(filename == 'administratie') { alert("Je kunt de hoofddatabase 'administratie' niet verwijderen!"); return(false); }
  filename = filename.replace(/^_?([^.]+)(.*$)/,"$1");
  var   msg = "Je staat op het punt de geselecteerde database '" + filename + "' te verwijderen!\\n";
  msg = msg + "Weet je het zeker!";
  var msg2 = "Weet je het ABSOLUUT zeker!";
  if(!confirm(msg)) return(false);
  else {
    if(!confirm(msg2)) return(false);
    else {
      x.subaktie.value = 'dbasedelete';
      x.submit();
    }
  }
}

function unCheck(c) {
  var x = document.forms['frm1'];
  var y = x.elements.length;
  for(i=0; i<y; i++) if(x.elements[i].name == c) x.elements[i].checked=false;
} 

EOJ;
 
/* __END__ */
