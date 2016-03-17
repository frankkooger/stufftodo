<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _dagboektype_kas.inc 261 2013-07-31 08:47:54Z otto $
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
