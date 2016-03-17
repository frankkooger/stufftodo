<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _dagboektype_kas.inc 215 2011-09-25 18:54:41Z otto $
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

      // if(dagboektype == 'kas')
      //
      // ophalen van de kasgegevens in het dagboek met de gevraagde dagboekcode
      // Nadat de gegevens zijn opgehaald, zet een slot bij het dagboek zodat geen andere nieuwe
      // kas-journaalposten kunnen worden geopend. De slot bestaat uit het journaalid, dus dit
      // wordt pas gezet als dit nieuwe journaalpost wordt opgeslagen.
      // Tevens worden dagboek.saldo en dagboek.nummer (is kasbladnummer) aan de nieuwe situatie aangepast.
      // Het slot wordt verwijderd als de journaalpost kant en klaar (saldo=0) naar kas wordt geboekt.
      // Het slot wordt ook verwijderd als de journaalpost wordt weggegooid.
      // Tijdelijk wordt het nieuw ingegeven kasbladnummer en saldo opgeslagen in de tabel dagboekhistorie
      // de velden code,vorigeboeknummer,saldo,huidigeboeknummer,nieuwsaldo. Deze gegevens blijven bestaan zodat
      // ze later gebruikt kunnen worden bij het presenteren van een bestaande kas journaalpost.
      // Ze worden ook gebruikt in een rollback (verwijderen kas-journaalpost).
      // Ze kunnen worden verwijderd zodra journaalposten naar het grootboek doorgeboekt en afgesloten worden.
      if(!$journaalid) { // nieuwe journaalpost, haal de initiele gegevens uit dagboek
        $arr = $stam->Get_fields(array("grootboekrekening","boeknummer","saldo"),$GLOBALS['stam']->dagboeken, "\"code\"='{$post->dagboekcode}'",ASSOC, $scriptfile."::".__LINE__);
        $oudboeknummer = $arr['boeknummer'];
        $boeknummer = $oudboeknummer + 1;
        $beginsaldo = $huidigsaldo = $arr['saldo'];
        // het huidig saldo wordt niet met de hand ingegeven. Het huidig saldo wordt gedurende het boeken
        // steeds bijgewerkt. Aan het begin van een nieuw kasblad is het huidig saldo dus gelijk aan het
        // beginsaldo want het beginsaldo is als laatst bijgewerkte saldo naar dagboek.saldo geschreven
        // toen het vorige kasblad (=journaalpost) werd doorgeboekt naar kas.
        // Zet een default omschrijving in een nieuw kasblad
        $post->jomschrijving = "Kasblad {$boeknummer}";
      }
      else if($journaalid) { // haal de gegevens uit dagboekhistorie
        $arr = $stam->Get_fields(array("saldo","huidigeboeknummer","nieuwsaldo"),$GLOBALS['stam']->dagboekhistorie, "\"journaalid\"={$journaalid}",ASSOC, $scriptfile."::".__LINE__);
        $boeknummer = $arr['huidigeboeknummer'];
        $beginsaldo = $arr['saldo'];
        $huidigsaldo = $arr['nieuwsaldo'];
        // disable huidigsaldo als het journaalpost is opgeslagen
      } 
        
  $render->jscript .=<<<EOT

EOT;

      $form->blockLine('',
                       array("Kasblad:",
                             "<input type='text' name='viewboeknummer' value='{$boeknummer}' size='5' {$disablethis} /> &nbsp;
                              beginsaldo: <input type='text' name='viewbeginsaldo' value='".formatbedrag($beginsaldo)."' size='10' {$disablethis} style='text-align:right' /> &nbsp;
                              huidig kassaldo: <input type='text' name='viewhuidigsaldo' value='".formatbedrag($huidigsaldo)."' size='10' {$disablethis} style='text-align:right' /> 

                              <input type='hidden' name='kasgrootboekrekening' value='{$arr['grootboekrekening']}' />
                              <input type='hidden' name='oudboeknummer' value='{$oudboeknummer}' />
                              <input type='hidden' name='boeknummer' value='{$boeknummer}' />
                              <input type='hidden' name='saldo' value='{$post->saldo}' />
                              <input type='hidden' name='beginsaldo' value='{$beginsaldo}' />
                              <input type='hidden' name='huidigsaldo' value='{$huidigsaldo}' />
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
