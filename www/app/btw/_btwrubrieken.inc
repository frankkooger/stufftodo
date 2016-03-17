<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _btwrubrieken.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body .= "\n          <!-- btwrubrieken.inc -->\n";
$render->subtitle[] = "btwrubrieken.inc";
$render->titel = "BTWrubrieken overzicht/invoeren/beheren";

// Indien een wisseling van boekjaar heeft plaatsgevonden, activeer dat hier
// voor het inlezen van de gegevens verderop.
//
if($p->aktie == 'boekjaar') {
    $stam->jaarSelect($p->boekjaar);
}

// Gegevens inlezen
//
//$stam->query = "SELECT * FROM {$stam->stam} ORDER BY \"code\", \"subcode\" + 0";
$stam->query = "SELECT * FROM {$stam->btwrubrieken}"; 

$stam->Do_sql(basename(__FILE__).'::'.__LINE__);

$rec = array();
$c_lijst = array();

// Lees de btwrubrieken in in een objectenarray
// Skip daarbij de records met dezelfde naam zodat de nieuwste naamrecords overblijven
//
$tmp = '';
while($obj = $stam->Do_object()) {
  if($obj->key == $tmp) continue; $tmp = $obj->key;

  // Vul een objectenarray met de btwrubrieken
  //
  $rec[$obj->key] =  array(
                           'key'=>$obj->key
                          ,'type'=>$obj->type
                          ,'actief'=>$obj->actief
                          ,'ccode'=>$obj->ccode
                          ,'acode'=>$obj->acode
                          ,'label'=>$obj->label
                          ,'labelstam'=>$obj->labelstam
                          ,'labeldefaults'=>$obj->labeldefaults
                          ,'boekjaar'=>$obj->boekjaar);
  $c_lijst["c_{$obj->key}"] ='';
}
$c_lijst['aktie'] = '';

//printrc1($rec, 'rec: ');


// START BUILDING BODYTEXT
//

$form = new aForm($render->body);

// Vraag tabel met itemnamen
//

$fieldargs = array("width='30'","width='30'","width='30'","nowrap='nowrap', width='50%'","width='40%'");

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                          $c_lijst
                          );
$tmp = '';

    $form->fieldSetStart("BTW Rubrieken");

foreach($rec AS $key=>$arr) {

  if($tmp != substr($arr['ccode'],0,1)) {
    $form->fieldSetBridge();
    $form->linecolor=1;
  }
    
  // calculate
  $arr['label'] = ($arr['acode'] != '') ? $arr['label'] : '';
  $checked = ($arr['actief']) ? "checked='checked'" : '';

      $form->blockLine('',
                       array(
                             "<div class='help' onClick=\"Help('".RUBRIEK.".{$key}','{$arr['labelstam']}');\">&nbsp;</div>"
                            ,"<input type='checkbox' name='{$key}' {$checked} title='{$arr['labelstam']}' onChange='c_{$key}.value=true;' />"
                            ,"<div title=''>{$arr['acode']}</div>"
                            ,"<div title=''>{$arr['label']}</div>"
                            ,"<div title=''>{$arr['labelstam']}</div>"
                            ), 
                       $fieldargs );

  $tmp = substr($arr['ccode'],0,1);

} // END FOREACH rec


  // Buttonstrap
  //
$buttons=<<<EOT

        <input type="submit" name="opslaan" value="opslaan" size="10" class='bsmall2' class='bsmall2' onClick="var x=document.forms['frm1'];x.aktie.value='save';sendForm('')"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>

EOT;

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
