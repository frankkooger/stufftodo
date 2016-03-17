<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _facturenblok.inc 215 2011-09-25 18:54:41Z otto $
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

// Dit script wordt ingelezen vanuit _crediteurenstam.inc en _crediteurenschema_print.inc
// als in dat script de optie 'facturen' wordt geactiveerd.
// Het toont dan per crediteur het totaaloverzicht aan facturen plus de betalingsstatus ervan.
//

    // Roep de facturen van deze crediteur. Geef het WHERE criterium volledig mee
    //
    $farr = $crediteur->fetchFacturen("WHERE \"relatieid\"=".$id);

/*
printrc1($farr);
Array
(
[0] => stdClass Object
    (
        [crediteurid] => 7
        [code] => apple
        [naam] => Apple Sales International
        [factuurid] => 8
        [journaalid] => 18
        [datum] => 2008-06-04
        [omschrijving] => IMac SN.VM823WHT0KM
        [factuurbedrag] => 2047.99
        [relatiecode] => apple
        [relatieid] => 7
        [factuurnummer] => 9044011895
        [voldaan] => 2047.99
        [betaaldatum] => 2008-06-04
    )
*/
    $openstaand = $ouder0 = $ouder1 = $ouder3 = $tomzet = 0;
    $omzet = array();
    $currency = false;

    foreach($farr AS $fobj) {

      // Bereken de omzetbedragen per jaar en totaal
      //
      preg_match("/([\d]{4})/",$fobj->datum,$ar);
      if(isset($omzet[$ar[1]])) $omzet[$ar[1]] += $fobj->factuurbedrag;
      else                      $omzet[$ar[1]] = $fobj->factuurbedrag;
      // totaalomzet
      $tomzet += $fobj->factuurbedrag;

      // Bereken de openstaande bedragen
      //
      if($verschil = ($fobj->factuurbedrag - $fobj->voldaan) <> 0) { // er is een saldo
        $voldaan = formatbedrag($fobj->voldaan,$nul=true,$currency);
        $openstaand += ($fobj->factuurbedrag - $fobj->voldaan);
        switch($diff = $stam->Get_datediff($fobj->datum)) {
          case ($diff === 0)               : // moet erbij voor facturen van dezelfde dag, anders belanden ze bij na1mnd
          case ($diff <= 30)               : $ouder0 += ($fobj->factuurbedrag - $fobj->voldaan); break;
          case ($diff > 30 && $diff <= 90) : $ouder1 += ($fobj->factuurbedrag - $fobj->voldaan); break;
          case ($diff > 90)                : $ouder3 += ($fobj->factuurbedrag - $fobj->voldaan); break;
        }
      }
      else {
        $voldaan = $GLOBALS['timer']->iso2norm($fobj->betaaldatum);
      }
          
    // PRINT DE FACTUUR
    //

    $form->fieldSetBridge("Factuurnr: {$fobj->factuurnummer}");

      $form->blockLine('',
                       array(
                             "<div class='schemarow_std'>Datum: ".$GLOBALS['timer']->iso2norm($fobj->datum)."</div>"
                            ,"<div class='schemarow_std'>Bedrag: ".formatbedrag($fobj->factuurbedrag,$nul=true,$currency)."</div>"
                            ,"<div class='schemarow_std'>Voldaan: {$voldaan}</div>"
                             ), 
                       array(
                             "width='33%'"
                            ,"width='33%'"
                            ,"width='33%'"
                             ) );

          
      $form->blockLine('',
                       array(
                             "<div class='schemarow_std'>Omschrijving: {$fobj->omschrijving}</div>"
                             ), 
                       array(
                             "width='100%', colspan='4'"
                             ) );

    } // END FOREACH fobj

    // OPENSTAAND SALDO
    //
    $fieldarray = array("width='23%'","width='23%'","width='53%'");

    $form->fieldSetBridge("Saldo");

      $form->blockLine('',
                       array(
                             "<div class='schemarow_std'>Openstaand: </div>"
                            ,"<div class='schemarow_std' style='text-align:right'>".formatbedrag($openstaand,true,$currency)."</div>"
                            ,"<div class='schemarow_std'></div>"
                             ), 
                       $fieldarray
                      );

      $form->blockLine('#a9d0ff',
                       array(
                             "<div class='schemarow_std'>Jonger dan 1mnd: </div>"
                            ,"<div class='schemarow_std' style='text-align:right'>".formatbedrag($ouder0,'',$currency)."</div>"
                            ,"<div class='schemarow_std'></div>"
                             ), 
                       $fieldarray
                      );
      
    $ouder1 <> 0 and $fontcolor1 = "#edbbbb" or $fontcolor1 = '';
    
      $form->blockLine("#edbbbb",
                       array(
                             "<div class='schemarow_std'>Ouder dan 1mnd: </div>"
                            ,"<div class='schemarow_std' style='text-align:right'>".formatbedrag($ouder1,'',$currency)."</div>"
                            ,"<div class='schemarow_std'></div>"
                             ), 
                       $fieldarray
                      );

    $ouder3 <> 0 and $fontcolor3 = "#ed9f9f" or $fontcolor3 = '';
    
      $form->blockLine("#ed9f9f",
                       array(
                             "<div class='schemarow_std'>Ouder dan 3mnd: </div>"
                            ,"<div class='schemarow_std' style='text-align:right'>".formatbedrag($ouder3,'',$currency)."</div>"
                            ,"<div class='schemarow_std'></div>"
                             ), 
                       $fieldarray
                      );

printrc2($omzet, "omzet: ");
    // OMZETTEN
    //

    if(count($omzet)) { // er zijn omzetbedragen

      ksort($omzet);

      $form->fieldSetBridge("Omzet (incl.BTW)");

      foreach($omzet AS $jaar=>$bedrag) 

        $form->blockLine('',
                         array(
                               "<div class='schemarow_std'>Jaar: ".$jaar."</div>"
                              ,"<div class='schemarow_std' style='text-align:right'>".formatbedrag($bedrag,$nul=true,$currency)."</div>"
                              ,"<div class='schemarow_std'></div>"
                               ), 
                         $fieldarray
                        );

      // Totaalomzet

        $form->blockLine('#a9d0ff',
                         array(
                               "<div class='schemarow_std'>Totaalomzet:</div>"
                              ,"<div class='schemarow_std' style='text-align:right'>".formatbedrag($tomzet,$nul=true,$currency)."</div>"
                              ,"<div class='schemarow_std'></div>"
                               ), 
                         $fieldarray
                        );


    } // END IF count(omzet)

    // Spacerline
    //
    $form->fieldSetBridge("");

?>
