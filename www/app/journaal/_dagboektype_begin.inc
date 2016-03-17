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

/*
   Dagboektype 'begin' is een speciale.
   Normaliter wordt in het begin van een nieuwe (dus lege) administratie een
   beginbalans boeking gemaakt.
   Ergo: de beginbalans moet handmatig zijn in te geven.
   In een al bestaande administratie komt de beginbalans boeking voort uit de
   jaarafsluiting van het vorige jaar.
   We kiezen er daarom nu voor om de beginbalans boeking alleen handmatig toe
   te staan aan het begin van een nieuwe administratie.
   Later moeten we nog eens bekijken of er behoefte bestaat om ook later in de
   administratie alvast een beginbalans voor een boekjaar op te geven als we
   b.v. al in het nieuwe jaar boeken en het oude nog niet is afgesloten.
*/

    // Datum

      $form->blockLine('',
                       array("Datum:",
                             "<input type='text' name='vwdatum' value='01-01-".$stam->boekjaar."' size='12' disabled='disabled' /> 
                              <input type='hidden' name='datum' value='01-01-".$stam->boekjaar."' /> 
                             "),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

    // Omschrijving

      $form->blockLine('',
                       array("Omschrijving:",
                             "<input type='text' name='vwjomschrijving' value='Beginbalans' size='40' disabled='disabled'} /> 
                              <input type='hidden' name='jomschrijving' value='Beginbalans' /> 
                              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{$formbuttons}"),
                       array("nowrap='nowrap', width='100'","","width='70%'") );

/* __END__ */
