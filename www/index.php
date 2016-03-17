<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: index.php 253 2013-07-28 07:46:21Z frank $
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

require("../lib/_init.inc");

// Er kan een voorkeur-achtergrondkleur in de tabel voorkeuren zijn ingegeven
if($x = $stam->Get_field('"value"', "\"{$config->data['tbl']['voorkeuren']}\"", "\"naam\"='achtergrondkleur'")) {
  $bggif = "/img/backlijn-{$x}.gif";
}
else 
switch($config->data['style']['bg']) {
  case 'blauw'  : $bggif = '/img/backlijn-blue.gif'; break;
  case 'groen'  : $bggif = '/img/backlijn-green.gif'; break;
  case 'purple' : $bggif = '/img/backlijn-purple.gif'; break;
  default       : $bggif = '/img/backlijn.gif'; break;
}

// Indien automatische updates is ingeschakeld:
// kijk op de site of er updates zijn
if($config->data['system']['autoupdates']) {
  null; // TODO autoupdates implementeren
}

// Controleer of de sqlversie van de applicatie en uit de datbase overeen komen.
// Let op: er is sprake van incompatibiliteit als de eerste 2 cijfers niet
// overeen komen. Het laatste cijfer staat voor mineure veranderingen, meestal
// een verandering in de dataset b.v. een record toegevoegd of de waarde
// veranderd.
$sqlversieDbase = $stam->Get_field('"value"', $stam->tableMeta, "\"key\"='sqlversie'");
preg_match("/^[\d]+\.[\d]+/", $sqlversieDbase, $een);
preg_match("/^[\d]+\.[\d]+/", $version->data['sql']['version'], $twee);
if(! preg_match("/$een[0]/", $twee[0])) {
  $msg['red'][] = "De database-versie komt niet overeen met de applicatie-versie";
}

// als wisseling van jaar is aangevraagd:
//
$p = new Params(array("aktie"=>""
                     ,"boekjaar"=>""
                     ),'_POST');

if($p->aktie == 'boekjaar') {
  $stam->jaarSelect($p->boekjaar);
}

// Vul de jaarselect pulldown list
//
// Vul het lopendjaar pulldown. Toon alle jaren waarvan boekingen in het
// systeem aanwezig zijn en het jaar volgend op het huidig jaar vermits dat
// niet het huidige kalenderjaar overschrijdt. Als het lopendjaar=2009 en het
// is nu 2009 dan wordt niet 2010 getoond, dus het huidig kalenderjaar is
// altijd bovengrens.
//
$jaarselect = $stam->jaarSelectbox();

// Cookie expiration
$expire = time() + 31104000; # (60 * 60 * 24 * 360);

/* De site zou eigenlijk onder dit DTD moeten werken maar doet dat niet goed. 
   Zonder de DTD draait de site in Quirksmode (en geeft goed weer), met de DTD
   doet een aantal CSS eigenschappen het niet meer.

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
*/
?>
<html>
  <head>
    <title>Administratie startpagina</title>

    <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
    <meta name="description" content="Startpagina administratiepakket OpenAdmin.nl" />
    <meta name="keywords" content="" />

    <meta name="author" content="OpenAdmin.nl, Frank Kooger" />
    <meta name="authored" content="2006-01-05" />
    <meta name="build" content="<?php echo $version->data['application']['build'] ?>" />
    <meta name="builddate" content="<?php echo $version->data['application']['builddate'] ?>" />
    <meta name="sqlversion" content="<?php echo $version->data['sql']['version'] ?>" />
    <meta name="dbversion" content="<?php echo $sqlversieDbase ?>" />

    <meta name="driver" content="<?php print $config->data['db']['driver'] ?>" />

    <link rel="stylesheet" type="text/css" href="/css/stylesheet.css" />
    
    <style type="text/css">
      .menuitem {
        padding:8 0 8 30;
      }
      td.paraph {
        font-weight: bold;
      }
    </style>
    
    <script type="text/javascript" src="/js/validation.js"></script>

    <script type="text/javascript">
      
function Help(code,tag) {
  var win = window.open('<?php print $config->data['url']['base_url'] ?>/helper/help.php?code='+code+'&tag='+tag,'Help','resizable,scrollbars,status,width=450,height=400,left=40,top=40');
}

// popup-opener script
//
function pop_app(app,url) {
  var set = '';

  switch(app) {
    case 'journaalpost'    : 
      set = <?php print $GLOBALS['WINDOW_OPTIONS']['JOURNAALPOST']?>; break;
    case 'journaalprint'   : 
    case 'ifacturenlijst'  : 
    case 'vfacturenlijst'  : 
    case 'grbprint'        : 
    case 'saldilijsten'    : 
      set = <?php print $GLOBALS['WINDOW_OPTIONS']['GROOTBOEKKAART']?>; break;
    case 'btwrubrieken'    : 
      set = <?php print $GLOBALS['WINDOW_OPTIONS']['BTWRUBRIEKEN']?>; break;
    case 'btw'             : 
      set = <?php print $GLOBALS['WINDOW_OPTIONS']['BTWAANGIFTE']?>; break;
    case 'grootboekstam'   : 
    case 'debiteurenstam'  : 
    case 'crediteurenstam' : 
      set = <?php print $GLOBALS['WINDOW_OPTIONS']['GROOTBOEKSTAM']?>; break;
    case 'dagboeken'       : 
      set = <?php print $GLOBALS['WINDOW_OPTIONS']['DAGBOEKEN']?>; break;
    case 'stamgegevens'    : 
    case 'jaarafsluiting'  : 
    case 'backups'         : 
      set = <?php print $GLOBALS['WINDOW_OPTIONS']['STAMGEGEVENS']?>; break;
    case 'administraties'  : 
      set = <?php print $GLOBALS['WINDOW_OPTIONS']['ADMINISTRATIES']?>; break;
    default                : return; break;
  }

  if (!app.closed && app.location) {
    app.location.href = url;
  }
  else {
    app=window.open(url,app,set);
    if (!app.opener) app.opener = self;
  }
  if (window.focus) app.focus();
  return false;
}

function changeBoekjaar() {
  var x=window.document.frm1;
  x.aktie.value = 'boekjaar';
  x.submit();
}

function hideshow(which){
  if (!document.getElementById) return
  var k2 = document.getElementById('kolom2');
  if (k2.style.visibility=="visible") {
    k2.style.visibility='hidden';
    which.innerHTML="toon meer";
    setCookie("mainmenu","1",<?php echo $expire ?>);
  }
  else {
    k2.style.visibility='visible';
    which.innerHTML="toon minder"
    setCookie("mainmenu","2",<?php echo $expire ?>);
  }
}

  </script>

  </head>
  <body background='<?php print $bggif ?>'>
    <h1 style='padding:8 0 8 60;'>Administratie: <span id='adminnaamid'><?php print $stam->adminnaam['value']?></span></h1>

<?php
  if(!empty($msg['red'])) {
    $tmp = '';
    foreach($msg['red'] AS $val) $tmp .= $val."<br />\n";

    print("<div style='padding:8 0 8 60;'>\n");
    print("<table><tr><td class='paraph' style='color:red;font-size:110%'>{$tmp}</td></tr>\n");
    print("</table></div>");
  }
?>

    <div style='padding:8 0 4 60;'>

<form name='frm1' action='/index.php' enctype='multipart/form-data' method='post'>
<input type='hidden' name='aktie' value='' />

    <table>
      <tr><td class='paraph'>Database: </td><td class='paraph' id='bedrijfsnaamid'><?php if($config->data['db']['driver'] != 'sqlite' && !preg_match("/localhost/",$config->data['db']['host'])) print $config->data['db']['host'].'::'; print $config->data['db']['default'] ?></td></tr>

      <tr><td class='paraph'>Boekjaar: </td><td class='paraph'><?php print $stam->lopendjaar['value']?>/<?php print $stam->huidigeperiode; ?>
          <span style='padding: 0px 26px;'></span><select name='boekjaar' id='boekjaar' onChange='changeBoekjaar();'><?php print $jaarselect ?></select></td></tr>
    </table>
</form>
    </div>
    <div style='position:relative;left:60;'>
    
      <table width='70%' height='70%' style='font-size:100%; background-image:url(/img/schriftlijn.gif);'>

        <tr style='padding:0px;'>
          <td></td>
          <td></td>
          <td><div id='pijltje' onClick='hideshow(this);' style='cursor:pointer;font-size:85%;'>pijltje</div><!-- TODO tekst vervangen door plaatje --></td>
        </tr>
        
        <tr><td valign='top'>
          <!-- kolom 1 -->
          <td valign='top'>

    <h2 >Boeken</h2>

    <div class='menuitem'>
    <a href='#' title='Klik hier om journaalposten in te geven in te zien en te wijzigen.'
       class='rightmenu' style="cursor:pointer;"  
       onClick="pop_app('journaalpost','<?php print $config->data['url']['base_url'] ?>/run.php?app=journaalpost');">Journaalposten</a>
    </div>

    <h2 >Rapportage</h2>

    <div class='menuitem'>
    <a href='#' title='Klik hier om voor een overzicht van het journaal in te zien en te printen.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('journaalprint','<?php print $config->data['url']['base_url'] ?>/run.php?app=journaalpost&aktie=print');">Overzicht journaal</a>
    </div>
    <div class='menuitem'>
    <a href='#' title='Klik hier om grootboekrekeningen in te zien.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('grbprint','<?php print $config->data['url']['base_url'] ?>/run.php?app=grbprint');">Grootboekkaarten</a>
    </div>
    <div class='menuitem'>
    <a href='#' title='Klik hier om saldilijsten in te zien.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('saldilijsten','<?php print $config->data['url']['base_url'] ?>/run.php?app=saldilijsten');">Saldilijsten</a>
    </div>
    <div class='menuitem'>
    <a href='#' title='Klik hier om BTW opgavecijfers in te zien.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('btw','<?php print $config->data['url']['base_url'] ?>/run.php?app=btw&aktie=btw');">BTW aangifte</a>
    </div>
    <div class='menuitem'>
    <a href='#' title='Klik hier om inkoopfacturen in te zien.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('ifacturenlijst','<?php print $config->data['url']['base_url'] ?>/run.php?app=ifacturenlijst&aktie=print&facturen=1');">Lijst Inkoopfacturen</a>
    </div>
    <div class='menuitem'>
    <a href='#' title='Klik hier om verkoopfacturen in te zien.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('vfacturenlijst','<?php print $config->data['url']['base_url'] ?>/run.php?app=vfacturenlijst&aktie=print&facturen=1');">Lijst Verkoopfacturen</a>
    </div>

          </td>
          <!-- kolom 2 -->
          <td valign='top'>
            <div id='kolom2'>

    <h2 >Administratiegegevens</h2>

    <div class='menuitem'>
    <a href='#' title='Klik hier om grootboek stamgegevens in te zien en te wijzigen.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('grootboekstam','<?php print $config->data['url']['base_url'] ?>/run.php?app=grootboekstam');">Grootboek schema</a>
    </div>
    <div class='menuitem'>
    <a href='#' title='Klik hier om crediteuren stamgegevens in te zien en te wijzigen.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('crediteurenstam','<?php print $config->data['url']['base_url'] ?>/run.php?app=crediteurenstam');">Crediteuren gegevens</a>
    </div>
    <div class='menuitem'>
    <a href='#' title='Klik hier om debiteuren stamgegevens in te zien en te wijzigen.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('debiteurenstam','<?php print $config->data['url']['base_url'] ?>/run.php?app=debiteurenstam');">Debiteuren gegevens</a>
    </div>


    <div class='menuitem'>
    <a href='#' title='Klik hier om dagboeken in te zien en te wijzigen.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('dagboeken','<?php print $config->data['url']['base_url'] ?>/run.php?app=dagboeken');">Dagboeken</a>
    </div>
    <div class='menuitem'>
    <a href='#' title='Onderhoud BTW rubrieken.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('btwrubrieken','<?php print $config->data['url']['base_url'] ?>/run.php?app=btwrubrieken');">BTW-rubrieken</a>
    </div>
    <div class='menuitem'>
    <a href='#' title='Klik hier om systeem-stamgegevens in te zien en te wijzigen.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('stamgegevens','<?php print $config->data['url']['base_url'] ?>/run.php?app=stamgegevens');">Gegevens administratie</a>
    </div>

    <h2 >Systeem</h2>

    <div class='menuitem'>
    <a href='#' title='Jaarafsluiting.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('jaarafsluiting','<?php print $config->data['url']['base_url'] ?>/run.php?app=jaarafsluiting');">Jaarafsluiting</a>
    </div>
    <div class='menuitem'>
    <a href='#' title='Klik hier om backups te beheren.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('backups','<?php print $config->data['url']['base_url'] ?>/run.php?app=backups&load=noload');">Backups</a>
    </div>
    <div class='menuitem'> 
    <a href='#' title='Klik hier om een nieuwe of testadministratie aan te maken/in te schakelen.'
       class='rightmenu' style="cursor:pointer;"  
       onclick="pop_app('administraties','<?php print $config->data['url']['base_url'] ?>/run.php?app=administraties&load=noload');">Andere administratie</a>
    </div> 

            </div>
          <!-- einde kolom2 -->
          </td>
        <!-- einde kolommen -->
        </tr>

        <tr style='padding:0px;'>
          <td></td>
          <td colspan='2'><div style='font-size:80%;color:gray;text-align:center;'>Copyright @ <?php echo $GLOBALS['timer']->jaar ?> <a href='http://www.openadmin.nl/'>OpenAdmin.nl</a> - All Rights Reserved.</div></td>
        </tr>
        

    </table>

    </div>

  </body>

<script type='text/javascript'>
  switch(getCookie("mainmenu")) {
    case '1' : 
      document.getElementById('kolom2').style.visibility='hidden';
      document.getElementById('pijltje').innerHTML='toon meer';
      break;
    case '2' : 
    default  :
      document.getElementById('kolom2').style.visibility='visible';
      document.getElementById('pijltje').innerHTML='toon minder';
      break;
  }

</script>

</html>
