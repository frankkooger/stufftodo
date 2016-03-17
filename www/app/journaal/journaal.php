<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: journaal.php 289 2015-01-04 09:09:40Z otto $
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

require("_journaal.lib");

// Een journaalobject wordt dadelijk geladen als een journaalid al dan niet bekend is

$p = new Params(array('aktie'=>''
                     ,'subaktie'=>''
                     ,'journaalid'=>''
                     ,'journaalpost'=>''
                     ,'saldonietnul'=>''
                     ,'haschanged'=>''
                     ,'process'=>''
                     ,'viewboeknummer'=>''
                     ,'dagboekcode'=>''
                     ,'m_dagboekcode'=>''
                     ,'factuurnummer'=>''
                     ,'relatie'=>''
                     ,'viewrelatieid'=>''
                     ,'relatiecode'=>''
                     ,'boorsprong'=>''
                     ,'factuurid'=>''
                     ,'factuurbedrag'=>''
                     ,'periode'=>''
                     ,'tekst'=>''
                     ,'saldo'=>''
                     ,'btw'=>''
), "_PG", $clean=true, $quote="{$GLOBALS['config']->data['db']['driver']}" );

printrc1($p, "Parms ". basename(__FILE__) .": ");

define('RUBRIEK','Journaal.');

$aktie = $p->aktie;

// Voer enkele standaard controles uit voordat we kunnen boeken:
//   - is/wordt het boekjaar afgesloten?
//     In dit geval blokkeren we de mogelijkheid om nog boekingen in dit boekjaar te maken.
//   - is er al een grootboekschema van het huidige boekjaar?
//     Deze controle zal slechts 1 keer nodig zijn, tijdens de eerste keer dat
//     we in een nieuw boekjaar willen boeken. Als het nieuwe schema er nog
//     niet is, maak het dan aan.

// Is het boekjaar in een eindejaarslock?
// Doe dit niet als aktie=='print' want ondanks een eindejaarslock willen we de
// journaalposten nog wel kunnen inzien, alleen niet meer wijzigen.
//
if($stam->boekjaarSemiBlocked && $aktie != 'print') $aktie = 'blocked';

// Er zijn akties waarbij het journaalpost verandert en akties waarbij dat niet
// het geval is. Dat laatste gebeurt b.v. bij alles wat met boekregels te maken
// heeft. Bij het opvragen en opslaan van een boekregel (nieuw of bestaand,
// eigenlijk Ajax functies (voor later)) moet het originele journaalpost
// gehandhaafd blijven.
//
switch($p->aktie) {
  
  case 'dagboekload' : $journaalid = '';
  case 'periodeload' : $journaalid = ''; break;

  default            : $journaalid = $p->journaalid; break;
}

$processing = false;

// We moeten naar een situatie toe waarin alles in dit script gestuurd wordt
// door gegevens vanuit een post object, leeg of geladen.
// Zorg dus dat er altijd een actuele post object beschikbaar is.

// Laad een journaalobject
// Als journaalid=='' en journaalpost=='' dan wordt automatisch een leeg object geladen met
// daarin de periode en dagboekcode uit $p
//
$post = new Journaal($journaalid,0,$processing);

//printrc2($post, "Een hele schone, lege post\n");

// In alle achterliggende modules moet met us format bedragen gerekend
// worden. In de journaalmodule worden regelmatig bedragen ingegeven.
// Die hier centraal controleren en naar us zetten.
// Voorwaarde is dat tijdens het ingeven geen duizendsep wordt gebruikt.
// Punt en komma mag als decimale sep. Die worden hier naar punt omgezet.
//
$puntvelden = array('saldo','credit','debet','bedrag','btwbedrag','viewfactuurbedrag');
foreach($puntvelden AS $val) {
  ! empty($p->$val) and $p->$val = str_replace(",",".",$p->$val);
}

$render->extra_styles .=<<<EOT

body {
  background-color: {$GLOBALS['config']->data['bgcolor']['journaal']};
}

EOT;

// START 
//
switch($aktie) {
  case 'blocked':
    require('_journaalblocked.inc');
    break;
  case 'print'  :
    require('_journaalprint.inc');
    break;
  case 'schema'  :
    require('_journaalschema.inc');
    break;
  case 'save'   :
    require('_journaal_save.inc');
  case 'back'   :
  default       :
    require('_journaal.inc');
    break;
}

$render->output();

/* __END__ */
