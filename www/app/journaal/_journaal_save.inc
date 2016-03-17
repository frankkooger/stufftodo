<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _journaal_save.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body .= "\n          <!-- journaal_save.inc -->\n";
$render->title[] = 'Journaalposten opslaan';
$render->subtitle[] = 'journaal_save.inc';
$scriptfile = basename(__FILE__);

/*
  In _journaal_save.inc wordt het nieuw opslaan en updaten van een journaalpost
  behandeld, dus niet de boekregels van een journaalpost. Dat gebeurt via de route: 
  _journaal.inc -> _journaal_preprocessing.inc -> $post->opslaanLine($p)

  De enige boekregels die van hieruit worden opgeslagen zijn die als gevolg van
  de journaalpost zelf b.v. het verschilsaldo van een bankafschriftboeking.  Dus
  alle bedragen die hier binnenkomen en die ertoe doen zijn journaalbedragen en
  evt. het genoemde verschilsaldo (anhankelijk van het dagboektype).

  Zie voor verdere uitleg _journaal_preprocessing.inc

  Alle metagegevens van de journaalpost worden in de journaalpost zelf
  opgeslagen, ook die straks als default waarden aan de boekingsregels worden
  meegegeven. In deze procedure zou het wel kunnen dat bij de verschilsaldo
  boekingsregel al wat default waarden worden meegegeven.
*/

// HOUSEKEEPING

$gadoor = true;
$succes_insert = $succes_update = false;
$lastid = false;
$jrelatiecode = $jrelatieid = $jnummer = $jfactuurbedrag = '';

// escape bomschrijving
$jomschrijving = $p->jomschrijving;
$tekst = $p->tekst;
$p->datum = trim($p->datum);

// zet de datum goed
//
if(! empty($p->datum)) { $datum = $GLOBALS['timer']->norm2iso($p->datum); }
else {
  $msg['red'][] = "Er is geen (valide) datum ingevuld. Doe dit alsnog!";
  $gadoor = false;
}

/*
printrc1($p,"p: journaal_save.inc\n");
p: journaal_save.inc
Params Object
(
    [_ADMIN_SID] => odmjk0tt1m3jght78bb9dn7ao1
    [aktie] => save
    [m_dagboekcode] => inkoop
    [m_dagboektype] => inkoop
    [journaalsaldo] => 
    [btwhoog] => 19
    [btwlaag] => 6
    [dagboekgrootboekrekening] => 
    [boekregel] => 
    [aantalboekregels] => 0
    [periode] => 2
    [dagboekcode] => inkoop
    [overzicht] => 0
    [journaalid] => 
    [viewrelatieid] => 12
    [relatieid] => 
    [viewfactuurnummer] => 5566
    [factuurnummer] => 
    [viewfactuurbedrag] => 75.00
    [factuurbedrag] => 
    [datum] => 17-04-2009
    [jomschrijving] => Dingen 5
    [subaktie] => 
    [journaalpost] => 
    [relatie] => 
    [boorsprong] => 
    [factuurid] => 
    [tekst] => 
    [saldo] => 
    [btw] => 
)
*/

// PREPROCESSING

switch($post->dagboektype) {
  
  case 'begin'    :
    $p->periode = '0';
    break;

  case 'kas'    :
    // We gaan het met kas voorlopig anders doen, geen kasbladen maar elke boeking direct het grootboek in.
    // Daarmee hebben we ook geen dagboeklocks etc. nodig. We hebben nog niet echt goede ideeen voor 
    // kasbladen en het aantal kasboekingen is niet zoveel dus voorlopig maar even direct naar grootboerekening kas.
    /*
    if(empty($p->journaalid)) { // nieuwe journaalpost
      // controleer eerst of er geen slot staat op het dagboek met de gevraagde dagboekcode
      // er mag pas een slot staan als dit journaalpost vers is opgeslagen
      // waarna het nieuwe journaalpost de slot is totdat de journaalpost wordt
      // doorgeboekt naar grootboek kas, waarna de slot pas wordt verwijderd
      if($tmp = $stam->Get_field("slot",$GLOBALS['config']->data['tbl']['dagboeken'],"code='{$post->dagboekcode}'")) { // er is een slot
        $msg['red'][] = "Het dagboek '{$post->dagboekcode}' is gelockt met lock: [{$tmp}]! Deze journaalpost kan niet worden opgeslagen.";
        $gadoor = false;
      }
      else { // niet gelockt, ga door met de procedure
        // in joorsprong vullen we een identifier in die bestaat uit de dagboekcode en het kasbladnummer (boeknummer)
        $joorsprong = $post->dagboekcode." ".$p->boeknummer;
      }
    }
    */
    break;

  case 'bank'    :
    if(empty($p->journaalid)) { // nieuwe journaalpost
      // Indien dit de eerste boeking is en een dagboek van het type bank dan
      // wordt boeknummer en beginsaldo aangeleverd in viewboeknummer en
      // viewbeginsaldo. Zorg dat met deze gegevens kan worden verder gewerkt
      // door ze hier op te slaan in boeknummer en beginsaldo.
      //
      if($p->viewboeknummer) {
        $p->boeknummer = $p->viewboeknummer;
        $p->beginsaldo = $p->viewbeginsaldo;
      }

      // controleer eerst of er geen slot staat op het dagboek met de gevraagde dagboekcode
      // er mag pas een slot staan als dit journaalpost vers is opgeslagen
      // waarna het nieuwe journaalpost de slot is totdat de journaalpost op 0 loopt
      // waarna de slot pas wordt verwijderd.
      // TODO kijk het slotenprincipe nog eens na. 
      //      ook het principe van slot verwijderen bij 0-saldo moeten we nog nader bekijken want we
      //      kunnen ook per ongeluk een 0-saldo realiseren.
      if($tmp = $stam->Get_field("slot",$stam->dagboeken,"code='{$post->dagboekcode}'")) { // er is een slot
        // Geef het journaalpost door en niet alleen het slot (= journaal-id) omdat dat de gebruiker niets zegt
        //
        $journaalpost = $stam->Get_field("journaalpost", $stam->journaal, "\"journaalid\"={$tmp}" ,basename(__FILE__).'::'.__LINE__ );
        $msg['red'][] = "Het dagboek '{$post->dagboekcode}' is gelockt met lock: [{$tmp}]<br/>"
                       ."Deze journaalpost kan niet worden opgeslagen alvorens journaalpost {$journaalpost} is afgerond!";
        $gadoor = false;
      }
      else { // niet gelockt, ga door met de procedure
        // in joorsprong vullen we een identifier in die bestaat uit de dagboekcode en het bankafschriftnummer (boeknummer)
        $joorsprong = $post->dagboekcode." ".$p->boeknummer;
      }
    }
    break;

  case 'inkoop'  :
  case 'verkoop' :
    // bij het inkoop/verkoopboek worden bij een nieuwe journaalpost de velden
    // viewrelatieid/viewfactuurnummer/viewfactuurbedrag aangeleverd
    // bij een bestaande journaalpost staan de values in relatieid/factuurnummer/factuurbedrag
    // omdat de view- velden disabled staan.
    $jrelatieid = (isset($p->viewrelatieid)) ? $p->viewrelatieid : $p->relatieid;
    $jnummer = (isset($p->viewfactuurnummer)) ? $p->viewfactuurnummer : $p->factuurnummer;
    // viewfactuurbedrag hebben we alleen nodig bij het opslaan van een nieuwe journaalpost
    // factuurbedrag hebben we dus nog niet nodig. Mss later als we ook een update van dit type journaalpost
    // overwegen.
    // $jfactuurbedrag = (isset($p->viewfactuurbedrag)) ? $p->viewfactuurbedrag : $p->factuurbedrag;
    // We moeten echter wel het viewfactuurbedrag normaliseren zodat elke type invoer (decimale punten en kommas etc.) kan worden verwerkt.
    $jfactuurbedrag = (isset($p->viewfactuurbedrag)) ? formatInputBedrag($p->viewfactuurbedrag) : 0;
    break;
  case 'pin'     :
    // In pin wordt in viewrelatieid een code aangeleverd: de naam van de firma
    $jrelatiecode = (isset($p->viewrelatieid)) ? $p->viewrelatieid : $p->relatieid;
    $jrelatieid = 0;
    $jnummer = (isset($p->viewfactuurnummer)) ? $p->viewfactuurnummer : $p->factuurnummer;
    $jfactuurbedrag = (isset($p->viewfactuurbedrag)) ? formatInputBedrag($p->viewfactuurbedrag) : 0;
    break;

}
// We moeten nog een keer door het dagboektype heen voor extra selectie binnen inkoop/verkoop/pin
switch($post->dagboektype) {
  case 'inkoop'  :
    $jrelatiecode = $post->relatieCode($jrelatieid, 'crediteuren');
    break;
  case 'verkoop' :
    $jrelatiecode = $post->relatieCode($jrelatieid, 'debiteuren');
    break;
}

// MAIN PROCESSING

// een nieuwe journaalpost wordt gekenmerkt door GEEN p->journaalid
// Sla deze journaalpost nieuw op
//
if(empty($p->journaalid) && $gadoor) {
  // enkele velden zijn niet altijd gevuld (b.v. momenteel bij kasboek)
  empty($joorsprong) and $joorsprong = '';
  // vraag het nieuwst mogelijke journaalid op
  // LET OP: journaalpost 1 moet altijd aan beginbalans worden toegekend. Als de
  // eerste boeking van het nieuwe jaar geen beginbalans is, geef die dan
  // journaalpost 2.
  //
  if(!$GLOBALS['stam']->eersteJournaalpost) { // er is nog geen journaalpost
    $nieuwid = ($post->dagboekcode == 'begin') ? 1 : 2;
  }
  elseif($post->dagboekcode == 'begin') { // er is al wel een journaalpost(en) maar nog geen beginbalans
    $nieuwid = 1;
  }
  else {
    $nieuwid = $stam->Get_field('MAX("journaalpost")',$stam->journaal,"\"boekjaar\"={$stam->boekjaar}" ,basename(__FILE__).'::'.__LINE__ );
    $nieuwid++;
  }
  // Stel de journaalpost samen
  //
  $journaalid = $stam->newId($stam->journaal);
  $saldo = ($p->saldo) ? $p->saldo : '0.00';
  $fields = '("journaalid","journaalpost","boekjaar","datum","periode","dagboekcode","jomschrijving","saldo","jrelatie","jnummer","joorsprong","tekst")';
  $values = "({$journaalid},{$nieuwid}, {$stam->boekjaar}, '{$datum}',{$p->periode},'{$post->dagboekcode}','{$jomschrijving}',
             '{$saldo}','{$jrelatiecode}','{$jnummer}','{$joorsprong}','{$tekst}')";
  $stam->query = "INSERT INTO {$stam->journaal} {$fields} VALUES {$values} ";
  if($stam->Do_sql(basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__)) {
    $lastid = $journaalid;
    $msg['blue'][] = "Toegevoegd: ({$lastid}) - [{$post->dagboekcode}] {$p->jomschrijving}";
    // Laad de nieuwe journaalpost in het post object
    $post->getJournaalpost($lastid);
    $succes_insert = true;
  }
}
else if($gadoor) { // update
  // bij een update hoeven we een aantal velden eigenlijk niet meer te updaten
  // zoals periode, saldo en joorsprong. Die velden zijn toch al gelockt. We laten het nog
  // even staan voor het geval we een of enkele van deze velden nog vrijgeven, zoals b.v.
  // periode. Maar als we periode achteraf nog willen wijzigen moet er eerst preprocessing
  // overheen plaatsvinden om te zien of de periode waarin we willen wijzigen mss al is 
  // afgesloten.
  $saldo = ($p->saldo) ? $p->saldo : '0.00';

  $val =<<<EOT
 "datum"='{$datum}'
,"periode"={$p->periode}
,"jomschrijving"='{$jomschrijving}'
,"saldo"='{$saldo}'
,"jrelatie"='{$jrelatiecode}'
,"jnummer"='{$jnummer}'
,"joorsprong"='{$joorsprong}'
,"tekst"='{$tekst}'
EOT;
  $stam->query = "UPDATE {$stam->journaal} SET {$val} WHERE \"journaalpost\"={$p->journaalpost} AND \"boekjaar\"={$stam->boekjaar}";
  # printbr($stam->query);
  if($stam->Do_sql(basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__)) {
    $p->boekregel = '';
    $succes_update = true;
  }
}


// POSTPROCESSING

switch($post->dagboektype) {
  
  case 'kas'    :
    // Kasboekingen nog even direct naar het grootboek, zie preprocessing
    /*
    if($succes_insert) { // nieuwe journaalpost voor het kasboek
      // er mag nu een slot worden gezet bestaande uit het journaalpost en het saldo en boeknummer mag worden 
      // aangepast aan de nieuwe situatie
      $stam->Do_query("UPDATE {$GLOBALS['config']->data['tbl']['dagboeken']} "
                   ."SET saldo='{$p->huidigsaldo}',boeknummer={$p->boeknummer},slot={$journaalpost} WHERE code='{$post->dagboekcode}'");
      // en er mag een dagboekhistorie regel worden gezet met oude en nieuw saldi en boeknummers
      // check eerst of dit record er al niet is, indien zo: eerst verwijderen
      if($stam->Exist_record($GLOBALS['config']->data['tbl']['dagboekhistorie'],"code={$post->dagboekcode} AND huidigeboeknummer={$p->boeknummer}")) 
        $stam->Delete_record($GLOBALS['config']->data['tbl']['dagboekhistorie'],"code={$post->dagboekcode} AND huidigeboeknummer={$p->boeknummer}");
      $fields = "(code,journaalid,vorigeboeknummer,saldo,huidigeboeknummer,nieuwsaldo)";
      $values = "('{$post->dagboekcode}',{$lastid},{$p->oudboeknummer},'{$p->beginsaldo}',{$p->boeknummer},'{$p->huidigsaldo}')";
      $stam->Do_query("INSERT INTO {$GLOBALS['config']->data['tbl']['dagboekhistorie']} {$fields} VALUES {$values}");
      // maak hier nog geen boekregel voor kas, in tegenstelling tot bankboek
      // het kassaldo wordt tijdens het finale doorboeken van het kasblad naar kas geboekt.
      // TODO we moeten nog nader bepalen hoe we met kasbladen omgaan
    }
    else if($succes_update) { // update journaalpost voor het kasboek
    }
    */
    break;

  case 'bank'    :
    if($succes_insert) { // nieuwe journaalpost voor het bankboek
      // er mag nu een slot worden gezet bestaande uit het journaal-id en het saldo en boeknummer mag worden 
      // aangepast aan de nieuwe situatie
      $stam->Do_query("UPDATE {$stam->dagboeken} "
                   ."SET \"saldo\"='{$p->eindsaldo}',\"boeknummer\"={$p->boeknummer},\"slot\"={$lastid} WHERE \"code\"='{$post->dagboekcode}'", basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__);
      // en er mag een dagboekhistorie regel worden gezet met oude en nieuw saldi en boeknummers
      // check eerst of dit record er al niet is, indien zo: eerst verwijderen
      if($stam->Exist_record($stam->dagboekhistorie,"\"code\"='{$post->dagboekcode}' AND \"huidigeboeknummer\"={$p->boeknummer}")) 
        $stam->Delete_record($stam->dagboekhistorie,"\"code\"='{$post->dagboekcode}' AND \"huidigeboeknummer\"={$p->boeknummer}");
      $fields = '("code","journaalid","vorigeboeknummer","saldo","huidigeboeknummer","nieuwsaldo")';
      $values = "('{$post->dagboekcode}',{$lastid},{$p->oudboeknummer},'{$p->beginsaldo}',{$p->boeknummer},'{$p->eindsaldo}')";
      $stam->Do_query("INSERT INTO {$stam->dagboekhistorie} {$fields} VALUES {$values}", $scriptfile."::".__FUNCTION__."::".__LINE__);
      // maak nu een boekregel voor bank
      // draai het saldo niet om (zie uitleg in _journaal_preprocessing.inc)
      $p->journaalid = $lastid;
      $p->boekdatum = $p->datum;
      $p->bomschrijving = $p->jomschrijving;
      $p->boekregelbedrag = ($p->saldo) ? $p->saldo : '0.00';
      $p->grootboekrekening = $stam->Get_field("grootboekrekening",$stam->dagboeken,"\"code\"='{$post->dagboekcode}'" ,basename(__FILE__).'::'.__LINE__ );
      $post->opslaanLine($p);
    }
    else if($succes_update) { // update journaalpost voor het bankboek
      // als de metagegevens van de journaalpost zijn verander (kan alleen datum en/of omschrijving zijn)
      // dan die gegevens ook veranderen in de boekregel van de default bank-journaalpost
      $grootboekrekening = $stam->Get_field("grootboekrekening",$stam->dagboeken,"code='{$post->dagboekcode}'" ,basename(__FILE__).'::'.__LINE__ );
      $boekregelid = $stam->Get_field("boekregelid", $stam->boekregelstbl, "\"journaalid\"={$p->journaalid} AND \"grootboekrekening\"={$grootboekrekening} AND \"boekjaar\"={$stam->boekjaar}" 
          ,basename(__FILE__).'::'.__LINE__ );
      if($stam->Do_query("UPDATE {$stam->boekregelstbl} SET \"datum\"='{$datum}',\"bomschrijving\"='{$jomschrijving}' WHERE \"boekregelid\"={$boekregelid} AND \"boekjaar\"={$stam->boekjaar}"
            ,basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__));
        $GLOBALS['msg']['blue'][] = "Gegevens boekregel: {$boekregelid}, grootboekrekening: {$grootboekrekening} zijn ook aangepast.";
    }
    break;

  case 'inkoop'    :
    if($succes_insert) { // nieuwe journaalpost voor het inkoopboek
      // schrijf deze factuur bij in inkoopfacturen als factuurnr en relatie zijn gezet
      if($jrelatieid && $jnummer) {
        $id = $stam->newId($stam->inkoopfacturen);
        $fields = '("id","journaalid","boekjaar","datum","omschrijving","factuurbedrag","relatiecode","relatieid","factuurnummer")';
        $values = "({$id},{$lastid},{$stam->boekjaar}, '{$datum}','{$jomschrijving}','{$jfactuurbedrag}',
                   '{$jrelatiecode}',{$jrelatieid},'{$jnummer}')";
        if($stam->Do_query("INSERT INTO {$stam->inkoopfacturen} {$fields} VALUES {$values}", $scriptfile."::".__FUNCTION__."::".__LINE__))
          $msg['blue'][] = "Inkoopfactuur bijgeschreven: {$jrelatiecode}, {$jnummer}, ".formatbedrag($jfactuurbedrag);
        // maak nu een boekregel voor crediteuren
        // draai het saldo om (zie uitleg in _journaal_preprocessing.inc)
        $p->journaalid = $lastid;
        $p->boekdatum = $p->datum;
        $p->bomschrijving = $p->jomschrijving;
        $p->boekregelbedrag = $jfactuurbedrag * -1;
        $p->relatiecode = $jrelatiecode;
        $p->factuurnummer = $jnummer;
        $p->grootboekrekening = $stam->Get_field("grootboekrekening",$stam->dagboeken,"\"code\"='{$post->dagboekcode}'" ,basename(__FILE__).'::'.__LINE__ );
        $post->opslaanLine($p);
      }
    }
    break;

  case 'verkoop'    :
    if($succes_insert) { // nieuwe journaalpost voor het verkoopboek
      // schrijf deze factuur bij in verkoopfacturen als factuurnr en relatie zijn gezet
      if($jrelatieid && $jnummer) {
        $id = $stam->newId($stam->verkoopfacturen);
        $fields = '("id","journaalid","boekjaar","datum","omschrijving","factuurbedrag","relatiecode","relatieid","factuurnummer")';
        $values = "({$id},{$lastid},{$stam->boekjaar}, '{$datum}','{$jomschrijving}','{$jfactuurbedrag}',
                   '{$jrelatiecode}',{$jrelatieid},'{$jnummer}')";
        if($stam->Do_query("INSERT INTO {$stam->verkoopfacturen} {$fields} VALUES {$values}", $scriptfile."::".__FUNCTION__."::".__LINE__))
          $msg['blue'][] = "Verkoopfactuur bijgeschreven: {$jrelatiecode}, {$jnummer}, ".formatbedrag($jfactuurbedrag);
        // maak nu een boekregel voor crediteuren
        // draai het saldo niet om (zie uitleg in _journaal_preprocessing.inc)
        $p->journaalid = $lastid;
        $p->boekdatum = $p->datum;
        $p->bomschrijving = $p->jomschrijving;
        $p->boekregelbedrag = $jfactuurbedrag;
        $p->relatiecode = $jrelatiecode;
        $p->factuurnummer = $jnummer;
        $p->grootboekrekening = $stam->Get_field("grootboekrekening",$stam->dagboeken,"\"code\"='{$post->dagboekcode}'" ,basename(__FILE__).'::'.__LINE__ );
        $post->opslaanLine($p);
      }
    }
    break;

  case 'pin'    : // gebaseerd op inkoop
    if($succes_insert) { // nieuwe journaalpost voor het boek pinbetalingen
      // factuurnr en relatie hoeven hier niet verplicht te zijn gezet
      # if($jrelatieid && $jnummer) {
      
      if($id = $stam->newId($stam->pinbetalingen)) {
        $fields = '("id","journaalid","boekjaar","datum","omschrijving","factuurbedrag","relatiecode","relatieid","factuurnummer")';
        $values = "({$id},{$lastid},{$stam->boekjaar}, '{$datum}','{$jomschrijving}','{$jfactuurbedrag}',
                   '{$jrelatiecode}',{$jrelatieid},'{$jnummer}')";
        if($stam->Do_query("INSERT INTO {$stam->pinbetalingen} {$fields} VALUES {$values}", $scriptfile."::".__FUNCTION__."::".__LINE__))
          $msg['blue'][] = "Pinbetaling bijgeschreven: {$jnummer}, ".formatbedrag($jfactuurbedrag);
        // maak nu een boekregel voor crediteuren
        // draai het saldo om (zie uitleg in _journaal_preprocessing.inc)
        $p->journaalid = $lastid;
        $p->boekdatum = $p->datum;
        $p->bomschrijving = $p->jomschrijving;
        $p->boekregelbedrag = $jfactuurbedrag * -1;
        $p->relatiecode = $jrelatiecode;
        $p->factuurnummer = $jnummer;
        $p->grootboekrekening = $stam->Get_field("grootboekrekening",$stam->dagboeken,"\"code\"='{$post->dagboekcode}'" ,basename(__FILE__).'::'.__LINE__ );
        $post->opslaanLine($p);
      }
    }
    break;

}

/* __END__ */
