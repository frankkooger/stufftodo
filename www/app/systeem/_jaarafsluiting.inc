<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _jaarafsluiting.inc 243 2013-07-13 20:57:37Z otto $
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

$render->body .= "\n          <!-- jaarafsluiting.inc -->\n";
$render->subtitle[] = "jaarafsluiting.inc";
$render->titel = "Jaarafsluiting jaar {$stam->boekjaar}";

// HOUSEKEEPING
//

// Als de boekregels in de eindejaarsregel tabel er voor dit jaar nog niet zijn, maak  ze dan nu aan.
//
if(! $eindejaar->checkEindejaarcheck()) $eindejaar->initEindejaar();

// array met veldattributen voor blockLine
//
$veldarr = array("width='10%'","width='5%'","width='45%'","width='25%'","width='15%'");
$veldarr_saldo = array("colspan='2' width='60%'","width='25%'","width='15%'","width='15%'");

// Reageer op een reset alvorens gegevens weer opnieuw in te lezen
// Zet alle values weer op beginwaarden
//
if($p->aktie == 'reset') {
  $arr = array();
  $stam->Do_query("SELECT * FROM {$stam->eindcheck} WHERE \"boekjaar\"='{$stam->boekjaar}' ORDER BY \"sortering\"");
  while($obj = $stam->Do_object()) { $arr[] = $obj; }
  foreach($arr AS $val) {
    if($val->value == GREENLIT ) 
      $stam->Do_query("UPDATE {$stam->eindcheck} SET \"value\"=".RED." WHERE \"naam\"='{$val->naam}' AND \"boekjaar\"='{$stam->boekjaar}'", basename(__FILE__).'::'.__LINE__);
    elseif($val->value == BLUELIT ) 
      $stam->Do_query("UPDATE {$stam->eindcheck} SET \"value\"=".BLUE." WHERE \"naam\"='{$val->naam}' AND \"boekjaar\"='{$stam->boekjaar}'", basename(__FILE__).'::'.__LINE__);
  }
}


// Gegevens inlezen
//
// Lees de eindejaarsitems
//
$items = array();
$stam->Do_query("SELECT * FROM {$stam->eindcheck} WHERE \"boekjaar\"='{$stam->boekjaar}' ORDER BY \"sortering\"");
while($obj = $stam->Do_object()) {
  $items[$obj->naam] = $obj;
}
checkBlocking($items);

$mess=<<<EOT

<p>Als alle onderstaande items in volgorde zijn uitgevoerd is de jaarafsluiting voltooid.</p>
<p>Blauwe buttons zijn reminders, rode buttons zijn actiebuttons en doen wat erachter vermeld is.
Na de eerste actie (=rode button) KAN NIET MEER GEBOEKT WORDEN in het boekjaar!</p>

EOT;

// START BUILDING BODYTEXT
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>""
                         ,"subaktie"=>""
                         ,"item"=>""
                         ) );

  $form->mainTableStart();

    $form->schemaHeader("Jaarafsluiting");
    
    $form->fieldSetBridge("Jaarafsluiting",array('',RUBRIEK.'.overzicht','Jaarafsluiting overzicht') );

      $form->blockLine('2',
                           array($mess
                                 ),
                           array("width='100%'") );
    // messages

    $form->messagePrint();

  // ITEMLIST
  //
/*
<pre>items: 
Array
(
    [memoriaal] => stdClass Object
        (
            [id] => 8
            [datum] => 0000-00-00
            [boekjaar] => 2008
            [sortering] => 5
            [label] => Eindejaars memoriaalposten
            [naam] => memoriaal
            [type] => 0
            [value] => 3
            [tekst] => De laatste memoriaalposten van het boekjaar
        )
*/

  if(! empty($items)) {

    $form->fieldSetBridge("Vink onderstaande items af:");

      $form->blockLine('4',
                           array("<div class='schemarow_head'></div>"
                                ,"<div class='schemarow_head' align='middle'></div>"
                                ,"<div class='schemarow_head' style='cursor:crosshair;padding:7' onClick='resetAll();'>item</div>"
                                ,"<div class='schemarow_head' align='middle'>&nbsp;</div>"
                                ,"<div class='schemarow_head'>&nbsp;</div>"
                                 ),
                           $veldarr );

    // Print de itemregels
    //
    foreach($items AS $val) {

      $button = checkButton($val);
      //$help = $stam->helpDiv(RUBRIEK.preg_replace("/[ -?]/","",$val->label),$val->label); 
      $help = $stam->helpDiv(RUBRIEK.preg_replace("/[ -?]/","",$val->naam),$val->label); 
      $kut = ($val->naam == 'herstel') ? "style='cursor:crosshair;padding-left:7' onClick='herstel();'" : "style='padding-left:7'";

      $form->blockLine('',
                           array("<div class='schemarow_std' style='padding:7'>{$button}</div>"
                                ,"<div class='schemarow_std' align='middle'>{$help}</div>"
                                ,"<div title='{$val->tekst}' class='schemarow_std'  {$kut}>{$val->label}</div>"
                                ,"<div class='schemarow_std' align='middle'></div>"
                                ,"<div class='schemarow_head'>&nbsp;</div>"
                                 ),
                           $veldarr );

    } // END FOREACH items

  } // END IF items
  

  // BUTTONS
  //
    
    $form->fieldSetBridge("");

      $buttons=<<<EOT

        <input type='button' name='sluiten' value='sluiten' size='10' class='bsmall2' class='bsmall2' onClick="window.close();"/>
EOT;

      $buttons2=<<<EOT

        <input type='button' name='omschakelbutton' value='activeren' size='10' class='bsmall2' class='bsmall2' onClick="doLaden();"/>
        <input type='button' name='verwijderbutton' value='verwijderen' size='10' class='bsmall2' class='bsmall2' onClick="doWissen();"/>
EOT;

      $form->blockLine('2',array($buttons,""),
                           array("width='30%'","width='70%' align='right'") );


    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();

// tekstchunks naar body
//
$render->body .=<<<EOT

<div id='chunk1'>
Zorg ervoor dat alle eindejaarsmemoriaalposten zijn gedaan zoals:

- Afschrijvingen
- Correcties
- Zakelijke kilometers
- etc.

Is dat allemaal gebeurd, klik dan op 'OK' en ga door met de volgende items.

Als je nog niet klaar bent, klik dan hier op 'Annuleer' en maak de memoriaalboekingen af.

</div>

<div id='chunk2'>

</div>

<script type="text/javascript">
var chunk1 = document.getElementById('chunk1');
var chunk2 = document.getElementById('chunk2');

chunk1.style.display='none';
chunk2.style.display='none';
</script>
EOT;

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

// a = item.naam
// b = green|red
//
function settle(a,b) {
  var x = document.forms['frm1'];
  var goon = true;

  switch(a) {
    case 'memoriaal' :
      var msg = chunk1.innerHTML;
      if(! confirm(msg))goon = false;
      break;
  }

  if(goon) {
    x.item.value = a;
    x.aktie.value = 'check';
    x.subaktie.value = b;
    x.submit();
  }
  else
    return(false);
}

// herstel grootboeksaldi manually
//
function herstel() {
  var x = document.forms['frm1'];
  var msg = '';
  msg = msg + "Je gaat nu de grootboeksaldi herstellen!\\n\\n";
  if(!confirm(msg)) return(false);
  x.aktie.value = 'herstelsaldi';
  x.subaktie.value = '';
  x.submit();
}

// Reset alle blocks en values voor dit boekjaar
//
function resetAll() {
  var x = document.forms['frm1'];
  var msg = '';
  msg = msg + "Je gaat ALLE checks nu resetten naar beginstand!\\n\\n";
  msg = msg + "WEET JE ZEKER dat je dit wilt?!\\n\\n";
  if(!confirm(msg)) return(false);
  x.aktie.value = 'reset';
  x.subaktie.value = '';
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

EOJ;
 
/* ******************* FUNCTIONS ************************* */

/*
* We moeten hier bepalen of een knop aanklikbaar is of niet. Er is een
* bepaalde volgorde die zegt dat een knop pas kan worden ingedrukt als 1
* of meer eerdere knoppen al actief zijn. 
* - De eerste twee blauwe knoppen 'memoriaal' en 'consolidatie' kunnen worden aan en uitgedrukt.
* - De 3e, rode knop 'herstel' kan pas worden ingedrukt als 1 en 2 actief zijn.
* - De 4e en 5e, blauwe knoppen 'balansen' en 'grootboekkaarten' kunnen worden aan en uitgedrukt als 3 actief is. 
* - De 6e 7e en 8e, rode knoppen 'eindbalans', 'kapitaal' en 'beginbalans' kunnen sequentieel worden ingedrukt nadat de eerdere knoppen allemaal actief zijn.
* - Als een knop die afhankelijk is van vorige knoppen actief is, kunnen de vorige knoppen niet meer inactief worden gemaakt.
*
Array
(
    [memoriaal] => stdClass Object
        (
            [id] => 8
            [datum] => 0000-00-00
            [boekjaar] => 2008
            [sortering] => 5
            [label] => Eindejaars memoriaalposten
            [naam] => memoriaal,consolidatie , herstel , balansen,grootboekkaarten , eindbalans,kapitaal,beginbalans
            [type] => 0
            [value] => 3
            [tekst] => De laatste memoriaalposten van het boekjaar
toevoegen in checkBlocking: 
            [blocked] => 1
        )
*/
function checkBlocking(&$items) {

  // zet een blockparameter in de objects
  foreach($items AS $key=>$val)
    $items[$key]->blocked = false;

// BLUE - memoriaal
// BLUE - consolidatie
// RED  - backup
// RED  - herstel
// BLUE - balansen
// BLUE - grootboekkaarten
// RED  - eindbalans
// RED  - beginbalans

  // Bovenste blok
  //
  // blokkeer alles na memoriaal maar niet memoriaal zelf, dit is het startpunt
  if($items['memoriaal']->value == BLUE) {
    $items['consolidatie']->blocked = true;
    $items['backup']->blocked = true;
    $items['herstel']->blocked = true;
  }
  // blokkeer alles na consolidatie
  elseif($items['consolidatie']->value == BLUE) {
    $items['consolidatie']->blocked = true;
    $items['backup']->blocked = true;
    $items['herstel']->blocked = true;
  }
  // blokkeer alles na backup
  elseif($items['backup']->value == RED) {
    $items['backup']->blocked = true;
    $items['herstel']->blocked = true;
  }
  // Onderste blok
  //
  // blokkeer alles na balansen
  if($items['balansen']->value == BLUE) {
    $items['balansen']->blocked = true;
    $items['grootboekkaarten']->blocked = true;
    $items['eindbalans']->blocked = true;
    $items['beginbalans']->blocked = true;
  }
  // blokkeer alles na grootboekkaarten
  elseif($items['grootboekkaarten']->value == BLUE) {
    $items['grootboekkaarten']->blocked = true;
    $items['eindbalans']->blocked = true;
    $items['beginbalans']->blocked = true;
  }
  // blokkeer alles na eindbalans
  elseif($items['eindbalans']->value == RED) {
    $items['eindbalans']->blocked = true;
    $items['beginbalans']->blocked = true;
  }
  // EINDE default blocking. Hierna selectieve openstelling

  // open consolidatie na memoriaal
  if($items['memoriaal']->value == BLUELIT) {
    $items['consolidatie']->blocked = false;
  }
  // open backup na consolidatie
  if($items['consolidatie']->value == BLUELIT) {
    $items['backup']->blocked = false;
  }
  // Als memoriaal of consolidatie nog niet (meer) beide actief zijn, dan backup (weer) blocked 
  if($items['memoriaal']->value == BLUE || $items['consolidatie']->value == BLUE) {
    $items['backup']->blocked = true;
  }
  // Als backup actief is mogen memoriaal en consolidatie niet meer uit
  // Tevens mag backup zelf niet meer uit
  if($items['backup']->value == GREENLIT) { //
    $items['memoriaal']->blocked = true;
    $items['consolidatie']->blocked = true;
    $items['backup']->blocked = true;
  }
  // Als herstel actief is mag herstel zelf niet meer uit
  if($items['herstel']->value == GREENLIT) { // 
    $items['herstel']->blocked = true;
  }

  // Link tussen bovenste en onderste blok
  if($items['herstel']->value == GREENLIT) { // 
    $items['balansen']->blocked = false;
  }

  // Onderste blok

  // Stel grootboekkaarten open als balansen actief
  if($items['balansen']->value == BLUELIT) {
    $items['grootboekkaarten']->blocked = false;
  }
  // Stel eindbalans open als grootboekkaarten actief
  if($items['grootboekkaarten']->value == BLUELIT) {
    $items['eindbalans']->blocked = false;
  }
  // Als balansen of grootboekkaarten nog niet actief dan eindbalans blocked
  if($items['balansen']->value == BLUE || $items['grootboekkaarten']->value == BLUE) {
    $items['eindbalans']->blocked = true;
  }
  // Stel beginbalans open indien eindbalans actief
  if($items['eindbalans']->value == GREENLIT) {
    $items['beginbalans']->blocked = true;
  }
  // Als eindbalans actief dan balansen en grootboekkaarten en zichzelf blocked
  if($items['eindbalans']->value == GREENLIT) {
    $items['balansen']->blocked = true;
    $items['grootboekkaarten']->blocked = true;
    $items['eindbalans']->blocked = true;
    $items['beginbalans']->blocked = false;
  }
  // Als beginbalans actief dan balansen en grootboekkaarten en zichzelf blocked
  if($items['beginbalans']->value == GREENLIT) {
    $items['balansen']->blocked = true;
    $items['grootboekkaarten']->blocked = true;
    $items['eindbalans']->blocked = true;
    $items['beginbalans']->blocked = true;
  }

  return(true);
}

// Stel de buttons samen. Gebruik voor de buttonkleur de waarde in value. Of
// een button aanklikbaar is hangt af van de waarde in blocked.
//
function checkButton($val) {
  global $items;

  if($val->blocked)

    switch($val->value) {
      case BLUE     :
        $button = "<img src='/img/button-blue-50.gif' border='0' onClick='nothing(\"{$val->naam}\",\"blue\")' "
                 ." title='NOT Cecked: {$val->label}' />" ; break;
      case BLUELIT  :
        $button = "<img src='/img/button-lblue-lit-50.gif' border='0' onClick='nothing(\"{$val->naam}\",\"bluelit\")' "
                 ." title='NOT Cecked: {$val->label}' />" ; break;
      case GREENLIT :
        $button = "<img src='/img/button-green-lit-50.gif' border='0' onClick='nothing(\"{$val->naam}\",\"greenlit\")' "
                 ." title='NOT Cecked: {$val->label}' />" ; break;
      case RED      :
        $button = "<img src='/img/button-red-50.gif' border='0' onClick='nothing(\"{$val->naam}\",\"red\")' "
                 ." title='NOT Cecked: {$val->label}' />" ; break;
    }

  else
    switch($val->value) {
      case BLUE     :
        $button = "<img src='/img/button-blue-50.gif' border='0' onClick='settle(\"{$val->naam}\",\"blue\")' "
                 ."style='cursor:pointer;' title='Cecked: {$val->label}' />" ; break;
      case BLUELIT  :
        $button = "<img src='/img/button-lblue-lit-50.gif' border='0' onClick='settle(\"{$val->naam}\",\"bluelit\")' "
                 ."style='cursor:pointer;' title='Cecked: {$val->label}' />" ; break;
      case GREENLIT :
        $button = "<img src='/img/button-green-lit-50.gif' border='0' onClick='settle(\"{$val->naam}\",\"greenlit\")' "
                 ."style='cursor:pointer;' title='Cecked: {$val->label}' />" ; break;
      case RED      :
        $button = "<img src='/img/button-red-50.gif' border='0' onClick='settle(\"{$val->naam}\",\"red\")' "
                 ."style='cursor:pointer;' title='Cecked: {$val->label}' />" ; break;
    }

  return($button);
}

/* __END__ */
