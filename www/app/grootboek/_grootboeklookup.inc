<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _grootboeklookup.inc 236 2013-07-07 19:51:19Z frank $
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

$render->body .= "\n          <!-- grootboeklookup.inc -->\n";
$render->subtitle[] = "grootboeklookup.inc";
$render->titel = "Grootboekstamgegevens schema overzicht";

//
// Gegevens inlezen
//
// controleer of alle rkg koppelingen en rekeningen bestaan
//
$defaults = array("debiteuren"=>$stam->existRekening('rkg_debiteuren')
                 ,"crediteuren"=>$stam->existRekening('rkg_crediteuren')
                 ,"pinbetalingen"=>$stam->existRekening('rkg_pinbetalingen'));
      
//
// START BUILDING BODYTEXT
//

// helaas moeten we de javascript functies in _journaal.inc en _journaal.js hier
// herhalen om de BTW regel goed ingesteld te krijgen als gevolg van het 
// aanklikken van een GEENBTW rekeningnummer
// Mocht er iets in die functies wijzigen, doe het dan ook hier.
//
$tmp = (isset($p->periode) && $p->periode == $GLOBALS['stam']->periodeextra['value']) ? '' :
  $tmp = $grootboek->selectJSGeenBtwKaarten();

// Geef dagboektype mee naar facturenselectiescherm omdat dit uit kan maken of
// een bedrag debet of credit in het boekregelveld wordt gezet.
$dagboektype = ($p->dagboektype) ? "&dagboektype={$p->dagboektype}" : '' ;

  $render->iscript[] = "/js/ajax.js";

  $render->jscript .=<<<EOJ

function init() {
  // alert("Zit in init");
}

addEvent(window,'load',init)

function checkGrbBtw(b) {
  var a = String(b);
  {$tmp}
}
    

function isset(  ) {
  // *     example 1: isset( undefined, true);
  // *     returns 1: false
  // *     example 2: isset( 'Kevin van Zonneveld' );
  // *     returns 2: true
  var a=arguments; var l=a.length; var i=0;
      
  if (l==0) throw new Error('Empty isset'); 
  while (i!=l) {
    if (typeof(a[i])=='undefined' || a[i]===null) return false; 
    else i++; 
  }
  return true;
}


// Onderstaande twee functies zijn kopieen van die in _journaal.js

//
// disable BTW velden op instigatie van een 'GEENBTW' grootboeknummer
// reset ook evt het oorspronkelijke bedrag en maak de btw velden leeg
//
function disableBtw() {
  var x = window.opener.document.forms['frm1'];
  // voor het geval deze lookup in andere toepassingen wordt gebruikt dan boekregels
  if(! isset(x.bedrag)) return;
  // is er al iets in x.bedrag? ja: zet dat terug in x.debet of x.credit
  if(x.bedrag.value != '') {
    if(x.bedrag.value > 0) x.debet.value = parseFloat(x.bedrag.value).toFixed(2);
    else if(x.bedrag.value < 0) x.credit.value = (x.bedrag.value * -1).toFixed(2);
  }
  x.elements['btwbedrag'].disabled = true;
  x.elements['btwbedrag'].value = '';
  for(i=0;i<5;i++) {
    x.elements['btw'][i].checked = false;
    x.elements['btw'][i].disabled = true;
  }
}

//
// enable BTW velden op instigatie van een 'BTW' grootboeknummer
//
function enableBtw() {
  var x = window.opener.document.forms['frm1'];
  if(! isset(x.elements['btwbedrag'])) return;
  x.elements['btwbedrag'].disabled = false;
  for(i=0;i<5;i++)
    x.elements['btw'][i].disabled = false;
}


function doLoad(a,b) {
  window.resizeTo(550,670);
  switch(a) {
    case '{$defaults['debiteuren']}' :
      window.location='/run.php?app=debiteuren&aktie=facturenlookup{$dagboektype}';
      break;
    case '{$defaults['crediteuren']}' :
      window.location='/run.php?app=crediteuren&aktie=facturenlookup{$dagboektype}';
      break;
    case '{$defaults['pinbetalingen']}' :
      window.location='/run.php?app=pinbetalingen&aktie=facturenlookup{$dagboektype}';
      break;
  }

}

  
function settle(a,b,c,d) {
  // leg eerst de click vast in populariteit
  registerClick(a);
  window.opener.document.forms['frm1'].grootboekrekening.value = a;
  window.opener.document.forms['frm1'].grootboekrekening.title = b;
  if(c != '')
    window.opener.document.getElementById('btwnummer').innerHTML = 'rkg.' + c;
  else
    window.opener.document.getElementById('btwnummer').innerHTML = '';
  window.opener.document.getElementById('btwnummer').title = d;
  // stel de btwregel in parent in op het geselecteerde nummer
  checkGrbBtw(a);
  window.close();
}


function registerClick(a) {
  //var url = "/grootboek/populariteit.php?nr=" + a;
  var url = "/run.php?app=populariteit&nr=" + a;
  // ajax actie
  doURL(url);
  if(a == '0') window.location.reload();
}

EOJ;

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>""
                         ) );

  $form->mainTableStart();

  // EERSTE FIELDBLOCK 
  // Debiteuren/Crediteuren/Pinboekingen
  // Toon dit eerste en tweede fieldblock alleen als het scherm wordt
  // opgevraagd vanuit een boekingspost en niet vanuit overige lookupfuncties.
  // In die gevallen gaat het immers uitsluitend om een grootboeknummer.
  //
    
  if($dagboektype) {

    $form->fieldSetStart("Dagboeken",array('','Journaal..dagboekSelecteren','Dagboek selecteren'));

      $form->blockLine('',
                       array("<div class='schemarow_std'><a href='#' onClick=\"doLoad('{$defaults['debiteuren']}','');\" style='color:black;text-decoration:none;'>{$defaults['debiteuren']}</a></div>"
                            ,"<div class='schemarow_std'>Verkopen</div>"
                             ),
                       array("width='10%'","width='70%'"));
      
      $form->blockLine('',
                       array("<div class='schemarow_std'><a href='#' onClick=\"doLoad('{$defaults['crediteuren']}','');\" style='color:black;text-decoration:none;'>{$defaults['crediteuren']}</a></div>"
                            ,"<div class='schemarow_std'>Inkopen</div>"
                             ),
                       array("width='10%'","width='70%'"));
      
      $form->blockLine('',
                       array("<div class='schemarow_std'><a href='#' onClick=\"doLoad('{$defaults['pinbetalingen']}','');\" style='color:black;text-decoration:none;'>{$defaults['pinbetalingen']}</a></div>"
                            ,"<div class='schemarow_std'>Pinbetalingen</div>"
                             ),
                       array("width='10%'","width='70%'"));
      

  // GROOTBOEKREKENINGEN
  //
    
    $form->fieldSetBridge("Veel gevraagde rekeningen &nbsp; <img src='/img/sponge2s.png' style='cursor:pointer;' onClick=\"registerClick('0');\" title='Opschonen veel gevraagde rekeningen'/>");

$stam->query = "SELECT \"naam\",\"nummer\" FROM {$stam->grootboekstam} WHERE \"populariteit\">0 ORDER BY \"populariteit\" DESC, \"nummer\"";
$stam->query =<<<EOT
SELECT DISTINCT
  g.nummer,
  g.naam,
  g.populariteit,
  CASE WHEN g.btwdefault = '' THEN NULL ELSE
    CASE WHEN b.nummer > {$stam->omslag['value']} THEN NULL ELSE b.nummer END 
  END AS btwnummer,
  CASE WHEN g.btwdefault = '' THEN NULL ELSE 
    CASE WHEN b.nummer > {$stam->omslag['value']} THEN NULL ELSE b.naam END 
  END AS btwnaam
FROM vw_grootboekstam AS g
JOIN vw_grootboekstam AS b
ON g.btwdefault=b.btwkey
WHERE
  g.nummer NOT IN (SELECT value FROM vw_notinpopular)
AND
  g.populariteit > 0
ORDER BY 
  g.populariteit DESC

EOT;
$stam->Do_sql(basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__);

      $render->body .= "<div id='popular'>";

while($obj = $stam->Do_object()) {
 
      $form->blockLine('',
                       array("<div class='schemarow_std'><a name='{$obj->nummer}'></a><a href='#' onClick=\"settle({$obj->nummer},'{$obj->naam}','{$obj->btwnummer}','{$obj->btwnaam}');\" style='color:black;text-decoration:none;'>{$obj->nummer}</a></div>",
                             "<div class='schemarow_std'>{$obj->naam}</div>",
                             "<div class='schemarow_std'></div>"
                             ), 
                       array("width='10%'","width='70%'","width='20%'") );
}

      $render->body .= "</div>";

  } // END IF dagboektype

    $form->fieldSetBridge("Balansrekeningen",array('','Journaal..rekeningSelecteren','Grootboekrekening selecteren'));
      
//
// begin met target als balans
//
$target = BALANS;

//
// Het balans overzicht
//
$stam->query = "SELECT \"naam\",\"nummer\" FROM {$stam->grootboekstam} WHERE \"nummer\" < {$stam->omslag['value']} ORDER BY \"nummer\"";
$stam->query =<<<EOT
SELECT DISTINCT
  g.nummer,
  g.naam,
  CASE WHEN g.btwdefault = '' THEN NULL ELSE
    CASE WHEN b.nummer > {$stam->omslag['value']} THEN NULL ELSE b.nummer END 
  END AS btwnummer,
  CASE WHEN g.btwdefault = '' THEN NULL ELSE 
    CASE WHEN b.nummer > {$stam->omslag['value']} THEN NULL ELSE b.naam END 
  END AS btwnaam
FROM vw_grootboekstam AS g
JOIN vw_grootboekstam AS b
ON g.btwdefault=b.btwkey
WHERE 
  g.nummer < {$stam->omslag['value']} 
ORDER BY g.nummer

EOT;
$stam->Do_sql(basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__);

while($obj = $stam->Do_object()) {

      $form->blockLine('',
                       array("<div class='schemarow_std'><a name='{$obj->nummer}'></a><a href='#' onClick=\"settle({$obj->nummer},'{$obj->naam}','{$obj->btwnummer}','{$obj->btwnaam}');\" style='color:black;text-decoration:none;'>{$obj->nummer}</a></div>",
                             "<div class='schemarow_std'>{$obj->naam}</div>",
                             "<div class='schemarow_std'></div>"
                             ), 
                       array("width='10%'","width='70%'","width='20%'") );
}


    $form->fieldSetBridge("Winst/Verliesrekeningen");
      
//
// ga verder met target als resultaat
//
$target = RESULTAAT;

//
// Het VenW overzicht
//
//$stam->query = "SELECT \"naam\",\"nummer\" FROM {$stam->grootboekstam} WHERE \"type\"={$target} ORDER BY \"nummer\"";
$stam->query = "SELECT \"naam\",\"nummer\" FROM {$stam->grootboekstam} WHERE \"nummer\" >= {$stam->omslag['value']} ORDER BY \"nummer\"";
$stam->query =<<<EOT
SELECT DISTINCT
  g.nummer,
  g.naam,
  CASE WHEN g.btwdefault = '' THEN NULL ELSE
    CASE WHEN b.nummer > {$stam->omslag['value']} THEN NULL ELSE b.nummer END 
  END AS btwnummer,
  CASE WHEN g.btwdefault = '' THEN NULL ELSE 
    CASE WHEN b.nummer > {$stam->omslag['value']} THEN NULL ELSE b.naam END 
  END AS btwnaam
FROM vw_grootboekstam AS g
JOIN vw_grootboekstam AS b
ON g.btwdefault=b.btwkey
WHERE 
  g.nummer >= {$stam->omslag['value']} 
ORDER BY g.nummer

EOT;
$stam->Do_sql(basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__);

while($obj = $stam->Do_object()) {

      $form->blockLine('',
                       array("<div class='schemarow_std'><a name='{$obj->nummer}'></a><a href='#' onClick=\"settle({$obj->nummer},'{$obj->naam}','{$obj->btwnummer}','{$obj->btwnaam}');\" style='color:black;text-decoration:none;'>{$obj->nummer}</a></div>",
                             "<div class='schemarow_std'>{$obj->naam}</div>",
                             "<div class='schemarow_std'></div>"
                             ), 
                       array("width='10%'","width='70%'","width='20%'") );
 
}


  // BUTTONS
  //
    
    $form->fieldSetBridge("");

      $buttons=<<<EOT

        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>
EOT;

      $form->blockLine('2',array($buttons),
                           array("width='100%'") );


    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();


/* __END__ */
