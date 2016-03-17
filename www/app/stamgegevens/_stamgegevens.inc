<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _stamgegevens.inc 254 2013-07-29 21:28:15Z otto $
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

$render->body .= "\n          <!-- stamgegevens.inc -->\n";
$render->subtitle[] = "stamgegevens.inc";
$render->titel = "Stamgegevens overzicht/invoeren/beheren";

// Indien een wisseling van boekjaar heeft plaatsgevonden, activeer dat hier
// voor het inlezen van de gegevens verderop.
//
if($p->aktie == 'boekjaar') {
    $stam->jaarSelect($p->boekjaar);
}

// Gegevens inlezen
//
//$stam->query = "SELECT * FROM {$stam->stam} ORDER BY \"code\", \"subcode\" + 0";
$stam->query = "SELECT * FROM {$stam->stam} WHERE \"boekjaar\" <= {$stam->lopendjaar['value']} "
              ."ORDER BY \"code\", CAST(\"subcode\" AS SIGNED), \"boekjaar\" DESC";
$stam->Do_sql(basename(__FILE__).'::'.__LINE__);

$rec = array();
$disabled = array();
$blocked=false;
$lopendjaar='';

// Lees de stamgegevens in in een objectenarray
// Skip daarbij de records met dezelfde naam zodat de nieuwste naamrecords overblijven
//
$tmp = '';
while($obj = $stam->Do_object()) {
  if($obj->naam == $tmp) continue; $tmp = $obj->naam;

  // Zet het huidig jaar even apart omdat we dat nodig hebben bij het opzoeken van boekingen
  //
  $obj->naam == "lopendjaar" and $lopendjaar = $obj->value;

  // Vul een objectenarray met de stamgegevens
  //
  $rec[$obj->naam] = array('id'=>$obj->id
                          ,'code'=>$obj->code
                          ,'subcode'=>$obj->subcode
                          ,'dagboek'=>''
                          ,'label'=>$obj->label
                          ,'naam'=>$obj->naam
                          ,'value'=>$obj->value);

}

// Bepaal welke velden disabled moeten staan.
// Ga hiervoor na of het een rkg is en of er al boekingen zijn op deze rkg
//
foreach($rec AS $key=>$obj) {

  if(preg_match("/^rkg/", $key)) $blocked = ($stam->isBlocked($obj['value'],$lopendjaar)) ? true : false;

  $rec[$key]['blocked'] = $blocked;

  // Zet de disabled vlaggen
  //
  $disabled[$key] = ($blocked) ? DISABLED : '';
}
printrc2($rec, 'rec array: ');
// Vul het lopendjaar pulldown. Toon alle jaren waarvan boekingen in het
// systeem aanwezig zijn en het jaar volgend op het huidig jaar vermits dat
// niet het huidige kalenderjaar overschrijdt. Als het lopendjaar=2009 en het
// is nu 2009 dan wordt niet 2010 getoond, dus het huidig kalenderjaar is
// altijd bovengrens.
//
$yearselect = $stam->jaarSelectbox();

// eerstvolgende journaalpost. Als de journaalposten >= 1 zijn dan is er al
// geboekt en gaat disabled aan
//
$volgendejournaalpost = $stam->Get_field('MAX("journaalpost")',$stam->journaal,"\"boekjaar\"='{$lopendjaar}'");
$active_disabled = ($volgendejournaalpost  >= 1) ? DISABLED : "";
$altijd_disabled = DISABLED;
$volgendejournaalpost++;

// START BUILDING BODYTEXT
//

$form = new aForm($render->body);

// Vraag tabel met itemnamen
//
$c_lijst = $stam->namenLijst($clijst=true);
$c_lijst['aktie'] = '';

$fieldargs = array("nowrap='nowrap', width='180'","","width='70%'");

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                          $c_lijst
                          );
  
  // huidige periode lezen we af van de feitelijke situatie in het journaal met inachtneming van het lopend jaar
  //
  $rec['huidigeperiode'] = $stam->Get_field('MAX("periode")',$stam->journaal,"\"boekjaar\"={$rec['lopendjaar']['value']}");

  // check welke standaardgrootboekrekeningen zijn gekoppeld met dagboeken
  //
  $stam->query=<<<EOT
SELECT d."code", s."naam"
FROM {$stam->dagboeken} AS d
INNER JOIN {$stam->stam} AS s
ON (CAST(d."grootboekrekening" AS char(5)) = s."value")
WHERE s."code"='e' AND d."grootboekrekening" <> 0
ORDER BY s."code", CAST(s."subcode" AS SIGNED);
EOT;
printrc2($stam->query);

  $stam->Do_sql( basename(__FILE__).'::'.__LINE__);

  while($obj = $stam->Do_object())
    $rec[$obj->naam]['dagboek'] = $obj->code;

  // Start de output
  //
  $form->mainTableStart();

  /*
   * We zetten nu een aantal veldblokken neer, achtereenvolgens:
   * a. Administratiegegevens
   * c. Boekjaar en periodes
   * e. Standaard rekeningen
   * f. BTW rekeningen
   * g. BTW tarieven

   * De letters komen overeen met de 'code' in de stamgegevens records.
   * Binnen een groep worden de stamgegevens gesorteerd adhv 'subcode'
   * Als een stamgegeven een dagboekcode bevat wordt dat aan het stamgegeven gekoppeld

   * De eerst 2 en het laatste blok worden hard neergezet; hierin is weinig
   * verandering te verwachten. Het 'e' en 'f' blok wordt in een lus uitgeschreven,
   * rekening houdende met de subcode sortering.

   */

  // a. ADMINISTRATIEGEGEVENS
  //
    $form->fieldSetStart("Administratiegegevens");
    
      $form->blockLine('',
                       array("<div title='adminnaam'>{$rec['adminnaam']['label']}:</div>"
                            ,"<div class='help' onClick=\"Help('".RUBRIEK.".{$rec['adminnaam']['naam']}','{$rec['adminnaam']['label']}');\">&nbsp;</div>"
                            ,"<input type='text' name='adminnaam' value=\"{$rec['adminnaam']['value']}\" size='35' title='adminnaam' onChange='c_adminnaam.value=true;' {$disabled['adminnaam']} />"), 
                       $fieldargs );

      $form->blockLine('',
                       array("<div title='adminomschrijving'>{$rec['adminomschrijving']['label']}:</div>"
                            ,"<div class='help' onClick=\"Help('".RUBRIEK.".{$rec['adminomschrijving']['naam']}','{$rec['adminomschrijving']['label']}');\">&nbsp;</div>"
                            ,"<textarea name='adminomschrijving' rows='7' cols='40' style='font-size: 100%' title='adminomschrijving' onChange='c_adminomschrijving.value=true;'>{$rec['adminomschrijving']['value']}</textarea>"), 
                       $fieldargs );


  // Buttonstrap
  //
$buttons=<<<EOT

        <input type="submit" name="opslaan" value="opslaan" size="10" class='bsmall2' class='bsmall2' onClick="var x=document.forms['frm1'];x.aktie.value='save';sendForm('')"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>

EOT;

    $form->fieldSetBridge();

      $form->blockLine('2',array($buttons));

  // c. BOEKJAAR EN PERIODES
  //

    $form->fieldSetBridge("Boekjaar en periodes");
      
      $form->blockLine('',
                       array("<div title='lopendjaar'>{$rec['lopendjaar']['label']}:</div>"
                            ,"<div class='help' onClick=\"Help('".RUBRIEK.".{$rec['lopendjaar']['naam']}','{$rec['lopendjaar']['label']}');\">&nbsp;</div>"
                            ,"<select name='boekjaar' id='boekjaar' onChange='changeBoekjaar(this);' >$yearselect</select>"), 
                       $fieldargs );

      $form->blockLine('',
                       array("<div title='periodevan'>{$rec['periodevan']['label']}/tot/extra:</div>"
                            ,"<div class='help' onClick=\"Help('".RUBRIEK.".{$rec['periodevan']['naam']}','{$rec['periodevan']['label']}');\">&nbsp;</div>"
                            ,"<input type='text' name='periodevan' value='{$rec['periodevan']['value']}' size='3' title='periodevan' onChange='c_periodevan.value=true;' {$active_disabled} /> &nbsp;
                              <input type='text' name='periodetot' value='{$rec['periodetot']['value']}' size='3' title='periodetot' onChange='c_periodetot.value=true;' {$active_disabled} /> &nbsp;
                              <input type='text' name='periodeextra' value='{$rec['periodeextra']['value']}' size='3' title='periodeextra' onChange='c_periodeextra.value=true;' {$active_disabled} />"), 
                       $fieldargs );

      $form->blockLine('',
                       array("<div title='huidigeperiode'>Huidige periode:</div>"
                            ,"<div class='help' onClick=\"Help('".RUBRIEK.".huidigeperiode','Huidige periode');\">&nbsp;</div>"
                            ,"<input type='text' name='huidigeperiode' value='{$rec['huidigeperiode']}' size='5' {$altijd_disabled} />
                              &nbsp; volgende journaalpost: <input type='text' naam='volgendejournaalpost' value='{$volgendejournaalpost}' size='5' {$altijd_disabled} />"), 
                       $fieldargs );


  // e. STANDAARD REKENINGEN
  //

    $form->fieldSetBridge("Standaard rekeningen");

  foreach($rec AS $key=>$val) {

    // Make sure alleen de 'e' items in deze lus
    if($val['code'] != 'e') continue;

/*
printrc1($rec, "rec: ");

[rkg_kasboek] => Array
    (
        [id] => 20
        [code] => e
        [subcode] => 3
        [dagboek] => kas
        [label] => Rekening kasboek
        [naam] => rkg_kasboek
        [value] => 1000
        [blocked] => 1
    )
*/
    $dagboek = ($val['dagboek']) ? " &nbsp; [dagboek: {$val['dagboek']}] " : ''; 

      $form->blockLine('',
                       array("<div title='{$key}'>{$val['label']}:</div>"
                            ,"<div class='help' onClick=\"Help('".RUBRIEK.".{$key}','{$val['label']}');\">&nbsp;</div>"
                            ,"<input type='text' name='{$key}' value='{$val['value']}' size='5' title='{$key}' onChange='c_{$key}.value=true;' ".$disabled[$key]." />".$dagboek),
                       $fieldargs );

  } // END foreach


  // f. BTW REKENINGEN
  //
/*
    $form->fieldSetBridge("BTW rekeningen");

  foreach($rec AS $key=>$val) {

    // Make sure alleen de 'f' items in deze lus
    if($val['code'] != 'f') continue;

    $dagboek = ($val['dagboek']) ? " &nbsp; [dagboek: {$val['dagboek']}] " : ''; 

      $form->blockLine('',
                       array("<div title='{$key}'>{$val['label']}:</div>"
                            ,"<div class='help' onClick=\"Help('".RUBRIEK.".{$key}','{$val['label']}');\">&nbsp;</div>"
                            ,"<input type='text' name='{$key}' value='{$val['value']}' size='5' title='{$key}' onChange='c_{$key}.value=true;' ".$disabled[$key]." />".$dagboek),
                       $fieldargs );

  } // END foreach
*/

  // g. BTW TARIEVEN
  //

    $form->fieldSetBridge("BTW tarieven");

      $form->blockLine('',
                       array("<div title='btwhoog / btwlaag'>{$rec['btwverkoophoog']['label']}/laag:</div>"
                            ,"<div class='help' onClick=\"Help('".RUBRIEK.".{$rec['btwverkoophoog']['naam']}','{$rec['btwverkoophoog']['label']}');\">&nbsp;</div>"
                            ,"<input type='text' name='btwverkoophoog' value='{$rec['btwverkoophoog']['value']}' size='5' title='btwverkoophoog' onChange='c_btwverkoophoog.value=true;' {$disabled['btwverkoophoog']} />% &nbsp;
                              <input type='text' name='btwverkooplaag' value='{$rec['btwverkooplaag']['value']}' size='5' title='btwverkooplaag' onChange='c_btwverkooplaag.value=true;' {$disabled['btwverkooplaag']} />%"), 
                       $fieldargs );



  // Buttonstrap
  //

    $form->fieldSetBridge();

      $form->blockLine('2',array($buttons));


    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();

  // $render->iscript[] = "/js/validation.js";

  $render->jscript .=<<<EOJ

function sendForm(optie){
  // Controleer of alle verplichte velden zijn ingevuld, 
  // anders focus op dat valed leggen en een alert geven dat het veld verplicht is.
  
  var verpl = " is een verplicht veld. Eerst invullen alvorens op 'opslaan' te klikken A.U.B";

  if(document.forms['frm1'].elements['adminnaam'].value=="") {
    alert("Naam administratie" + verpl);
    document.forms['frm1'].elements['adminnaam'].focus();
    return(false);
  }else {
    document.forms['frm1'].submit();
    return(true);
  }
  return(false);

}

function changeBoekjaar(deze) {
  var x = window.document.forms['frm1'];
  x.aktie.value = 'boekjaar';
  x.submit();
}


EOJ;

/* __END__ */
