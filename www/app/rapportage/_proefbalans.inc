<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _proefbalans.inc 289 2015-01-04 09:09:40Z otto $
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

$render->body .= "\n          <!-- proefbalans.inc -->\n";
$render->subtitle[] = "proefbalans.inc";
$render->titel = ($printen) ?  "Proefbalans printen" : "Proefbalans";

// zet eventjes hard
//
$saldilijst = true;

// HOUSEKEEPING
//

// array met veldattributen voor blockLine
//
$veldarr = array("width='10%'","width='30%'","width='15%'","width='15%'","width='15%',width='15%'");
$veldarr_saldo = array("colspan='2' width='40%'","width='15%'","width='15%'","width='15%',width='15%'");

$checked = array('nulsaldocheck'=>'','proefbalanscheck'=>'');

// END HOUSEKEEPING
//

// Gegevens inlezen
//
require_once('_eindejaar.lib');
$eindejaar = new Eindejaar();

// haal de grootboekrekeningen van grootboeksaldi, hierop staan alle rekeningen van een boekjaar, ook met 0-saldi.
//
$arr = $eindejaar->proefbalansObjecten();

// saldobalans en saldowinst zijn aan de objecten array toegevoegde strings;
// haal die eruit anders zitten ze dadelijk in de weg
//
$saldobalans = $arr['saldobalans'];
$saldowinst = $arr['saldowinst'];
unset($arr['saldobalans']);
unset($arr['saldowinst']);

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

    // over welke datum geldt deze saldilijst?
    // Hij kan iig niet verder dan de huidige datum als dit een saldilijst is
    // van het huidige boekjaar.
    // Maximaal kan hij niet verder dan 31-12-boekjaar
    // Het boekjaar ontlenen we aan stam->lopendjaar
    //

    $datum = "1-1-{$stam->boekjaar} - 31-12-{$stam->boekjaar}";
    
    $form->schemaHeader("Proefbalans over: {$datum}");
    
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

    $form->fieldSetStart("Proefbalans &nbsp; - &nbsp; boekjaar: {$stam->boekjaar}",
                         array('',RUBRIEK.'.Proefbalans','Proefbalans') );
    
  // nulcheck
  //

  ! empty($p->nulsaldocheck) and $checked['nulsaldocheck'] = "checked='checked'";
  // nulsaldocheck is altijd aan bij proefbalans en kan niet uitgezet worden
  $checked['nulsaldocheck'] = "checked='checked' disabled='disabled'";
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

      $form->blockLine('',
                       array("<div class='schemarow_std'>&nbsp;&nbsp;&nbsp;</div>"), 
                       array("colspan='2' nowrap='nowrap', width='100%'") );


  // Buttonstrap
  //

    $form->fieldSetBridge();

      $buttons=<<<EOT

        <input type="button" name="select" value="select" size="10" class='bsmall2' onClick="doLoad(this);"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' onClick="window.close();"/>
EOT;

      $printerbutton=<<<EOT

        <img src='/img/printer1.gif' style="cursor:pointer" onClick="var x=document.forms['frm1'];x.aktie.value='printproefbalans';x.submit();" />
EOT;

      $form->blockLine('2',array($buttons,'',$printerbutton),
                           array("width='40%'","width='40%'","width='10%' align='right'") );

} // END ELSE printen

    $form->fieldSetBridge("Balansrekeningen");
      
      printHeader($form,$totalen);

// begin met balansrekeningen
//

$rows = $count = 0;
$totaal_debet = $totaal_credit = $winstsaldo = $resultaatsaldo = 0;

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

    $saldo_debet = formatbedrag($obj->debet,$nul=false);
    $saldo_credit = formatbedrag($obj->credit * -1,$nul=false);

    $saldo = formatbedrag($obj->delta,$nul=false);
    
    $form->blockLine('',
                     array("<div class='schemarow_std'>{$obj->nummer}</div>"
                          ,"<div class='schemarow_std'>{$obj->naam}</div>"
                          ,"&nbsp;"
                          ,"<div class='schemarow_std' align='right'>{$saldo_debet}</div>"
                          ,"<div class='schemarow_std' align='right'>{$saldo_credit}</div>"
                          ,"<div class='schemarow_std' align='right'>{$saldo}</div>"
                           ), 
                     $veldarr
                     );

} // END WHILE balansrekeningen

    // Totalen
    //
    $form->blockLine('',
                     array("&nbsp;"
                          ,"&nbsp;"
                          ,"<div class='schemarow_enh' align='right'>Totalen:</div>"
                          ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($totaal_debet)."</div>"
                          ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($totaal_credit * -1,$nul=false)."</div>"
                          ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($resultaatsaldo,$nul=false)."</div>"
                           ), 
                     $veldarr
                     );


// ga verder met resultaatrekeningen
//

    $form->fieldSetBridge("Winst/Verliesrekeningen");
      
      printHeader($form,$totalen);

$target = RESULTAAT;
$saldo = $totaal_debet = $totaal_credit = $resultaatsaldo = 0;

foreach($arr AS $key=>$obj) {

  // scheid balans- en resultaatrekeningen
  //
  if($obj->type == BALANS) continue;

    // totalen debet en credit kolom
    //
    $totaal_debet  += $obj->debet;
    $totaal_credit += $obj->credit;
    $resultaatsaldo += $obj->delta;

    $saldo_debet = formatbedrag($obj->debet,$nul=false);
    $saldo_credit = formatbedrag($obj->credit * -1,$nul=false);

    $saldo = formatbedrag($obj->delta,$nul=false);
    
    $form->blockLine('',
                     array("<div class='schemarow_std'>{$obj->nummer}</div>"
                          ,"<div class='schemarow_std'>{$obj->naam}</div>"
                          ,"&nbsp;"
                          ,"<div class='schemarow_std' align='right'>{$saldo_debet}</div>"
                          ,"<div class='schemarow_std' align='right'>{$saldo_credit}</div>"
                          ,"<div class='schemarow_std' align='right'>{$saldo}</div>"
                           ), 
                     $veldarr
                     );
} // END WHILE resultaatrekeningen

    // Totalen
    //
    $form->blockLine('',
                     array("&nbsp;"
                          ,"&nbsp;"
                          ,"<div class='schemarow_enh' align='right'>Totalen:</div>"
                          ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($totaal_debet)."</div>"
                          ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($totaal_credit * -1,$nul=false)."</div>"
                          ,"<div class='schemarow_debetsum' align='right'>".formatbedrag($resultaatsaldo,$nul=false)."</div>"
                           ), 
                     $veldarr
                     );


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

EOJ;

/* ***************************************************************** */
// LOCAL FUNCTIONS
//

function printHeader(&$form,&$totalen) {
  global $veldarr;

    !empty($totalen) and $glabel = 'groepstotaal' or $glabel = '';
    
      $form->blockLine('4',
                       array(
                             "<div class='schemarow_head'>nummer</div>"
                            ,"<div class='schemarow_head'>omschrijving</div>"
                            ,"<div class='schemarow_head' align='right'>{$glabel}</div>"
                            ,"<div class='schemarow_head_debet' align='right'>debet</div>"
                            ,"<div class='schemarow_head_credit' align='right'>credit</div>"
                            ,"<div class='schemarow_head_credit' align='right'>saldo</div>"
                            ),
                       $veldarr
                       );

}

/* __END__ */
