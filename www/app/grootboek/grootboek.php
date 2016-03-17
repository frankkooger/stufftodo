<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: grootboek.php 289 2015-01-04 09:09:40Z otto $
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

$p = new Params(array('aktie'=>''
                     ,'subaktie'=>''
                     ,'dagboektype'=>''
                     ,'nummervan'=>''
                     ,'nummertot'=>''
                     ,'totaalcheck'=>''
                     ,'nulperiodecheck'=>''
                     ,'nulsaldocheck'=>''
                     ,'dense'=>''
), "_PG", $clean=true, $quote="{$GLOBALS['config']->data['db']['driver']}" );

if($p->aktie == 'print')
  $GLOBALS['config']->setValue('debug', 'level', 0);

require("_grootboek.lib");
$grootboek = new Grootboek();

printrc1($p, "Parms ". basename(__FILE__) .": ");

define('RUBRIEK','Grootboek.');

$aktie = $p->aktie;;
$printen = false;

$render->extra_styles .=<<<EOT

body {
  background-color: {$GLOBALS['config']->data['bgcolor']['grootboek']};
}

EOT;

// START 
//
// is een uid meegegeven? 
//   - geen aktie: het grootboek _grootboek.inc weergeven
//   - aktie 'save': ga door _grootboek_save.inc waar een update actie
//     plaatsvindt (er is immers een uid) en daarna naar _grootboek.inc

switch($aktie) {
  case "lookup"  :
    require("_grootboeklookup.inc");
    break;
  case "print"  :
    $printen = true;
    require("_grootboekkaart-pdf.inc");
    break;
  case "back"   :
  default       :
    require("_grootboekkaart.inc");
    break;
}

$render->output();

/* __END__ */
