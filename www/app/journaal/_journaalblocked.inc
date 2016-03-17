<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _journaalblocked.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body .= "\n          <!-- journaalblocked.inc -->\n";
$render->titel = "Journaalposten kunnen niet meer worden ingevoerd/beheerd";
$render->subtitle[] = 'journaalblocked.inc';
$render->schriftstijl = 'journaal';

// Housekeeping

$disablethis = DISABLED;

// Create buttons

  $button_sluiten=<<<EOT

        <input type="button" name="sluiten" value="sluit scherm" size="10" class='bsmall2' onClick="window.close()"/>
EOT;

  $button_terug=<<<EOT

        <input type='button' name='terug' value='terug naar vorige pagina' class='bsmall2' onClick="history.go(-1);" title='Ga een pagina terug'/>
EOT;

  $button_printen=<<<EOT

        <img src='/img/printer1.gif' style="cursor:pointer;" onClick="window.print();"/>
EOT;


//
// Start het formulier
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>""
                         ) );

  $form->mainTableStart();

  // Eerste fieldblock

    $form->fieldSetStart("");
    
$msg=<<<EOT
<br/>
<p>Het boekjaar {$GLOBALS['stam']->lopendjaar['value']} wordt/is afgesloten!</p>
<br/>

<p>Er kunnen geen boekingen meer in dit boekjaar worden gepleegd.</p>
<br/>

EOT;

      $form->blockLine('',
                       array("{$msg}"), 
                       array("") );

// Buttons
//

    $form->fieldSetBridge();

$buttons = $button_terug." ".$button_sluiten." ";

      $form->blockLine('',
                       array("{$buttons}"), 
                       array("") );

    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();
 
/* __END__ */
