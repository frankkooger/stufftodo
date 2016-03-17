<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _backup.inc 161 2010-12-17 15:41:59Z otto $
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

$render->body .= "\n          <!-- backup.inc -->\n";
$render->subtitle[] = "backup.inc";
$render->titel = "Backups overzicht/maken/terugzetten";

// HOUSEKEEPING
//
$file = new File();
$bufile = '';
$budir = $GLOBALS['config']->data['dir']['backup'];

//
// array met veldattributen voor blockLine
//
$veldarr = array("width='5%'","width='40%'","width='20%'","width='20%'","width='15%'");
$fromdbase = '';

//
//SUBAKTIES
//
switch($p->subaktie) {

  case 'overzichtvan'  :
  // positioneer de cursor
    $render->onload .= "document.forms['frm1'].overzichttot.focus();";
    break;

  case 'switchdbase'  :
    // we switchen hier niet naar een andere dbase maar tonen de backupfiles van de gekozen dbase
    if($p->dbasenaam) $fromdbase = $p->dbasenaam;
    break;

  case 'buregelsave'  :
    // As of versie 1.0 slaan we de logtekst niet meer op in een database maar in aparte .log bestanden met dezelfde naam als het bu bestand.
    file_put_contents($budir.PS.$p->fileselect.'.log', $p->logregel);
    break;

  case 'backupsave'  :
    // wat is de naam van de huidige administratiedatabase?
    // ingeval mysql is dat puur de naam van de database
    // ingeval sqlite en firebird is het een volledig pathname naar een databasefile met extentie 'fdb' (firebird) of 'db3' (sqlite)
    $naam = $GLOBALS['config']->data['db']['default'];
    $host = ($GLOBALS['config']->data['db']['host'] != 'localhost') ? $GLOBALS['config']->data['db']['host'] : '';
    // sla een dump van de database op naar file
    $bufile = dbaseDump($naam, $p->logregel, $host);
    break;

  case 'backupload'  :
    // Wordt een andere database meegegeven om in terug te laden?
    $dbasenaam = ($p->terugzettenin) ? $p->terugzettenin : '';
    // wat is de naam van de sqlfile
    if(empty($p->fileselect)) {
      $msg['red'][] = "Er is geen backupbestand gekozen!";
    }
    else {
      $geladenin = dbaseLoad($p->fileselect, $dbasenaam);
      // als er een andere databasenaam is meegegeven, schakel dan naar die database
      if($dbasenaam) dbaseDefault($dbasenaam);
      // bupfile  _administratie.sqlite.unixml6.20091224-0039.sql.gz
    }
    break;

  case 'backupdelete'  :
    // welke backupfile moet gewist worden?
    if(!unlink($budir.PS.$p->fileselect))
      $msg['red'][] = "Kan backupbestand: {$p->fileselect} niet verwijderen!";
    else {
      // verwijder de logfile maar check eerst of er wel een is
      if($file->is_sane($budir.PS.$p->fileselect.'.log',1)) {
        if(!unlink($budir.PS.$p->fileselect.'.log')) {
          $msg['red'][] = "Kan logbestand: {$p->fileselect}.log niet verwijderen!";
        }
      }
    }
    break;

  case 'backupdownload'  :
    // welke backupfile moet gedownload worden?
    $filename = $budir.PS.$p->fileselect;
    $ctype="application/octet-stream";
    header("Pragma: public");
    header("Expires: 0");
    header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
    header("Cache-Control: public");
    header("Content-Type: $ctype");
    header("Content-Disposition: attachment; filename=".basename($filename).";" );
    header("Content-Transfer-Encoding: binary");
    header("Content-Length: ".filesize($filename));
    ob_clean();
    flush();
    readfile($filename);
    break;

}

//
// Gegevens inlezen
//
// Alle bestaande backups van de geladen administratie weergeven
// Haal eerst alle .gz files uit de dbase map
//
$File = new File();

// Zijn de backupfile ge-gzipt? Scan de .gz bestanden anders de .sql bestanden
// bupfile  _administratie.sqlite.unixml6.20091224-0039.sql.gz
//
if($GLOBALS['config']->data['db']['driver'] == 'firebird') {
  $backupfiles = ($GLOBALS['config']->data['system']['gzip']) ?
    $File->get_files($budir,$GLOBALS['config']->data['db']['driver'],"gz",false,true) :
    $File->get_files($budir,$GLOBALS['config']->data['db']['driver'],"fbk",false,true);
}
else {
  $backupfiles = ($GLOBALS['config']->data['system']['gzip']) ?
    $File->get_files($budir,$GLOBALS['config']->data['db']['driver'],"gz",false,true) :
    $File->get_files($budir,$GLOBALS['config']->data['db']['driver'],"sql",false,true);
}

$filelistmsg = ''; $filelist = '';
if(is_array($backupfiles)) {
  $filelistmsg = "De volgende backupfiles staan op de server:";
}

$mess=<<<EOT

<p>Via deze pagina kan je backups maken van de huidige, geladen administratie.
Je kunt de backups terugzetten naar de administratie, backup-bestanden verwijderen of naar je eigen PC downloaden.</p>

<p>Je ziet op deze pagina een overzicht van alle backups die zijn gemaakt van de huidige, geladen administratie: 
<b>{$GLOBALS['config']->data['db']['default']}</b> ...
EOT;
$mess .= " <img src='/img/helpbubble.gif' onClick=\"Help('".RUBRIEK.".bupenrestore','Help bij backup en restore');\" style='cursor:help;width:15px;'>&nbsp;";

// START BUILDING BODYTEXT
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);
// De GET parm load=unload moet er hier wel aanblijven
$again = $_SERVER['REQUEST_URI'];

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>""
                         ,"subaktie"=>""
                         ,"terugzettenin"=>""
                         ) );

  $form->mainTableStart();

    $form->schemaHeader("Backups");
    
    $form->fieldSetBridge("");

      $form->blockLine('2',
                           array($mess
                                 ),
                           array("width='100%'") );

  // NIEUWE BUFILE
  //

  if($bufile) {

    $form->fieldSetBridge("Nieuw backupbestand gemaakt:");

      $form->blockLine('3',
                           array("<div class='schemarow_std' style='padding:8 8 8 8;font-weight:bold;font-size:110%'>".$bufile."</div>"
                                 ),
                           array("width='100%'") );

  } // END IF bufile

  // BACKUP GELADENIN
  //

  if(!empty($geladenin)) {

    $form->fieldSetBridge("Backup teruggezet in:");

      $form->blockLine('1',
                           array("<div class='schemarow_std' style='padding:8 8 8 8;font-weight:bold;font-size:110%'>".$geladenin."</div>"
                                 ),
                           array("width='100%'") );

  } // END IF geladenin


  // FILELIST
  //

  if(is_array($backupfiles)) {

    $form->fieldSetBridge("De volgende backupfiles staan op de server:");

      $form->blockLine('4',
                           //array("<div class='schemarow_head'><input type='radio' name='fileselect' onClick='settitle(\"\");' value='' /></div>"
                           array("<div class='schemarow_head'></div>"
                                ,"<div class='schemarow_head'><span onClick='unCheck(\"fileselect\")'>b.u. van database</span></div>"
                                ,"<div class='schemarow_head' align='middle'>datum</div>"
                                ,"<div class='schemarow_head' align='middle'>tijd</div>"
                                ,"<div class='schemarow_head'>&nbsp;</div>"
                                 ),
                           $veldarr );

    $naam = ($fromdbase) ? $fromdbase : $GLOBALS['config']->data['db']['default'];
    foreach($backupfiles AS $val) {
      // Toon alleen de backupfiles van de geladen administratie
      //   haal het naamdeel uit de administratienaam 
      if(!preg_match("/^_?{$naam}\./",$val)) continue;

      // Haal de eerste logregel op.
      $logregel = $file->firstline_read($budir.PS.$val.'.log');

      // Als er newlines in de logregel staan, extra escapen voor javascript
      $logregel = preg_replace("/\r\n/", "<br />", $logregel);
      //$logregel = preg_replace("/\r\n/", "", $logregel);

      // verwijder tekens die ongewenst zijn in de output
      $logregel = preg_replace("/['\"]/", "", $logregel);
      
      // Herleid de bestandsnaam naar onderdelen om in het scherm te tonen.
      // bupfile  _administratie.sqlite.unixml6.20091224-0039.sql.gz
      $ar = explode(".", $val);
      $administratie = preg_replace("/_?(\w+)/", "$1", $ar[0]);
      preg_match("/(\d{4})(\d{2})(\d{2})-(\d{2})(\d{2})/", $ar[3], $ar2);
      $datum         = "{$ar2[3]}-{$ar2[2]}-{$ar2[1]}";
      $tijd          = "{$ar2[4]}:{$ar2[5]}";

      $form->blockLine('',
                           array("<div class='schemarow_std'><input type='radio' name='fileselect' onClick='settitle(\"{$logregel}\");' value='{$val}' /></div>"
                                ,"<div class='schemarow_std' title='{$logregel}'>{$administratie}</div>"
                                ,"<div class='schemarow_std' align='middle'>{$datum}</div>"
                                ,"<div class='schemarow_std' align='middle'>{$tijd}</div>"
                                ,"<div class='schemarow_head'>&nbsp;</div>"
                                 ),
                           $veldarr );

    } // END FOREACH backupfiles

  } // END array bupfiles
  
  
  // LOGREGEL
  //

    $form->fieldSetBridge("Logtekst voor backup:");

      #$form->blockLine('2',array("<div class='schemarow_std'><input type='text' name='logregel' size='60' value='' /></div>"),
      #                     array("width='100%'") );

      $form->blockLine('2',array("<div class='schemarow_std'><textarea name='logregel' rows='2' cols='55' style='font-size:100%;'></textarea></div>"
                                ,"<div class='schemarow_std' style='font-size:90%;'><a onClick='document.forms[\"frm1\"].logregel.disabled=false;' style='cursor:pointer;'>&lt;&lt;edit</a><br /><br />"
                                ."<a onClick='savebulog();' style='cursor:pointer;'>&lt;&lt;set</a></div>"
                                 ),
                           array("width='90%'","width='10%'") );

  // BUTTONS
  //
    
    $form->fieldSetBridge("");

      $buttons=<<<EOT

        <input type='button' name='backupbutton' value='backup' size='10' class='bsmall2' class='bsmall2' onClick="doBackup();"/>
        <input type='button' name='sluiten' value='sluiten' size='10' class='bsmall2' class='bsmall2' onClick="window.close();"/>
EOT;

      $buttons2=<<<EOT

        <input type='button' name='terugzetbutton' value='terugzetten' size='10' class='bsmall2' class='bsmall2' onClick="doLaden();"/>
        <input type='button' name='downloadbutton' value='downloaden'  size='10' class='bsmall2' class='bsmall2' onClick="doDownloaden();"/>
        <input type='button' name='wisbutton'      value='wissen'      size='10' class='bsmall2' class='bsmall2' onClick="doWissen();"/>
EOT;

      $form->blockLine('2',array($buttons,"Backup-bestand: ".$buttons2),
                           array("width='30%'","width='70%' align='right'") );

  //
  // Lees een lijst met beschikbare databases, hierin kan het geselecteerde
  // bu bestand evt. kunnen teruggezet. De databases waarin kan worden
  // teruggezet hoeven geen administratiedatabases te zijn; ook een lege
  // database komt in aanmerking.
  //

  $dbaseselect = $dbaseselect_van = "\n<option value=''>---------------</option>";
  // TODO in mysql geeft na het inlezen van een bup, listDatabases een fout. We
  // bouwen even een controle in maar uiteindelijk moet de fout eruit.
  $arr = listDatabases($plain=true);
  if(is_array($arr)) {
    foreach($arr AS $naam) {
      $dbaseselect .= ($naam == $p->dbasenaam) ?
        "\n<option selected='selected' value='{$naam}'>{$naam}</option>" :
        "\n<option value='{$naam}'>{$naam}</option>";
    }
    foreach(listDatabases() AS $naam) {
      $dbaseselect_van .= ($naam == $p->dbasenaam) ?
        "\n<option selected='selected' value='{$naam}'>{$naam}</option>" :
        "\n<option value='{$naam}'>{$naam}</option>";
    }
  }

      $form->blockLine('2',array("<div class='schemarow_std'>&nbsp;</div>"
                                ,"Backup kiezen in: <select onChange='switchdbase();' name='dbasenaam'>{$dbaseselect_van}</select>"
                                ),
                           array("width='30%'","width='70%' align='right'") );

      $form->blockLine('2',array("<div class='schemarow_std'>&nbsp;</div>"
                                ,"Gekozen backup terugzetten in: <select onChange='setotherdbase();' name='terugzettenkeuze'>{$dbaseselect}</select>"
                                ),
                           array("width='30%'","width='70%' align='right'") );
/* TODO kunnen werken met meerdere administraties Dat wil zeggen dat we een willekeurige bupfile ergens vandaan kunnen laden en deze inlezen in een (al dan niet lege) administratie van desnoods een andere naam. Deze functie is voor accountants die administratiebestanden van klanten binnenkrijgen.
*/

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

function get_filename() {
  var x = document.forms['frm1'];
  var c = 'fileselect';
  // als fileselect is een string (1 over)
  if(x[c].value) { 
    var filename = x[c].value; 
  }
  else {
    var y = x.elements[c].length;
    for(i=0; i<y; i++) 
      if(x[c][i].checked) 
        var filename = x[c][i].value;
  }
  if(filename)
    return(filename);
  else
    return(false);
}

function savebulog() {
  // schrijft de bulogregel opnieuw weg naar het geselecteerde bubestand
  var x = document.forms['frm1'];
  // als logregel is disabled, ga dan niet door
  if(x.logregel.disabled===true) return(false);
  // wat is het geselecteerde bubestand?
  if(! (filename = get_filename())) { alert("Selecteer een backup-file om de logtekst naar op te slaan!"); return(false); }
  else {
    x.subaktie.value = 'buregelsave';
    x.submit();
  }

}

// TODO de functie om de logtekst te laden moet via Ajax worden uitgevoerd
function settitle(a) {
  var x = document.forms['frm1'];
  if(a) {
    x.logregel.value=a.replace(/<br \/>/g,"\\n");
    x.logregel.disabled=true;
  }
  else {
    x.logregel.value='';
    x.logregel.disabled=false;
  }
}

function doBackup() {
  var x = document.forms['frm1'];

  if(!confirm('Je gaat nu een backup maken van de huidge administratie!')) return(false);
  else {
    x.subaktie.value = 'backupsave';
    x.submit();
  }
}

function switchdbase() {
  var x = document.forms['frm1'];
  // dbasenaam komt van de selectbox
  if(x.dbasenaam.options[x.dbasenaam.selectedIndex].value != '') 
    var dbasename = x.dbasenaam.options[x.dbasenaam.selectedIndex].value;
  else {
    x.dbasenaam.options[0].value = 'administratie';
    x.dbasenaam.options[0].selected = 'true';
  }
  x.subaktie.value = 'switchdbase';
  x.submit();
}

function setotherdbase() {
  var x = document.forms['frm1'];
  // dbasenaam komt van de selectbox
  if(x.terugzettenkeuze.options[x.terugzettenkeuze.selectedIndex].value != '') 
    var dbasename = x.terugzettenkeuze.options[x.terugzettenkeuze.selectedIndex].value;
  else {
    x.terugzettenkeuze.options[0].value = 'administratie';
    x.terugzettenkeuze.options[0].selected = 'true';
  }
  var   msg = 'Je gaat de geselecteerde backup terugladen in de database: ' + dbasename + '\\n';
  msg = msg + 'DIT SCHOONT DE DATABASE: ' + dbasename + '!\\n';
  msg = msg + 'Maak desnoods eerst een veiligheidsbackup van de die database.';
  if(!confirm(msg)) {
    x.terugzettenin.value = '';
    x.terugzettenkeuze.options[0].selected = 'true';
    return(false);
  }
  else {
    x.terugzettenin.value = dbasename;
  }
  return;
}

function f_replace(f) {
  return(f.replace(/^_?([^.]+)(.*$)/,"$1"));
}

function doLaden() {
  var x = document.forms['frm1'];
  var filename = '';
  if(! (filename = get_filename())) { alert("Selecteer een backup-file!"); return(false); }
  // dbasenaam komt van de terugzettenin of van de bu-filename
  if(x.terugzettenin.value != '') var dbasename = x.terugzettenin.value;
  else var dbasename = f_replace(filename);
  var   msg = 'Je gaat de geselecteerde backup terugladen in de database: ' + dbasename + '\\n';
  msg = msg + 'DIT SCHOONT DE HUIDIGE DATABASE: ' + dbasename + '!\\n';
  msg = msg + 'Maak desnoods eerst een veiligheidsbackup van de huidige database.';
  if(!confirm(msg)) return(false);
  else {
    x.subaktie.value = 'backupload';
    x.submit();
  }
}

function doDownloaden() {
  var x = document.forms['frm1'];
  var filename = '';
  if(! (filename = get_filename())) { alert("Selecteer een backup-file!"); return(false); }
  filename = f_replace(filename);
  var   msg = 'Je gaat de geselecteerde backupfile nu downloaden naar je eigen PC.';
  if(!confirm(msg)) return(false);
  else {
    x.subaktie.value = 'backupdownload';
    x.submit();
  }
}

function doWissen() {
  var x = document.forms['frm1'];
  var filename = '';
  if(! (filename = get_filename())) { alert("Selecteer een backup-file!"); return(false); }
  filename = f_replace(filename);
  var   msg = 'Je staat op het punt de geselecteerde backup-file te verwijderen!\\n';
  msg = msg + 'Weet je het zeker!';
  if(!confirm(msg)) return(false);
  else {
    x.subaktie.value = 'backupdelete';
    x.submit();
  }
}

function unCheck(c) {
  var x = document.forms['frm1'];
  var y = x.elements.length;
  for(i=0; i<y; i++) if(x.elements[i].name == c) x.elements[i].checked=false;
} 

EOJ;
 
/* __END__ */
