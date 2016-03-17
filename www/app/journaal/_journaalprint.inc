<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _journaalprint.inc 268 2013-08-19 20:57:41Z otto $
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

$render->body .= "\n          <!-- journaalprint.inc -->\n";
$render->subtitle[] = 'journaalprint.inc';
$render->titel = "Journaalposten bekijken/printen";

//
// _journaalprint.inc toont journaalposten en wordt geactiveerd vanuit:  'index.php::Overzicht journaal'

// HOUSEKEEPING
$file = basename(__FILE__);

// array met veldattributen voor blockLine
$veldarr       = array("width='3%'","width='10%'","width='7%'","width='7%'","width='7%'","width='42%'","width='12%'","width='12%'");
$veldarr_saldo = array("width='3%'","colspan='2' width='17%'","colspan='2' width='14%'","width='42%'","width='12%'","width='12%'");

$checked = array('nulperiodecheck'=>'','nulsaldocheck'=>'','totaalcheck'=>'','saldonietnulcheck'=>'');

// In een aantal gevallen beinvloedt het invullen van een optie enkele andere opties
//
// saldonietnul, dagboek en periodes beinvloeden elkaar. We moeten daarom een
// hulpvar benoemen die bijhoudt welke van de drie is gechanged
switch($p->haschanged) {
  case 'directid'     : 
  case 'directpost'   : 
                        $p->saldonietnul = '';
                        $post->dagboekcode = '';
                        unset($p->periodearr);
                        break;
  case 'saldonietnul' : $p->dagboekcode = $post->dagboekcode = '';
                        $p->periodearr = '';
                        break;
  case 'dagboekload'  : 
  case 'select'       :                      
                        $p->saldonietnul = '';
                        break;
}

$checked['saldonietnulcheck'] = ($p->saldonietnul) ? 'checked=\'checked\'' : '';

// welke periodes hebben we, wat is de hoogste periode, we beginnen altijd bij 0, dat staat vast

for($i=0;$i<=$stam->periodeextra['value'];$i++) $checked['periodecheck'][$i] = "";

if(! isset($p->periodearr) || empty($p->periodearr)) $p->periodearr = array();

$types = array(BALANS=>'Balans',RESULTAAT=>'Resultaat',TOTAALKAART=>'Totaalkaart');

// periodecheck: het stukje AND sql maken
// Dit hebben we nodig in de selecties voor het samenstellen van 
// de grootboekrekening en eerder in de selectiecriteria van-tot
// Die laatse heeft een iets andere syntax en wordt dan ook in die
// lus uitgevoerd.

$tmp = $whereperiode = '';
$first = true;

for($i=0;$i<=$stam->periodeextra['value'];$i++) {
  if(in_array($i,$p->periodearr)) {
    if($first) { $whereperiode .= " AND j.\"periode\" IN ($i"; $first = false; }
    else       $whereperiode .= ",$i";
  }
}
$whereperiode and $whereperiode .= ")";

// END HOUSEKEEPING

// Een post journaalobject is hier al default geladen in de starter

switch($p->subaktie) { // verschillende subakties testen

  case 'dagboekload'      :
    $render->onload .= "document.forms['frm1'].dagboekcode.focus();";
    break;

  case 'periodeload'      :
    $render->onload .= "document.forms['frm1'].periodearr.focus();";     
    break;

}

//
// Gegevens inlezen
//

// Vul de dagboeken pulldown
//
$dagboeken = $post->dagboekenPullDown();

$disabled['dagboeken'] = (! empty($post->boekregel)) ? "disabled='disabled'" : '';

//
// START BUILDING BODYTEXT
//

  $render->iscript[] = "/js/validation.js";

  $render->jscript .=<<<EOJ

function doLoad(deze) {
  var x = document.forms['frm1'];
  x.haschanged.value = deze.name;
  x.submit();
}


function dagboekLoad(a) {
  var x = document.forms['frm1'];
  var b = a.options[a.selectedIndex].value;
  if(b) {
    x.haschanged.value = 'dagboekload';
    x.subaktie.value = 'dagboekload';
    x.dagboekcode.value = b;
    x.submit();
  }
}


function editLine() {
  // dummy
}


function periodesWissel(a) {
  var x = document.forms['frm1'];
  var c = "periodearr[]";
  // onderstaand geeft alleen de formelementen-array met name check[]
  var y = x.elements[c].length;
  // denk erom: omdat de naam van het element 'check[]' is, met blokhaken dus
  // moeten we de naam eerst in een variabele zetten en deze variabele in blokhaken
  // teruggeven. Beide onderstaande voorbeelden werken hier niet:
  //    var y = x.elements.check[].length;
  //    var y = x.elements.c.length;

  // onderstaande lus gaat door formelementen met naam periodearr[]
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
  periodesWissel('uit');
  x.dagboekcode[0].selected=true;
  x.elements['directid'].value='';
  x.elements['directpost'].value='';
  x.elements['journaalpost'].value='';
  x.elements['journaalpost_old'].value='';
  x.submit();
}

EOJ;

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          'aktie'=>'print'
                         ,'subaktie'=>''
                         ,'haschanged'=>''
                         ,'process'=>''
                         ) );

  $form->mainTableStart();

  // Eerste fieldblock
  // Keuzevelden: dagboekcode, direct ingeven journaalid

    $form->fieldSetStart("Journaalposten selectie: &nbsp; - &nbsp; Boekjaar: {$stam->boekjaar}",
                         array('',RUBRIEK.'..journaalPrint','Overzicht journaalposten') );

      $form->blockLine('',
                       array(
                             "direct ingeven: journaalpost  <input type='text' size='5' name='directpost' value='' onChange='doLoad(this);' /> "
                            ."journaalid: <input type='text' size='5' name='directid' value='' onChange='doLoad(this);' /> "
                            ."saldo niet 0: <input type='checkbox' name='saldonietnul' value='1' {$checked['saldonietnulcheck']} onChange=\"doLoad(this);\" />"
                            ,"dagboek: <select name='dagboekcode' onChange='dagboekLoad(this);' >{$dagboeken}</select>"
                            ), 
                       array("","","") );

  // periodecheck vullen en gelijk het stukje AND sql maken
  // herstel: het stukje AND sql hebben we al eerder nodig.
  // Dit sql stukje verplaatsen we naar eerder in de procedure.

  $tmp = '';
  
  for($i=0;$i<=$stam->periodeextra['value'];$i++) {
    if(in_array($i,$p->periodearr)) {
      $tmp .= "{$i}:<input type='checkbox' name='periodearr[]' value='{$i}' checked='checked' /> &nbsp;\n"; 
    }
    else 
      $tmp .= "{$i}:<input type='checkbox' name='periodearr[]' value='{$i}' /> &nbsp;\n"; 
  }

      $form->blockLine('',
                       array("<div class='schemarow_std'>Periode(s) &nbsp; {$tmp} 
                              &nbsp;&nbsp;<a href='#' onClick=\"javascript:periodesWissel('uit');\">uit</a>
                              /<a href='#' onClick=\"javascript:periodesWissel('aan');\">aan</a></div>"), 
                       array("colspan='3' width='100%'") );


  // Buttonstrap

    $form->fieldSetBridge();

      $buttons=<<<EOT

        <input type="button" name="select" value="select" size="10" class='bsmall2' class='bsmall2' onClick="document.forms['frm1'].process.value='1';doLoad(this)"/>
        <input type="button" name="leeg" value="leeg" size="10" class='bsmall2' class='bsmall2' onClick="doClear()"/>
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>
EOT;

      $printerbutton=<<<EOT

        <img src='/img/printer1.gif' style="cursor:pointer;" onClick="window.print();"/>
EOT;

      $form->blockLine('2',array($buttons,$printerbutton),
                           array("width='90%'","width='10%' align='right'") );


  // Start journaalposten

  // eerst de journaalposten inlezen behorende bij de gekozen selectie

#if(! empty($p->journaalid)) { // journaalnummer wordt extern aangeboden
#$journaalids = array($p->journaalid);
#}
#else if(! empty($p->directnummer)) { // er is een direct journaalnummer gekozen
#  $journaalids = array($p->directnummer);
#}
// directnummer (dit is eigenlijk het journaalid) doen we niet meer!
// Je kunt nu ingeven: directid (is het oude directnummer) of directpost (is de
// journaalpost in het huidige boekjaar). Als een journaalpost wordt ingegeven
// moeten we dit herleiden naar een journaalid want daarmee werken we verder in
// deze procedure.
if(! empty($p->directid)) { // er is een direct journaalid gekozen
  $journaalids = array($p->directid);
  $p->process = true;
}
else if(! empty($p->directpost)) { // er is een direct journaalpost gekozen.
                                   // Maak er eerst een journaalid van
  $where = " \"journaalpost\"={$p->directpost} AND \"boekjaar\"={$stam->boekjaar}";
  $journaalids = $stam->Get_array_field("journaalid", "{$stam->journaal}", $where, $file."::".__LINE__);
  $p->process = true;
}
else { // selectie toepassen
  // dagboekcode
  if($post->dagboekcode == 'none' || $post->dagboekcode == '') { 
    $where = " \"boekjaar\"={$stam->boekjaar} {$whereperiode} ";
  }
  else {
    $where = " \"dagboekcode\"='{$post->dagboekcode}' AND \"boekjaar\"={$stam->boekjaar} {$whereperiode}";
    $p->process = true;
  }
  // journaalposten met een saldo niet gelijk aan nul
  if($p->saldonietnul) {
    $where .= " AND \"saldo\" <> 0.00";
    $p->process = true;
  }
  // sortering
  $order = " ORDER BY \"dagboekcode\",\"journaalpost\"";
  $journaalids = $stam->Get_array_field("journaalid", "{$stam->journaal} AS j", $where . $order, __FILE__."::".__LINE__);
}
//printrc2($where,"where: ");
//printrc2($order,"order: ");
printrc2($journaalids,"journaalids: ");

// vraag niet zomaar het hele boekjaar op; daarvoor moet je expliciet op
// 'Select' drukken of er moet een specifieke selectie zijn.
if(!$p->process) $journaalids = array();

foreach($journaalids AS $journaalid) {

  // leeg de huidige journaalpost
  unset($post);

  if($journaalid) {
    if(!$post = new Journaal($journaalid, $journaalpost=0, $processing=false)) {
      $msg['red'][] = "Gevraagde journaalpost: $journaalid bestaat niet!";
      $form->fieldSetBridge("Journaalpost: {$post->journaalpost}");
      
      $form->messagePrint();

      continue;
    }
  }
  else
    continue;

  printrc2($post,"post: _journaalprint.inc\n");

  // bewerk saldo
  $saldoclass = 'veldsub';
  $journaalsaldo = $post->saldo;
  if($journaalsaldo <> 0) 
    $saldoclass = 'veldsub_enh';

    $form->fieldSetBridge("Journaalpost: {$post->journaalpost}");
    
  // Journaalnummer, periode, journaalpostsaldo
    
      $form->blockLine('',
                       array("<div style='padding:4 2 4 2'>Dagboek:</div>"
                            ,"<span class='veldsub'>{$post->dagboekcode}</span> "
                            ."boekjaar: <span class='veldsub'>{$post->boekjaar}</span> "
                            ."periode: <span class='veldsub'>{$post->periode}</span> "
                            ."datum: <span class='veldsub'>".$GLOBALS['timer']->iso2norm($post->datum)."</span> "
                            ."saldo journaalpost: <span class='{$saldoclass}'>".formatbedrag($journaalsaldo,$nul=true)."</span> "
                            ."record: <span class='veldsub'>{$journaalid}</span> "
                            ), 
                       array("nowrap='nowrap', width='100'","","width='70%'") );
      

    // Journaalpostheaders
    //
    if($post->dagboektype == 'kas') {
      // ophalen van de kasgegevens in het dagboek met de gevraagde dagboekcode
      if($journaalid) { // haal de gegevens uit dagboekhistorie
        $arr = $stam->Get_fields(array("saldo","huidigeboeknummer","nieuwsaldo"),$stam->dagboekhistorie,"\"journaalid\"={$journaalid}",ASSOC, $file."::".__LINE__);
        $boeknummer = (isset($arr['huidigeboeknummer'])) ? $arr['huidigeboeknummer'] : 0;
        $beginsaldo = (isset($arr['saldo'])) ? $arr['saldo'] : '0.00' ;
        // het huidige saldo is het kasblad beginsaldo gesaldeerd met de boekingen van dit kasblad
        // dus het saldo journaalpost
        $huidigsaldo = $beginsaldo + ($journaalsaldo * -1);
        // disable huidigsaldo als het journaalpost is opgeslagen
      } 
        
      // Zolang we nog geen kasbladen gebruiken met een begin- en eindsaldo
      // zoals bij een bankboekingsvel, hebben we onderstaande regel niet
      // nodig.
      /*
      $form->blockLine('',
                       array("<div style='padding:4 2 4 2'>Kasblad:</div>"
                            ,"<span class='veldsub'>{$boeknummer}</span>"
                            ."kasblad beginsaldo: <span class='veldsub'>".formatbedrag($beginsaldo,$nul=true)."</span>"
                            ."kasblad huidig saldo: <span class='veldsub'>".formatbedrag($huidigsaldo,$nul=true)."</span>"
                            ), 
                       array("nowrap='nowrap', width='100'","","width='70%'") );
     */

    } // END IF dagboektype == 'kas'

    if($post->dagboektype == 'bank') {

      if($post->journaalid) { // haal de gegevens uit dagboekhistorie
        $arr = $stam->Get_fields(array("saldo","huidigeboeknummer","nieuwsaldo"),$stam->dagboekhistorie,"\"journaalid\"={$journaalid}",ASSOC, $file."::".__LINE__);
        $boeknummer = $arr['huidigeboeknummer'];
        $beginsaldo = $arr['saldo'];
        $eindsaldo = $arr['nieuwsaldo'];
        // disable eindsaldo als het journaalpost is opgeslagen
        $disabled['eindsaldo'] = "disabled='disabled'";
      } 
        
      $form->blockLine('',
                       array("<div style='padding:4 2 4 2'>Bankstuknummer:</div>"
                            ,"<span class='veldsub'>{$boeknummer}</span>"
                            ."beginsaldo:  <span class='veldsub'>".formatbedrag($beginsaldo,$nul=true)."</span>"
                            ."eindsaldo:  <span class='veldsub'>".formatbedrag($eindsaldo,$nul=true)."</span>"
                              ), 
                       array("nowrap='nowrap', width='100'","","width='70%'") );
      
    } // END IF dagboektype == 'bank'

    else if($post->dagboektype == 'inkoop') {
      // In het inkoop-, verkoop- en pinboek tonen we extra velden in de journaalpost:
      // debiteur/crediteur/naam bedrijf, factuurnummer/factuurnummer/bonnr
      // Deze gegevens worden als defaults bijgeschreven onder journaal.jrelatie en -jnummer
      // en tijdens een boeking als defaults overgenomen in de boekingsregel.
        
      // de meeste factuurgegevens zijn opgeslagen in de journaalpost (jrelatie,jnummer)
      // maar niet het factuurbedrag. Dit moeten we halen uit de opgeslagen factuur in inkoopfacturen
      if($post->journaalid) { // haal de gegevens uit inkoopfacturen
        $factuurbedrag = $stam->Get_field("factuurbedrag",$stam->inkoopfacturen,"\"journaalid\"={$journaalid}", $file."::".__LINE__);
        // disable eindsaldo als het journaalpost is opgeslagen
        $disabled['relatie']        = "disabled='disabled'";
        $disabled['jfactuurnummer'] = "disabled='disabled'";
        $disabled['factuurbedrag']  = "disabled='disabled'";
      } 

      $form->blockLine('',
                       array("<div style='padding:4 2 4 2'>Crediteur:</div>"
                            ,"<span class='veldsub'>{$post->jrelatie}</span>"
                            ."factuurnr: <span class='veldsub'>{$post->jnummer}</span>"
                            ."factuurbedrag: <span class='veldsub'>".formatbedrag($factuurbedrag)."</span>"
                              ), 
                       array("nowrap='nowrap', width='100'","","width='70%'") );
      
    } // END IF dagboektype == 'inkoop'

    else if($post->dagboektype == 'verkoop') {
      // In het inkoop-, verkoop- en pinboek tonen we extra velden in de journaalpost:
      // debiteur/crediteur/naam bedrijf, factuurnummer/factuurnummer/bonnr
      // Deze gegevens worden als defaults bijgeschreven onder journaal.jrelatie en -jnummer
      // en tijdens een boeking als defaults overgenomen in de boekingsregel.
        
      // de meeste factuurgegevens zijn opgeslagen in de journaalpost (jrelatie,jnummer)
      // maar niet het factuurbedrag. Dit moeten we halen uit de opgeslagen factuur in verkoopfacturen
      if($journaalid) { // haal de gegevens uit verkoopfacturen
        $factuurbedrag = $stam->Get_field("factuurbedrag",$stam->verkoopfacturen,"\"journaalid\"={$journaalid}", $file."::".__LINE__);
        // disable eindsaldo als het journaalpost is opgeslagen
        $disabled['relatie']        = "disabled='disabled'";
        $disabled['jfactuurnummer'] = "disabled='disabled'";
        $disabled['factuurbedrag']  = "disabled='disabled'";
      } 

      $form->blockLine('',
                       array("<div style='padding:4 2 4 2'>Debiteur:</div>"
                            ,"<span class='veldsub'>{$post->jrelatie}</span>"
                            ."factuurnr: <span class='veldsub'>{$post->jnummer}</span>"
                            ."factuurbedrag: <span class='veldsub'>".formatbedrag($factuurbedrag)."</span>"
                              ), 
                       array("nowrap='nowrap', width='100'","","width='70%'") );
      
    } // END IF dagboektype == 'verkoop'

    else if($post->dagboektype == 'pin') {
        
  $render->jscript .=<<<EOT

EOT;

      $form->blockLine('',
                       array("<div style='padding:4 2 4 2'>Naam bedrijf:</div>"
                            ,"<span class='veldsub'>{$post->jrelatie}</span>"
                            ."bonnr: <span class='veldsub'>{$post->jnummer}</span>"
                            ), 
                       array("nowrap='nowrap', width='100'","","width='70%'") );
      
    } // END IF dagboektype == 'pin'


    // Omschrijving

      $form->blockLine('',
                       array("<div style='padding:4 2 4 2'>Omschrijving:</div>"
                            ,"<span class='veldsub'>{$post->jomschrijving}</span>"
                            ),
                       array("nowrap='nowrap', width='100'","","width='70%'") );


  // END Journaalpostheader

  // Overzicht boekregels van deze journaapost
  //
  if(! empty($post->boekregel)) {

    $post->Journaal_body($form, $print=true);

  } // END Boekregels

} // END FOREACH journaalids


    $form->fieldSetEnd();

  $form->mainTableEnd();
$form->formEnd();

  
$render->extra_styles .=<<<EOT

legend {
  font-weight:bold;
  padding-top: 10;
}

EOT;

/* __END__ */
