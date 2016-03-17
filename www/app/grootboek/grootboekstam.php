<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: grootboekstam.php 289 2015-01-04 09:09:40Z otto $
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

require("_grootboek.lib");

$grootboek = new Grootboek();

$p = new Params(array("aktie"=>""
                     ,"subaktie"=>""
                     ,"nummer"=>""
                     ,"m_nummer"=>""
                     ,"overzicht"=>""
                     ,"saldoweergave"=>""
));

printrc1($p, "Parms ". basename(__FILE__) .": ");

define('RUBRIEK','Grootboeklookup.');

$aktie = $p->aktie;;

$render->extra_styles .=<<<EOT

body {
  background-color: {$GLOBALS['config']->data['bgcolor']['grootboek']};
}

EOT;

// START 
//
// is een uid meegegeven? 
//   - geen aktie: het grootboekstam _grootboekstam.inc weergeven
//   - aktie 'save': ga door _grootboekstam_save.inc waar een update actie
//     plaatsvindt (er is immers een uid) en daarna naar _grootboekstam.inc

switch($aktie) {
  case "lookup"  :
    require("_grootboeklookup.inc");
    break;
  case "print"  :
    require("_grootboekprint.inc");
    break;
  case "save"   :
    require("_grootboekstam_save.inc");
  case "back"   :
  default       :
    require("_grootboekstam.inc");
    break;
}

$render->output();

/* __END__ */
