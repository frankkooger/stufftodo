<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _dagboektype_pin.inc 261 2013-07-31 08:47:54Z otto $
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

      // if($post->dagboektype == 'pin')
      //
      // In het inkoop-, verkoop- en pinboek tonen we extra velden in de journaalpost:
      // debiteur/crediteur/naam bedrijf, factuurnummer/factuurnummer/bonnr
      // Deze gegevens worden als defaults bijgeschreven onder journaal.jrelatie en -jnummer
      // en tijdens een boeking als defaults overgenomen in de boekingsregel.
        
      // de meeste factuurgegevens zijn opgeslagen in de journaalpost (jrelatie,jnummer)
      // maar niet het factuurbedrag. Dit moeten we halen uit de opgeslagen factuur in pinbetalingen
      if($post->journaalid) { // haal de gegevens uit pinbetalingen
        $factuurbedrag = $stam->Get_field("factuurbedrag",$GLOBALS['stam']->pinbetalingen, "\"journaalid\"={$post->journaalid}", $scriptfile."::".__LINE__);
        // disable eindsaldo als het journaalpost is opgeslagen
        $disabled['relatieid']        = DISABLED;
        $disabled['jfactuurnummer'] = DISABLED;
        $disabled['factuurbedrag']  = DISABLED;
      } 
      else {
        $factuurbedrag = '';
        $disabled['relatieid']      = '';
        $disabled['jfactuurnummer'] = '';
        $disabled['factuurbedrag']  = '';
      }
        
  $render->jscript .=<<<EOT

EOT;

      $form->blockLine('',
                       array("Naam bedrijf:",
                             "<input type='text' name='viewrelatieid' value='{$post->jrelatie}' size='30' {$disabled['relatieid']} /> &nbsp;
                              <input type='hidden' name='relatieid' value='{$post->jrelatie}' />
                              <div style='float:right;width:260'>
                              bonnummer: <input type='text' name='viewfactuurnummer' value='{$post->jnummer}' size='10' {$disabled['jfactuurnummer']} /></div>
                              <input type='hidden' name='factuurnummer' value='{$post->jnummer}' />
                              "), 
                       array("nowrap='nowrap', width='100'","","width='70%'") );

    // Datum

      $nu = $GLOBALS['timer']->vandaag;
      $form->blockLine('',
                       array("Datum:",
                             "<input type='text' name='datum' value='".$GLOBALS['timer']->iso2norm($post->datum)."' size='12' onChange='doCheckDatum(this,\"\",\"{$stam->lopendjaar['value']}\");' {$disabled['datum']} /> 
                              <div style='float:left;cursor:crosshair;' onClick=\"var x=document.forms['frm1'];x.datum.value='{$nu}'\" >dd-mm-jjjj </div>
                              <div style='float:right;width:260'>
                              bonbedrag: &nbsp; <input type='text' name='viewfactuurbedrag' value='".formatbedrag($factuurbedrag)."' size='10' {$disabled['factuurbedrag']} style='text-align:right' /></div>
                              <input type='hidden' name='factuurbedrag' value='{$factuurbedrag}' />
                              "),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

    // Omschrijving

      $form->blockLine('',
                       array("Omschrijving:",
                             "<input type='text' name='jomschrijving' value=\"{$post->jomschrijving}\" size='40' {$disabled['jomschrijving']} /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$formbuttons}"),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

/* __END__ */
