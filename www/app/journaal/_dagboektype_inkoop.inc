<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _dagboektype_inkoop.inc 289 2015-01-04 09:09:40Z otto $
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

      // if($post->dagboektype == 'inkoop')
      //
      // In het inkoop-, verkoop- en pinboek tonen we extra velden in de journaalpost:
      // debiteur/crediteur/naam bedrijf, factuurnummer/factuurnummer/bonnr
      // Deze gegevens worden als defaults bijgeschreven onder journaal.jrelatie en -jnummer
      // en tijdens een boeking als defaults overgenomen in de boekingsregel.
        
      // de meeste factuurgegevens zijn opgeslagen in de journaalpost (jrelatie,jnummer)
      // maar niet het factuurbedrag. Dit moeten we halen uit de opgeslagen factuur in inkoopfacturen
      if($post->journaalid) { // haal de gegevens uit inkoopfacturen
        $factuurbedrag = $stam->Get_field("factuurbedrag",$GLOBALS['stam']->inkoopfacturen, "\"journaalid\"={$post->journaalid}", $scriptfile."::".__LINE__);
        // disable eindsaldo als het journaalpost is opgeslagen
        $disabled['relatieid']      = DISABLED;
        $disabled['jfactuurnummer'] = DISABLED;
        $disabled['factuurbedrag']  = DISABLED;
        $newmarker = '';
      } 
      else {
        $factuurbedrag = '';
        $disabled['relatieid']      = '';
        $disabled['jfactuurnummer'] = '';
        $disabled['factuurbedrag']  = '';
        $newmarker = "<img src='/img/b_edit.png' class='pointer' onClick=\"pop_app('crediteuren','{$config->data['url']['base_url']}/run.php?app=crediteurenstam&amp;id=')\" title='Edit crediteurenstam'/>";
      }

  $render->jscript .=<<<EOT

EOT;

      $crediteuren_id = '';
      // Denk erom dat in post->jrelatie de relatiecode staat en niet het id. We moeten er dus eerste een id van maken.
      $crediteuren_id = (isset($post->jrelatie)) ? $post->relatieId($post->jrelatie,'crediteuren') : $p->viewrelatieid;
      // Haal het crediteuren pulldown menu op.
      // De pulldownlijst is hierna bekend is $crediteurenlijst.
      //
      require('_crediteuren.lib');
      $crediteur = new Crediteuren();
 
      $form->blockLine('',
                       array("Crediteur:",
                             "<select name='viewrelatieid' Id='viewrelatieidId'  {$disabled['relatieid']} width='300' style='widht:\"300\";'  onChange=''>".$crediteur->selectFill($crediteuren_id)."</select> &nbsp;
                              <input type='hidden' name='relatieid' value='{$crediteuren_id}' />
                              {$newmarker}
                              
                              <div style='float:right;width:260'>
                              factuurnummer: <input type='text' name='viewfactuurnummer' value='{$post->jnummer}' size='10' {$disabled['jfactuurnummer']} /></div>
                              <input type='hidden' name='factuurnummer' value='{$post->jnummer}' />
                              "), 
                       array("nowrap='nowrap', width='100'","","width='70%'") );

    // Datum

      $nu = $GLOBALS['timer']->vandaag;
      $form->blockLine('',
                       array("factuurdatum:",
                             "<input type='text' name='datum' value='".$GLOBALS['timer']->iso2norm($post->datum)."' size='12' onChange='doCheckDatum(this,\"\",\"{$stam->lopendjaar['value']}\");' {$disabled['datum']} />
                              <div style='float:left;cursor:crosshair;' onClick=\"var x=document.forms['frm1'];x.datum.value='{$nu}'\" >dd-mm-jjjj </div>
                              <div style='float:right;width:260'>
                              factuurbedrag: &nbsp;&nbsp; <input type='text' name='viewfactuurbedrag' value='".formatbedrag(formatInputBedrag($factuurbedrag))."' size='10' {$disabled['factuurbedrag']} /></div>
                              <input type='hidden' name='factuurbedrag' value='{$factuurbedrag}' />
                             "),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

    // Omschrijving

      $form->blockLine('',
                       array("Omschrijving:",
                             "<input type='text' name='jomschrijving' value=\"{$post->jomschrijving}\" size='40' {$disabled['jomschrijving']} /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$formbuttons}"),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

/* __END__ */
