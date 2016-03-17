<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _grootboekstam_save.inc 287 2014-12-13 18:02:02Z frank $
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

$render->body .= "\n          <!-- grootboekstam_save.inc -->\n";
$render->subtitle[] = "grootboekstam_save.inc";

//
// fetch alleen de post parms
//
$p = new Params(array(
                       "nummer"=>''
                      ,"kostenplaats"=>''
                      ,"type"=>0
                      ,"nivo"=>0
                      ,"btwdefault"=>5
                      ,"naam"=>""
                      ,"c_nummer"=>''
                      ,"c_kostenplaats"=>''
                      ,"c_type"=>''
                      ,"c_nivo"=>''
                      ,"c_btwdefault"=>''
                      ,"c_btwkey"=>''
                      ,"c_naam"=>''
                      ,"m_nummer"=>0
), "_POST", $clean=true, $quote="{$GLOBALS['config']->data['db']['driver']}" );

/*
Korte uitleg bij binnenkomende parameters
- $p->nummer:      is het nummer dat in het scherm getoond werd, mits dat niet disabled was
- $p-><item>:      value van het item, mits niet disabled (nummer is ook een item maar wordt hierboven even apart genoemd)
- $p->c_<item>:    'change' parms; true indien het <item> is veranderd
- $p->m_nummer:    is het 'geheugen' voor het nummer dat in het scherm getoond werd
- $p->overzicht:   is het resultaat van wisselen van de selectiebox. Is in save niet van belang want dat wordt alleen geactiveerd door de knop 'opslaan'
*/

printrc1($p, "p in save: ");

// als 'nummer' niet is gezet (dus ''), dan is wss het inputveld 'nummer' disabled.
// gebruik in dat geval 'm_nummer'
//
if(! $p->nummer && ! empty($p->m_nummer)) $p->nummer = $p->m_nummer;
//
// Op dit punt is er dus altijd een $p->nummer beschikbaar behalve als het
// nummer veld ook leeg was maar dan kan niet opgeslagen worden, daar zorgt js
// voor. Het veld kan wel de waarde '0' hebben indien gebruiker dit invult.

$toupdate = false;
$toupdateNummer = false;

// Is het nummer 0?
//
if($p->nummer == 0) {
  $p->nummer = $p->m_nummer;
  $msg['red'][] = "Het nummer mag geen 0 zijn!";
}
elseif(! preg_match("/^[\d]{1,6}$/", $p->nummer) ) {
  $p->nummer = $p->m_nummer;
  $msg['red'][] = "Het nummer moet 1 tot max 6 cijfers bevatten en geen andere tekens!";
  $render->onload .= "document.forms['frm1'].nummer.focus();";
}
elseif(! empty($p->m_nummer) && ($p->m_nummer <> $p->nummer) ) { // er was een bestaand nummer geladen; dit is dus een update conditie van een
                                // bestaand nummer naar een nieuw
printrc2($p->m_nummer, 'hieperdepiep');
  if($grootboek->ExistsNieuwNummer($p->nummer)) {
    //
    // het nummer het bestaat al, mag niet veranderd worden.
    //
    $render->onload .= "document.forms['frm1'].nummer.focus();";
    //
    // vergeet weer het nieuw gevraagde nummer anders wordt dat nieuw gevraagde nummer dadelijk geladen in het form
    //
    $p->nummer = $p->m_nummer;
  }
  else { 
    if($p->nummer && $p->naam) { // controles accoord, sla op als update
      $toupdateNummer = true;
    }
  }
}
else if( empty($p->m_nummer) && $p->nummer && $p->naam) { // sla op als nieuw
printrc2($p->m_nummer, 'kutterdekut');
  if($grootboek->ExistsNieuwNummer($p->nummer)) {
    //
    // het nummer het bestaat al, mag niet opgeslagen worden.
    //
    $render->onload .= "document.forms['frm1'].nummer.focus();";
    //
    // vergeet weer het nieuw gevraagde nummer anders wordt dat nieuw gevraagde nummer dadelijk geladen in het form
    //
    $p->nummer = $p->m_nummer;
  }
  else { // sla op als nieuw
    $grootboek->insertKaart($p);
printrc2($p->m_nummer, 'kloterdekloot, nieuw nummer');
  }
}
else { // normale update
printrc2($p->m_nummer, 'tieterdetiet, normale update');
  $toupdate = true;
}


printrc2($toupdate, "toupdate staat nu toch op false?!");
if($toupdateNummer) {
  //
  // Als het nummer is veranderd, moet de aparte veranderRekeningnummer
  // procedure worden aangeroepen omdat het nummer in meerdere tabellen (kan)
  // voorkomt!
  //
  if($p->c_nummer) { // Het nummerveld is veranderd
    // Controleer of het echt veranderd is

    if($p->nummer <> $p->m_nummer) { // echt veranderd
      //
      // Als de kaart uit een eerder boekjaar komt, maak een nieuwe kaart
      // en delete de oude (delete wil zeggen: kopieer de oude in het huidige jaar
      // en zet active=0)
      // LET OP: als er boekingen, saldo etc op de kaart van het oude nummer
      // staat, moeten we na de nieuwe kaart gemaakt te hebben, het oude nummer
      // in de tabellen voor het huidige boekjaar wel updaten.
      //
      // Omdat er mutaties kunnen zijn op het oude nummer, tevens de nummer-verander
      // procedure draaien.
      //

      if($p->historie < $stam->boekjaar) {
        $grootboek->insertKaart($p);
        if($grootboek->veranderRekeningnummer($p->m_nummer, $p->nummer)) {
          // $p bevat het nieuwe nummer. Om de oude kaart te deleten moet het oude nummer 
          // weer even terug in $p
          $temp = $p->nummer;
          $p->nummer = $p->m_nummer;
printrc2($p, 'Ga lekker deleten voor update: ');
          $grootboek->deleteKaart($p);
          $p->nummer = $temp;
        }
      }
      else { // de kaart is uit het huidige jaar
        if(!$grootboek->veranderRekeningnummer($p->m_nummer, $p->nummer, $grootboekOok=true)) { // Indien fout
          $GLOBALS['msg']['red'][] = "Gevraagde grootboekrekeningnummer {$p->nummer} bestaat al!";
          $render->onload .= "document.forms['frm1'].nummer.focus();";
          // vergeet tevens weer het nieuw gevraagde nummer anders wordt dat nieuw gevraagde nummer dadelijk geladen in het form
          $p->nummer = $p->m_nummer;
        }
      }
    }
  }
} // END if toupdateNummer
else if($toupdate) {
  // Update alleen als er iets veranderd is, anders dan het nummer.
  // Als de grootboekkaart uit een eerder boekjaar komt dan betekent 
  // de update: een nieuwe grootboekkaart maken met de gewijzgide
  // gegevens (wel hetzelfde nummer) en het huidige boekjaar.
  // Is de grootboekkaart van dit jaar of een nieuwer, dan gewoon updaten.
  //
  $tmp = '';
  if($p->c_type)          { $tmp .= ",\"type\"={$p->type}";}
  if($p->c_nivo)          { $tmp .= ",\"nivo\"={$p->nivo}"; }
  if($p->c_btwkey)        { $tmp .= ",\"btwkey\"='{$p->btwkey}'"; }
  if($p->c_btwdefault)    { $tmp .= ",\"btwdefault\"='{$p->btwdefault}'"; }
  if($p->c_naam)          { $tmp .= ",\"naam\"='{$p->naam}'"; }
  if($p->c_kostenplaats)  { $tmp .= ",\"kostenplaats\"='{$p->kostenplaats}'"; }
  if($tmp) {
    if($p->historie < $stam->boekjaar)
      $grootboek->insertKaart($p);
    else {
      $tmp = substr($tmp,1);

      // Sqlite wil in ieder geval geen aliasen in de UPDATE syntax.
      // Mssch andere drivers ook niet; dat moeten we nog testen
      if($GLOBALS['config']->data['db']['driver'] == 'sqlite') {
        // bepaal het id van de grootboekkaart
        $boekregelid = $stam->Get_Field('id', 'vw_grootboekstam', "\"nummer\"={$p->nummer}", basename(__FILE__).'::'.__LINE__);
        $stam->Do_query("UPDATE {$stam->grootboekstamtbl} SET {$tmp} WHERE \"id\"='{$boekregelid}' ",'',basename(__FILE__).'::'.__LINE__);
      }
      // Onderstaande syntax is accoord voor mysql en postgresql
      else {
        $stam->query =<<<EOT
          UPDATE {$stam->grootboekstamtbl} SET {$tmp} WHERE 
          "id"=(SELECT * FROM(SELECT id FROM "vw_grootboekstam" WHERE "nummer"={$p->nummer}) As temp);
EOT;
      }
      $stam->Do_sql(basename(__FILE__)."::".__FUNCTION__."::".__LINE__);
    }
  }

}


/* __END__ */
