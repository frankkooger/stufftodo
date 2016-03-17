<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _administratie_nieuw.inc 161 2010-12-17 15:41:59Z otto $
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

$render->body .= "\n          <!-- administratie_nieuw.inc -->\n";
$render->subtitle[] = "administratie_nieuw.inc";
$render->titel = "Administratie maken";

// HOUSEKEEPING
//

//
// array met veldattributen voor blockLine
//
$veldarr = array("width='10%'","width='45%'","width='15%'","width='15%'","width='15%'");

//
// positioneer de cursor
//
switch($p->subaktie) {

  case 'save'  :
    // schoon evt de opgegeven naam
    $p->databasenaam = preg_replace("/[^0-9a-zA-Z]/","",$p->databasenaam);
    // Controleer eerst of de database al bestaat
    $iseral = false;
    $arr = listDatabases();
    foreach($arr AS $val)
      if($p->databasenaam == $val)
        $iseral = true;

    if($iseral) {
      $msg['red'][] = "Een database met naam {$p->databasenaam} bestaat al!";
    }
    else {
      // Maak de gevraagde database
      if(dbaseCreate($p)) {
        // Herlaad en zorg dat de nieuwe database wordt geladen
        dbaseDefault($p->databasenaam);
      }
    }
    break;

}

$mess=<<<EOT

<p>Geef hieronder een naam voor de database en evt. een bedrijfsnaam voor de administratie.<br />
De databasenaam moet een simpele naam zijn. Het systeem verwijdert niet juiste tekens.

<p>Een bedrijfsnaam is optioneel en mag alle tekens bevatten.</p>


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

    $form->schemaHeader("Nieuwe administratie");
    
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


  // FORMULIER
  //

    $form->fieldSetBridge();

      $form->blockLine('',
                           array("<div class='schemarow_std'>Databasenaam:</div>"
                                ,"<div class='schemarow_std'><input type='text' name='databasenaam' value='' size='15' /></div>"
                                ,"<div class='schemarow_std'>&nbsp;</div>"
                                ,"<div class='schemarow_head'>&nbsp;</div>"
                                 ),
                           $veldarr );

// Laad de schemas uit de struct/schemas directory
//
$tmp = '';
$File = new File();
$arr = $File->get_files($GLOBALS['config']->data['dir']['struct'].PS.'schemas','','',false,true);
foreach($arr AS $id=>$val) {
  // toon alleen bestanden die beginnen met 'schema.' en die eindigen op '.php'
  if(!preg_match("/^schema\./",$val)) continue;
  $val = preg_replace("/^.+\.(.+)\.php$/","$1",$val);
  $tmp .= "<option value='{$val}'>{$val}</option>\n";
}

      $form->blockLine('',
                           array("<div class='schemarow_std'>Rekeningschema:</div>"
                                ,"<div class='schemarow_std'><select name='schema'>{$tmp}</select></div>"
                                ,"<div class='schemarow_std'>&nbsp;</div>"
                                ,"<div class='schemarow_head'>&nbsp;</div>"
                                 ),
                           $veldarr );

      $form->blockLine('',
                           array("<div class='schemarow_std'>Bedrijfsnaam:</div>"
                                ,"<div class='schemarow_std'><input type='text' name='bedrijfsnaam' value='' size='30' /></div>"
                                ,"<div class='schemarow_std'>&nbsp;</div>"
                                ,"<div class='schemarow_head'>&nbsp;</div>"
                                 ),
                           $veldarr );


  // BUTTONS
  //
    
    $form->fieldSetBridge("");

      $buttons=<<<EOT

        <input type='button' name='maakbutton' value='maken' size='10' class='bsmall2' class='bsmall2' onClick="doSave();"/>
        <input type='button' name='sluiten' value='sluiten' size='10' class='bsmall2' class='bsmall2' onClick="window.close();"/>
EOT;

      $buttons2=<<<EOT
EOT;

      $form->blockLine('2',array($buttons,$buttons2),
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

function doSave(deze) {
  var x = document.forms['frm1'];

  // controleer de ingevulde velden
  var msg = "is een verplicht veld. Vul deze in!";
  if(x.databasenaam.value == '') {
    alert("Databasenaam " + msg);
    x.databasenaam.focus();
    return(false);
  } 
  // niet verplicht meer
  // else if(x.bedrijfsnaam.value == '') {
  //   alert("Bedrijfsnaam " + msg);
  //   x.bedrijfsnaam.focus();
  //   return(false);
  // } 
  else {
    x.aktie.value = 'nieuw';
    x.subaktie.value = 'save';
    x.submit();
  }
}


EOJ;
 
/* __END__ */
