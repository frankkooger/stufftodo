<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: populariteit.php 230 2013-04-27 08:24:43Z frank $
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

/* ***********************
   ML design & techniek
   Frank Kooger
*********************** */

/**
 * Update de populariteit - het aantal x dat een grootboeknummer is gebruikt
 * voor een boeking. Dit bepaalt waar het grootboeknummer wordt gesorteerd in
 * het grootboeknummer overzicht tijdens het boeken van boekregels.
 *
 * @abstract
 * @package		OpenAdmin.nl
 * @since		1.0
 */

// no direct access
defined('_JEXEC') or die('Restricted access');

$p = new Params(array('nr'=>''));

define('RUBRIEK','Populariteit');

if($p->nr === '0') {
  $stam->Do_query("UPDATE \"{$GLOBALS['config']->data['tbl']['grootboekstam']}\" SET \"populariteit\"=0",'',basename(__FILE__).'::'.__LINE__);
}
else {
  $aantal = $stam->Get_Field('"populariteit"', "\"{$GLOBALS['config']->data['tbl']['grootboekstam']}\"", "\"nummer\"={$p->nr}",'',basename(__FILE__).'::'.__LINE__);
  $aantal++;
  $stam->Do_query("UPDATE \"{$GLOBALS['config']->data['tbl']['grootboekstam']}\" SET \"populariteit\"={$aantal} WHERE \"nummer\"={$p->nr}",'',basename(__FILE__).'::'.__LINE__);
}

/* __END__ */
