<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _jaarafsluiting_save.inc 289 2015-01-04 09:09:40Z otto $
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

$render->body .= "\n          <!-- jaarafsluiting_save.inc -->\n";
$render->subtitle[] = "jaarafsluiting_save.inc";

switch($p->aktie) {

  case 'herstelsaldi': // herstel grootboeksaldi manually zonder dat iets met statussen verandert.
    require_once("_grootboek.lib");
    $grootboek = new Grootboek();
printrc2($p, 'ben in herstelsaldi');
    if($grootboek->aanmakenSaldi()) {
printrc2($p, 'BEN in herstelsaldi');
      $GLOBALS['msg']['blue'][] = "Grootboeksaldi hersteld.";
    }
//    die;
    break;

  case 'check'  :
   
    switch($p->item) {

      case 'memoriaal'        :
        // 
        $p->aktie = 'change';
        break;

      case 'consolidatie'     : // controleer of alle periodes zijn geconsolideerd
        $max = $stam->Get_field('MAX("periode")', $stam->btwaangiftes,"\"boekjaar\"={$boekjaar}", basename(__FILE__).'::'.__LINE__ );
        if($max==$stam->periodetot['value']) $p->aktie = 'change';
        else {
          $msg['red'][] = "Nog niet alle btw-aangifteperiodes zijn geconsolideerd! Doe dit eerst.";
        }
        break;

      case 'backup'     : // Maak een backup van de huidige administratie
        require_once("_functions.{$GLOBALS['config']->data['db']['driver']}.inc");
        // Doe een dbaseDump met naam van de huidig administratie
        //
        $host = ($GLOBALS['config']->data['db']['host'] != 'localhost') ? $GLOBALS['config']->data['db']['host'] : '';
        $logregel = "Laatste backup voor eindejaarsafsluiting van deze administratie.";
        $bufile = dbaseDump($GLOBALS['config']->data['db']['default'], $logregel, $host, "{$boekjaar}1231-2359");
        $msg['blue'][] = "Backup gemaakt: ".$bufile;
        $p->aktie = 'change';
        break;

      case 'herstel'     : // draai een herstel grootboeksaldi voor het geval er iets niet is goed gegaan in het bijhouden van de saldi tijdens het boeken.
        require_once("_grootboek.lib");
        $grootboek = new Grootboek();
        // We gebruiken aanmakenSaldi omdat dit van boekingen uitgaat die het
        // vind op boekregels, dus daar kunnen ook nulsaldi rekeningen bij zijn
        // die anders wellicht niet gevonden worden. We gaan dus niet uit van
        // de salditabel (daar kunnen rekeningen nog niet opstaan) of de
        // grootboekstamtabel (daarop staan teveel rekeningen, ook die nooit
        // gebruikt zijn gedurende het boekjaar).
        //
        if($grootboek->aanmakenSaldi()) {
          $GLOBALS['msg']['blue'][] = "Grootboeksaldi hersteld.";
          $p->aktie = 'change';
        }
        break;

      case 'balansen'     : // Maak een uitdraai van proef- en saldibalansen
        $p->aktie = 'change';
        break;

      case 'grootboekkaarten'     : // Maak een uitdraai van de grootboekkaarten
        $p->aktie = 'change';
        break;

      case 'eindbalans'     : // Leg debet, credit en saldo vast in eindejaarsregels
        require_once("_eindejaar.lib");
        $eindejaar = new Eindejaar();
        if($eindejaar->eindbalansBoeking()) {
          $GLOBALS['msg']['blue'][] = "Eind proef- en saldibalans vastgelegd.";
          $p->aktie = 'change';
        }
        break;

      case 'kapitaal'     : // Maak de journaalboeking winst/verlies naar Kapitaal 
        // Deze case werkt niet!!
        // Hiermee boeken we posten op een administratie die al afgesloten is.
        // Dat geeft een hoop heisa en inconsistenties. We slaan deze case over
        // en doen de Kapitaalberekeningen (prive rekeningcourant en
        // balanssaldo naar kapitaal) tijdens het maken van de beginbalans in
        // de volgende case. 
        $p->aktie = 'change';
        break;
        
        require_once("_eindejaar.lib");
        $eindejaar = new Eindejaar();
        if($eindejaar->kapitaalBoeking()) {
          $GLOBALS['msg']['blue'][] = "Kapitaalboekingen gepleegd.";
          $p->aktie = 'change';
        }
        else
          $GLOBALS['msg']['blue'][] = "Kapitaalboekingen NIET gepleegd!";
        break;

      case 'beginbalans'     : // Maak de journaalboeking van de beginbalans nieuwe jaar
        require_once("_eindejaar.lib");
        $eindejaar = new Eindejaar();
        if($eindejaar->beginbalansBoeking()) {
          $GLOBALS['msg']['blue'][] = "Beginbalans voor het nieuwe jaar geboekt.";
          $p->aktie = 'change';
        }
        break;

    }

} // END switch aktie


// Onderstaande aktie switch't de knopkleur
//
if($p->aktie == 'change') {
   
    switch($p->subaktie) {
      case 'greenlit'  :
        $stam->Do_query("UPDATE {$stam->eindcheck} SET \"value\"=".RED." WHERE \"naam\"='{$p->item}' AND \"boekjaar\"='{$boekjaar}'", basename(__FILE__).'::'.__LINE__ ); break;
      case 'red'  :
        $stam->Do_query("UPDATE {$stam->eindcheck} SET \"value\"=".GREENLIT." WHERE \"naam\"='{$p->item}' AND \"boekjaar\"='{$boekjaar}'", basename(__FILE__).'::'.__LINE__ );  break;
      case 'bluelit'  :
        $stam->Do_query("UPDATE {$stam->eindcheck} SET \"value\"=".BLUE." WHERE \"naam\"='{$p->item}' AND \"boekjaar\"='{$boekjaar}'", basename(__FILE__).'::'.__LINE__ );  break;
      case 'blue'  :
        $stam->Do_query("UPDATE {$stam->eindcheck} SET \"value\"=".BLUELIT." WHERE \"naam\"='{$p->item}' AND \"boekjaar\"='{$boekjaar}'", basename(__FILE__).'::'.__LINE__ );  break;
    }

} // END IF aktie==change

/* __END__ */
