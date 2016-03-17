<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: journaaledit.php 289 2015-01-04 09:09:40Z otto $
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

$p = new Params(array("aktie"=>""
                     ,"journaalid"=>""
                     ,"datumpropageren"=>""
                     ,"periode"=>""
), "_PG", $clean=true, $quote="{$GLOBALS['config']->data['db']['driver']}" );

printrc1($p, "Parms ". basename(__FILE__) .": ");

define('RUBRIEK','Journaaledit.');

$aktie = $p->aktie;;

//
// Laad een journaalobject
// Geef als tweede argument true om te zorgen dat het journaalobject geen
// preprocessing uitvoert, alleen de journaalgegevens laadt.
//
$post = new Journaal($p->journaalid,'',true);

printrc2($post,"post: journaaledit.phtml\n");

//
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
// is een uid meegegeven? 
//   - geen aktie: het journaal _journaaledit.inc weergeven
//   - aktie 'save': ga door _journaaledit_save.inc waar een update actie
//     plaatsvindt (er is immers een uid) en daarna naar _journaaledit.inc

switch($aktie) {
  case "save"   :
    require("_journaaledit_save.inc");
  case "back"   :
  default       :
    require("_journaaledit.inc");
    break;
}

$render->output();

?>
