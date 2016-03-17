<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _grootboekkaart.inc 270 2013-08-21 07:20:31Z otto $
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

$render->body .= "\n          <!-- grootboekkaart.inc -->\n";
$render->subtitle[] = 'grootboekkaart.inc';
$render->titel = ($printen) ? "Grootboekkaart printen" : "Grootboekkaart";

// positioneer de cursor
//
switch($p->subaktie) {

  case 'overzichtvan'  :
    $render->onload .= "document.forms['frm1'].overzichttot.focus();";
    break;

  case 'overzichttot'  :
    $render->onload .= "document.forms['frm1'].overzichttot.focus();";
    break;

}

// HOUSEKEEPING
//

//
// array met veldattributen voor blockLine
//
$veldarr = array("width='2%'"
                ,"width='12%'"
                ,"width='7%'"
                ,"width='7%'"
                ,"width='7%'"
                ,"width='40%'"
                ,"width='12%'"
                ,"width='12%'");

// $veldarr_saldo = array("colspan='3' width='21%'","colspan='2' width='14%'","width='40%'","width='12%'","width='12%'");

$checked = array('nulperiodecheck'=>'','totaalcheck'=>'','dense'=>'');

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
//printrc2($btwdefault, "btwdefault: ");

// periodecheck: het stukje AND sql maken
// Dit hebben we nodig in de selecties voor het samenstellen van 
// de grootboekrekening en eerder in de selectiecriteria van-tot
// Die laatse heeft een iets andere syntax en wordt dan ook in die
// lus uitgevoerd.
//
$tmp = $whereperiode = $situatie = '';
$first = true;
$arr = array();

for($i=0;$i<=$stam->periodeextra['value'];$i++) {
  if(in_array($i,$p->periode)) {
    if($first) { $whereperiode .= " AND \"periode\" IN ({$i}"; $first = false; }
    else         $whereperiode .= ",{$i}";
  }
}
$whereperiode and $whereperiode .= ")";

//
// END HOUSEKEEPING

// Gegevens inlezen
//
// Eerst 2 maal het totale overzicht van rekeningnummers als vulling voor de select boxen
//
$overzichtvan = $grootboek->grootboekselectFill($p->nummervan);
$overzichttot = $grootboek->grootboekselectFill($p->nummertot);

// Laad de nummervan-nummertot records. Bepaal of er 1 nummer is geselecteerd
// (in nummervan of nummertot) of dat beide nummers zijn geselecteerd. 
// - Als alleen nummervan is ingevuld, dan wordt alleen die rekening getoond
// (nummervan). Het maakt niet uit of die rekening buiten evt inclusief
// selecties valt, hij wordt getoond.
// - Als alleen nummertot is ingevuld, dan worden alle rekeningen tot en met die rekening getoond (10..nummertot)
// - Als beide nummers zijn ingevuld, dan wordt de verzameling tussen die nummers getoond (1200..3000)
// Op beide laatste gevallen zijn de inclusief selecties van toepassing (0-saldo etc.)
//
if($p->nummervan && ! $p->nummertot) { 
  // er is 1 nummer, hierop zijn geen Inclusier selecties van toepassing zodat een dergelijke rekening altijd toont
  $arr[] = $GLOBALS['stam']->Get_object("SELECT * FROM {$stam->grootboekstamsaldo} WHERE \"nummer\"={$p->nummervan}");
}

if(! $p->nummervan && $p->nummertot) { 
  // er is alleen nummertot, selecteer alle rekeningen vanaf het begin t.m. nummertot
  $p->nummervan = 1;
}

if($p->nummervan && $p->nummertot) { 
  // er is een nummerrange, hierop zijn alle zinnige 'Inclusief' selecties van toepassing

  // Selectie op basis van geactiveerde 'nulperiodecheck' en/of 'totaalcheck'

  switch ($p->nulperiodecheck) {
    case false : switch($p->totaalcheck) {
                   case false : $where = 'AND "saldo" IS NOT NULL AND "type"<>'.TOTAALKAART; break;
                   case true  : $where = 'AND ("saldo" IS NOT NULL OR "type"='.TOTAALKAART.')'; break;
                 }
                 break;

    case true  : switch($p->totaalcheck) {
                   case false : $where = 'AND "type"<>'.TOTAALKAART; break;
                   case true  : $where = ''; break;
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
//printrc2($query,'fout queyr: ');
/*
   Deze query toont alleen de nummers waarop een boeking heeft plaatsgevonden in genoemde periode
select DISTINCT g.nummer
from vw_grootboekstamsaldo g
inner join vw_boekregels b
on g.boekjaar=b.boekjaar
AND g.nummer=b.grootboekrekening
WHERE b.periode IN (3)
AND b.boekjaar={$stam->boekjaar}
ORDER BY g.nummer,b.boekjaar
*/
    // Do query en stop antwoord in een objectenarray
    //
    $GLOBALS['stam']->Do_query($query,'',basename(__FILE__)."::".__FUNCTION__."::".__LINE__);
    while($xobj = $GLOBALS['stam']->Do_object()) $arr[] = $xobj;

} // END IF nummervan nummertot

//printrc2($arr,'arr: ');
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

$where = " {$tmp} ". $whereperiode;

$kut =<<<EOT
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
// Hier kan de densed of de normale grootboekpresentatie worden gekozen.
// De densed versie vat boekingen uit hetzelfde journaalpost samen
// tot 1 regel, b.v. voor kasbladen

$typekaart = ($p->dense) ? '"vw_grootboekkaartExp"' : '"vw_grootboekkaart"';

$GLOBALS['stam']->query =<<<EOT
SELECT
  "journaalid"
  ,"journaalpost"
  ,"grootboekrekening"
  ,"periode"
  ,"boekdatum"
  ,"dagboekcode"
  ,"jomschrijving"
  ,"bedrag"
FROM
  {$typekaart}
WHERE 1=1
  {$where}
EOT;

//printrc2( $GLOBALS['stam']->query , "de query: ");

$GLOBALS['stam']->Do_sql( basename(__FILE__).'::'.__METHOD__.'::'.__LINE__);

while($obj = $GLOBALS['stam']->Do_object()) {
  $row[] = $obj;
}

/*
Array
(
    [0] => stdClass Object
        (
            [boekregelid] => 458
            [journaalid] => 1
            [grootboekrekening] => 100
            [periode] => 0
            [boekdatum] => 2008-01-01
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

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>""
                         ,"subaktie"=>""
                         ,"nummervan"=>$p->nummervan
                         ,"nummertot"=>$p->nummertot
                         ,"m_totaalcheck"=>$p->totaalcheck
                         ) );

  $form->mainTableStart();


if($printen) { // printlayout

    $form->schemaHeader("Grootboekkaarten");
    
    // Buttons
    
    $form->fieldSetBridge("");

      $buttons=<<<EOT

        <input type="button" name="printen" value="printen" size="10" class='bsmall2' class='bsmall2' onClick="print(document)"/>
        <input type="button" name="terug" value="terug" size="10" class='bsmall2' class='bsmall2' onClick="doLoad(this)"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>
EOT;

      $form->blockLine('2',array($buttons),
                           array("width='100%'") );

    $form->fieldSetBridge("Selectie");
    
} // END IF printen
else {

    $form->fieldSetStart("Grootboekkaarten: &nbsp; - &nbsp; Boekjaar: {$stam->boekjaar}",
                         array('',RUBRIEK.'..grootboekKaart','Overzicht Grootboekkaarten') );
 
}

  // SELECTIE REKENINGNUMMERS VAN - TOT
  //

if(! $printen) {

      $form->blockLine('1',
                       array("<div class='schemarow_std'>Kies 1 of meer grootboekrekeningen:</div>"
                            ,"<div class='schemarow_std'><a href='#' onClick='kiesAlles();' style='cursor:pointer;'>klik hier voor alle grootboekrekeningen</a></div>"
                            ), 
                       array("width='50%'","width='50%'") );

} // END IF NOT printen

      $form->blockLine('1',
                       array("<div class='schemarow_std'>Van: <select name='overzichtvan' onChange='doLoad(this);'>{$overzichtvan}</select> &nbsp;
                              Tot: <select name='overzichttot' onChange='doLoad(this);'>{$overzichttot}</select></div>"), 
                       array("colspan='2' nowrap='nowrap', width='100%'") );
      
  // nulcheck en totaalcheck

  ! empty($p->totaalcheck) and $checked['totaalcheck'] = "checked='checked'";
  ! empty($p->nulperiodecheck) and $checked['nulperiodecheck'] = "checked='checked'";
  ! empty($p->nulsaldocheck) and $checked['nulsaldocheck'] = "checked='checked'";
  ! empty($p->dense) and $checked['dense'] = "checked='checked'";

      $form->blockLine('',
                       array("<div class='schemarow_std'>Inclusief: &nbsp;&nbsp; 
                                <span style='cursor:pointer;' 
                                title='klik dit aan als je ook de totaalrekeningen in het overzicht wilt zien.'>totaalrekeningen:<input 
                                type='checkbox' name='totaalcheck' value='1' {$checked['totaalcheck']} /></span> &nbsp; &nbsp;

                                <span style='cursor:pointer;' 
                                title='Inclusief rekeningen die in de gewenste periode geen boekingen hebben.'>0-boekingen in periode(s):<input 
                                type='checkbox' name='nulperiodecheck' value='1' {$checked['nulperiodecheck']} /></span> &nbsp; &nbsp;

                                <span style='cursor:pointer;' 
                                title='Verzamel boekingsregels van 1 journaalpost.'>Verzamelregels uit:<input 
                                type='checkbox' name='dense' value='1' {$checked['dense']} /></span> &nbsp; &nbsp;

                              </div>
                              "), 
                       array("colspan='2' nowrap='nowrap', width='100%'") );

  // periodecheck vullen en gelijk het stukje AND sql maken
  // herstel: het stukje AND sql hebben we al eerder nodig.
  // Dit sql stukje verplaatsen we naar eerder in de procedure.

  $tmp = '';
  
  for($i=0;$i<=$stam->periodeextra['value'];$i++) {
    if(in_array($i,$p->periode)) {
      $tmp .= "{$i}:<input type='checkbox' name='periode[]' value='{$i}' checked='checked' /> &nbsp;\n"; 
    }
    else 
      $tmp .= "{$i}:<input type='checkbox' name='periode[]' value='{$i}' /> &nbsp;\n"; 
  }

      $form->blockLine('',
                       array("<div class='schemarow_std'>Periode(s) &nbsp; {$tmp} 
                              &nbsp;&nbsp;<a href='#' onClick=\"javascript:periodesWissel('uit');\">uit</a>
                              /<a href='#' onClick=\"javascript:periodesWissel('aan');\">aan</a></div>"), 
                       array("colspan='2' nowrap='nowrap', width='100%'") );


  // BUTTONSTRAP
  //

if($printen) { // printlayout


} // END IF printen
else {

    $form->fieldSetBridge();

      $buttons=<<<EOT

        <input type="button" name="select" value="select" size="10" class='bsmall2' class='bsmall2' onClick="doLoad(this);"/>
        <input type="button" name="leeg" value="leeg" size="10" class='bsmall2' class='bsmall2' onClick="doClear()"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close();"/>
EOT;

      $printerbutton=<<<EOT

        <img src='/img/printer1.gif' style="cursor:pointer;" onClick="var x=document.forms['frm1'];x.aktie.value='print';x.submit();" />
EOT;

      $printerbuttonori =<<<EOT

        <img src='/img/printer1.gif' style="cursor:pointer;" onClick="var x=document.forms['frm1']; win=window.open('grootboekkaart.phtml?aktie=print&nummervan=' + x.nummervan.value + '&nummertot=' + x.nummertot.value + '&totaalcheck=' + x.m_totaalcheck.value ,'',{$GLOBALS['WINDOW_OPTIONS']['GROOTBOEKKAARTPRINT']});"/>
EOT;

      $form->blockLine('2',array($buttons,"<b>Boekjaar: {$GLOBALS['stam']->lopendjaar['value']}</b>",$printerbutton),
                           array("width='40%'","width='40%'","width='10%' align='right'") );

} // END ELSE printen


if($p->nummervan || $p->nummertot) {

  // Hier start de lus van rekeningnummers
  //
  foreach($arr AS $obj) { 

    !isset($obj->saldo) && $obj->saldo='';
/*
printrc1($obj, "object rekeningnummer: ");
//                   die();
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

  // Start uitschrijven van de grootboekkaart

    $form->fieldSetBridge("Grootboekkaart: {$obj->nummer} - {$obj->naam}");
      
if(! $printen) { // printlayout

    // messages

    $form->messagePrint();

      $form->blockLine('',
                       array("<div class='schemarow_std_emp'>Type:</div>"
                            ,"<div class='schemarow_std'>{$types[$obj->type]}</div>"
                            ,"<div class='schemarow_std_emp'>BTWdefault:</div>"
                            ,"<div class='schemarow_std'>{$btwdefault[$obj->btwdefault]}</div>"
                              ), 
                       array("width='15%'","width='35%'","width='15%'","width='35%'") );

} // END IF NOT printen

  // SALDI OVERZICHT
  //

    # $form->fieldSetBridge();
    $form->blockTableEnd();
    $form->blockTableStart();

      $form->blockLine('4',
                       array("<div class='schemarow_head'>per.</div>"
                            ,"<div class='schemarow_head'>datum</div>"
                            ,"<div class='schemarow_head'>dagboek</div>"
                            ,"<div class='schemarow_head'>journaal</div>"
                            // ,"<div class='schemarow_head'>boekst.</div>"
                            ,"<div class='schemarow_head'> </div>"
                            ,"<div class='schemarow_head'>omschrijving</div>"
                            ,"<div class='schemarow_head_debet' align='right'>debet</div>"
                            ,"<div class='schemarow_head_credit' align='right'>credit</div>"
                            ), 
                       $veldarr
                       );

  $creditsum = 0.00;
  $debetsum = 0.00;

  // Start met het uitschrijven van de rijen boekingsregels van deze kaart
  // Doe dit alleen als er rijen (=boekingsregels) zijn
  //
  if(! empty($row)) {

    foreach($row AS $key=>$bobj) {

      if($obj->nummer != $bobj->grootboekrekening) { // break als er een volgend grootboeknummer verschijnt. Dit stop het verdere uitschrijven
                                                     // van regels en voorkomt dat steeds de hele array wordt doorlopen
        break; 
      }

      unset($row[$key]);

      $datum = $GLOBALS['timer']->iso2norm($bobj->boekdatum);
      $debet = $credit = '';
      
      // print relatie en/of (factuur/bon)nummer tussen haakjes achter de omschrijving
/*
      if($bobj->relatie && $bobj->nummer) $extra = " ({$bobj->relatie} - {$bobj->nummer})";
      else if($bobj->relatie) $extra = " ({$bobj->relatie})";
      else if($bobj->nummer) $extra = " ({$bobj->nummer})";
      else $extra = "";
      $bobj->bomschrijving .= $extra;
*/
      // als iets in joorsprong staat, print dat als dagboekcode.
      // dit gebeurt b.v. bij bank en kas waar de oorsprong de dagboekcode plus het bankafschriftnummer is
      // $bobj->joorsprong and $dagboekcode = $bobj->joorsprong or $dagboekcode = $bobj->dagboekcode;
      $dagboekcode = $bobj->dagboekcode;
        
      if($bobj->bedrag<0) {
        $credit = $bobj->bedrag * -1;
        $creditsum += $credit;
      }
      else {
        $debet = $bobj->bedrag;
        $debetsum += $debet;
      }

        $form->blockLine('',
                         array("<div class='schemarow_std'>{$bobj->periode}</div>"
                              ,"<div class='schemarow_std'>{$datum}</div>"
                              ,"<div class='schemarow_std'>{$dagboekcode}</div>"
                              ,"<div class='schemarow_std' align='middle' onClick='journaalLoad({$bobj->journaalid})' style='cursor:pointer;'>{$bobj->journaalid}</div>"
                            //  ,"<div class='schemarow_std' align='middle'>{$bobj->boekregelid}</div>"
                              ,"<div class='schemarow_std' align='middle'> </div>"
                            //  ,"<div class='schemarow_std'>{$bobj->bomschrijving}</div>"
                              ,"<div class='schemarow_std'>{$bobj->jomschrijving}</div>"
                              ,"<div class='schemarow_debet' align='right'>".formatbedrag($debet,$nul=false)."</div>"
                              ,"<div class='schemarow_credit' align='right'>".formatbedrag($credit,$nul=false)."</div>"
                              ), 
                         $veldarr
                         );

    } // END FOREACH row

  }

    // Subtotalen

      $form->blockLine('',
                       array("<div class='schemarow_std'>&nbsp;</div>"
                            ,"<div class='schemarow_std'>&nbsp;</div>"
                            ,"<div class='schemarow_std'>&nbsp;</div>"
                            ,"<div class='schemarow_std'>&nbsp;</div>"
                            ,"<div class='schemarow_std'>&nbsp;</div>"
                            ,"<div class='schemarow_std' align='right'>Totalen:</div>"
                            ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($debetsum,$nul=true)."</div>"
                            ,"<div class='schemarow_creditsum' align='right'>".formatbedrag($creditsum,$nul=true)."</div>"
                            ), 
                       $veldarr
                       );

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

  $veldarr_saldo = array("colspan='4' width='36%'","width='12%'","width='40%'","width='12%'","width='12%'");

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

  } // END FOREACH arr grootboeknummer

} // END IF nummer

    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();


// STYLESHEET
//

$render->extra_headers .=<<<EOT

<style type="text/css">

legend {
  font-weight:bold;
  padding-top: 10;
}

</style>

EOT;


// JAVASCRIPT
//

  $render->jscript .=<<<EOJ

function doLoad(deze) {
  var x = document.forms['frm1'];
  a = x.overzichtvan.options[x.overzichtvan.selectedIndex].value;
  b = x.overzichttot.options[x.overzichttot.selectedIndex].value;

  // nummertot mag niet kleiner zijn dan nummervan
  if(parseInt(b) < parseInt(a) && parseInt(b) > 0) {
    return(false);
  }
  else  {
    x.subaktie.value = deze.name;
    x.nummervan.value = a;
    x.nummertot.value = b;
    x.submit();
  }

}


function journaalLoad(deze) {
  // laad een journaalpost
  var x = document.forms['frm1'];
  journaalprint = window.open('/run.php?app=journaalpost&aktie=print&haschanged=directid&directid=' + deze,'journaalprint',{$GLOBALS['WINDOW_OPTIONS']['JOURNAALKAART']});

}


function kiesAlles() {
  // selecteer alle grootboekrekeningen in de van-tot selectvelden
  var x = document.forms['frm1'];
  var a = 'overzichtvan';
  var b = 'overzichttot';
  var c = x.elements[b].length;

  x.elements[a][1].selected = true;
  x.elements[b][c-1].selected = true;

}


function periodesWissel(a) {
  var x = document.forms['frm1'];
  var c = "periode[]";
  // onderstaand geeft alleen de formelementen-array met name check[]
  var y = x.elements[c].length;
  // denk erom: omdat de naam van het element 'check[]' is, met blokhaken dus
  // moeten we de naam eerst in een variabele zetten en deze variabele in blokhaken
  // teruggeven. Beide onderstaande voorbeelden werken hier niet:
  //    var y = x.elements.check[].length;
  //    var y = x.elements.c.length;

  // onderstaande lus gaat door formelementen met naam periode[]
  if(a == 'aan') {
    for(i=0; i<y; i++) {
      if(x[c][i].checked == false) {
        if(x[c][i].checked = true);
      }
    }
  }
  else {
    for(i=0; i<y; i++) {
      if(x[c][i].checked == true) {
        if(x[c][i].checked = false);
      }
    }
  }

}


function doClear() {
  var x = document.forms['frm1'];
  var a = 'overzichtvan';
  var b = 'overzichttot';

  periodesWissel('uit');

  x.elements['totaalcheck'].checked=false;
  x.elements['nulperiodecheck'].checked=false;

  x.elements[a][0].selected = true;
  x.elements[b][0].selected = true;

  x.elements[a].focus();
}


function pop_app(app,url) {
  var set = '';

  switch(app) {
    case 'journaal'   : 
      set = 'resizable,scrollbars,status,width=850,height=590,left=450,top=0'; break;
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

EOJ;

/* __END__ */
