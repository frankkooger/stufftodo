<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _debiteurenstam.inc 284 2014-08-11 18:48:04Z otto $
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

$render->body .= "\n          <!-- debiteurenstam.inc -->\n";
$render->subtitle[] = "debiteurenstam.inc";
$render->titel = "Debiteurenstamgegevens overzicht/invoeren/beheren";

//
// aktie 'delete' altijd als eerste testen
//
if($aktie == 'delete') {
  $id = $debiteur->deleteKaart($id);
}

//
// disabled keys
//
$disabled=array("code"=>"");

if($id) $disabled['code'] = "disabled='disabled'";

// Gegevens inlezen
//
$overzicht = $debiteur->selectFill($id, isset($lastinserted) ? $lastinserted : '');

$sobj = ($id) ? $debiteur->loadKaart($id) : $debiteur->loadDummy();

// START BUILDING BODYTEXT
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          'c_id'=>false
                         ,'c_naam'=>false
                         ,'c_codeview'=>false
                         ,'c_contact'=>false
                         ,'c_telefoon'=>false
                         ,'c_fax'=>false
                         ,'c_email'=>false
                         ,'c_adres'=>false
                         ,'c_datum'=>false
                         ,'c_code'=>false
                         ,'naam_old'=>$sobj->naam
                         ,'code_old'=>$sobj->code
                         ,'aktie'=>''
                         ,'subaktie'=>$p->subaktie
                         ) );

  $form->mainTableStart();

  //
  // Eerste fieldblock indien 'weergeven'
  // Indien 'ingeven' 'fullname' nog niet tonen
  //
    $form->fieldSetStart("Debiteurenrekeningen");
    
      $form->blockLine('',
                       array("<select name='overzicht' Id='overzichtId' onChange='doLoad(this);'>{$overzicht}</select>"), 
                       array("nowrap='nowrap', width='100%'") );


    $form->fieldSetBridge("Debiteurgegevens muteren",array('',RUBRIEK.'.debiteurenStamgegevens','Debiteuren Stamgegevens') );
      
    // messages

    $form->messagePrint();

      $form->blockLine('',
                       array("Naam:",
                             "<input type='text' name='naam' value=\"{$sobj->naam}\" size='40' onChange='c_naam.value=true;' /> &nbsp; 
                              code: <input type='text' name='codeview' value='{$sobj->code}' size='10' onChange='c_code.value=true;setType(this);' {$disabled['code']} />
                              <input type='hidden' name='code' value=\"{$sobj->code}\" />
                              <input type='hidden' name='id' value='{$id}' />"), 
                       array("nowrap='nowrap', width='100'","","width='70%'") );

      $form->blockLine('',
                       array("Contact:",
                             "<input type='text' name='contact' value=\"{$sobj->contact}\" size='40' onChange='c_contact.value=true;' />"),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

      $form->blockLine('',
                       array("Telefoon:",
                             "<input type='text' name='telefoon' value='{$sobj->telefoon}' size='15' onChange='c_telefoon.value=true;' /> &nbsp;
                              Fax: <input type='text' name='fax' value='{$sobj->fax}' size='15' onChange='c_fax.value=true;' />
                             "),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

      $form->blockLine('',
                       array("E-mail:",
                             "<input type='text' name='email' value='{$sobj->email}' size='40' onChange='c_email.value=true;' />"),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

      $form->blockLine('',
                       array("Adres:",
                             "<textarea name='adres' cols='40' rows='4' onChange='c_adres.value=true;' style='font-size:100%' />{$sobj->adres}</textarea>"),
                       array("nowrap='nowrap', width='100'","","width='70%'") );
// TODO koppelen van notitie tabel voor tekstveld
      $form->blockLinex('',
                       array("Opmerkingen:",
                             "<textarea name='tekst' cols='40' rows='1' onChange='c_tekst.value=true;' style='font-size:100%;color:red' />Veld is tijdelijk buiten gebruik</textarea>"),
                       array("nowrap='nowrap', width='100'","","width='70%'") );


  // BUTTONSTRAP
  //

    $form->fieldSetBridge();

      $buttons=<<<EOT

        <input type="submit" name="opslaan" value="opslaan" size="10" class='bsmall2' class='bsmall2' onClick="var x=document.forms['frm1'];x.aktie.value='save';sendForm('');return(false);"/>
        <input type="button" name="verwijder" value="verwijder" size="10" class='bsmall2' class='bsmall2' onClick="doDelete({$id})"/>
        <input type="reset" name="reset" value="reset" size="10" class='bsmall2' class='bsmall2' />
        <input type="button" name="clear" value="legen" size="10" class='bsmall2' class='bsmall2' onClick="doClear()"/>
        <input type="button" name="facturen" value="facturen" size="10" class='bsmall2' class='bsmall2' onClick="var x=document.forms['frm1'];if(x.subaktie.value!='facturen')x.subaktie.value='facturen';else x.subaktie.value='';x.submit();return(false);"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>
        <input type="button" name="transfer" value="transfer" size="10" class='bsmall2' class='bsmall2' onClick="settleOpener();"/>
EOT;

    $printfacturen = ($p->subaktie == 'facturen') ? true : false;

      $printerbutton=<<<EOT

        <img src='/img/printer1.gif' style="cursor:pointer;" onClick="debcredprint=window.open('/run.php?app=debiteurenstam&aktie=print&facturen={$printfacturen}','debcredprint',{$GLOBALS['WINDOW_OPTIONS']['SCHEMAS']});"/>
EOT;

      $form->blockLine('2',array($buttons,$printerbutton),
                           array("width='90%'","width='10%' align='right'") );

  // FACTUREN OVERZICHT
  //

  if($p->subaktie == 'facturen' && $id) {
    
    require("_facturenblok.inc");

  } // END IF facturen

    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();

// JAVASCRIPT
//

$render->iscript[] = "/js/validation.js";

$render->jscript .=<<<EOJ

function doLoad(a) {
  var x = document.forms['frm1'];
  var b = a.options[a.selectedIndex].value;
  if(b) {
    x.id.value = b;
    x.submit();
  }

}

function doDelete(a) {
  var x = document.forms['frm1'];
  if(a) {
    if(confirm("Weet je zeker dat je debiteur " + a + " wilt verwijderen?!")) {
      x.aktie.value = 'delete';
      x.id.value = a;
      x.submit();
    }
  }

}

function doClear() {
  var x = document.forms['frm1'];
    x.elements['id'].value='';
    x.elements['naam'].value='';
    x.elements['codeview'].value='';
    x.elements['code'].value='';
    x.elements['contact'].value='';
    x.elements['telefoon'].value='';
    x.elements['fax'].value='';
    x.elements['email'].value='';
    x.elements['adres'].value='';
    x.elements['naam'].focus();

    x.elements['codeview'].disabled=false;
}


function sendForm(optie){
  // Controleer of alle verplichte velden zijn ingevuld, 
  // anders focus op dat valed leggen en een alert geven dat het veld verplicht is.
  
  var verpl = " is een verplicht veld. Eerst invullen alvorens op 'opslaan' te klikken A.U.B";

  if(document.forms['frm1'].elements['naam'].value=="") {
    alert("Naam" + verpl);
    document.forms['frm1'].elements['naam'].focus();
    return(false);
  }else if(document.forms['frm1'].elements['codeview'].value=="") {
    alert("Code" + verpl);
    document.forms['frm1'].elements['codeview'].focus();
    return(false);
  }else {
    document.forms['frm1'].submit();
    return(true);
  }
  return(false);

}

function settleOpener() {
//  var xl = document.getElementById("overzichtId").selectedIndex;
//  var yl = document.getElementById("overzichtId").options;
  var xl = _("overzichtId").selectedIndex;
  var yl = _("overzichtId").options;
  // define there
  var s = opener.document.getElementById("viewrelatieidId");
  // add there
  var option = opener.document.createElement("option");
  option.text = yl[xl].text;
  option.value = yl[xl].value;
  s.add(option,null);
  // go there
  s.selectedIndex = s.length - 1;
  window.close();
}

EOJ;

// __EOT__ //
