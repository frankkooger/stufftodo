<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _saldibalans-pdf.inc 289 2015-01-04 09:09:40Z otto $
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

$GLOBALS['config']->setValue('debug', 'level', 0);

require("_pdf.lib");

// Variabele instellingen:
//
// Landscape
#$pdf->landscape = true;

// Laad de tabelsjablonen
//
require("_saldibalanssjablonen.inc");

$pdf->initialize();

// Deze saldilijst bestrijkt het volledige huidigjaar
//
$datum = "1-1-{$stam->lopendjaar['value']} - 31-12-{$stam->lopendjaar['value']}";
    
// Variabele kopgegevens (komen uit programma)
$pdf->onderwerp = $stam->adminnaam['value'] . " - Saldibalans over: ".$datum;

// set document information
$pdf->SetTitle($pdf->onderwerp);
$pdf->SetSubject($pdf->onderwerp);
$pdf->SetKeywords("{$stam->adminnaam['value']}, administratie {$pdf->boekjaar}, {$pdf->onderwerp}");

// Start de pdf pagina
//
if($pdf->landscape) 
  $pdf->AddPage('L');
else
  $pdf->AddPage();

// zet eventjes hard
//
$saldilijst = true;

// HOUSEKEEPING
//

// array met veldattributen voor blockLine
//

$checked = array('nulsaldocheck'=>'','proefbalanscheck'=>'');

// vraag welke niveaus er aan totaalrekeningen zijn gekoppeld. Hieruit kan worden gekozen
// Het niveau 0 en -1 wordt er altijd aan gekoppeld:
// n: toon alleen totaalrekeningen vanaf niveau n en geen normale rekeningen. Toon ook geen totaalsaldi, alleen de saldi van de totaalrekeningen
// 0: toon totaalrekeningen van alle niveaus plus normale rekeningen
// -1: toon alleen normale rekeningen zonder totaalrekeningen
//
$arr = $stam->Get_array_field('DISTINCT "nivo"', $stam->grootboekstam, "ORDER BY \"nivo\"", basename(__FILE__)."::".__FUNCTION__."::".__LINE__);
$checked['nivocheck'] = array("-1"=>"");
foreach($arr AS $val) $checked['nivocheck'][$val] = "";

// een leeg array just in case er geen periode is aangeklikt
//
if(! isset($p->periode)) $p->periode = array();

// bereken de saldi van de gewenste nivos totaalrekeningen als die 
// getoond moeten worden
//
$totalen = ($p->nivo > -1) ? totalenSaldi($p->nivo) : array();

//
// END HOUSEKEEPING

// printlayout
//

  // nivocheck
  // De nivos zijn de nivos van de totaalrekeningen
  // nivo 8 laat alleen totaalrekening 8 zien (least verbose)
  // nivo 1 alle totaalrekeningen van 8 t.m. 1
  // nivo 0 alle totaalrekeningen plus gewone rekeningen (most verbose)
  // nivo -1 alleen gewone rekeningen
  // nivocheckline radiobuttons vullen
  //

// haal de grootboekrekeningen op
//

$geentotalen = $nulsaldo = "";

// Gegevens inlezen
//
// het gewenste grootboekstam overzicht
// - indien nivo==-1 dan alleen rekeningen, geen totaalrekeningen
// - indien nivo==0 dan alle rekeningen incl totaalrekeningen, 
// - anders, bij een hoger niveau de rekeningen vanaf dat nivo (zijn dus
//   totaalrekeningen, gewone rekeningen hebben nivo 0)
//
$nivois = ($p->nivo > 0) ? "AND \"nivo\">={$p->nivo}" : '';

// geen totaalrekeningen meenemen
$geentotalen = (empty($totalen)) ? "AND \"type\" <> ".TOTAALKAART : '';

// geen rekeningen zonder boekingen of 0-saldo tonen; default instelling
$nulsaldo = (empty($p->nulsaldocheck)) ? "AND (\"saldo\" <> 0 OR \"type\"=".TOTAALKAART.")" : '';

$stam->query = "SELECT * FROM {$stam->grootboekstamsaldo} WHERE 1=1 {$geentotalen} {$nulsaldo} {$nivois} ORDER BY \"nummer\"";

$stam->Do_sql( basename(__FILE__).'::'.__LINE__);

$arr  =array();
while($obj = $stam->Do_object()) $arr[] = $obj;

// begin met balansrekeningen
//

// BALANS
//

$totaal_debet = $totaal_credit = $singlesaldo = $winstsaldo = $resultaatsaldo = 0;
$Aheader = array('sjabloon'=>'header', 'data'=>array('Nummer','Omschrijving','Debet','Credit')) ;
$Adata = array();

$Adata[] = $Aheader;

foreach($arr AS $obj) {
 
  // scheid balans- en resultaatrekeningen
  //
  if($obj->type == RESULTAAT) continue;
  //
  // Skip totaalkaarten groter dan $stam->omslag (meestal 4000)
  //
  if($p->nivo>=0 && $obj->type == TOTAALKAART && $obj->nummer >= $stam->omslag['value']) continue;

  if($p->saldoweergave) {

    // totalen debet en credit kolom hebben we nodig bij saldilijst presentatie
    //
    if($obj->saldo < 0) { $totaal_credit += $obj->saldo * -1; $saldo_credit = formatbedrag($obj->saldo * -1,$nul=false); $saldo_debet = ''; }
    else                { $totaal_debet  += $obj->saldo     ; $saldo_debet = formatbedrag($obj->saldo,$nul=false); $saldo_credit = ''; }

    // singlesaldo hebben we nodig bij venwpresentatie
    //
    $singlesaldo += $obj->saldo;
    
    if($obj->type == TOTAALKAART)
      $totalensaldo = bedrag($totalen[$obj->nummer],'',false);
    else
      $winstsaldo += $obj->saldo;
  }
  else $singlesaldo = $totalensaldo = '';
   
  if($obj->type == TOTAALKAART) {
    $Adata[] = array('sjabloon'=>'totaalkaart', 'data'=>array($obj->nummer, "{$obj->naam}  niveau:{$obj->nivo}", $totalensaldo, '', ''));
  }
  else { // reguliere regel
    $Adata[] = array('sjabloon'=>'regular','data'=>array($obj->nummer,$obj->naam,bedrag($saldo_debet,'',false), bedrag($saldo_credit,'',false) ) ); 
  }

} // END WHILE balansrekeningen

// print bij een saldilijst de salditotalen, bij een venw lijst niet
// en ook bij verdichtingen niet. De salditotalen worden alleen maar
// gesaldeerd van standaard grootboekrekeningen niet van totaalrekeningen
//
if($saldilijst and ($totaal_debet or $totaal_credit)) { 

  // Print de totalen van de balansdata
  $Adata[] = array('sjabloon'=>'totalen', 'data'=>array('Totalen: ', bedrag($totaal_debet,'',false), bedrag($totaal_credit,'',false)));
}

// print een extra saldoregel
//
if($winstsaldo) { 

  // plaats de saldoregel in de juiste kolom
  //
  $debetline = $creditline = '';
  if($winstsaldo < 0)
    $debetline = bedrag($winstsaldo * -1,'',false);
  else
    $creditline = bedrag($winstsaldo,'',false);
    
  // Print het saldo Balans
  $Adata[] = array('sjabloon'=>'totalen', 'data'=>array('Saldo balans: ', $debetline, $creditline));
  $pdf->sjabloon['regular']->switchstatus = 0;

} // END IF winstsaldo

// Print de balansdata in een tabel
$pdf->printKop("Balansrekeningen", false); 
//

$pdf->cTable($Adata);
$pdf->cTable(array()); // afsluitende rand

//
// ga verder met resultaatrekeningen
//

$totaal_debet = $totaal_credit = $singlesaldo = 0;

$data = array();
$Adata = array();
$lines = array('header'=>0, 'regular'=>0, 'totaalkaart'=>0, 'totalen'=>0);

$Adata[] = $Aheader;
$lines['header']++;

foreach($arr AS $obj) {

  // scheid balans- en resultaatrekeningen
  //
  if($obj->type == BALANS) continue;
  //
  // Skip totaalkaarten kleiner dan $stam->omslag (meestal 4000)
  //
  if($p->nivo>=0 && $obj->type == TOTAALKAART && $obj->nummer < $stam->omslag['value']) continue;

  if($p->saldoweergave) {

    if($obj->saldo < 0) { $totaal_credit += $obj->saldo * -1; $saldo_credit = formatbedrag($obj->saldo * -1,$nul=false); $saldo_debet = ''; }
    else                { $totaal_debet  += $obj->saldo     ; $saldo_debet = formatbedrag($obj->saldo,$nul=false); $saldo_credit = ''; }

    // singlesaldo hebben we nodig bij venwpresentatie
    //
    $singlesaldo += $obj->saldo;
    
    if($obj->type == TOTAALKAART)
      $totalensaldo = bedrag($totalen[$obj->nummer],'',false);
    else
      $resultaatsaldo += $obj->saldo;
  }
  else $singlesaldo = $totalensaldo = '';
   
  if($obj->type == TOTAALKAART) {
    $Adata[] = array('sjabloon'=>'totaalkaart', 'data'=>array($obj->nummer, "{$obj->naam}  niveau:{$obj->nivo}", $totalensaldo, '', ''));
    $lines['totaalkaart']++;
  }
  else { // reguliere regel
    $Adata[] = array('sjabloon'=>'regular','data'=>array($obj->nummer,$obj->naam,bedrag($saldo_debet,'',false), bedrag($saldo_credit,'',false) ) ); 
    $lines['regular']++;
  }

} // END WHILE resultaatrekeningen

// print bij een saldilijst de salditotalen, bij een venw lijst niet
// en ook bij verdichtingen niet. De salditotalen worden alleen maar
// gesaldeerd van standaard grootboekrekeningen niet van totaalrekeningen
//
if($saldilijst and ($totaal_debet or $totaal_credit)) { 

  // Print de totalen van de venwdata
  $Adata[] = array('sjabloon'=>'totalen', 'data'=>array('Totalen: ', bedrag($totaal_debet,'',false), bedrag($totaal_credit,'',false)));
  $lines['totalen']++;

}

// print een extra saldoregel
//
if($resultaatsaldo) { 

  // plaats de saldoregel in de juiste kolom
  //
  if($resultaatsaldo < 0) {
    $debetline = bedrag($resultaatsaldo * -1,'',false);
    $label = "Saldo winst: ";
    $creditline = '';
  }
  else {
    $creditline = bedrag($resultaatsaldo,'',false);
    $label = "Saldo verlies: ";
    $debetline = '';
  }
    
  // Print het saldo VenW
  $Adata[] = array('sjabloon'=>'totalen', 'data'=>array($label, $debetline, $creditline));
  $lines['totalen']++;

} // END IF resultatensaldo


// Bepaal of er ruimte genoeg is om de VenW tabel nog op dezelfde pagina te printen
/*
printr($lines);
Array
(
    [header] => 1
    [regular] => 9
    [totaalkaart] => 9
    [totalen] => 2
)
*/
$spaceTaken = 14; // printKop
foreach($lines AS $label=>$val) {
  $spaceTaken += ($val * $pdf->sjabloon[$label]->height);
}

// Als de totale hoogte niet meer past op de rest van de pagina, geef een nieuwe pagina
if($spaceTaken > ($pdf->Pagedimensions['hk'] - $pdf->GetY() - $pdf->Pagedimensions['bm'])) {
  $pdf->AddPage();
}

// Print de VENWdata in een tabel
$pdf->printKop("Verlies en Winstrekeningen", false); 

$pdf->cTable($Adata);
$pdf->cTable(array()); // afsluitende rand


$item = "saldibalans";

$bestandsnaam = $item.'-'.$pdf->boekjaar.'-'.preg_replace("/[-]/","",$GLOBALS['timer']->vandaag).'.pdf';
//Close and output PDF document
$pdf->Output($bestandsnaam, 'I');


/* ***************************************************************** */
// LOCAL FUNCTIONS
//

function totalenSaldi($nivo=0) {
  global $stam, $grootboek;
 
  // maak een array met totaalkaartnummers en nivos
  // en lees de in een objecten array
  //
  $nivowhere = ($nivo > 0) ? " AND \"nivo\">={$nivo}" : '';
  //
  $stam->Do_query("SELECT \"nummer\",\"type\",\"nivo\" FROM {$stam->grootboekstam} WHERE \"type\"=".TOTAALKAART.$nivowhere, __FILE__."::".__FUNCTION__."::".__LINE__ );
  //
  $arr  =array();
  while($obj = $stam->Do_object())  $arr[] = $obj;
/*
printrc1($arr, "arr: ");
arr: Array
(
    [0] => stdClass Object ( [nummer] => 3999 [type] => 3 [nivo] => 7)
    [1] => stdClass Object ( [nummer] => 4999 [type] => 3 [nivo] => 5)
    [2] => stdClass Object ( [nummer] => 8985 [type] => 3 [nivo] => 5)
    [3] => stdClass Object ( [nummer] => 8990 [type] => 3 [nivo] => 7)
    [4] => stdClass Object ( [nummer] => 8999 [type] => 3 [nivo] => 8)
)
*/
  $totalen = array();

  foreach($arr AS $val) {
    //
    // bepaal van deze rekening of er een voorganger is op hetzelfde nivo
    // en bereken het saldo tussen de twee
    //
    $select =<<<EOT
"nummer" BETWEEN 
  COALESCE( (SELECT MAX("nummer")
    FROM "vw_grootboekstamsaldo"
    WHERE "nummer"<{$val->nummer} AND "nivo">={$val->nivo}), 1)
  AND {$val->nummer}
  AND "nivo"=0
EOT;
    $totalen[$val->nummer] = $stam->Get_field('SUM("saldo")', $stam->grootboekstamsaldo, $select, basename(__FILE__)."::".__FUNCTION__."::".__LINE__);

  } // END FOREACH

  return($totalen);

} // END FUNCTION totalenSaldi

die;
