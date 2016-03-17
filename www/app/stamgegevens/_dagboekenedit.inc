<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _dagboekenedit.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body      .= "\n          <!-- dagboekenedit.inc -->\n";
$render->titel      = "Dagboekenposten metadata beheren";
$render->subtitle[] = 'dagboekenedit.inc';

// Housekeeping

$disabled = array("dagboeknaam"=>"","dagboekcode"=>"","dagboektype"=>"","grootboekrekening"=>"","boeknummer"=>"","saldo"=>"","slot"=>"");

// Aktie 'save' als eerste aanpakken omdat het een resultaat geeft dat de rest
// van dit script beinvloedt.
//
if($aktie == 'save') {

  // Vul een leeg object met de waarden vanuit het form
  //
  $obj = new Dagboek();

  // Laad de objectvars met gegevens uit het form
  //
  $obj->voorbereiden($p);

  if($id) { // update
    $obj->update($id);
  }
  else { // insert
    // Test of de ingegeven code (die uniek moet zijn) al niet in gebruik is
    // Doe dit alleen bij een insert dus als er geen $id wordt meegegeven. Dat is n.l. een update.
    //
    if($obj->checkCode()) {
      $msg['red'][] = "Dagboekcode bestaat al! Gebruik een ander";
      $render->onload .= "document.forms['frm1'].view_dagboekcode.focus();";
      $aktie = 'opnieuw';
    }
    else
      $id = $obj->insert() and $aktie = ''; // zorg dat verderop weer een vers object geladen wordt
  }

} // END IF aktie == 'save'

// Laad de dagboekpost
// Niet als we door 'save' zijn gegaan omdat de dagboekpost daar geladen wordt
// afhankelijk van omstandigheden. Daardoor kan hier niet nog een keer geladen
// worden.
if($aktie != 'save' && $aktie != 'opnieuw') 
  $obj = ($id) ? new Dagboek($id) : new Dagboek();

function disable_all(&$disabled) {
  $disabled['dagboeknaam'] = DISABLED;
  $disabled['dagboekcode'] = DISABLED;
  $disabled['dagboektype'] = DISABLED;
  $disabled['grootboekrekening'] = DISABLED;
  $disabled['boeknummer'] = DISABLED;
  $disabled['saldo'] = DISABLED;
  $disabled['slot'] = DISABLED;
}

function disable_xlock(&$disabled) {
  //$disabled['dagboeknaam'] = DISABLED;
  $disabled['dagboekcode'] = DISABLED;
  $disabled['dagboektype'] = DISABLED;
  //$disabled['grootboekrekening'] = DISABLED;
  //$disabled['boeknummer'] = DISABLED;
  $disabled['saldo'] = DISABLED;
}

function disable_code(&$disabled) {
  $disabled['dagboekcode'] = DISABLED;
}

// dagboekcode is vrijwel altijd disabled behalve igv. nieuw en opnieuw
if($aktie != 'nieuw' && $aktie != 'opnieuw') disable_code($disabled);

// Als een bestaand dagboek wordt opgevraagd waarop al geboekt is, alleen slot beschikbaar maken
if($obj->occupied) disable_xlock($disabled);
  
# printrc2($obj, "Dagboekobject pal voor bodytext: \n");

/*
Dagboek Object
(
    [id] => 19
    [historie] => 2008
    [active] => 1
    [naam] => asdfasfd
    [type] => memo
    [code] => asdf
    [grootboekrekening] => 4210
    [boeknummer] => 
    [saldo] => -5000.00
    [slot] => 
    [occupied] => 
)
*/

switch($aktie) { // verschillende akties testen

  case 'dagboekload' :
    $render->onload .= "document.forms['frm1'].overzicht.focus();";
    break;

  case 'save'      :
    $render->onload .= "document.forms['frm1'].sluiten.focus();";
    break;

  case 'delete'   :
    $obj->delete();
    $id = '';
    disable_all($disabled);
    break;

} // END switch aktie


// START BUILDING BODYTEXT

  $render->jscript .=<<<EOT

// verstuur het dagboek formulier; laat er eerst de nodige controles op los
//
function sendForm(optie){
  var x = document.forms['frm1'];
  var index = 0;

  // Controleer of alle verplichte velden zijn ingevuld, 
  // anders focus op dat veld leggen en een alert geven dat het veld verplicht is.
  
  if(x.view_dagboektype.options[0].selected) {
    alert("Je kunt niet opslaan zonder dagboektype! Kies eerst een dagboektype.");
    return(false);
  }

  // Er moet verplicht een grootboeknummer zijn gekozen ingeval de meeste dagboeken
  //
  if(x.elements['grootboekrekening'].value=="") {
    index = x.view_dagboektype.selectedIndex;
    var dagboektype = x.view_dagboektype[index].value; 
    if(dagboektype != 'begin' && dagboektype != 'memo') {
      alert("Er moet een grootboekrekening zijn ingevuld bij dit dagboektype: " + dagboektype); 
      return(false); 
    }
  }

  var verpl = " is een verplicht veld. Eerst invullen alvorens op 'opslaan' te klikken A.U.B";

  if(x.elements['view_dagboeknaam'].value=="") {
    alert("Dagboeknaam" + verpl);
    x.elements['view_dagboeknaam'].focus();
    return(false);
  }else if(x.elements['view_dagboekcode'].value=="") {
    alert("Dagboekcode" + verpl);
    x.elements['view_dagboekcode'].focus();
    return(false);
  }else {
    x.aktie.value='save';
    x.submit();
    window.opener.location.reload();
    return(true);
  }
  return(false);
}

function sendNieuw() {
  var x = document.forms['frm1'];

  x.aktie.value='nieuw';
  x.dagboekid.value = '';
  x.submit();
  return(true);
}

function doDelete(a) {
  var x = document.forms['frm1'];

  if(confirm('Weet je zeker dat je dit dagboek wilt verwijderen?!')) {
    x.aktie.value='delete';
    x.submit();
    window.opener.location.reload();
    return(true);
  }
  else {
    return(false);
  }
}


// De functie grbSelectie in journaal.js geeft een waarde terug in: 
//    window.opener.document.forms['frm1'].grootboekrekening.value = a;

EOT;

// Create buttons

  $button_opslaan=<<<EOT

        <input type="button" name="opslaanpost" value="opslaan" size="10" class='bsmall2' onClick="sendForm('');"/>
EOT;
  $button_verwijder=<<<EOT

        <input type="button" name="wissen" value="wissen" size="10" class='bsmall2' onClick="doDelete('{$id}')"/>
EOT;
  $button_verwijderdim=<<<EOT

        <input type="button" name="wissen" value="wissen" size="10" class='bsmall2' disabled='disabled' title='Kan dit dagboek niet verwijderen! Er zijn boekingen op gepleegd.' "/>
EOT;
  $button_reset=<<<EOT

        <input type="reset" name="reset" value="reset" size="10" class='bsmall2' />
EOT;
  $button_nieuwdagboek=<<<EOT

        <input type="button" name="nieuw" value="nieuw" size="10" class='bsmall2' onClick="sendNieuw()"/>
EOT;

  $button_terug=<<<EOT

        <input type="button" name="terug" value="terug" size="10" class='bsmall2' onClick="window.history.back()"/>
EOT;

$button_sluiten=<<<EOT

      <input type="button" name="sluiten" value="sluit scherm" size="10" class='bsmall2' onClick="window.close()"/>
EOT;

$buttonarray = array('1'=>"{$button_opslaan} &nbsp;{$button_nieuwdagboek} &nbsp;{$button_verwijder}"
                    ,'2'=>"{$button_opslaan} &nbsp;{$button_nieuwdagboek} &nbsp;{$button_verwijderdim}"
                    ,'3'=>"{$button_opslaan} &nbsp;{$button_terug}"
                    ,'4'=>"{$button_opslaan}"
                    ,'5'=>"{$button_nieuwdagboek}"
                    );
// Welke buttons tonen we
//
if($id) { // indien een geladen id: opslaan, nieuw maken, wissen indien nog geen boekingen erop
if($obj->occupied) { // er zijn boekingen, wissen is gedimd
  $buttonindex = 2;
}
else { // er zijn geen boekingen
  $buttonindex = 1;
}
}
elseif($aktie == 'edit' && $id == '') { // button terug niet als nieuw wordt gevraagd direct vanuit het dagboekenscherm
  $buttonindex = 4;
}
else { // er is geen geladen id, dus er wordt een nieuw ingevuld: opslaan en evt. terug
  // is er echter sprake van een delete, dan is er ook geen is maar is de enige keuze 'nieuw'
  $buttonindex = ($aktie == 'delete') ? 5 : 3;
}

$select_dagboektype = "<option value=''>---------</option>\n";

foreach($GLOBALS['config']->data['aux']['typearray'] AS $val) {
  $select_dagboektype .= ($val == $obj->type) ? 
    "<option selected='selected' value='{$val}'>{$val}</option>\n" :
    "<option value='{$val}'>{$val}</option>\n";
}

//
// Start het formulier
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders worden de nieuwe niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "dagboekid"=>$id
                         ,"historie"=>"$obj->historie"
                         ,"active"=>"$obj->active"
                         ,"aktie"=>""
                         ,"dagboeknaam"=>"$obj->naam"
                         ,"dagboekcode"=>"$obj->code"
                         ,"dagboektype"=>"$obj->type"
                         ,"m_grootboekrekening"=>"$obj->grootboekrekening"
                         ,"boeknummer"=>"$obj->boeknummer"
                         ,"saldo"=>"$obj->saldo"
                         ,"lock"=>"$obj->slot"
                         ) );

  $form->mainTableStart();

  // Eerste fieldblock
  // Keuzevelden: periode, dagboekcode, bestaande dagboeken

    $form->fieldSetStart("Gegevens dagboek");
    
    // messages

    $form->messagePrint();

      $tdarray = array("nowrap='nowrap', width='100'","");

      $form->blockLine('',
                       array("Dagboeknaam:",
                       "<input type='text' name='view_dagboeknaam' value='{$obj->naam}' size='20' {$disabled['dagboeknaam']} />"), 
                       $tdarray );
      
      $form->blockLine('',
                       array("Dagboekcode:",
                       "<input type='text' name='view_dagboekcode' value='{$obj->code}' size='12' {$disabled['dagboekcode']} />"
                      ." &nbsp; <span style='margin-right:20px;'>historie: {$obj->historie}</span>"), 
                       $tdarray );
      
      $form->blockLine('',
                       array("Dagboektype:",
                       "<select {$disabled['dagboektype']} name='view_dagboektype'>$select_dagboektype</select>"), 
                       $tdarray );

      $render->iscript[] = '/app/journaal/journaal.js';

      $form->blockLine('',
                       array("Grootboekrekening:",
                       "<input type='text' name='grootboekrekening' value='{$obj->grootboekrekening}' size='6' {$disabled['grootboekrekening']} /> 
                         &nbsp; <a href='#' onClick='grbSelectie(true);'><img src='/img/b_search.png' border='0' title='opzoeken grootboekrekeningen' /></a>
                       "), 
                       $tdarray );
      
      $form->blockLine('',
                       array("Boeknummer:",
                       "<input type='text' name='view_boeknummer' value='{$obj->boeknummer}' size='6' {$disabled['boeknummer']} />"), 
                       $tdarray );
      
      $form->blockLine('',
                       array("Saldo:",
                       "<input type='text' name='view_saldo' value='{$obj->saldo}' size='10' {$disabled['saldo']} />"), 
                       $tdarray );
      
      $form->blockLine('',
                       array("Lock:",
                       "<input type='text' name='view_lock' value='{$obj->slot}' size='6' {$disabled['slot']} />"), 
                       $tdarray );
      
  // Buttonstrap

    $form->fieldSetBridge();

      $form->blockLine('2',array("{$buttonarray[$buttonindex]} &nbsp{$button_sluiten}"),
                           array("nowrap='nowrap', width='100%'") );

  // Boekregel edit

    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();
  
/* __END__ */
