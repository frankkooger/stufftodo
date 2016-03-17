<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: _grootboekkaartsjablonen.inc 215 2011-09-25 18:54:41Z otto $
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

// Landscape
$pdf->landscape = false;

$pdf->setTopMargin(35);

// lettertype in tekst:
$pdf->fonttype = "dejavusans";
$pdf->fontsize = '8';

// lettertype in header:
#$pdf->headerfonttype = "dejavusans";
#$pdf->headerfontsize = '9';

$pdf->sjabloon['pagebreak'] = New Sjabloon();

$pdf->sjabloon['header'] = New Sjabloon(array(5,15,13,11,11,81,22,22), array('C','C','C','C','C','C','C','C'), array('1','1','1','1','1','1','1','1') );
$pdf->sjabloon['header']->fillspotcolor = 'Pantone 658 C';
$pdf->sjabloon['header']->textcolor = array(0);
$pdf->sjabloon['header']->height = 7;

//$pdf->sjabloon['regular'] = New Sjabloon(array(4,21,13,13,13,72,22,22), array('C','C','C','C','C','','R','R'), array('LR','LR','LR','LR','LR','LR','LR','LR') );
$pdf->sjabloon['regular'] = New Sjabloon(array(5,15,13,11,11,81,22,22), array('C','C','C','C','C','','R','R'), array('LR','LR','LR','LR','LR','LR','LR','LR') );
#$pdf->sjabloon['regular']->fillcolor = array(224, 235, 255);
$pdf->sjabloon['regular']->switchcolor = 1;
// Als we fillcolor als array met 2 leden benoemen dan wordt geswitch't met deze twee kleuren ipv met 1 kleur en het 'fill' mechanisme
$pdf->sjabloon['regular']->fillcolor[] = array(255);
$pdf->sjabloon['regular']->fillcolor[] = array(224, 235, 255);
$pdf->sjabloon['regular']->height = 6;

$pdf->sjabloon['totaalkaart'] = New Sjabloon(array(20,70,30,30,30), array('C','','R'), array('LR','LR','R','LR','LR') );
$pdf->sjabloon['totaalkaart']->fillcolor = array(195);
$pdf->sjabloon['totaalkaart']->switchcolor = 0;
$pdf->sjabloon['totaalkaart']->height = 6;

$pdf->sjabloon['totalen'] = New Sjabloon(array(100,36,22,22), array('','R','R','R'), array('LT','TR','LTR','LTR') );
$pdf->sjabloon['totalen']->fillcolor = array(255);
$pdf->sjabloon['totalen']->switchcolor = 0;
$pdf->sjabloon['totalen']->height = 7;

// Variabele kopgegevens 
$pdf->bedrijfsnaam = "OpenAdmin.nl";
$pdf->database = $GLOBALS['config']->data['db']['default'];
$pdf->boekjaar = $stam->lopendjaar['value'];

// set document information
$pdf->SetCreator(PDF_CREATOR);
$pdf->SetAuthor("OpenAdmin.nl");

// set variables with Pagedimensions and Margins
$pdf->Pagedimensions = $pdf->getPageDimensions();
$pdf->Margins = $pdf->getMargins();

// Aantal regular regels waarna een pagebreak wordt ingevoegd
$pdf->maxlines = 36;

?>
