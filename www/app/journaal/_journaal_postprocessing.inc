<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _journaal_postprocessing.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body .= "\n          <!-- journaal_postprocessing.inc -->\n";
$render->subtitle[] = 'journaal_postprocessing.inc';

// Een post journaalobject wordt default geladen in de starter


/*
   Boekregels die uit het journaal-formulier komen om nieuw op te slaan of te
   updaten worden vanuit _journaal.inc aangeboden aan $post->opslaanLine($p).
   De data moet echter worden ge-postprocessed om op een eenduidige wijze aan
   opslaanLine te kunnen aanbieden. 
   Daarna moet data van bepaalde dagboektypes nog een postproces ondergaan zoals
   het zetten/onzetten van locks.
   Evenals voor preprocessing handelen we postprocessing af in deze aparte file.
   Het is niet veel, had in _journaal.inc kunnen gebeuren maar zo is het 
   overzichtelijker.
*/
 
// als we hier binnenkomen dan weten we welke dagboekcode en -type het betreft doordat
// in journaal.phtml een $post object is geinstantieerd waarin die code en type zijn opgeslagen

// het dagboektype vraagt om verschillende benaderingen van de aangeboden data en moet hier
// worden ge-postprocessed.
// Dat dient alleen te gebeuren bij akties 'saveline' en 'savelinefinale' dus deze include wordt
// alleen aangeroepen vanuit _journaal.inc als het deze akties betreft. We hoeven hier dus niet
// te testen op die akties maar direct postprocessen.

switch($post->dagboektype) { 

  case 'bank'   :
    // Als zojuist een regel in een bankboekboeking is opgeslagen en het saldo is 0
    // dan veronderstellen we dat het bankafschrift 'volledig' is en kan 
    // het dagboek.slot van 'bank' verwijderen
    // TODO dit is geen 100% methode. Als b.v. per ongeluk een boeking wordt gedaan
    //      waardoor het saldo op 0 springt dan is er nu geen mechanisme meer dat het
    //      slot weer terugzet. Dat zou overigens wel kunnen door hieronder een 'else'
    //      te maken en na controle op het slot, dit alsnog weer te zetten als het er niet (meer) is.
    //      Even aankijken nog.
    if($post->saldo == '0') 
      $stam->Do_query("UPDATE {$GLOBALS['stam']->dagboeken} SET \"slot\"=0 WHERE \"slot\"={$post->journaalid}", basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__);
    break;

}

/* __END__ */
