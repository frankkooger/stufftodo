<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _proefbalans-pdf.inc 289 2015-01-04 09:09:40Z otto $
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
require("_proefbalanssjablonen.inc");

$pdf->initialize();

// Deze saldilijst bestrijkt het volledige huidigjaar
//
$datum = "1-1-{$stam->lopendjaar['value']} - 31-12-{$stam->lopendjaar['value']}";
    
// Variabele kopgegevens (komen uit programma)
$pdf->onderwerp = $stam->adminnaam['value']. " - Proefbalans over: ".$datum;

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

// END HOUSEKEEPING
//

// Gegevens inlezen
//
require_once("_eindejaar.lib");
$eindejaar = new Eindejaar();

// haal de grootboekrekeningen van grootboeksaldi, hierop staan alle rekeningen van een boekjaar, ook met 0-saldi.
//
$arr = $eindejaar->proefbalansObjecten();
printrc2($arr, "arr: ");
// saldobalans en saldowinst zijn aan de objecten array toegevoegde strings; haal die eruit
//
$saldobalans = $arr['saldobalans'];
$saldowinst = $arr['saldowinst'];
unset($arr['saldobalans']);
unset($arr['saldowinst']);

// START BUILDING BODYTEXT
//

// begin met balansrekeningen
//

// BALANS
//

$rows = $count = 0;
$totaal_debet = $totaal_credit = $winstsaldo = $resultaatsaldo = 0;
$Aheader = array('sjabloon'=>'header', 'data'=>array('Nummer','Omschrijving','Debet','Credit','Saldo')) ;
$Adata = array();

$Adata[] = $Aheader;

// de grootboekrekeningen hebben we in het objecten array $arr
//
/*
<pre>Array
(
    [100] => stdClass Object
        (
            [nummer] => 100
            [naam] => Inventaris
            [type] => 1
            [debet] => 3103.58
            [credit] => 0.00
            [delta] => 3103.58
        )

    [150] => stdClass Object
        (
            [nummer] => 150
            [naam] => Afschrijving Inventaris
            [type] => 1
            [debet] => 0.00
            [credit] => -1218.11
            [delta] => -1218.11
        )
*/

foreach($arr AS $key=>$obj) {

    // scheid balans- en resultaatrekeningen
    //
    if($obj->type == RESULTAAT) continue;

    // totalen debet en credit kolom
    //
    $totaal_debet  += $obj->debet;
    $totaal_credit += $obj->credit;
    $resultaatsaldo += $obj->delta;

    $saldo_debet = bedrag($obj->debet,'',false);
    $saldo_credit = bedrag($obj->credit * -1,'',false);

    $saldo = bedrag($obj->delta,'',false);
    
    $Adata[] = array('sjabloon'=>'regular', 'data'=>array($obj->nummer, $obj->naam, $saldo_debet, $saldo_credit, $saldo));

} // END WHILE balansrekeningen

// Print de totalen van de balansdata
$Adata[] = array('sjabloon'=>'totalen', 'data'=>array('Totalen: ', bedrag($totaal_debet,'',false), bedrag($totaal_credit,'',false), bedrag($resultaatsaldo,'',false)));

$pdf->printKop("Balansrekeningen", false);

$pdf->cTable($Adata);
$pdf->cTable(array());

//
// ga verder met resultaatrekeningen
//

$target = RESULTAAT;
$saldo = $totaal_debet = $totaal_credit = $resultaatsaldo = 0;
$Adata = array();
$lines = array('header'=>0, 'regular'=>0, 'totaalkaart'=>0, 'totalen'=>0);

$Adata[] = $Aheader;
$lines['header']++;

$pdf->sjabloon['regular']->switchstatus = 0; // begin de tabelregels weer met de basiskleur

foreach($arr AS $key=>$obj) {

  // scheid balans- en resultaatrekeningen
  //
  if($obj->type == BALANS) continue;

    // totalen debet en credit kolom
    //
    $totaal_debet  += $obj->debet;
    $totaal_credit += $obj->credit;
    $resultaatsaldo += $obj->delta;

    $saldo_debet = bedrag($obj->debet,'',false);
    $saldo_credit = bedrag($obj->credit * -1,'',false);

    $saldo = bedrag($obj->delta,'',false);
    
    $Adata[] = array('sjabloon'=>'regular', 'data'=>array($obj->nummer, $obj->naam, $saldo_debet, $saldo_credit, $saldo));
    $lines['regular']++;

} // END WHILE resultaatrekeningen

// Print de totalen van de balansdata
$Adata[] = array('sjabloon'=>'totalen', 'data'=>array('Totalen: ', bedrag($totaal_debet,'',false), bedrag($totaal_credit,'',false), bedrag($resultaatsaldo,'',false)));
$lines['totalen']++;

// Bepaal of er ruimte genoeg is om de VenW tabel nog op dezelfde pagina te printen
// De ruimte die nodig is: 
//   - ingeval nivo -1 en 0: 1xprintLine + 1xheader + nxAdata + 2xtotalen
//   - ingeval hogere nivos: 1xprintLine + 1xheader + nxAdata
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

// Print de Resultaatrekeningen in een tabel
$pdf->printKop("Resultaatrekeningen", false);

$pdf->cTable($Adata);
$pdf->cTable(array()); // lijn sluit tabel af

// Schrijf het pdf bestand

$item = "proefbalans";

$bestandsnaam = $item.'-'.$pdf->boekjaar.'-'.preg_replace("/[-]/","",$GLOBALS['timer']->vandaag).'.pdf';
//Close and output PDF document
$pdf->Output($bestandsnaam, 'I');

die;
