<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: _saldibalanssjablonen.inc 200 2011-07-23 09:07:14Z otto $
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

// lettertype in tekst:
$pdf->fonttype = "dejavusans";
$pdf->fontsize = '9';

// lettertype in header !!Kan niet in sjablonen omdat dit na initialize moet gebeuren.
#$pdf->headerfonttype = "dejavusans";
#$pdf->headerfontsize = '9';

$pdf->sjabloon['header'] = New Sjabloon(array(20,100,30,30), array('C','C','C','C'), array('1','1','1','1') );
$pdf->sjabloon['header']->fillspotcolor = 'Pantone 658 C';
$pdf->sjabloon['header']->textcolor = array(0);
$pdf->sjabloon['header']->height = 7;

$pdf->sjabloon['regular'] = New Sjabloon(array(20,100,30,30), array('C','','R','R'), array('LR','LR','LR','LR') );
$pdf->sjabloon['regular']->fillcolor = array(224, 235, 255);
$pdf->sjabloon['regular']->switchcolor = 1;
$pdf->sjabloon['regular']->height = 6;

$pdf->sjabloon['totaalkaart'] = New Sjabloon(array(20,70,30,30,30), array('C','','R'), array('LR','LR','R','LR','LR') );
$pdf->sjabloon['totaalkaart']->fillcolor = array(195);
$pdf->sjabloon['totaalkaart']->switchcolor = 0;
$pdf->sjabloon['totaalkaart']->height = 6;

$pdf->sjabloon['totalen'] = New Sjabloon(array(120,30,30), array('R','R','R'), array('LTR','LTR','LTR') );
$pdf->sjabloon['totalen']->fillcolor = array(255);
$pdf->sjabloon['totalen']->switchcolor = 0;
$pdf->sjabloon['totalen']->height = 7;

// Variabele kopgegevens 
$pdf->bedrijfsnaam = $stam->adminnaam['value']; 
$pdf->database = $GLOBALS['config']->data['db']['default'];
$pdf->boekjaar = $stam->lopendjaar['value'];

// set document information
$pdf->SetCreator(PDF_CREATOR);
$pdf->SetAuthor($stam->adminnaam['value']);

// set variables with Pagedimensions and Margins
$pdf->Pagedimensions = $pdf->getPageDimensions();
$pdf->Margins = $pdf->getMargins();

// Aantal regular regels waarna een pagebreak wordt ingevoegd
$pdf->maxlines = 36;

?>
