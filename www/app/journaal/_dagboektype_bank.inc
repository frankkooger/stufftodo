<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _dagboektype_bank.inc 261 2013-07-31 08:47:54Z otto $
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

      // if($post->dagboektype == 'bank') {
      //
      // ophalen van de bankgegevens in het dagboek met de gevraagde dagboekcode
      // Nadat de gegevens zijn opgehaald, zet een slot bij het dagboek zodat geen andere nieuwe
      // bank-journaalposten kunnen worden geopend. De slot bestaat uit het journaal-id, dus dit
      // wordt pas gezet als dit nieuwe journaalpost wordt opgeslagen.
      // Tevens worden dagboek.saldo en dagboek.bankstuknummer aan de nieuwe situatie aangepast.
      // Het slot wordt verwijderd als de journaalpost kant en klaar (saldo=0) naar bank wordt geboekt.
      // Het slot wordt ook verwijderd als de journaalpost wordt weggegooid.
      //
      // Het nieuw ingegeven boeknummer en saldo worden ook opgeslagen in de tabel dagboekhistorie met
      // de velden
      // code,journaal-id,vorigebankbladnummer,saldo,huidigebankbladnummer,nieuwsaldo.
      // Deze gegevens blijven bestaan zodat ze later gebruikt kunnen worden
      // bij het presenteren van een oud bank journaalpost.  Ze worden ook
      // gebruikt in een rollback (verwijderen bank-journaalpost).
      //

      // nieuwe journaalpost, haal de initiele gegevens uit dagboeken. Als die
      // gegevens voor dit bankboek nog op 0 staan dan is er nog niet eerder op
      // dit bankboek geboekt en moeten we het bankstuknummer en beginsaldo
      // kunnen ingeven. Als er al eerder boekingen zijn geweest dan
      // presenteren we bankstuknummer+1 en saldo in disabled velden.
      //
      if(!$post->journaalid) { 
        $arr = $stam->Get_fields(array("grootboekrekening","boeknummer","saldo"),$GLOBALS['stam']->dagboeken,"\"code\"='{$post->dagboekcode}'",ASSOC, $scriptfile."::".__LINE__);
//        printrc2($arr, "arr na get_fields: ");
        $oudboeknummer = $arr['boeknummer'];
        if($oudboeknummer == 0) { // eerste boeking op dit bankboek
          $boeknummer = '';
          $beginsaldo = 0;
          $disabled['boeknummer'] = '';
          $disabled['beginsaldo'] = '';
        }
        else {
          $boeknummer = $oudboeknummer + 1;
          $beginsaldo = $arr['saldo'];
          $disabled['boeknummer'] = DISABLED;
          $disabled['beginsaldo'] = DISABLED;
        }
        $eindsaldo = 0;
        $disabled['eindsaldo'] = "";
      }
      //
      // bestaande journaalpost, haal de gegevens uit dagboekhistorie
      //
      else if($post->journaalid) { 
        $arr = $stam->Get_fields(array("saldo","huidigeboeknummer","nieuwsaldo"),$GLOBALS['stam']->dagboekhistorie,"\"journaalid\"={$post->journaalid}",ASSOC, $scriptfile."::".__LINE__);
        $boeknummer = $arr['huidigeboeknummer'];
        $beginsaldo = $arr['saldo'];
        $eindsaldo = $arr['nieuwsaldo'];
        //
        // disable invoervelden
        //
        $disabled['boeknummer'] = DISABLED;
        $disabled['beginsaldo'] = DISABLED;
        $disabled['eindsaldo'] = DISABLED;
        //
        // Onderstaande inits om Notifys te voorkomen in de printsectie
        //
        $oudboeknummer = '';
        $arr['grootboekrekening'] = '';
      } 
        
  $render->jscript .=<<<EOT

//
// bereken het journaalpostsaldo adhv het bank-begin en eindsaldo
//
function calcsaldo(a) {
  var x = document.forms['frm1'];
  //
  // we moeten de bedragen die we uitlezen wel goedzetten
  // de (hidden) beginsaldo staat in us formaat en is goed
  // de viewbeginsaldo (ingeval er nog geen beginsaldo is) moet wel gefilterd
  //
  var b = x.beginsaldo.value;
  //var v = x.viewbeginsaldo.value.replace(".","");
  var v = x.viewbeginsaldo.value.replace(",",".");
  //
  // de vieweindsaldo geven we zelf in en moeten zorgen dat we
  // geen duizendep. ingeven. punt of komma maakt dan niet uit, die
  // herstellen we hieronder naar een punt.
  //
  var e = x.vieweindsaldo.value.replace(",",".");

  if(b == '0' && v != '0.00')
    x.viewsaldo.value = x.saldo.value = Math.round((e - v)*100)/100;
  else
    x.viewsaldo.value = x.saldo.value = Math.round((e - b)*100)/100;
  x.eindsaldo.value = x.vieweindsaldo.value = e;
  // blocksaldo();

  if(x.jomschrijving.value == '') x.jomschrijving.value = 'Bankafschrift: ' + x.viewboeknummer.value;

} // END FUNCTION calcsaldo


// zet eindsaldo disabled als journaalpostsaldo gevuld is
//
function blocksaldo() {
  var x = document.forms['frm1'];
  if(x.viewsaldo != '') x.eindsaldo.disabled=true;
}

EOT;

      $form->blockLine('',
                       array("Bankstuknummer:",
                             "<input type='text' name='viewboeknummer' value='{$boeknummer}' size='5' {$disabled['boeknummer']} /> &nbsp;
beginsaldo: <input type='text' name='viewbeginsaldo' value='".formatbedrag($beginsaldo)."' size='10' {$disabled['beginsaldo']} style='text-align:right' /> &nbsp;
eindsaldo: <input type='text' name='vieweindsaldo' value='".formatbedrag($eindsaldo)."' size='10' {$disabled['eindsaldo']} onChange='calcsaldo(this);' style='text-align:right' /> 
                              <input type='hidden' name='bankgrootboekrekening' value='{$arr['grootboekrekening']}' />
                              <input type='hidden' name='oudboeknummer' value='{$oudboeknummer}' />
                              <input type='hidden' name='boeknummer' value='{$boeknummer}' />
                              <input type='hidden' name='saldo' value='{$post->saldo}' />
                              <input type='hidden' name='beginsaldo' value='{$beginsaldo}' />
                              <input type='hidden' name='eindsaldo' value='{$eindsaldo}' />
                              "), 
                       array("nowrap='nowrap', width='100'","","width='70%'") );

    // Datum

      $nu = $GLOBALS['timer']->vandaag;
      $form->blockLine('',
                       array("Datum:",
                             "<input type='text' name='datum' value='".$GLOBALS['timer']->iso2norm($post->datum)."' size='12' onChange='doCheckDatum(this,\"\",\"{$stam->lopendjaar['value']}\");' {$disabled['datum']} /> 
                              <div style='float:left;cursor:crosshair;' onClick=\"var x=document.forms['frm1'];x.datum.value='{$nu}'\" >dd-mm-jjjj </div>
                             "),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

    // Omschrijving

      $form->blockLine('',
                       array("Omschrijving:",
                             "<input type='text' name='jomschrijving' value=\"{$post->jomschrijving}\" size='40' {$disabled['jomschrijving']} /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$formbuttons}"),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

/* __END__ */
