<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _journaal_preprocessing.inc 215 2011-09-25 18:54:41Z otto $
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

$render->body .= "\n          <!-- journaal_preprocessing.inc -->\n";
$render->subtitle[] = 'journaal_preprocessing.inc';

// Een 'post' journaalobject wordt default geladen in de starter


/*
   Journaalposten die uit het journaal-formulier komen om nieuw op te slaan of
   te updaten gaan door _journaal_save.inc. Daarin wordt de metadata van de
   journaalpost opgeslagen in tabel journaal en eventuele boekregels die uit de
   journaalpost voortvloeien (een verschilsaldo bij een bankboeking b.v.)
   worden direct vanuit _journaal_save.inc aangeboden aan
   $post->opslaanLine($p).

   Boekregels die uit het journaal-formulier komen om nieuw op te slaan of te
   updaten worden vanuit _journaal.inc aangeboden aan $post->opslaanLine($p).
   De data moet echter worden ge-preprocessed om op een eenduidige wijze aan
   opslaanLine te kunnen aanbieden.  Met name bedragen worden in de juiste
   polariteit geplaatst. Dat gebeurt per dagboektype op een verschillende
   manier. Bij 'memo' wordt een 'echte' journaalpost ingegeven maar bij 'bank'
   en 'kas' worden de boekingen vanuit het perspectief van een bankafschrift of
   een kasblad gedaan.  Dat wil zeggen:

   Memo journaalpost: 
   ==================

   Dit is de standaard situatie. In principe kan je een hele boekhouding voeren
   met alleen maar memo-journaalposten maar dat zou betekenen dat je elke regel
   op een bankafschrift ook als aparte memo-journaalpost zou moeten boeken, zoals
   onderstaand voorbeeld.
 
     GRB.  OMSCHRIJVING                         DEBET    CREDIT
     ----  -------------------------------   --------  --------
     4610  Uitgegeven aan schrijfwaren          10,50
     2200  Te ontvangen BTW                      2,00
     1050  Per bank betaald                               12,50
 
   Een bedrag dat hier dus via de debetkolom binnenkomt wordt ook debet geboekt op
   betreffende grootboekrekening en wordt ook debet gesaldeerd op het groottotaal
   saldo van de grootboekstamrekening.

   Bankafschrift:
   ==============

     GRB.  OMSCHRIJVING                     ONTVANGEN   BETAALD  SALDO_VERSCHIL   
     ----  -------------------------------   --------  --------  --------------
     1050  Saldo verschil naar bank                                      -12,50
     4610  Uitgegeven aan schrijfwaren                    10,50
     2200  Te ontvangen BTW                                2,00
 
   Je boekt hier dus precies andersom, zoals het op het bankafschrift staat:
   ontvangsten en uitgaven naar en van je bankrekening. 
   Bij dit type dagboek moet de polariteit van de binnengekomen bedragen uit de
   debet en creditkolom worden omgedraaid alvorens het verder gebruikt wordt om 
   boekregels mee te maken en grootboekstamsaldi bij te werken.
 
   Omdat het uitgavebedrag (10,50) aan de creditzijde wordt geboekt, is ook het
   geassembleerde btw bedrag een negatief bedrag. Ook dit moet dus gepolariseerd
   worden alvorens het aan opslaanLine wordt aangeboden als '$p->btwboekregelbedrag'.
   Het verschilsaldo boek je niet zelf en wordt automatisch geboekt tijdens het
   aanmaken van een nieuwe bank-journaalpost (= bankafschrift). Dit saldo is het
   verschil tussen het vorige banksaldo en het nieuwe eindsaldo dat op je rekening-
   afschrift voorkomt en dat je in de nieuwe journaalpost ingeeft. De polariteit van
   dit saldo is wel juist dus als dit als basis voor de boekregel naar bank wordt
   gebruikt dan moet de polariteit niet worden omgedraaid.
 
   Dit saldo wordt opgeslagen in post-processing van _journaal_save.inc nadat het
   nummer van de nieuwe journaalpost bekend is geworden door het opslaan van de
   nieuwe journaalpost. Belangrijk is dat vanuit die post-processing het bedrag ook
   als '$p->boekregelbedrag' aan $post->opslaanLine($p) wordt aangeboden (zie verderop).
 
   Kasblad:
   ========

   TODO dit moeten we nog nader bekijken
        Voorlopig maken we geen kasbladen maar gaat elke kasboeking direct het grootboek in.
        Dat moet maar even tot we een modus hebben gevonden voor kasbladen en het aantal
        boekingen is toch nog niet zo groot dus het moet maar even.
        De kasboeklayout is dus gewoon een memoriaal layout, ook de headerline (dus geen
        ontvangsten/uitgaven als in bank maar debet/credit)

  *   28-10-08
  *   We gaan voor kas toch een kasblad maken maar niet met een begin en
  *   eindsaldo dat op elkaar moet aansluiten en waarvoor een lock van het
  *   dagboek nodig is zolang nog een 'open' journaalpost bestaat. Het saldo
  *   van het kasblad wordt gewoon op de grootboekrekeing 'kas' geboekt bij het
  *   afronden van het kasblad. Daardoor komt de kasbladafhandeling grotendeels
  *   overeen met die van het bankboek.

     GRB.  OMSCHRIJVING                     ONTVANGEN   BETAALD  SALDO_VERSCHIL   
     ----  -------------------------------   --------  --------  --------------
     1000  Saldo verschil naar kas                                       -12,50
     4610  Uitgegeven aan schrijfwaren                    10,50
     2200  Te ontvangen BTW                                2,00
 
   Inkoopboek:
   ===========

     GRB.  OMSCHRIJVING                        DEBET    CREDIT   FACTUURBEDRAG
     ----  -------------------------------  --------  --------  --------------
     1600  Factuurbedrag naar crediteuren                             -1167,33 
     4520  Productie folder                   980,95
     2200  Te ontvangen BTW                   186,38

   Boekregels worden normaal geboekt zoals ingegeven in de debet/credit kolommen.
   Het factuurbedrag wordt tijden creatie van de journaalpost in _journaal_save.inc
   als boekregel geboekt maar eerst omgedraaid.

   Verkoopboek:
   ============

     GRB.  OMSCHRIJVING                        DEBET    CREDIT   FACTUURBEDRAG
     ----  -------------------------------  --------  --------  --------------
     1600  Factuurbedrag naar debiteuren                               1167,33 
     8010  Opbrengst factuur 123                        980,95
     2110  Af te dragen BTW hoog                        186,38

   Boekregels worden normaal geboekt zoals ingegeven in de debet/credit kolommen.
   Het factuurbedrag wordt tijden creatie van de journaalpost in _journaal_save.inc
   als boekregel geboekt en niet omgedraaid.


   BOEKREGELS
   ==========

   Vanuit het formulier worden bedragen aangeboden in:
     $p->debet, $p->credit en evt $p->btwbedrag.
   Dit bedragen worden in dit script verwerkt en leiden tot:
     $p->boekregelbedrag en evt $p->btwboekregelbedrag

   Het enige bedrag dat voor het boeken van boekregels worden gebruikt wordt
   vanuit dit script aangeboden in:
   $p->boekregelbedrag.
 
   Als in de boeking een btwbedrag is verwerkt, dus van het journaalformulier komt
   een debet/creditbedrag + een btwbedrag, dan wordt dit naar de boekregel-boeking
   gebracht via:
   $p->btwboekregelbedrag.
 
   Tot nu toe wordt die btwboeking geregeld in $post->opslaanLine($p) maar het
   is de vraag of dat ook niet beter in preprocessing geregeld kan worden door
   een tweede boekregel te instantieren en die standaard via opslaanLine te
   laten opslaan. Nee, dat is lastig want dan moeten we opslaanLine vanuit preprocessing
   oproepen en dat soort actie willen we hier niet, alleen het goedzetten van data.
   Dus zodra in $p een btwboekregelbedrag wordt aangeboden dan moet dit in opslaanLine
   worden afgehandeld. We moeten daar dan ook weten welke btwdefault er in het spel is (dit wordt
   niet uit het formulier aangeboden). Dat vragen we daar op op basis van het grootboeknummer
   waarin een btwdefault is opgenomen dat we matchen met een $stam->rkg_<btwrekeningnummer>
*/
 
/*
   als we hier binnenkomen dan weten we welke dagboekcode en -type het betreft doordat
   in journaal.phtml een $post object is geinstantieerd waarin die code en type zijn opgeslagen

   het dagboektype vraagt om verschillende benaderingen van de aangeboden data en moet hier
   worden ge-preprocessed.
   Dat dient alleen te gebeuren bij akties 'saveline' en 'savelinefinale' dus deze include wordt
   alleen aangeroepe vanuit _journaal.inc als het deze akties betreft. We hoeven hier dus niet
   te testen op die akties maar direct preprocessen.
*/
//
// Instantieer een $p->boekregelbedrag en een $p->btwboekregelbedrag.
//
$p->boekregelbedrag = $p->btwboekregelbedrag = '';

/*
   De bedragen die uit debet en credit komen, kunnen op verschillende manieren
   zijn geformatteerd: 
   Als we terugkomen uit een editmode zijn ze Europees geformatteerd: 1.234,56;
   Als we terugkomen uit een handmatige ingave zijn ze doorgaans niet voorzien
   van een duizendsep. en kan de decimalesep. zowel een punt als een komma
   zijn. We moeten dus eerst proberen de bedragen te normaliseren naar een
   format voor interne verwerking: 1234.56.
*/
(! empty($p->debet)) and $p->debet = formatInputBedrag($p->debet);
(! empty($p->credit)) and $p->credit = formatInputBedrag($p->credit);

// Verwerk nu de verschillende dagboektypes
//
switch($post->dagboektype) { 

  case 'kas'    :
  case 'bank'   :

    // Het omdraaien van polariteit van bankboekbedragen (omdat die vanuit bankafschrift-perspectief
    // geboekt worden) gebeurt hier in preprocessing voordat het naar de boekingsregel gaat.

    // Eerst het btw bedrag als dat er is:
    if(! empty($p->btwbedrag)) 
      if($p->btwbedrag <> 0) $p->btwboekregelbedrag = $p->btwbedrag * -1 ;
      else                   $p->btwboekregelbedrag = $p->btwbedrag ;

    // Dan de bedragen uit de debet/credit kolom
    // - er komt een debet bedrag binnen: dit is een ontvangst en moet credit worden
    // geboekt op de tegenrekening b.v. debiteuren of direct op verkopen;
    // - er komt een credit bedrag binnen: dit is een uitgave en moet debet worden
    // geboekt op de tegenrekening b.v. kantoorkosten;
    ! empty($p->debet) and $p->boekregelbedrag = $p->debet * -1 or
     ( ! empty($p->credit) and $p->boekregelbedrag = $p->credit );

    // We willen de relatiecode in de boekregels zichtbaar hebben. Als er een
    // relatiecode is dan wordt die hier aangeleverd in 'p->relatie' en wordt
    // dan niet gezien in opslaanLine. Zet hem in de juiste param.
    $p->relatiecode = ($p->relatie != '') ? $p->relatie : '';

    break;

  default      : // ingeval inkoop en verkoop en alle andere gevallen

    // We willen de relatiecode in de vervolg-boekregels opslaan. Als er een
    // relatiecode is dan wordt die hier aangeleverd in 'p->relatie' en wordt
    // dan niet gezien in opslaanLine. Zet hem in de juiste param.
    $p->relatiecode = ($p->relatie != '') ? $p->relatie : '';

    // Eerst het btw bedrag als dat er is:
    if(! empty($p->btwbedrag)) 
      if($p->btwbedrag <> 0) $p->btwboekregelbedrag = $p->btwbedrag ;
      else                   $p->btwboekregelbedrag = $p->btwbedrag ;

    // Dan de debet/credit kolommen
    ! empty($p->debet) and $p->boekregelbedrag = $p->debet  or
     ( ! empty($p->credit) and $p->boekregelbedrag = $p->credit * -1 );

    break;

}

/* __END__ */
