<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _grootboekkaart-pdf.inc 289 2015-01-04 09:09:40Z otto $
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

require("_pdf.lib");

// Laad de tabelsjablonen
//
require("_grootboekkaartsjablonen.inc");

$pdf->initialize();

// Deze lijst bestrijkt het volledige huidigjaar
//
$datum = "1-1-{$stam->lopendjaar['value']} - 31-12-{$stam->lopendjaar['value']}";
    
// Variabele kopgegevens (komen uit programma)
$pdf->onderwerp = "Grootboekkaarten over: ".$datum;
$pdf->onderwerp = "Grootboekkaarten";

// set document information
$pdf->SetTitle($pdf->onderwerp);
$pdf->SetSubject($pdf->onderwerp);
$pdf->SetKeywords("OpenAdmin.nl, administratie {$pdf->boekjaar}, {$pdf->onderwerp}");

// Start de pdf pagina
//
if($pdf->landscape) 
  $pdf->AddPage('L');
else
  $pdf->AddPage();

// HOUSEKEEPING
//

// welke periodes hebben we, wat is de hoogste periode, we beginnen altijd bij 0, dat staat vast
//
for($i=0;$i<=$stam->periodeextra['value'];$i++) $checked['periodecheck'][$i] = "";

if(! isset($p->periode)) $p->periode = array();

$types = array(BALANS=>'Balans'
              ,RESULTAAT=>'Resultaat'
              ,TOTAALKAART=>'Totaalkaart');

$btwdefault = array(""=>"");
$stam->Do_query("SELECT \"btwkey\",\"nummer\",\"naam\" FROM {$stam->grootboekstam} WHERE \"btwkey\" NOT LIKE '' OR \"btwkey\" NOT LIKE NULL ");
while($obj = $stam->Do_object())
  $btwdefault[$obj->btwkey] = $obj->nummer . ': ' . $obj->naam;
printrc2($btwdefault, "btwdefault: ");

// periodecheck: het stukje AND sql maken
// Dit hebben we nodig in de selecties voor het samenstellen van 
// de grootboekrekening en eerder in de selectiecriteria van-tot
// Die laatse heeft een iets andere syntax en wordt dan ook in die
// lus uitgevoerd.
//
$tmp = $whereperiode = '';
$first = true;
$arr = array();

for($i=0;$i<=$stam->periodeextra['value'];$i++) {
  if(in_array($i,$p->periode)) {
    if($first) { $whereperiode .= " AND (\"periode\"=$i"; $first = false; }
    else         $whereperiode .= " OR \"periode\"=$i";
  }
}
$whereperiode and $whereperiode .= ")";

//
// END HOUSEKEEPING

// Gegevens inlezen
//

// Laad de nummervan-nummertot records. Bepaal of er 1 nummer is geselecteerd
// (in nummervan of nummertot) of dat beide nummers zijn geselecteerd. 
// - Als alleen nummervan is ingevuld, dan wordt alleen die rekening getoond
// (nummervan). Het maakt niet uit of die rekening buiten evt inclusief
// selecties valt, hij wordt getoond.
// - Als alleen nummertot is ingevuld, dan worden alle rekeningen tot en met die rekening getoond (10..nummertot)
// - Als beide nummers zijn ingevuld, dan wordt de verzameling tussen die nummers getoond (1200..3000)
// Op beide laatste gevallen zijn de inclusief selecties van toepassing (0-saldo etc.)
//
if($p->nummervan && ! $p->nummertot) { // er is 1 nummer, hierop zijn geen Inclusier selecties van toepassing zodat een dergelijke rekening altijd toont
  $arr[] = $stam->Get_object("SELECT * FROM {$stam->grootboekstamsaldo} WHERE \"nummer\"={$p->nummervan} ORDER BY \"nummer\"");
}

if(! $p->nummervan && $p->nummertot) { 
  // er is alleen nummertot, selecteer alle rekeningen vanaf het begin t.m. nummertot
  $p->nummervan = 1;
}

if($p->nummervan && $p->nummertot) { 
  // er is een nummerrange, hierop zijn alle zinnige 'Inclusief' selecties van toepassing

  $where = '';

  // Selectie op basis van geactiveerde 'nulperiodecheck' en/of 'totaalcheck'

  switch ($p->nulperiodecheck) {
    case false : switch($p->totaalcheck) {
                   case false : $where = 'AND "saldo" IS NOT NULL AND "type"<>'.TOTAALKAART; break;
                   case true  : $where = 'AND ("saldo" IS NOT NULL OR "type"='.TOTAALKAART.')'; break;
                 }
                 break;

    case true  : switch($p->totaalcheck) {
                   case false : $where = 'AND "type"<>'.TOTAALKAART; break;
                   case true  : $where = ''; break; // empty
                 }
                 break;

    default :    $where = '';
    }

  $query=<<<EOT
SELECT * FROM {$stam->grootboekstamsaldo} 
WHERE "nummer" BETWEEN {$p->nummervan} AND {$p->nummertot}
{$where}
ORDER BY
 "nummer"
EOT;

    // Do query en doe antwoord in een objectenarray
    //
    $GLOBALS['stam']->Do_query($query,'',basename(__FILE__)."::".__FUNCTION__."::".__LINE__);
    while($xobj = $GLOBALS['stam']->Do_object()) $arr[] = $xobj;

} // END IF nummervan nummertot

// arr bevat altijd een element, ook de teruggegeven fout als er niets gevonden is
// op select. Hiermee gaat hij tenminste 1x door de printlus (dus foutmelding vanwege geen nummer).
// maak arr leeg als hij alleen maar het fout element bevat.
//
if(! isset($arr) || ! isset($arr[0])) $arr = array();

// We hebben hier dus een array met rekeningnummer objecten. Van elk nummer moeten we
// nu bepalen welke boekingsregels er zijn. Die moeten we dus ophalen. Voorheen
// deden we voor elk rekeningnummer een dbase query maar we gaan nu eens
// proberen of we alle boekingen in een lang array kunnen laden met 1 query.
//
// Maak eerste een where clause voor alle gevonden rekeningnummers
// 
$tmp = '';
foreach($arr AS $val) {
  /*
printrc1($val, "val: ");
val: stdClass Object
  (
    [id] => 1
    [nummer] => 100
    [populariteit] => 1
    [type] => 1
    [nivo] => 0
    [btwdefault] => 1
    [naam] => Inventaris
    [boekjaar] => 2008
    [saldo] => 3103.58
  )
*/
  $tmp .= "{$val->nummer},";
}
$tmp and $tmp = ' AND "grootboekrekening" IN ('. substr($tmp,0,-1).')';

$where = "AND \"boekjaar\"={$stam->boekjaar} {$tmp} ". $whereperiode;

$GLOBALS['stam']->query =<<<EOT
SELECT
   "boekregelid"
  ,"journaalid"
  ,"grootboekrekening"
  ,"periode"
  ,"boekdatum"
  ,"relatie"
  ,"nummer"
  ,"boorsprong"
  ,"jnummer"
  ,"joorsprong"
  ,"dagboekcode"
  ,"bomschrijving"
  ,"bedrag"
FROM
  {$stam->boekregels}
WHERE 1=1
  {$where}
ORDER BY
   "grootboekrekening"
  ,"periode"
  ,"boekdatum"
  ,"boekregelid"  
EOT;

$GLOBALS['stam']->Do_sql( basename(__FILE__).'::'.__METHOD__.'::'.__LINE__);

while($obj = $GLOBALS['stam']->Do_object()) {
  $row[] = $obj;
}

/*
printrc1($row);
Array
(
    [0] => stdClass Object
        (
            [boekregelid] => 458
            [journaalid] => 1
            [grootboekrekening] => 100
            [periode] => 0
            [datum] => 2008-01-01
            [relatie] => 
            [nummer] => 
            [boorsprong] => 
            [jnummer] => 
            [joorsprong] => 
            [dagboekcode] => begin
            [bomschrijving] => Beginbalans
            [bedrag] => 955.80
        )
*/
// Bedenk dat we nu in de array alle boekingsregels met bijbehorende
// grootboeknummers maar de nummers zonder boekingsregels staan er niet in. Dus
// als we een opsomming willen zien van alle rekeningen, ook die zonder
// boekingen dan moeten we bij de lus dadelijk uitgaan van de nummers en per
// nummer de array-items uit deze array erbij zoeken.

// START BUILDING BODYTEXT
//

if($p->nummervan || $p->nummertot) {

  // Hier start de lus van rekeningnummers
  //
  foreach($arr AS $obj) { 
/*
printrc1($obj, "object rekeningnummer: ");
object rekeningnummer: stdClass Object
(
    [id] => 4
    [nummer] => 250
    [populariteit] => 0
    [type] => 1
    [nivo] => 0
    [btwdefault] => 5
    [naam] => Afschrijving transportmiddelen
    [boekjaar] => 
    [saldo] => 
)
*/

  $creditsum = 0.00;
  $debetsum = 0.00;

  // Start met het uitschrijven van de rijen boekingsregels van deze kaart
  //
  $aantalregels = 0;

  // Controleer of row er wel is. Bij kaarten zonder boekingen is dat niet het geval.
  //
  if(isset($row) && is_array($row)) {

    foreach($row AS $key=>$bobj) {

      if($obj->nummer != $bobj->grootboekrekening) { // break als er een volgend grootboeknummer verschijnt. Dit stop het verdere uitschrijven
                                                     // van regels en voorkomt dat steeds de hele array wordt doorlopen
        break; 
      }

      unset($row[$key]);

      $datum = $GLOBALS['timer']->iso2norm($bobj->datum);
      // we korten de datum wat in om meer ruimte op het scherm te laten. Jaar 2 digits
      preg_match("/^([\d]{2})-([\d]{2})-[\d]{2}([\d]{2})$/", $datum, $ar);
      $datum = "{$ar[1]}-{$ar[2]}-{$ar[3]}";
      $debet = $credit = '';
      
      // print relatie en/of (factuur/bon)nummer tussen haakjes achter de omschrijving

      if($bobj->relatie && $bobj->nummer) $extra = " ({$bobj->relatie} - {$bobj->nummer})";
      else if($bobj->relatie) $extra = " ({$bobj->relatie})";
      else if($bobj->nummer) $extra = " ({$bobj->nummer})";
      else $extra = "";
      $bobj->bomschrijving .= $extra;

      // als iets in joorsprong staat, print dat als dagboekcode.
      // dit gebeurt b.v. bij bank en kas waar de oorsprong de dagboekcode plus het bankafschriftnummer is
      $bobj->joorsprong and $dagboekcode = $bobj->joorsprong or $dagboekcode = $bobj->dagboekcode;
        
      if($bobj->bedrag<0) {
        $credit = $bobj->bedrag * -1;
        $creditsum += $credit;
      }
      else {
        $debet = $bobj->bedrag;
        $debetsum += $debet;
      }

      $Adata[] = array('sjabloon'=>'regular', 'data'=>array($bobj->periode,$datum,$dagboekcode,$bobj->journaalid,$bobj->boekregelid,$bobj->bomschrijving,bedrag($debet,'',false),bedrag($credit,'',false)));

      // Indien het aantal regels is max dan is de pagina vol en moet een nieuwe pagina worden begonnen incl kopregel
      //
      if(++$aantalregels > $pdf->maxlines) {
        // Nieuwe pagina wordt in de pdf class afgedwongen door een specifiek sjabloon
        $Adata[] = array('sjabloon'=>'pagebreak');
        $Adata[] = array('sjabloon'=>'header','data'=>array('p','datum','dagbk','journl','boekst','omschrijving','debet','credit',));
        $aantalregels = 0;
      }

    } // END FOREACH row

  } // END IS_ARRYA row


    // Subtotalen

    $Adata[] = array('sjabloon'=>'totalen', 'data'=>array("{$obj->nummer} - {$obj->naam}", "Totalen: ", bedrag($debetsum,'',false),bedrag($creditsum,'',false)));

    // periodesaldo

  $subsaldo = $creditsum - $debetsum;

  if($subsaldo<0) {
    $debetsaldo = '';
    $creditsaldo = $subsaldo * -1;
  }
  else {
    $creditsaldo = '';
    $debetsaldo = $subsaldo;
  }

// FORMATBEDRAG

// als bedrag dat wordt aangeleverd aan formatbedrag = '0.00' en null=false dan komt een lege string terug
// hetzelfde met null=true geeft '0,00'
// als bedrag dat wordt aangeleverd aan formatbedrag = '' en null=false dan komt '' terug
// hetzelfde met null=true geeft '0,00'

/* Ingeval we een periodesaldo willen opnemen:

      $form->blockLine('',
                       array(
                             "<div class='schemarow_std' style='font-weight:bold;' >{$obj->nummer} - {$obj->naam}<br/>Geconsolideerd jaarsaldo: </div>"
                            ,"<div class='schemarow_std' style='font-weight:bold;' ><br/>".formatbedrag($obj->saldo,$nul=true)."</div>"
                            ,"<div class='schemarow_std' style='font-weight:bold;' align='right'>Periodesaldo:</div>"
                            ,"<div class='schemarow_debet' style='font-weight:bold;' align='right'>".formatbedrag($debetsaldo,$nul=false)."</div>"
                            ,"<div class='schemarow_credit' style='font-weight:bold;' align='right'>".formatbedrag($creditsaldo,$nul=false)."</div>"
                            ), 
                       $veldarr_saldo
                       );

    // Separator line

      $form->blockLine('',
                       array("<div></div>"
                            ,"<div></div>"
                            ,"<div></div>"
                            ,"<div></div>"
                            ,"<div></div>"
                            ,"<div></div>"
                            ,"<div><img src='/img/clear.gif' width='90' height='1' /></div>"
                            ,"<div><img src='/img/clear.gif' width='90' height='1' /></div>"
                            ), 
                       $veldarr
                       );
*/

    // Start uitschrijven van de grootboekkaart
    //

  // Bereken eerst of deze kaart nog op de huidige pagina past anders een pagebreak geven.
  //
  // De totale hoogte van de tabelrijen plus kop
  $size = 14 + $pdf->sjabloon['header']->height + ($pdf->sjabloon['regular']->height * count($Adata));
  //
  // Als de totale hoogte niet meer past op de rest van de pagina, geef een nieuwe pagina
  if($size > ($pdf->Pagedimensions['hk'] - $pdf->GetY() - $pdf->Pagedimensions['bm'])) {
    //$rest = ($pdf->Pagedimensions['hk'] - $pdf->GetY() - $pdf->Pagedimensions['bm']);
    $pdf->AddPage();
    //printr($pdf->Pagedimensions['hk'], "pdf->Pagedimensions['hk']: ");
    //printr($pdf->Pagedimensions['bm'], "pdf->Pagedimensions['bm']: ");
    //printr($pdf->GetY(), 'gety: ');
    //printr($rest, 'rest: ');
    //printr($obj->nummer, 'nr: ');
    //printr('-------------------------');
  }
  //printr($size, "size: ");

    // We gebruiken nog even printKop om het nummer en naam van de
    // grootboekkaart te printen. TODO is het beter om dit als onderdeel van de
    // tabel met een eigen sjabloon te printen?
    // De hoogte van een printkop zonder lijn (zoals onderstaand) is 14
    $pdf->printKop("Grootboekkaart: {$obj->nummer} - {$obj->naam}", false);

    // Tabelheader
    //
    $pdf->cTable(array(array('sjabloon'=>'header','data'=>array('p','datum','dagbk','journl','boekst','omschrijving','debet','credit',))));

    $pdf->cTable($Adata);
    $pdf->cTable(array());

    // reset de tabel
    $Adata = array();
    $pdf->sjabloon['regular']->switchstatus = 0;

  } // END FOREACH arr grootboeknummer

} // END IF nummer


$item = "grootboekkaarten";

$bestandsnaam = $item.'-'.$pdf->boekjaar.'-'.preg_replace("/[-]/","",$GLOBALS['timer']->vandaag).'.pdf';
//Close and output PDF document
$pdf->Output($bestandsnaam, 'I');

die;
