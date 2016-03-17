<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _journaaledit_save.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body .= "\n          <!-- journaaledit_save.inc -->\n";
$render->subtitle[] = 'journaaledit_save.inc';

/*

  In _journaaledit_save.inc wordt het updaten van de metagegevens een journaalpost
  behandeld, dus niet de boekregels van een journaalpost. Dat gebeurt via de route: 
  _journaal.inc -> _journaal_preprocessing.inc -> $post->opslaanLine($p)

  Voorlopig zijn alleen periode, omschrijving en datum te editten. Overige,
  dagboekspecifieke velden als Crediteur, bonnummer, saldo etc nog niet. Dit
  vergt een ingwikkelder logica maar willen we op termijn wel (TODO).

*/

// HOUSEKEEPING
$file = basename(__FILE__);

$jomschrijving = $p->jomschrijving;
$p->datum = trim($p->datum);

$gadoor = true;

// zet de datum goed
//
if(! empty($p->datum)) { 
  $datum = $GLOBALS['timer']->norm2iso($p->datum); 
  $m_datum = $GLOBALS['timer']->norm2iso($p->m_datum); 
}
else {
  $msg['red'][] = "Er is geen (valide) datum ingevuld. Doe dit alsnog!";
  $gadoor = false;
}

// Kijk of de periode veranderd is. Indien waar: kijk of de gewenste periode niet in of voor een geconsolideerde periode ligt.
//
if($p->viewperiode <> $p->m_periode) { // veranderd
  if($p->viewperiode <= $stam->Get_field('MAX("periode")',$stam->btwaangiftes,"\"boekjaar\"='{$stam->boekjaar}'", $file."::".__LINE__)) {
    $msg['red'][] = "De gevraagde periode valt in of voor een geconsolideerde periode!";
    $gadoor = false;
  }
}
printrc2($gadoor, "gadoor: ");
/*
printrc1($p,"p: journaaledit_save.inc\n");
Params Object
(
    [_ADMIN_SID] => a8fai5hbnk9luhgnnqdnkhb7k6
    [aktie] => save
    [id] => 78
    [m_periode] => 1
    [viewperiode] => 1
    [journaalid] => 4
    [datum] => 04-01-2009
    [datumpropageren] => on
    [m_datum] => 03-01-2009
    [jomschrijving] => Kasbetalingen 1e kwartaal 2009
    [periode] => 
)
*/
if($gadoor) { // update
  // bij een update hoeven we een aantal velden eigenlijk niet meer te updaten
  // zoals periode, saldo en joorsprong. Die velden zijn toch al gelockt. We laten het nog
  // even staan voor het geval we een of enkele van deze velden nog vrijgeven, zoals b.v.
  // periode. Maar als we periode achteraf nog willen wijzigen moet er eerst preprocessing
  // overheen plaatsvinden om te zien of de periode waarin we willen wijzigen mss al is 
  // afgesloten.
  $val =<<<EOT
 "datum"='{$datum}'
,"periode"={$p->viewperiode}
,"jomschrijving"='{$jomschrijving}'
EOT;
  $stam->query = "UPDATE {$stam->journaal} SET {$val} WHERE \"journaalid\"={$post->journaalid}";
  if($stam->Do_sql(basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__)) {
    $succes_update = true;

    // Indien datum propageren is ingeschakeld moet de datum ook worden
    // aangepast in de tabellen/records die zijn gerelateerd aan dit
    // journaalid. Dit zijn:
    //   boekregels, inkoopfacturen, pinbetalingen, verkoopfacturen
    if($p->datumpropageren) {

      // verander van de boekregels alleen de data die gelijk zijn aan de
      // journaaldatum. Als er andere data instaan dan zijn die handmatig
      // ingebracht en moeten niet veranderd worden (b.v. regels van een bank-
      // of kasboek).
      $stam->Do_query("UPDATE {$stam->boekregelstbl} SET \"datum\"='{$datum}' WHERE \"journaalid\"={$p->journaalid} AND \"datum\"='{$m_datum}' ", $file."::".__LINE__);

      switch($post->dagboekcode) {
        case 'inkoop' : 
          $stam->Do_query("UPDATE {$stam->inkoopfacturen} SET \"datum\"='{$datum}' WHERE \"journaalid\"={$p->journaalid} ", $file."::".__LINE__);
          break;
        case 'pin' : 
          $stam->Do_query("UPDATE {$stam->pinbetalingen} SET \"datum\"='{$datum}' WHERE \"journaalid\"={$p->journaalid} ", $file."::".__LINE__);
          break;
        case 'verkoop' : 
          $stam->Do_query("UPDATE {$stam->verkoopfacturen} SET \"datum\"='{$datum}' WHERE \"journaalid\"={$p->journaalid} ", $file."::".__LINE__);
          break;
      }
    }

    // Laad het journaalobject opnieuw; het is immers veranderd.
    // Geef als tweede argument true om te zorgen dat het journaalobject geen
    // preprocessing uitvoert, alleen de journaalgegevens laadt.
    $post = reloadPost($post);
  }
}

/* __END__ */
