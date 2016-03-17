<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _grootboekstam.inc 287 2014-12-13 18:02:02Z frank $
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

$render->body      .= "\n          <!-- grootboekstam.inc -->\n";
$render->subtitle[] = "grootboekstam.inc";
$render->titel      = "Grootboekstamgegevens overzicht/invoeren/beheren";

//
// aktie 'delete' altijd als eerste testen
//
if($aktie == 'delete') {
  if(($tmp = $grootboek->deleteKaart($p)) == '')
    $msg['red'][] = "Rekeningnummer: {$tmp} {$p->naam} is verwijderd!";
}

//
// positioneer de cursor
//
switch($p->subaktie) {

  case 'overzicht'  :
    $render->onload .= "document.forms['frm1'].overzicht.focus();";
    $p->nummer = $p->overzicht;
    break;

  case 'overzichttot'  :
    $render->onload .= "document.forms['frm1'].overzichttot.focus();";
    break;

}

// als 'p->nummer' niet is gezet (dus 0), dan is wss het inputveld 'nummer' disabled.
// gebruik in dat geval 'm_nummer' als p->nummer
//
if(!$p->nummer) {
  if(! empty($p->m_nummer)) $p->nummer = $p->m_nummer;
}

// Gegevens inlezen
//
// Eerst het totale overzicht
// Maak daarvan vulling voor de select box
//
$overzicht = $grootboek->grootboekselectFill($p->nummer);

$selected['type'] = array( BALANS =>""
                          ,RESULTAAT =>""
                          ,TOTAALKAART =>"");

$disabled = array("nummer"=>"","saldo"=>"","nivo"=>"");
$titleNummer = '';
$boekNummer = '';
$lock = true;

// Is er een nummer meegegeven of bekend?
// Laad dan het nummer-record
//
if(!empty($p->nummer)) {

  // Als hier een obj wordt geleverd is die als geheugenobj afkomstig van _grootboekstam_save.inc
  // Laad dan geen nieuwe gegevens
  //
  if(!isset($obj)) {
    if(!$obj = $stam->Get_object("SELECT * FROM {$stam->grootboekstamsaldo} WHERE \"nummer\"={$p->nummer} ", __FILE__."::".__FUNCTION__."::".__LINE__)) {
      // laad een dummy object om php Notices te voorkomen
      $obj = new Dummy();
      $obj->naam = '';
      $obj->nivo = '';
      $obj->historie = '';
      $obj->nummer = '';
      $obj->kostenplaats = '';
      $obj->type = '';
      $obj->btwkey = '';
      $obj->btwdefault = '';
      $obj->saldo = '';
    }
  }

  /*
  printrc2($obj, "vw_grootboekstamsaldo: ");
stdClass Object
(
    [id] => 20
    [historie] => 2008
    [nummer] => 2110
    [kostenplaats] =>
    [active] => 1
    [populariteit] => 1
    [type] => 1
    [nivo] => 0
    [verdichting] => 0
    [naam] => Af te dragen BTW hoog tarief
    [btwkey] => rkg_btwverkoophoog
    [btwdefault] => 
    [saldo] => -484.50
    [boekjaar] => 2010
)
  */

  $naam = $obj->naam;
  $selected['type'][$obj->type] = "checked='checked'";

  // rekeningnummers met al een saldo (er zijn dus boekingen op) kunnen alleen van nummer wijzigen via een speciale procedure.
  // als de rekeningnummers worden gebruikt als standaard rekeningnummers in de stamgegevens van deze
  // administratie dan geldt dat ook. We moeten dan ook een lock marker bij deze rekeningen zetten.
  // Kijk beide gevallen na:
  //
  $lock = true;
  // Indien er een saldo voor deze rekening bestaat is 'ie gebruikt geweest,
  // ook al is het saldo 0. Hij kan dan niet verwijderd worden.
  if(! $stam->boekjaarBlocked) {
    if(empty($obj->saldo)) { 
      $lock = false;
    }
    else {
      //$disabled['nummer'] = DISABLED;
      $titleNummer = " title='Deze rekening heeft boekingen. Als je het nummer wijzigt dan wordt het tevens in alle relevante tabellen gewijzigd!' ";
    }
  }
  // saldo is alleen ter informatie. Kan nooit gewijzigd worden.
  //
  $disabled['saldo'] = DISABLED;

  // laad een evt gekoppeld rekeningnummer uit stamgegevens
  //
  $dobj = $stam->Get_object("SELECT * FROM {$stam->stam} WHERE \"naam\" LIKE 'rkg_%' AND \"value\"='{$p->nummer}'", __FILE__."::".__FUNCTION__."::".__LINE__);
  // we moeten nu onder de teruggekregen "naam" kijken of die niet later als nieuwere entry voorkomt b.v.:
  // 20  2008  e   3   Rekening kasboek  rkg_kasboek   1000   
  // 30  2011  e   3   Rekening kasboek  rkg_kasboek   1060   
  // In bovenstaand geval is rgknummer 1000 dus feitelijk niet meer gekoppeld maar bij de
  // eerste zoekopdracht wordt ie wel gevonden onder rkg_kasboek
  //
  // TODO een betere oplossing vinden voor dit historie vraagstuk, wellicht iets als in grootboekstam
  //
  if($dobj) { 
    $tmp = $stam->Get_field('"id"',$stam->stam,"\"naam\"='{$dobj->naam}' ORDER BY \"boekjaar\" desc ", __FILE__."::".__FUNCTION__."::".__LINE__);
    if($dobj->id == $tmp) { 
      // $disabled['nummer'] = DISABLED;
      $titleNummer = " title='Deze rekening heeft een standaard koppeling met: {$dobj->label}!' ";
      $boekNummer = " &nbsp;&nbsp;&nbsp; Koppeling: <span class='veldsub_nomargin'>{$dobj->label}</span>";
      $lock = true;
    }
  }

  if($obj->type != TOTAALKAART) {
    $disabled['nivo'] = DISABLED;
  }

} // END IF p->nummer
else {
  //
  // op dit punt is geen object geladen. Laad een dummy object
  // om Notifys te voorkomen in de printsectie
  //
  $obj = new Dummy();
  $obj->naam = '';
  $obj->nivo = '';
  $obj->historie = '';
  $obj->nummer = '';
  $obj->kostenplaats = '';
  $obj->btwkey = '';
  $obj->btwdefault = '';
  $obj->saldo = '';
}

// START BUILDING BODYTEXT
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>""
                         ,"subaktie"=>""
                         ,"historie"=>$obj->historie
                         ,"c_nummer"=>false
                         ,"c_kostenplaats"=>false
                         ,"c_naam"=>false
                         ,"c_type"=>false
                         ,"c_nivo"=>false
                         ,"c_btwkey"=>false
                         ,"c_btwdefault"=>false
                         ,"lock"=>$lock
                         ) );

  $form->mainTableStart();

    $form->fieldSetStart("Grootboekrekeningen ".$stam->lopendjaar['value']);
    
      $form->blockLine('',
                       array("<select name='overzicht' id='idoverzicht' onChange='doLoad(this);'>{$overzicht}</select>"), 
                       array("nowrap='nowrap', width='100%'") );


    $form->fieldSetBridge("Rekening muteren",array('','Grootboek..stamgegevensMuteren','Grootboek Stamgegevens'));
      
    // messages

    $form->messagePrint();

      $form->blockLine('',
                       array("Nummer:"
                            ,"<div id='div1' {$titleNummer}><input type='text' name='nummer' value='{$obj->nummer}' size='5' onChange='c_nummer.value=true;setType(this);' {$disabled['nummer']} /> &nbsp;&nbsp;&nbsp;\n"
                            ."Saldo: <input type='text' name='viewsaldo' value='".formatbedrag($obj->saldo)."' size='12' {$disabled['saldo']} />\n"
                            ."<span id='span2'>{$boekNummer}</span></div>\n"
                            ."<input type='hidden' name='m_nummer' value='{$obj->nummer}' />"
                            ), 
                       array("nowrap='nowrap', width='100'","","width='70%'") );

      $form->blockLine('',
                       array("Naam:",
                             "<input type='text' name='naam' value=\"{$obj->naam}\" size='40' onChange='c_naam.value=true;' />"
                             ."<span style='margin-right:20px;'> </span>Historie: ".$obj->historie
                             ),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

      $form->blockLine('',
                       array("Type:",
                             "Balans:<input type='radio' name='type' value='".BALANS."' {$selected['type'][1]} onChange='c_type.value=true;nivo.disabled=true;' /> &nbsp;
                              Resultaten:<input type='radio' name='type' value='".RESULTAAT."' {$selected['type'][2]} onChange='c_type.value=true;nivo.disabled=true;' /> &nbsp;
                              Totaalkaart:<input type='radio' name='type' value='".TOTAALKAART."' {$selected['type'][3]} onChange='c_type.value=true;nivo.disabled=false;' /> &nbsp; &nbsp;
                              Niveau: <input type='text' name='nivo' value='{$obj->nivo}' size='1' onChange='c_nivo.value=true;' {$disabled['nivo']} />
                             "),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

/*
Dit gaat een lijst worden van elementen uit btwkeys met naam rkg_btw..
*/
      $form->blockLine('',
                       array("BTWdefault:",
                             "{$grootboek->btwDefaultRadio($obj->btwdefault)}"),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

      $koppeling = '';

      $form->blockLine('',
                       array("BTWkoppeling:",
                             "<select name='btwkey' onChange='c_btwkey.value=true;'>{$grootboek->koppelingPullDown($obj->nummer)}</select>"), 
                       array("nowrap='nowrap' style='padding:10px 2px', width='100'","","width='70%'") );

      $form->blockLine('',
                       array("Kostenplaats:",
                             "<select name='kostenplaats' onChange='c_kostenplaats.value=true;'>{$grootboek->kostenplaatsPullDown($obj->nummer)}</select>"), 
                       array("nowrap='nowrap' style='padding:10px 2px', width='100'","","width='70%'") );


  // BUTTONSTRAP
  //

    $form->fieldSetBridge();

    // Er zijn twee sets buttons:
    //  - voor een afgesloten boekjaar; geen veranderingen meer in de stamtabel toegestaan
    //  - voor het lopende boekjaar; veranderingen in de stamtabel toegestaan

    if($stam->boekjaarSemiBlocked) {

      $buttons=<<<EOT

        <input type="reset" name="reset" value="reset" size="10" class='bsmall2' class='bsmall2' />
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>
EOT;

    }
    else {

      $buttons=<<<EOT

        <input type="submit" name="opslaan" value="opslaan" size="10" class='bsmall2' class='bsmall2' onClick="var x=document.forms['frm1'];x.aktie.value='save';sendForm('');return(false);"/>
        <input type="button" name="verwijder" value="verwijder" size="10" class='bsmall2' class='bsmall2' onClick="doDelete({$obj->nummer})"/>
        <input type="reset" name="reset" value="reset" size="10" class='bsmall2' class='bsmall2' />
        <input type="button" name="clearX" value="legen" size="10" class='bsmall2' class='bsmall2' onClick="doClearX();"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close();"/>
EOT;
    }

      $printerbutton=<<<EOT

        <img src='/img/printer1.gif' style="cursor:pointer;" title='Grootboekoverzicht zonder saldi' onClick="win=window.open('/run.php?app=grootboekstam&aktie=print&saldoweergave=0','',{$GLOBALS['WINDOW_OPTIONS']['SCHEMAS']});"/>

EOT;

      $printerbuttonx=<<<EOT

        <img src='/img/printer1-saldi.gif' style="cursor:pointer;" title='Grootboekoverzicht met saldi' onClick="win=window.open('/run.php?app=grootboekstam&aktie=print&saldoweergave=1','',{$GLOBALS['WINDOW_OPTIONS']['SCHEMAS']});"/>

EOT;

      $form->blockLine('2',array($buttons,$printerbutton),
                           array("width='70%'","width='30%' align='right'") );

  // BOEKREGELS
  //

    $form->fieldSetBridge("");

      $form->blockLine('',
                       array(""), 
                       array("nowrap='nowrap', width='100%'") );



    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();

// JAVASCRIPT
//

// $render->iscript[] = "/js/validation.js";

$render->jscript .=<<<EOJ

function doLoad(deze) {
  var x = document.forms['frm1'];
  var b = deze.options[deze.selectedIndex].value;
  if(b) {
    x.subaktie.value = deze.name;
    x.nummer.value = b;
    x.submit();
  }
}

function doDelete(a) {
  var x = document.forms['frm1'];
  // Als er saldo is, of een koppeling met een dagboek dan is het
  // rekeningnummer in gebruik en kan niet verwijderd worden.
  if(x.lock.value) {
    alert('Het rekeningnummer is in gebruik en kan niet verwijderd worden!');
    return(false);
  }
  else if(a) {
    if(confirm("Weet je zeker dat je rekeningnummer " + a + " wilt verwijderen?!")) {
      x.aktie.value = 'delete';
      x.nummer.value = a;
      x.submit();
    }
  }
}

function doClear() {
  var x = document.forms['frm1'];
  var y;
    document.getElementById('span2').innerHtml = '';
    x.elements['nummer'].value='';
    x.elements['nummer'].disabled=false;
    x.elements['kostenplaats'].value='';
    x.elements['viewsaldo'].value='';
    x.elements['naam'].value='';
    x.elements['nivo'].value='';
    x.elements['nivo'].disabled=true;
    x.elements['btwkey'].selectedIndex = 0;
    for(i=0;i < x.elements.length; i++) {
      y = x.elements[i];
      //alert(y.name + ' ' + y.type + ' ' + y.value);
      if(y.type == 'radio') x.elements[i].checked = false;
      if(y.type == 'hidden') { 
        if(y.name.match("^c_")) x.elements[i].value = false;
        else if(y.name == 'actie') x.elements[i].value = false;
        else if(y.name == 'subactie') x.elements[i].value = false;
        else if(y.name == 'historie') x.elements[i].value = false;
        else if(y.name == 'lock') x.elements[i].value = false;
        else if(y.name == 'm_nummer') x.elements[i].value = false;
      }
    }
    x.btwdefault[x.btwdefault.length - 1].checked = true;
    x.elements['nummer'].focus();
}


function doClearX() {
  var x = document.forms['frm1'];
//  alert("wat is er toch aan de hand");
//  var i=document.getElementById("idoverzicht").selectedIndex;
//  var y=document.getElementById("idoverzicht").options;
//  alert("Index: " + y[i].index + " is " + y[i].text);
  x.aktie.value = '';
  x.subaktie.value = '';
  document.getElementById('idoverzicht').SelectedIndex=0;
  x.elements['nummer'].value='';
  x.elements['m_nummer'].value='';
  x.submit();
}


function setType(a) {
// zet type op 'resultaten' indien het ingevulde 
// rekeningnummer hoger is dan {$stam->omslag['value']}
  var x = document.forms['frm1'];
  re = new RegExp("[9]{2}$");

  if(re.test(a.value)) { // totaalkaarten eindigen met 99
    x.elements['type'][2].checked=true;
    x.elements['nivo'].disabled=false;
  }
  else if(a.value >= {$stam->omslag['value']}) {
    x.elements['type'][1].checked=true;
    x.elements['nivo'].disabled=true;
  }
  else {
    x.elements['type'][0].checked=true;
    x.elements['nivo'].disabled=true;
  }
}

function sendForm(optie){
  // Controleer of alle verplichte velden zijn ingevuld, 
  // anders focus op dat valed leggen en een alert geven dat het veld verplicht is.
  
  var verpl = " is een verplicht veld. Eerst invullen alvorens op 'opslaan' te klikken A.U.B";

  if(document.forms['frm1'].elements['nummer'].value=="") {
    alert("Rekeningnummer" + verpl);
    document.forms['frm1'].elements['nummer'].focus();
    return(false);
  }else if(document.forms['frm1'].elements['naam'].value=="") {
    alert("Rekeningnaam" + verpl);
    document.forms['frm1'].elements['naam'].focus();
    return(false);
  }else {
    document.forms['frm1'].submit();
    return(true);
  }
  return(false);
}

EOJ;

/* __END__ */
