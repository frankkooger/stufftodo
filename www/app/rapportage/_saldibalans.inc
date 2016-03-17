<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _saldibalans.inc 269 2013-08-20 23:06:42Z otto $
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

$render->body .= "\n          <!-- saldibalans.inc -->\n";
$render->subtitle[] = "saldibalans.inc";
$render->titel = ($printen) ?  "Saldibalans printen" : "Saldibalans";

// zet eventjes hard
//
$saldilijst = true;

// HOUSEKEEPING
//

// array met veldattributen voor blockLine
//
$veldarr = array("width='10%'","width='45%'","width='15%'","width='15%'","width='15%'");
$veldarr_saldo_totaalkaart = array("colspan='2' width='55%'","width='15%'","width='15%'","width='15%'");
$veldarr_saldo = array("colspan='3' width='70%'","width='15%'","width='15%'");

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

// bereken de saldi van de gewenste nivos totaalrekeningen als die getoond moeten worden
//
$totalen = ($p->nivo > -1) ? totalenSaldi($p->nivo) : array();

//
// END HOUSEKEEPING

// START BUILDING BODYTEXT
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          'ser'=>$ser
                         ,'aktie'=>''
                         ,'subaktie'=>''
                         ) );

  $form->mainTableStart();

//
// printlayout
//
if($printen) { 

    // Deze saldilijst bestrijkt het volledige huidigjaar
    //
    $datum = "1-1-{$stam->lopendjaar['value']} - 31-12-{$stam->lopendjaar['value']}";
    
    $form->schemaHeader("Saldibalans over: {$datum}");
    
    // Buttons
    
    $form->fieldSetBridge('');

      $buttons=<<<EOT

        <input type="button" name="printen" value="printen" size="10" class='bsmall2' onClick="print(document)"/>
        <input type="button" name="terug" value="terug" size="10" class='bsmall2' onClick="doLoad(this)"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' onClick="window.close()"/>
EOT;

      $form->blockLine('2',array($buttons),
                           array("width='100%'") );

    
} // END IF printen
//
// niet printen, toon de selectieboxen
//
else { 

    $form->fieldSetStart("Saldibalans &nbsp; - &nbsp; boekjaar: {$stam->boekjaar}",
                         array('',RUBRIEK.'.Saldibalans','Saldibalans') );
    
  // nulcheck
  //
  ! empty($p->nulsaldocheck) and $checked['nulsaldocheck'] = "checked='checked'";
  ! empty($p->proefbalanscheck) and $checked['proefbalanscheck'] = "checked='checked'";

      $form->blockLine('',
                       array("<div class='schemarow_std'>Inclusief: &nbsp;&nbsp; 
                                <span style='cursor:pointer' 
                                title='Inclusief rekeningen die gedurende het boekjaar (nog) geen saldo hebben.'>0-jaarsaldo:<input 
                                type='checkbox' name='nulsaldocheck' onClick='doLoad(this);' value='1' {$checked['nulsaldocheck']} /></span>
                              </div>"
                             ,"<div class='schemarow_std'>Proefbalans: &nbsp;&nbsp; 
                                <span style='cursor:pointer' title='Maak de proefbalans'>
                                <input type='checkbox' name='proefbalanscheck' onClick='doLoad(this);' value='1' {$checked['proefbalanscheck']} /></span>
                              </div>"
                              ), 
                       array("colspan='1' style='white-space:nowrap' width='50%'","colspan='1' style='white-space:nowrap' width='50%'") );

  // nivocheck
  // De nivos zijn de nivos van de totaalrekeningen
  // nivo 8 laat alleen totaalrekening 8 zien (least verbose)
  // nivo 1 alle totaalrekeningen van 8 t.m. 1
  // nivo 0 alle totaalrekeningen plus gewone rekeningen (most verbose)
  // nivo -1 alleen gewone rekeningen
  // nivocheckline radiobuttons vullen
  //

  $tmp = '';
  
  foreach($checked['nivocheck'] AS $i=>$val) {
    if($i == $p->nivo) {
      $tmp .= "{$i}:<input type='radio' name='nivo' value='{$i}' onClick='doLoad(this);' checked='checked' /> &nbsp;\n"; 
    }
    else 
      $tmp .= "{$i}:<input type='radio' name='nivo' value='{$i}' onClick='doLoad(this);' /> &nbsp;\n"; 
  }

      $form->blockLine('',
                       array("<div class='schemarow_std'>Verdichtingsnivo: &nbsp; {$tmp} 
                              &nbsp;&nbsp;</div>"), 
                       array("colspan='2' nowrap='nowrap', width='100%'") );


  // Buttonstrap
  //

    $form->fieldSetBridge();

      $buttons=<<<EOT

        <input type="button" name="select" value="select" size="10" class='bsmall2' onClick="doLoad(this);"/>
        <input type="button" name="leeg" value="leeg" size="10" class='bsmall2' onClick="doClear()"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' onClick="window.close();"/>
EOT;

      $printerbutton=<<<EOT

        <img src='/img/printer1.gif' style="cursor:pointer" onClick="var x=document.forms['frm1'];x.aktie.value='printsaldibalans';x.submit();" />
EOT;

      $form->blockLine('2',array($buttons,'',$printerbutton),
                           array("width='40%'","width='40%'","width='10%' align='right'") );

} // END ELSE printen

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
/*
Als we dit scherm binnenkomen willen we een saldibalans zien van alle rekeningen, zonder totaalrekeningen (nivo==-1)
waarop een saldo staat. Dus niet de rekeningen waarvan het saldo 0 is maar waarop wel iets is geboekt geweest tijdens
het boekjaar; dit is voor de proefbalans.

Als we nulsaldocheck aanklikken dan willen we alle rekeningen zien die in het grootboekschema zitten, saldo of niet

Als we een nivo aanklikken dan willen we uiteraard totaalrekeningen tussen de gewone rekeningen (nivo 0) of alleen 
totaalrekeningen zien (nivo > 0)

 Alle rekeningen waarop geboekt is, dus ook die met een 0-saldo: (voor de proefbalans)
   SELECT DISTINCT grootboekrekening FROM boekregels
 Alle rekeningen waarop saldo staat:
   SELECT FROM vw_grootboekstamsaldo WHERE saldo <> 0

*/

$stam->Do_sql( basename(__FILE__).'::'.__LINE__);

$arr  =array();
while($obj = $stam->Do_object()) $arr[] = $obj;

// begin met balansrekeningen
//

    $form->fieldSetBridge("Balansrekeningen");
      
      printHeader($form,$totalen);

$rows = $count = 0;
$totaal_debet = $totaal_credit = $singlesaldo = $winstsaldo = $resultaatsaldo = 0;

foreach($arr AS $obj) {
 
  // scheid balans- en resultaatrekeningen
  //
  if($obj->type == RESULTAAT) continue;
  //
  // Skip totaalkaarten groter dan $stam->omslag (is meestal 4000)
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
      $totalensaldo = formatbedrag($totalen[$obj->nummer]);
    else
      $winstsaldo += $obj->saldo;
  }
  else $singlesaldo = $totalensaldo = '';
   
  if($obj->type == TOTAALKAART) {
      $form->blockLine('',
                       array("<div class='schemarow_enh_darkblue'>+++ {$obj->naam} &nbsp; niveau:{$obj->nivo} &nbsp; ({$obj->nummer})</div>"
                            ,"<div class='schemarow_enh_darkblue' align='right'>{$totalensaldo}</div>"
                            ,"&nbsp;"
                            ,"&nbsp;"
                             ), 
                       $veldarr_saldo_totaalkaart
                       );
  }
  else {
      $form->blockLine('',
                       array("<div class='schemarow_std'>{$obj->nummer}</div>"
                            ,"<div class='schemarow_std' title='Klik om de grootboekkaart op te vragen.'
                               style='cursor:pointer;color:black;text-decoration:none'  
                               onClick=\"pop_app('grootboek','{$config->data['url']['base_url']}/run.php?app=grootboek&amp;nummervan={$obj->nummer}')\">{$obj->naam}</a></div>"
                            ,"&nbsp;"
                            ,"<div class='schemarow_std' align='right'>{$saldo_debet}</div>"
                            ,"<div class='schemarow_std' align='right'>{$saldo_credit}</div>"
                             ), 
                       $veldarr
                       );
  }

} // END WHILE balansrekeningen

// print bij een saldilijst de salditotalen, bij een venw lijst niet
// en ook bij verdichtingen niet. De salditotalen worden alleen maar
// gesaldeerd van standaard grootboekrekeningen niet van totaalrekeningen
//
if($saldilijst and ($totaal_debet or $totaal_credit)) { 

      $form->blockLine('',
                       array("&nbsp;"
                            ,"&nbsp;"
                            ,"<div class='schemarow_enh' align='right'>Totalen:</div>"
                            ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($totaal_debet)."</div>"
                            ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($totaal_credit)."</div>"
                             ), 
                       $veldarr
                       );

}

// print een extra saldoregel
//
if($winstsaldo) { 

  // plaats de saldoregel in de juiste kolom
  //
  $debetline = $creditline = '';
  if($winstsaldo < 0)
    $debetline = "<div class='schemarow_debetsum' align='right'>".formatbedrag($winstsaldo * -1)."</div>";
  else
    $creditline = "<div class='schemarow_debetsum' align='right'>".formatbedrag($winstsaldo)."</div>";
    
      $form->blockLine('',
                       array("<div class='schemarow_enh' align='right'>Saldo balans: </div>"
                            ,$debetline
                            ,$creditline
                             ), 
                       $veldarr_saldo
                       );

} // END IF winstsaldo

// ga verder met resultaatrekeningen
//

    $form->fieldSetBridge("Resultaatrekeningen");
      
      printHeader($form,$totalen);

$totaal_debet = $totaal_credit = $singlesaldo = 0;

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
      $totalensaldo = formatbedrag($totalen[$obj->nummer]);
    else
      $resultaatsaldo += $obj->saldo;
  }
  else $singlesaldo = $totalensaldo = '';
   
  if($obj->type == TOTAALKAART) {
      $form->blockLine('',
                       array("<div class='schemarow_enh_darkblue'>+++ {$obj->naam} &nbsp; niveau:{$obj->nivo} &nbsp; ({$obj->nummer})</div>"
                            ,"<div class='schemarow_enh_darkblue' align='right'>{$totalensaldo}</div>"
                            ,"&nbsp;"
                            ,"&nbsp;"
                             ), 
                       $veldarr_saldo_totaalkaart
                       );
  }
  else {
      $form->blockLine('',
                       array("<div class='schemarow_std'>{$obj->nummer}</div>"
                            ,"<div class='schemarow_std' title='Klik om de grootboekkaart op te vragen.'
                               style='cursor:pointer;color:black;text-decoration:none'  
                               onClick=\"pop_app('grootboek','{$config->data['url']['base_url']}/run.php?app=grootboek&amp;nummervan={$obj->nummer}')\">{$obj->naam}</a></div>"
                            ,"&nbsp;"
                            ,"<div class='schemarow_std' align='right'>{$saldo_debet}</div>"
                            ,"<div class='schemarow_std' align='right'>{$saldo_credit}</div>"
                             ), 
                       $veldarr
                       );

  }
 
} // END WHILE resultaatrekeningen

// print bij een saldilijst de salditotalen, bij een venw lijst niet
// en ook bij verdichtingen niet. De salditotalen worden alleen maar
// gesaldeerd van standaard grootboekrekeningen niet van totaalrekeningen
//
if($saldilijst and ($totaal_debet or $totaal_credit)) { 

      $form->blockLine('',
                       array("&nbsp;"
                            ,"&nbsp;"
                            ,"<div class='schemarow_enh' align='right'>Totalen:</div>"
                            ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($totaal_debet)."</div>"
                            ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($totaal_credit)."</div>"
                             ), 
                       $veldarr
                       );

}

// print een extra saldoregel
//
if($resultaatsaldo) { 

  // plaats de saldoregel in de juiste kolom
  //
  if($resultaatsaldo < 0) {
    $debetline = "<div class='schemarow_debetsum' align='right'>".formatbedrag($resultaatsaldo * -1)."</div>";
    $label = "Saldo winst: ";
    $creditline = '';
  }
  else {
    $creditline = "<div class='schemarow_debetsum' align='right'>".formatbedrag($resultaatsaldo)."</div>";
    $label = "Saldo verlies: ";
    $debetline = '';
  }
    
      $form->blockLine('',
                       array("<div class='schemarow_enh' align='right'>{$label}</div>"
                            ,$debetline
                            ,$creditline
                             ), 
                       $veldarr_saldo
                       );

} // END IF resultatensaldo

if(!$printen) {

    // Buttons
    //
    
    $form->fieldSetBridge("");

      $buttons=<<<EOT

        <input type="button" name="printen" value="printen" size="10" class='bsmall2' onClick="print(document)"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' onClick="window.close()"/>
EOT;

      $form->blockLine('2',array($buttons),
                           array("width='100%'") );

} // END IF NOT printen

    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();

// STYLE
//
$render->extra_styles .=<<<EOT

legend {
  font-weight:bold;
  padding-top: 10;
}

EOT;

// JAVASCRIPT
//
  $render->jscript .=<<<EOJ

function doLoad(deze) {
  var x = document.forms['frm1'];

  x.subaktie.value = deze.name;
  x.submit();

}

function doClear() {
  var x = document.forms['frm1'];

  // periodesWissel('uit');

  // x.elements['totaalcheck'].checked=false;
  x.elements['nulsaldocheck'].checked=false;
  x.elements['nivo'][0].checked = true;

  x.submit();
}

EOJ;

/* ***************************************************************** */
// LOCAL FUNCTIONS
//

function totalenSaldi($nivo=0) {
  global $stam, $grootboek;
 
  // maak een array met totaalkaartnummers en nivos
  // en lees die in een objecten array
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
    // bepaal van deze rekening het saldo van de rekeningen tot aan een voorganger op hetzelfde nivo
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
printrc2($totalen, "totalen: ");
  return($totalen);

} // END FUNCTION totalenSaldi


function printHeader(&$form,&$totalen) {
  global $veldarr;

    $glabel = !empty($totalen) ? 'groepstotaal' : '';
    
      $form->blockLine('4',
                       array(
                             "<div class='schemarow_head'>nummer</div>"
                            ,"<div class='schemarow_head'>omschrijving</div>"
                            ,"<div class='schemarow_head' align='right'>{$glabel}</div>"
                            ,"<div class='schemarow_head_debet' align='right'>debet</div>"
                            ,"<div class='schemarow_head_credit' align='right'>credit</div>"
                            ),
                       $veldarr
                       );

}

$render->jscript .=<<<EOJ

function pop_app(app,url) {
  var set = '';

  switch(app) {
    case 'grootboek'   : 
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
