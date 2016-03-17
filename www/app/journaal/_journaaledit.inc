<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _journaaledit.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body .= "\n          <!-- journaaledit.inc -->\n";
$render->titel = "Journaalposten metadata beheren";
$render->subtitle[] = 'journaaledit.inc';
$render->schriftstijl = 'journaal';

// Housekeeping

$buttons = array('button_opslaan'=>0,'button_x'=>0,'button_reset'=>0,'button_nieuwejournaalpost'=>0,'button_nieuweboekregel'=>0,'button_sluiten'=>1,'button_editjournaalpost'=>0,'button_verwijder'=>0);
$disabled = array('periodes'=>'','dagboeken'=>'','jomschrijving'=>'','datum'=>'');
$disablethis = DISABLED;
$checked = array('datumpropageren'=>'');

$checked['datumpropageren'] = $p->datumpropageren ? "checked='checked'" : '';

function open_input() {
  global $buttons, $disabled;
  $disabled['jomschrijving'] = $disabled['datum'] = '';
  $buttons['button_opslaan'] = 1;
  $buttons['button_nieuweboekregel'] = 0; 
  $buttons['button_verwijder'] = 0; 
  $buttons['button_editjournaalpost'] = 0; 
}

open_input();

//
// ! Een post journaalobject wordt default geladen in de starter
//

switch($aktie) { // aktie(s) testen

  case 'save'      :
    $render->onload .= "document.forms['frm1'].sluiten.focus();";
    break;

} // END switch aktie

printrc1($post,"post: _journaaledit.inc\n");

// START BUILDING BODYTEXT

$render->iscript[] = "/js/validation.js";

$render->jscript .=<<<EOT

// verstuur het journaal formulier; laat er eerst de nodige controles op los
//
function sendForm(optie){
  var x = document.forms['frm1'];

  // Controleer of alle verplichte velden zijn ingevuld, 
  // anders focus op dat valed leggen en een alert geven dat het veld verplicht is.
  
  // if(x.periode[0].selected) {
  // dit hebben we niet meer nodig omdat met periode 0 alleen beginbalans zichtbaar is
  if(false) {
    alert("Je kunt niet opslaan zonder periode! Klik eerst een periode aan.");
    return(false);
  }

  var verpl = " is een verplicht veld. Eerst invullen alvorens op 'opslaan' te klikken A.U.B";

  if(document.forms['frm1'].elements['datum'].value=="") {
    alert("Datum" + verpl);
    document.forms['frm1'].elements['datum'].focus();
    return(false);
  }else if(document.forms['frm1'].elements['jomschrijving'].value=="") {
    alert("Omschrijving" + verpl);
    document.forms['frm1'].elements['jomschrijving'].focus();
    return(false);
  }else {
    var x=document.forms['frm1'];
    x.aktie.value='save';
    x.submit();
    return(true);
  }
  return(false);
}


function settle(a,b) {
  var x = window.opener.document.forms['frm1'];
  x.jomschrijving.value = a;
  x.datum.value = b;
  // window.opener.document.forms['frm1'].grootboekrekening.title = "pinbetalingen";
  // window.opener.document.forms['frm1'].factuurnummer.value = c;
  // window.opener.document.forms['frm1'].relatie.value = d;
  // window.opener.document.forms['frm1'].bomschrijving.value = 'Pinbetaling';
  // var bedrag=Math.round(parseFloat(e) * 100)/100;
  // if(bedrag > 0)
  //   window.opener.document.forms['frm1'].credit.value = bedrag;
  // else
  //   window.opener.document.forms['frm1'].debet.value = bedrag;

  // window.opener.document.forms['frm1'].grootboekrekening.focus();

  window.close();
}

EOT;

// Create buttons

  $button_opslaan=<<<EOT

        <input type="button" name="opslaanpost" value="opslaan" size="10" class='bsmall2' class='bsmall2' onClick="sendForm('');"/>
EOT;

  $ndatum = $GLOBALS['timer']->iso2norm($post->datum);
  $button_sluiten=<<<EOT

        <input type="button" name="sluiten" value="sluit scherm" size="10" class='bsmall2' class='bsmall2' onClick="settle('{$post->jomschrijving}','{$ndatum}')"/>
EOT;

// Welke buttons moeten we tonen?
//
  $printbuttons = $formbuttons = '';
  foreach($buttons AS $key=>$val) {
    if($val) {
      switch($key) {
        case 'button_opslaan' : 
        case 'button_sluiten' : 
        case 'button_nieuweboekregel' : $printbuttons .= $$key; break;
        case 'button_verwijder' : 
        case 'button_editjournaalpost' : $formbuttons .= $$key; break;
      }
    }
  }

//
// Start het formulier
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          'aktie'=>''
                         ,'journaalid'=>$post->journaalid
                         ,'m_periode'=>$post->periode
                         ) );

  $form->mainTableStart();

  // Eerste fieldblock
  // Keuzevelden: periode, dagboekcode, bestaande journaalposten

    $form->fieldSetStart("Gegevens journaalpost",array('','Journaal..gegevensWijzigenJournaalpost','Gegevens Journaalpost Wijzigen'));
    
    // messages

    $form->messagePrint();

  // Journaalnummer, periode, journaalpostsaldo
    
      $form->blockLine('',
                       array("Journaalpostnummer:",
                             "<input type='text' name='viewjournaalpost' value='{$post->journaalpost}' size='5' {$disablethis} /> &nbsp;
                              periode: <input type='text' name='viewperiode' value='{$post->periode}' size='2' /> &nbsp;
                              saldo journaalpost: <input type='text' name='viewsaldo' value='".formatbedrag($post->saldo,$null=true)."' size='10' onChange='setType(this);' {$disablethis} align='right' /> &nbsp;
                              <input type='hidden' name='journaalpost' value='{$post->journaalpost}' /> "), 
                       array("nowrap='nowrap', width='100'","","width='70%'") );
      

    //
    // Vanaf hier een voor het dagboektype specifieke tussenregel en logica
    //

// WEGGEHAALD voor de time being. Als we met complexe logica willen werken,
// zoals het aanpassen van Crediteur, saldi etc dan kunnen we logica uit
// _journaal.inc weer als voorbeeld terughalen.

    //
    // Vanaf hier de generieke velden van de journaalpost
    //

    // Datum

      $nu = $GLOBALS['timer']->vandaag;
      $form->blockLine('',
                       array("Datum:",
                             "<input type='text' name='datum' value='".$GLOBALS['timer']->iso2norm($post->datum)."' size='12' onChange='doCheckDatum(this,\"\",\"{$stam->lopendjaar['value']}\");' {$disabled['datum']} /> &nbsp; &nbsp;
                             Propageer datumchange: <input type='checkbox' name='datumpropageren' {$checked['datumpropageren']} />&nbsp;
                             <input type='hidden' name='m_datum' value='".$GLOBALS['timer']->iso2norm($post->datum)."' /> "
                             ),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

    // Omschrijving

      $form->blockLine('',
                       array("Omschrijving:",
                             "<input type='text' name='jomschrijving' value=\"{$post->jomschrijving}\" size='40' {$disabled['jomschrijving']} /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$formbuttons}"),
                       array("nowrap='nowrap', width='100'","","width='70%'") );


  // Buttonstrap

    $form->fieldSetBridge();

      $form->blockLine('2',array($printbuttons,''),
                           array("width='90%'","width='10%' align='right'") );

  // Boekregel edit

    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();
  
/* __END__ */
