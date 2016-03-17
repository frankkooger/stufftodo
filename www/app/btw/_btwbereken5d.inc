<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _btwbereken5d.inc 295 2015-01-28 13:08:58Z otto $
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

$render->body .= "\n          <!-- btwbereken5d.inc -->\n";
$render->subtitle[] = "btwbereken5d.inc";

// HOUSEKEEPING
//
// rkg rekeningen worden al gecontroleerd in de aanroepende script _btwaangifte.inc
// en we nemen ook een rkgobj mee

// We moeten nu periode * queryArr's hebben, dus 4 of 12
// ergo we moeten het array kopieren. Dat wordt interessant omdat het array
// objecten bevat, dat zijn feitelijk pointers naar de objecten. Nu kan je een
// array wel kopieren (default by value) maar je kopieert dezelfde pointers
// naar de objecten mee en maakt geen value kopien van de objecten. We moeten
// dus per gekopieerd array de bevattende objecten klonen.
//
/*
for($i=1;$i<=$stam->periodetot['value'];$i++) {
  // Maak een kopie van queryArr en clone de objecten erin
  $queryArr[$i] = array();
  foreach($arr AS $key=>$obj) {
    $queryArr[$i][$key] = clone $obj;
  }

*/
/*
printrc1($rkgobj5d, "array met labelkey objecten: "); 
//
// Vul nu de rekeningenobjecten met resultaten uit de saldi queries.
//
$erzijnsaldi = false; $saldo=0; $key='';

// Leg totalen vast voor de totaalrekeningen
//
$totaal = 0;
$periodes = array();

  // Let wel dat indien geen saldo, er ook geen key is gezet.
  // 
  // Totaliseren INDIEN.. het saldo ervoor in aanmerking komt:
  //   - als in een periode BTW teruggave heeft plaatsgevonden, dan telt die
  //   periode niet mee en wordt niet negatief gesaldeerd.
  //   Dit is vw_btw5d geregeld
  //
  // Wat we van de "vw_btw5d" view willen zien zijn 3 dingen:
  //   1. Het totaalsaldo verkopen_verlegdebtw: 1e bedragen van grootboekrekening(en) met key 'verkopen_verlegdebtw'
  //   1a. afgeleid van 2 een BTW bedrag, 19% omdat verlegde omzet in de categorie van 6% denkelijk niet voorkomt??!! (nog nakijken)
  //   2. Het alreeds teruggevorderde bedrag 5d regeling: 5d
  //   3. Het totaal afgedragen en nog af te dragen betaalde BTW: de positieve 5c bedragen

  Het resultaat als er geen 1 en 2 boekingen zijn:
    2008;"5c";0;1883
    2009;"5c";0;1988
    2010;"5c";0;1141

*/
$verkopen_verlegdebtw = $btw_verkopen_verlegdebtw = $afdracht = $totaal = $algeboekte5d = $totaal5c = 0.00;

/*
$stam->Do_query('SELECT "ccode","verlegdeomzet","btwbedrag" FROM "vw_btw5d" ', 
                basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__);
while($obj = $stam->Do_object()) {

  printrc2($obj,"wat is nu het ojbetc: ");
  switch($obj->ccode) {
    case '1e': $verkopen_verlegdebtw = $obj->verlegdeomzet;
               $btw_verkopen_verlegdebtw = $obj->btwbedrag;
               break;
    //case '5d': $afdracht = $obj->btwbedrag;
    case '5d': $algeboekte5d = $obj->btwbedrag;
               break;
    //case '5c': $totaal = $obj->btwbedrag;
    case '5c': $totaal5c = $obj->btwbedrag;
               break;
  }
}
*/

$stam->Do_query('SELECT * FROM "vw_btw5d_calculus" ', 
                basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__);
if($obj = $stam->Do_object()) {
    $btw_verkopen_verlegdebtw   = $obj->verlegdebtw;
    $totaal5c                   = $obj->btwbedrag;
}

printrc2($totaal5c, "totaal5c is nu: ");
printrc2($algeboekte5d, "algeboekte5d is nu: ");
printrc2($verkopen_verlegdebtw, "verkopen_verlegdebtw is nu: ");
printrc2($btw_verkopen_verlegdebtw, "btw_verkopen_verlegdebtw is nu: ");

// Bereken evt. teruggaaf. Hieronder een tabel met de maximale vermindering per kwartaal
// indien per kwartaal of per maand al op voorhand wordt gerekend met 5d
// 
// Meer dan 1747: geen vermindering
// 1612..1747   : 68  per kwartaal
// 1476..1611   : 159 per kwartaal
// 1346..1475   : 250 per kwartaal
// 0000..1345   : het btw-bedrag
//
// Bij de eindejaarsberekening is de gegeven calculatie:
//
// Meer dan 1883 : geen vermindering
// 1346..1883    : 2,5 x (€ 1.883 - (btw-bedrag))
// 0000..1345    : het btw bedrag
//
// We werken in onderstaande berekeningen met twee bedragen
define('TOP', 1883);
define('MID', 1345);

// De te bepalen afdracht is totaal5c + btw_verkopen_verlegdebtw 
$totaal = $totaal5c + $btw_verkopen_verlegdebtw;

if($totaal > TOP) { // geen vermindering
  $vermindering = 0;
  $tekst = "Je hebt <b>geen</b> recht op vermindering volgens de regeling voor kleinondernemers.";
}
else if($totaal > MID && $totaal <= TOP) { // recht op vermindering volgens calculatie
  // $vermindering = round(2.5 * ( TOP - $afdracht),0);
  $vermindering = round(2.5 * ( TOP - $totaal),0);
  //
  // Let op: ingeval een groot bedrag aan verlegde BTW en weinig 'eigen' BTW
  // kan het verminderingbedrag hoger uitvallen dan de totaal betaalde btw zie
  // voorbeeld:
  //  ----------------------------------------------------------------------------------------------
  //  |In afgelopen boekjaar is tot nu toe 149 BTW afgedragen.
  //  |De omzet met verlegde BTW is: 8194
  //  |De verlegde BTW is: 1557. Deze verlegde BTW telt mee in de berekening voor kleinondernemers.
  //  |Je hebt recht op vermindering van 443
  //  ----------------------------------------------------------------------------------------------
  // In dit geval moet het verminderingsbedrag wordt teruggebracht naar maximaal de afgedragen btw.
  //
  ($vermindering > $totaal5c) and $vermindering = $totaal5c;
  $tekst = "Je hebt recht op vermindering van <b>{$vermindering}</b>";
}
else if($totaal <= MID) { // vermindering van de volledig btw afdracht, dus niet het bedrag btw_verkopen_verlegdebtw
  $vermindering = $totaal5c;
  $tekst = "Je hebt recht op vermindering van de volledige btw afdracht van dit boekjaar: <b>{$vermindering}</b>";
}

// Formatteer een tekstblok
$lines = array();
$lines[] = "<div style='margin:8;'>";
$lines[] = "In afgelopen boekjaar is tot nu toe {$totaal5c} BTW afgedragen.";
if($btw_verkopen_verlegdebtw) { 
  $lines[] = "De omzet met verlegde BTW is: {$verkopen_verlegdebtw}";
  $lines[] = "De verlegde BTW is: {$btw_verkopen_verlegdebtw}. Deze verlegde BTW telt mee in de berekening voor kleinondernemers.";
}
else
  $lines[] = "Er is geen omzet met verlegde BTW";

$lines[] = "</br>{$tekst}</br> ";

if($vermindering) {
  // controleer of we in de laatste periode zijn anders doen we niets
  if($p->periode == $stam->periodetot['value']) {
    // Je hebt recht op vermindering en je bevindt je in de laatste periode
    // Je kunt hier dus een boeking doen voor vermindering, tenzij die boeking al gedaan is
    // Kijk daarom eerst of er al een boeking is gedaan
    if($verminderingarr = $btw->existVermindering5d($p->periode)) { // Er is al een boeking. Stel voor om die te verwijderen
      $lines[] = "Er is al een 5d boeking voor een bedrag van '{$verminderingarr['bedrag']}' op rekening '{$verminderingarr['grootboekrekening']} {$verminderingarr['naam']}'";
      $lines[] = "Verwijder deze boeking eerst voordat je een nieuwe of aangepaste boeking kunt maken!</br>";
      $lines[] = "<div style='padding-top:15;'><input type='hidden' name='m_dagboektype' value='memo' />
                  <input type='hidden' name='vermindering' value='{$vermindering}' />";
      $lines[] = " &nbsp;<input type='button' value='5d boeking verwijderen' name='5dverwijderen' size='10' class='bsmall2' onClick='verwijder5d(this)'/></div>";
    }
    else { // er is nog geen boeking, stel voor om er een te maken
      $render->iscript[] = '/app/journaal/journaal.js';
      $lines[] = "Wil je van de 5d regeling gebruik maken en dit bedrag inboeken? Geef hieronder de grootboekrekening waarop de teruggave moet worden geboekt (meestal iets als 'Overige opbrengsten') en druk op '5d regeling inboeken': ";
      $lines[] = "<div style='padding-top:15;'><input type='text' size='4' name='grootboekrekening' title='' value='{$stam->rkg_divopbrengsten['value']}' style='text-align:right' />
                  <img src='/img/b_search.png' border='0' onClick='grbSelectie(true);' style='cursor:pointer' title='opzoeken grootboekrekeningen' />
                  <input type='hidden' name='m_dagboektype' value='memo' />
                  <input type='hidden' name='vermindering' value='{$vermindering}' />";
      $lines[] = " &nbsp;<input type='button' value='5d regeling inboeken' name='5dinboeken' size='10' class='bsmall2' onClick='inboeken5d(this)'/></div>";
    }
  }
  else { // je bent niet in de laatste periode
    $lines[] = "Je kunt een vermindering volgens 5d in de {$stam->periodetot['value']}e periode inboeken!";
  }
} // END IF vermindering
else {
  // Een andere mogelijkheid is dat er wel vermindering is geboekt maar bij
  // nadere controle blijkt dat er van vermindering geen sprake is, b.v. er
  // zijn na inboeken van 5d nog verkoopboekingen bijgekomen. Geef dan hier de
  // mogelijkheid om die 5d boeking te verwijderen.
  //
  // Bepaal eerst of er al een boeking bestaat
  //
  if($verminderingarr = $btw->existVermindering5d($p->periode)) { // Er is al een boeking. Stel voor om die te verwijderen
    $lines[] = "Er is nog een 5d boeking. Verwijder deze!</br>";
    $lines[] = "<div style='padding-top:15;'><input type='hidden' name='m_dagboektype' value='memo' />
                <input type='hidden' name='vermindering' value='{$vermindering}' />";
    $lines[] = " &nbsp;<input type='button' value='5d boeking verwijderen' name='5dverwijderen' size='10' class='bsmall2' onClick='verwijder5d(this)'/></div>";
  }
} // END ELSE vermindering

$lines[] = "</div>"; // laatste regel van het tekstblok, einde style=margin


// START BUILDING JAVASCRIPT
//

  $render->jscript .=<<<EOJ

function inboeken5d(deze) {
  var x = document.forms['frm1'];
  if(x.grootboekrekening.value == '') {
    alert("Je moet iets invullen in grootboekrekening!");
    x.grootboekrekening.focus();
    return(false);
  }
  x.aktie.value = 'btw';
  x.subaktie.value = 'inboeken5d';
  x.submit();
}


function verwijder5d(deze) {
  var x = document.forms['frm1'];
  x.aktie.value = 'btw';
  x.subaktie.value = 'verwijder5d';
  x.submit();
}


// De functie grbSelectie in journaal.js geeft een waarde terug in:
// window.opener.document.forms['frm1'].grootboekrekening.value = a;

EOJ;

/* __END__ */
