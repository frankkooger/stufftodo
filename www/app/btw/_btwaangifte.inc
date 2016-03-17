<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _btwaangifte.inc 289 2015-01-04 09:09:40Z otto $
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

$render->body .= "\n          <!-- btwaangifte.inc -->\n";
$render->subtitle[] = "btwaangifte.inc";

// HOUSEKEEPING
//
require_once("_journaal.lib");
$post = new Journaalpost();

require_once('_btw.lib');
$btw = new BTW();

// controleer of alle rkg koppelingen en rekeningen bestaan
//
// Dit hoeft niet meer omdat we geen stamtabel koppelingen meer gebruiken.
// Alle koppelingen zijn direct in grootboekstam en de keys in btwkeys
// Hoewel: mssch moeten we bij een nieuwe administratie toch checken of de 
// minimale BTW koppelingen er zijn: inkopen, verkopen hoog, btw betaald
//$btw->existRkg();

// Maak een keyList waarmee we acodes kunnen vertalen naar keys:
// '1a'=>'rkg_verkopenhoog'
$keys = $btw->getKeyList();

// array met veldattributen voor blockLine
//
$veldarr = array("width='2%'","width='42%'","width='14%'","width='14%'","width='14%'","width='14%'");

// inits om Notifys te voorkomen
//
$regel5dbutton = $vastleggenbutton = $help = $tekstblok = '';
$historielabel = array_fill(0,3,'');
$journaalid = 0;
$erzijnsaldi = false;

$render->titel = ($printen) ? "btwaangifte printen" : "btwaangifte";

// Als boekdatum gebruiken we de laatste dag van betreffende periode.
//
$boekdatum = $btw->boekdatum($p); // yyyy-mm-dd

printrc2($p, 'p75: ');
// cods is de verzameling BTW rubrieken waarvoor ook een gekoppelde grootboekrekening is gevonden
// het zijn deze rubrieken die in het form worden getoond.
//
$cods = $btw->maakQueryArr();
//
// Maak voor elke gevonden rubriek een Rekening object
//
foreach($cods AS $acode=>$val)
  $rkgobj[$acode] = new Rekening($acode,$val);

// Vraag de btw view af en vul de Rekening objecten met het resultaat
if($p->periode)
  $erzijnsaldi = $btw->loadQueryArr($rkgobj, $p->periode);

//
// PREAMBLE
//
switch($p->subaktie) {

  case 'consoliderenplus'  : 
    //
    // Als gelijk met de consolidatieboeking wordt gekozen voor een
    // journaalboeking van de BTW bedragen, dan komt op deze plek de
    // journaalboeking voor de BTW bedragen van deze periode.
    // real BTW bedragen van 2110 2120 2130 2200 naar 2300
    // en delta (afrondingsbedragen) van 2300 naar 8900
    //
    // Controleer eerst of de noodzakelijke rekeningen een btwkey koppeling hebben
    // Controleer daarna of er sprake is van partiele btwaftrek en maak die
    // journaalpost evt.
    //
    $ganietdoor=0;
    if(! $btwtussenrekening = $btw->existRkg('rkg_betaaldebtw')) {
      $msg['red'][] = $stam->helpImg(RUBRIEK.'.rgkbetbtwnietgekoppeld','Rkg Betaalde BTW niet gekoppeld')
                     ."De BTW rubriek rkg_betaaldebtw is niet gekoppeld aan een grootboekrekening!\n"
                     ."Doe dit alsnog in het scherm Grootboekstam";
      $ganietdoor=1;
    }
    if(! isset($stam->rkg_divopbrengsten['value'])) {
      $msg['red'][] = $stam->helpImg(RUBRIEK.'.rgkdivopbrnietgekoppeld','Rkg Diverse Opbrengsten niet gekoppeld')
                     ."De BTW rubriek rkg_divopbrengsten is niet gekoppeld aan een grootboekrekening!\n"
                     ."Doe dit alsnog in het scherm Stamgegevens";
      $ganietdoor=1;
    }
    if($ganietdoor) break;

    // PARTIELE BTWAFTREK
    //
    // Check of er sprake is van partiele btwaftrek
    // Dit is het geval als de BTW key 'rkg_btwpartmateriaal' actief is
    // en er sprake is van een dervingbtw bedrag in betreffende periode
    //
    if( ($stam->Get_field('"actief"', '"vw_btwkeys"', '"key"=\'rkg_btwpartmateriaal\''))
        and
        ($correctiebedrag = $stam->Get_field("\"dervingbtw_bedrag\"", "\"vw_partbtw_periode_jbedragen\"", "\"periode\"={$p->periode}"))
      ) {

      // Bepaal de benodigde rekeningnummers
      $rkg_btwpartmateriaal = $stam->Get_field('"value"', '"vw_btwtarieven"', '"key"=\'rkg_btwpartmateriaal\'');
      $dervingbtw_partbtwmateriaal = $stam->Get_field('"value"', '"vw_btwtarieven"', '"key"=\'dervingbtw_partbtwmateriaal\'');
      //
      // Maak de journaalpost
      //
      $cobj = new Dummy();
      $cobj->boekjaar      = $stam->boekjaar;
      $cobj->datum         = $boekdatum;
      $cobj->periode       = $p->periode;
      $cobj->dagboekcode   = "memo";
      $cobj->jomschrijving = "BTW derving boekingsperiode {$p->periode}";
      $cobj->saldo         = "0.00";
      $cobj->joorsprong    = "btwcorrectie";
      $cobj->tekst         = "Automatische boeking BTW derving getriggerd door BTW consolidatie van periode {$p->periode}";

      $journaalid = $post->opslaanJournaalpost($cobj);
  //printrc2($post, "post in opslaanjournaalpost: ");
  printrc2($cobj, "cobj in opslaanbtwderving1: ");
      //
      // Dan de boekingsregels
      //
      $cobj                    = new Dummy();
      $cobj->grootboekrekening = $rkg_btwpartmateriaal;
      $cobj->journaalid        = $journaalid;
      $cobj->boekjaar          = $stam->boekjaar;
      $cobj->datum             = $boekdatum;
      $cobj->boorsprong        = 'btwcorrectie';
      $cobj->bomschrijving     = "BTW partbtw correctie naar: {$dervingbtw_partbtwmateriaal}";
      // bedrag moet bij boeking worden gepolariseerd
      //
      $cobj->bedrag = $correctiebedrag * -1;

      $post->opslaanBoekregel($cobj);
  printrc2($cobj, "cobj in opslaanbtwderving2: ");
      
      // Tegenboeking
      //
      $cobj                    = new Dummy();
      $cobj->grootboekrekening = $dervingbtw_partbtwmateriaal;
      $cobj->journaalid        = $journaalid;
      $cobj->boekjaar          = $stam->boekjaar;
      $cobj->datum             = $boekdatum;
      $cobj->boorsprong        = ''; // geen boorsprong omdat dat "vw_partbtwbedragen" in de weg zit.
      $cobj->bomschrijving     = "BTW partbtw correctie van: {$rkg_btwpartmateriaal}";
      $cobj->bedrag            = $correctiebedrag;

      $post->opslaanBoekregel($cobj);
  printrc2($cobj, "cobj in opslaanbtwderving3: ");

      // Ik heb het idee dat deze veranderingen nog niet zichtbaar zijn in de navolgende vw_btwjournaal query
      // TODO dat komt omdat het rkgobj nog de startwaarden van deze functie heeft! Laad het rkgobj opnieuw
      // HIER LADEN
      $btw->loadQueryArr($rkgobj, $p->periode);

    } // END IF $correctiebedrag

    // EGALISATIE
    // 
    // De saldi die we voor deze boeking nodig hebben zijn meegekomen in 
    // p->objecten 'realbtwkeys' en 'delta'.
    // DIT IS NIET MEER ZO: tegenwoordig doen we alle berekeningen via views
    //
    // Eerst de journaalpost
    //
    $cobj                = new Dummy();
    $cobj->boekjaar      = $stam->boekjaar;
    $cobj->datum         = $boekdatum;
    $cobj->periode       = $p->periode;
    $cobj->dagboekcode   = "memo";
    $cobj->jomschrijving = "BTW egalisatie boekingsperiode {$p->periode}";
    $cobj->saldo         = "0.00";
    $cobj->joorsprong    = "egalisatie";
    $cobj->tekst         = "Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode {$p->periode}";

    $journaalid = $post->opslaanJournaalpost($cobj);
//printrc2($post, "post in opslaanjournaalpost: ");
//printrc2($cobj, "cobj in opslaanjournaalpost: ");

    //
    // Dan de boekingsregels
    //
    // Doorloop hiervoor het p->realbtwkeys object. De indexen van dit object
    // zijn acodes dus die moeten we eerst omzetten naar keys. Bij elk item dat
    // voldoet aan key==rkg_btw* en waarbij een bedrag staat zoeken we het
    // p->delta object en maken de boekingsregel naar de grootboekrekening die
    // overeenkomt met de acode/key in het object.
    //
    // !!! Update: dit wordt vanaf nu geregeld in een een view: vw_btwjournaal
    //     deze bevat kant en klaar alle journaalregels
    //     Bevraag met:
    //       SELECT * FROM `vw_btwjournaal` WHERE 
    //         boekjaar=2011 AND periode=1
    //       ORDER BY rekening,ccode, omschrijving desc

    // Vraag de btwjournaal view af
      $stam->Do_query("SELECT * FROM \"vw_btwjournaal\" WHERE " . $btw->periodeWhere($p->periode) . " "
                     ."ORDER BY \"periode\",\"rekening\",\"ccode\", \"omschrijving\" desc", basename(__FILE__)."::".__FUNCTION__."::".__LINE__);

    $arr = array();
    
    while($obj  = $stam->Do_object()) {
      $arr[] = $obj;
    } // END while
    $stam->Do_free();
    /*
printrc2($arr, "array objecten na vw_btwjournaal: ");

      boekjaar periode ccode rekening omschrijving              bedrag
      2011     1       1a    2110     egalisatie periode 1      2046.50
      2011     1       1b    2120     egalisatie periode 1      7.36
      2011     1       5b    2200     egalisatie periode 1      -1432.04
      2011     1       5b    2210     egalisatie periode 1      -845.81
      2011     1       5b    2220     egalisatie periode 1      -123.26
      2011     1       1a    2300     egalisatie van rkg: 2110  -2046.50
      2011     1       1a    2300     Afronding: 1a             -0.50
      2011     1       1b    2300     egalisatie van rkg: 2120  -7.36
      2011     1       1b    2300     Afronding: 1b             0.36
      2011     1       5b    2300     egalisatie van rkg: 2220  123.26
      2011     1       5b    2300     egalisatie van rkg: 2210  845.81
      2011     1       5b    2300     egalisatie van rkg: 2200  1432.04
      2011     1       5b    2300     Afronding: 5b             -0.11
      2011     1       1a    8900     Afronding BTW groep: 1a   0.50
      2011     1       1b    8900     Afronding BTW groep: 1b   -0.36
      2011     1       5b    8900     Afronding BTW groep: 5b   0.11

    */

    $cobj             = new Dummy();
    $cobj->journaalid = $journaalid;
    $cobj->boekjaar   = $stam->boekjaar;
    $cobj->datum      = $boekdatum;
    $cobj->boorsprong = 'egalisatie';
    $verschillenrekening = $stam->rkg_divopbrengsten['value'];

    foreach($arr AS $key=>$obj) {
      $cobj->grootboekrekening = $obj->rekening;
      $cobj->bedrag = $obj->bedrag;
      $cobj->bomschrijving = $obj->omschrijving;

      $post->opslaanBoekregel($cobj);

//printrc2($cobj, "cobj in opslaanboekregel: ");
    } // END foreach

     //break;  // Geen break, ga hiervandaan door met consolideren.

  case 'consolideren'  : 
    // 
    // sla de AanGifte saldi op in btwaangiftes als historierecords
    // als dit gedaan is voor een bepaalde periode, dan verdwijnt de knop
    // consolideren.
    //
    // Vanaf versie 1.7.0 doen we dit vanuit de view die ook de tabel op het scherm toont:
    //  select * from vw_btw where boekjaar=2011 and periode=2
    /*
    boekjaar   periode   ccode   label                                               omzet   btwbedrag
      2011       2         1a      1a. Leveringen/diensten belast met hoog tarief      2347    446
      2011       2         1e      1e. Leveringen/diensten belast met 0% of niet bij ..1515    NULL
      2011       2         5a      5a. Verschuldigde omzetbelasting: rubrieken 1 tm 4  NULL    446
      2011       2         5b      5b. Voorbelasting                                   NULL    792
      2011       2         5e      5e. Totaal                                          NULL    -346
    */

    $cquery="INSERT INTO {$stam->btwaangiftes}"
           .'("id","journaalid","datum","boekjaar","periode","acode","labelkey","omzet","btw") VALUES ';
    $arr = array();
    $id = $stam->newId($stam->btwaangiftes);

    // Vul de insert querys
    //
    foreach($rkgobj AS $acode=>$val) {
      // zorg dat omzet en btwbedrag niet NULL is
      $val->omzet = ($val->omzet) ? $val->omzet : 0;
      $val->btwbedrag = ($val->btwbedrag) ? $val->btwbedrag : 0;
      $arr[] = "({$id},{$journaalid},'{$boekdatum}',{$stam->boekjaar},{$p->periode},"
              ."'{$val->acode}','{$val->key}',{$val->omzet},{$val->btwbedrag})";
      $id++;
    }
    // Voer de querys uit
    //
    foreach($arr AS $str)
      $stam->Do_query($cquery.$str, basename(__FILE__)."::".__FUNCTION__."::".__LINE__);

    $btw->loadQueryArr($rkgobj, $p->periode);

    break;

  case 'herstelconsolidatie' : 
    //
    // verwijder de consolidatierecords van deze periode
    //
    // Doe nog een laatste check of het eindejaarscheck 'consolidatie' inmiddels niet is geactiveerd.
    //
    if($stam->Get_field('COUNT("id")', $stam->eindcheck, "\"boekjaar\"={$stam->boekjaar} AND \"naam\"='consolidatie' AND \"value\"=".BLUELIT, basename(__FILE__)."::".__FUNCTION__."::".__LINE__)) {
      $GLOBALS['msg']['red'][] = $stam->helpImg(RUBRIEK.'.eindjconsactief','Eindjaarscheck al actief')
                                ."De eindejaarscheck 'consolidatie' is al actief! Er kan niet meer veranderd worden in de btwaangiftes.";
      break;
    }

    // Bepaal eerst onder welk journaalid deze records zijn weggeschreven. Deze
    // hebben we nodig voor het verwijderen van de BTW journaalboeking die aan
    // deze consolidatie zijn gekoppeld.
    //
    $journaalid = $stam->Get_field('journaalid', $stam->btwaangiftes, "\"boekjaar\"={$stam->boekjaar} AND \"periode\"={$p->periode}"
                                   ,basename(__FILE__)."::".__FUNCTION__."::".__LINE__);
    // Verwijder de journaalpost
    //
    if($post->deletePost($journaalid)) {
      $cquery=" DELETE FROM {$stam->btwaangiftes}"
             ." WHERE \"boekjaar\"={$stam->boekjaar} AND \"periode\"={$p->periode} ";
      $stam->Do_query($cquery, basename(__FILE__)."::".__FUNCTION__."::".__LINE__);
    }
    //
    // TODO verwijderen evt btwderving boeking
    //
    if($journaalid = $stam->Get_field('journaalid', $stam->journaal, "\"boekjaar\"={$stam->boekjaar} AND \"periode\"={$p->periode} AND \"joorsprong\"='btwcorrectie'"
                                   ,basename(__FILE__)."::".__FUNCTION__."::".__LINE__)) {
      // Verwijder de journaalpost
      //
      if($post->deletePost($journaalid)) {
        null;
      }
    } // END IF journaalid btwcorrectie

    $btw->loadQueryArr($rkgobj, $p->periode);

    break;

  case 'verwijder5d' : 
    //
    // Verwijder de boeking omdat een eerder gedane boeking niet meer valide is.
    //
    // Bepaal of de boeking al bestaat
    //
    $stam->query =<<<EOT
SELECT "journaalid"
FROM   "vw_boekregels"
WHERE  "periode"={$p->periode}
  AND  "boorsprong"='5dregeling'
  AND  "btwkey" NOT LIKE 'rkg_betaaldebtw';
EOT;

    $stam->Do_sql(basename(__FILE__)."::".__FUNCTION__."::".__LINE__);
    if($stam->N_rows(basename(__FILE__)."::".__FUNCTION__."::".__LINE__)) { // Journaalpost bestaat, verwijder hem
      $obj = $stam->Do_object();
      $post->deletePost($obj->journaalid);
    }

    $btw->loadQueryArr($rkgobj, $p->periode);

    break;

  case 'inboeken5d' : 
    //
    // Maakt een journaalboeking van het 5d verminderingsbedrag. Deze
    // journaalboeking kan maar 1 keer gemaakt worden. Als de boeking nog eens
    // gemaakt wordt, dan moet het een update van de bestaande zijn!!
    // Het 5d bedrag wordt aangeleverd in p->vermindering. De journaalpost en
    // de boekregels krijgen als oorsprong '5dregeling' waarmee ze kunnen
    // worden opgezocht bij het verzamelen van het btw overzicht.
    //
    // Controleer eerst of de benodigde rekeningen in stam zijn opgenomen, ergo
    // een koppeling hebben naar een grootboekrekening.
    //
    $ganietdoor=0;
    if(! $btwtussenrekening = $btw->existRkg('rkg_betaaldebtw')) {
      $msg['red'][] = $stam->helpImg(RUBRIEK.'.rkgbetbtwnietgekoppeld','Rkg Betaalde BTW niet gekoppeld')
                     ."De BTW rubriek rkg_betaaldebtw is niet gekoppeld aan een grootboekrekening!\n"
                     ."Doe dit alsnog in het scherm Grootboekstam";
      $ganietdoor=1;
    }
    if(! isset($stam->rkg_divopbrengsten['value'])) {
      $msg['red'][] = $stam->helpImg(RUBRIEK.'.rkgdivopbrnietgekoppeld','Rkg Diverse Opbrengsten niet gekoppeld')
                     ."De BTW rubriek rkg_divopbrengsten is niet gekoppeld aan een grootboekrekening!\n"
                     ."Doe dit alsnog in het scherm Stamgegevens";
      $ganietdoor=1;
    }
    if($ganietdoor) break;

    // Bepaal of de boeking al bestaat. Als dat het geval is, doe een update anders een insert
    //
    $stam->query =<<<EOT
SELECT "boekregelid","bedrag","grootboekrekening" 
FROM   "vw_boekregels"
WHERE  "periode"={$p->periode}
  AND  "boorsprong"='5dregeling' 
ORDER BY "boekregelid";
EOT;

    $stam->Do_sql(basename(__FILE__)."::".__FUNCTION__."::".__LINE__);
    if($stam->N_rows(basename(__FILE__)."::".__FUNCTION__."::".__LINE__)) { // Er zijn boekingen, maak een update
      $arr = array();
      while($obj = $stam->Do_object()) {
        // De eerste boekregel met grootboeknummer 'rkg_betaaldebtw'
        // blijft hetzelfde grootboeknummer houden. De tweede regel kan een
        // gewijzigd grootboeknummer hebben.
        //
        $cobj = new Dummy();
        $cobj->grootboekrekening = ($obj->grootboekrekening == $btwtussenrekening) ?
          $obj->grootboekrekening :
          $p->grootboekrekening;
        $cobj->bedrag = ($obj->grootboekrekening == $btwtussenrekening) ?
          $p->vermindering :
          $p->vermindering * -1;

        $post->updateBoekregel($obj->boekregelid,$cobj);
        $arr[] = $obj;
      }
      // Door de volgorde van het inboeken staat de btwtussenrekening als
      // eerste boeking. Deze kan domweg worden geupdate.
      // Van de volgende boekregel moet eerst bepaald worden of het nieuw
      // aangeleverde grootboeknummer nog wel gelijk is aan het bestaande. Zo
      // niet dan moet het saldo op de nieuw aangeboden rekening worden
      // geboekt. Anders ook het grootboeknummer
      //

      break;
    }

    // Maak anders nieuwe boeking
    //
    $cobj = new Dummy();
    $cobj->boekjaar = $stam->boekjaar;
    $cobj->datum = $boekdatum;
    $cobj->periode = $p->periode;
    $cobj->dagboekcode = 'memo';
    $cobj->jomschrijving = 'BTW 5d vermindering inboeken';
    $cobj->saldo = '0.00';
    $cobj->joorsprong = '5dregeling';
    $cobj->tekst = 'Automatische boeking van vermindering volgens BTW regeling voor kleinondernemers';

    $journaalid = $post->opslaanJournaalpost($cobj);

    // Dan de boekingsregels

    // Controleer of de handmatig ingegeven grootboekrekening valide is. Neem anders de standaard rkg_divopbrengsten
    // TODO geef foutmelding terug als verkeerd rekeningnummer is opgegeven en wordt geboekt op standaardrekening
    //
    $divopbrengstrekening = (!$stam->Get_field('COUNT("id")', $stam->grootboekstam, "\"nummer\"={$p->grootboekrekening}", basename(__FILE__)."::".__FUNCTION__."::".__LINE__)) ?
      $stam->rkg_divopbrengsten['value'] :
      $p->grootboekrekening;

    // boeking op btwtussenrekening en tegenboeking op diverse opbrengsten
    //
    $cobj = new Dummy();
    $cobj->grootboekrekening = $btwtussenrekening;
    $cobj->journaalid = $journaalid;
    $cobj->boekjaar = $stam->boekjaar;
    $cobj->datum = $boekdatum;
    $cobj->boorsprong = '5dregeling';
    $cobj->bomschrijving = "BTW 5d vermindering naar: {$divopbrengstrekening}";
    $cobj->bedrag = $p->vermindering;

    $post->opslaanBoekregel($cobj);
    
    // Tegenboeking
    //
    $cobj = new Dummy();
    $cobj->grootboekrekening = $divopbrengstrekening;
    $cobj->journaalid = $journaalid;
    $cobj->boekjaar = $stam->boekjaar;
    $cobj->datum = $boekdatum;
    $cobj->boorsprong = '5dregeling';
    $cobj->bomschrijving = "BTW 5d vermindering van: {$btwtussenrekening}";
    // bedrag moet bij tegenboeking worden gepolariseerd
    //
    $cobj->bedrag = $p->vermindering * -1;

    $post->opslaanBoekregel($cobj);

    $btw->loadQueryArr($rkgobj, $p->periode);

    break;

  case 'bereken5d' : 
    //
    // Berekent Vermindering volgens Kleinondernemersregeling
    //
    // Haal cijfers in eerste instantie uit geconsolideerde data. Zijn deze
    // voor een periode nog niet ingevuld, bereken de cijfers dan rechtstreeks
    // uit de boekingsregels, net zoals de berekening voor de aangiftes.
    // Bereken de cijfers op dezelfde manier als normale perioden maar nu
    // zonder periodebeperking, dus over het hele jaar. Gebruik hiervoor een
    // aparte plugin. NOTE: dit werkt niet! er moet per periode gerekend
    // worden omdat periodes met BTW teruggaves als 0 worden meegerekend in de
    // berekening 5d.
    // UPDATE dit wordt nu allemaal geregeld door view "vw_btw5d" die uitgaat
    // van de gecumuleerde periodes uit "vw_btw" en de -periodes weglaat.
    //
    require('_btwbereken5d.inc');
    break;

}

$periodestring = $btw->periodeStringFill($p);  // AND (j."periode"=4)
//printrc2($periodestring, "periodestring: ");

// Tot zover de saldi van de gevraagde periode
// Check nu of er van deze periode al een consolidatieboeking is (ofwel: zijn de
// periodecijfers opgeslagen omdat ze naar de belastingdienst zijn verstuurd)
//
if($p->periode) {

  // Onderstaande query in een Do_sql anders doet N_rows het niet!
  $stam->query = "SELECT * FROM {$stam->btwaangiftes} WHERE \"boekjaar\"={$stam->boekjaar} AND \"periode\"={$p->periode}";
  $stam->Do_sql( basename(__FILE__)."::".__FUNCTION__."::".__LINE__);
  //
  // als er geen resultaten zijn is deze periode nog niet geconsolideerd en kan
  // de consolidatiebutton worden getoond
  //
  $regel5dbutton="<input type='button' name='regel5dbutton' value='bereken 5d' size='10' "
                ."class='bsmall2' class='bsmall2' onClick='bereken5d();'/>";

  $gevonden = $stam->N_rows(basename(__FILE__)."::".__FUNCTION__."::".__LINE__);

  if(! $gevonden && $erzijnsaldi) { // tonen button
    $vastleggenbutton="<input type='button' name='consoliderenbutton' value='consolideren' size='10' "
                     ."class='bsmall2' class='bsmall2' onClick='consolideren();'/>";
    $help = $stam->helpImg(RUBRIEK.'.BTWAangifte','BTW Aangifte',4);
  }
  else if($gevonden) { // er zijn resultaten
    // 5d button niet meer tonen als in het laatste periode een 5d boeking is geconsolideerd
    //
    $regel5dbutton='';

    while($obj = $stam->Do_object()) {
      // Als er geen rkgobj is van deze acode (dus geen cods object) dan kunnen we uiteraard niets invullen
      // dit is overigens een ongewenste situatie die we nog moeten afvangen.
      if(empty($rkgobj[$obj->acode])) continue;
      //
      $rkgobj[$obj->acode]->AG_omzet = Rekening::numberFormat($obj->omzet);
      $rkgobj[$obj->acode]->AG_btwbedrag = Rekening::numberFormat($obj->btw);
      //
      // Wijkt het aangiftebedrag af van het gemeten AG_saldo? (zou niet mogen).
      // Indien wel: zet een rode marker.
printrc2($rkgobj[$obj->acode], "rkgobj voor de markers: " );
      //
      $rkgobj[$obj->acode]->markers();

      //
      // Is er een tekst toegevoegd? Zet dat in een tekstblok.
      //
      // TODO tekstblok is geen veld meer in 'btwaangiftes' en moet uit tabel 'notities' gaan komen
      //
      //if($obj->tekst != '') $tekstblok .= $obj->tekst . '<br /><br />';
    }
    $historielabel = array("<div onClick='verwijderhistorie({$stam->boekjaarBlocked});' style='cursor:crosshair;'>Op aangifte</div>", 'Omzetbedrag', 'BTW');
  } // END ELSE IF

} // END IF p->periode

printrc2($rkgobj, "rkgobj2: " );

// START BUILDING BODYTEXT
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "ser"=>$ser
                         ,"aktie"=>""
                         ,"subaktie"=>""
                         ) );

  $form->mainTableStart();

    $form->schemaHeader("BTW aangiftecijfers over periode: {$stam->boekjaar}/{$p->periode}");
    

    $form->fieldSetBridge("Selectie");
    

  // periodecheck

      $form->blockLine('',
                       array("<div class='schemarow_std'>Periode: </div>"
                            ,"<div class='schemarow_std'>{$btw->periodestring}</div>"
                             ),
                       array("width='15%'","width='85%'") );


    $form->fieldSetBridge("");

  // messages

    $form->messagePrint();

    $form->fieldSetBridge("");

  // headerrow

      $form->blockLine('4',
                       array("<div class='schemarow_head'>Item</div>"
                            ,"<div class='schemarow_head' align='center'>Aangiftebedragen</div>" 
                            ,"<div class='schemarow_head' align='center'>{$historielabel[0]}</div>" 
                            ), 
                       array("width='44%', colspan='2'","width='28%', colspan='2'","width='28%', colspan='2'")
                       );

      $form->blockLine('4',
                       array("<div class='schemarow_head'></div>"
                            ,"<div class='schemarow_head'></div>"
                            ,"<div class='schemarow_head' align='right'>Omzetbedrag</div>" 
                            ,"<div class='schemarow_head' align='right'>BTW</div>" 
                            ,"<div class='schemarow_head' align='right'>{$historielabel[1]}</div>" 
                            ,"<div class='schemarow_head' align='right'>{$historielabel[2]}</div>" 
                            ), 
                       $veldarr
                       );


  // print de objecten als saldiregels
  //
$tmp = '';
foreach($rkgobj AS $key=>$val) {

  if($tmp != substr($val->acode,0,1) ) {
    $form->fieldSetBridge("",0);
    $form->linecolor = 1;
  }

  // formatteer bedragen alleen als er iets in is, anders staat er voortdurend een '0'
  //
  $val->numberFormats();

  // formatteer de opmaak voor subtotalen en totaal (bold)
  //
  $stijl = (preg_match("/^sub|^tot/", $val->type)) ? "style='font-weight:bold'" : '';

  // formatteer Totaal als 'te betalen' of 'terug te vragen'
  //
  if(preg_match("/^tot/", $val->type)) 
    $val->label .= ($val->btwbedrag < 0) ? ' terug te vragen' : ' te betalen';

      $form->blockLine('',
                       array("<div class='schemarow_std' {$stijl}>{$val->acode}</div>"
                            ,"<div class='schemarow_std' {$stijl}>{$val->label}</div>"
                            ,"<div class='schemarow_std' {$stijl} align='right'>".$val->omzet." &nbsp;</div>"
                            ,"<div class='schemarow_std' {$stijl} align='right'>".$val->btwbedrag." &nbsp;</div>"
                            ,"<div class='schemarow_std' {$stijl} align='right'>".$val->AG_omzet."</div>"
                            ,"<div class='schemarow_std' {$stijl} align='right'>".$val->AG_btwbedrag.$val->marker."</div>\n" 
                             ), 
                       $veldarr
                       );

  $tmp = substr($val->acode,0,1);

} // END FOREACH

  // Ingeval een tekstblok, hier printen
  //
if($tekstblok != '') {

    $form->fieldSetBridge("");

      $form->blockLine('2',array($tekstblok,''),
                           array("width='70%'","width='30%' align='right'") );

} // END IF tekstblok

if(isset($lines)) {

  $tekstblok = '';
  foreach($lines AS $val) {
    $tekstblok .= $val;
    (!preg_match("/[>]$/",$val)) and $tekstblok .= "</br>\n";
  }

    $form->fieldSetBridge("Vermindering volgens kleinondernemersregeling",
                          array('',RUBRIEK.'.5dRegeling','Vermindering volgens 5d Regeling') );

      $form->blockLine('#ecad5a',array($tekstblok,''),
                           array("width='70%'","width='30%' align='right'") );


} // END IF lines

  // BUTTONS
  //
    
    $form->fieldSetBridge("");

      $buttons=<<<EOT

        {$regel5dbutton}
        {$vastleggenbutton}
        <input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' onClick="window.close()"/>
        {$help}
EOT;

      $printerbutton=<<<EOT

        <img src='/img/printer1.gif' style="cursor:pointer;" onClick="window.print();" />
EOT;

      $form->blockLine('2',array($buttons,$printerbutton),
                           array("width='70%'","width='30%' align='right'") );


    $form->fieldSetEnd();

  $form->mainTableEnd();
$form->formEnd();

$render->extra_styles .=<<<EOT

legend {
  font-weight:bold;
  padding-top: 10;
}

EOT;


// START BUILDING JAVASCRIPT
//

  $render->jscript .=<<<EOJ

function doLoad(deze) {
  var x = document.forms['frm1'];
  x.aktie.value = 'btw';
  x.submit();
}

function bereken5d() {
  var x = document.forms['frm1'];
  var msg = "Bereken of sprake is van Vermindering volgens kleinondernemersregeling (lid 5d).\\n";
  msg = msg + "Dit is pas goed te berekenen nadat alle gegevens t.m. de laatste periode zijn ingevuld.\\n\\n";
  if(! confirm(msg)) return(false);
  x.aktie.value = 'btw';
  x.subaktie.value = 'bereken5d';
  x.submit();
}

function consolideren() {
  var x = document.forms['frm1'];
  var msg = "Consolideren betekent dat je de saldi voor deze periode vastlegt.\\n";
  msg = msg + "Je doet dat nadat je de BTWaangifte hebt gedaan op basis van de periodesaldi.\\n";
// TODO onderstaand mechanisme moet nog worden ingebouwd.
//  msg = msg + "Na consolidatie kan niet meer op de BTW rekeningen worden geboekt.\\n";
//  msg = msg + "Consolideren kan niet meer ongedaan worden gemaakt.";
  if(! confirm(msg)) return(false);
  else {
    msg = "Er wordt automatisch een BTW egalisatie-journaalboeking gemaakt.\\n\\n";
    //msg = "Wil je automatisch de BTW journaalboeking maken?\\n\\n";
    //msg = msg + "We raden je aan dit wel te doen! Anders moet je het later alsnog via het memoriaal doen.\\n";
    if(confirm(msg)) x.subaktie.value = 'consoliderenplus';
    else return(false);
    //else x.subaktie.value = 'consolideren';
  }
  x.aktie.value = 'btw';
  x.submit();
}

function verwijderhistorie(a) {
  var x = document.forms['frm1'];
  if(a>0) {
    var msg="Het boekjaar is afgesloten!\\n\\n";
    msg = msg + "Je kunt geen veranderingen meer in het boekjaar aanbrengen.\\n";
    alert(msg);
    return(false);
  }

  var msg="Hiermee verwijder je de consolidatieboeking.\\n";
  msg = msg + "Doe dit niet onbezonnen.\\n";
  if(! confirm(msg)) return(false);
  x.aktie.value = 'btw';
  x.subaktie.value = 'herstelconsolidatie';
  x.submit();
}

function toPrint() {
  var x=document.forms['frm1'];
  // var b=escape(x.ser.value);
  var b='{$ser}';
  var c='saldilijsten.phtml?aktie=printbtw&ser' + b; 
  
  win=window.open(c,'',{$GLOBALS['WINDOW_OPTIONS']['SCHEMAS']});
}

EOJ;

/*
 * Class Rekening
 * Een container voor opgevraagde en gepresenteerde gegevens
 */

Class Rekening {
  public $btwbedrag='';
  public $omzet='';
  public $AG_btwbedrag='';
  public $AG_omzet='';
  public $key='';
  public $type='';
  public $acode='';
  public $label='';
  public $geconsolideerd='';
  public $marker=' &nbsp;';

  public function __construct($key,$arr) {
    $this->acode = $key;
    $this->label = $arr['label'];
    $this->type = $arr['type'];
    $this->key = $arr['key'];
  }

  public function numberFormat($i) {
    $i = preg_replace("/[.,]/", "", number_format((double)$i,0,',','.'));
    if($i == '0') return(''); else return($i);
  }

  public function numberFormats() {
    $this->omzet = $this->numberFormat($this->omzet);
    $this->btwbedrag = $this->numberFormat($this->btwbedrag);
    $this->AG_omzet = $this->numberFormat($this->AG_omzet);
    $this->AG_btwbedrag = $this->numberFormat($this->AG_btwbedrag);
  }

  public function markers() {
    if($this->btwbedrag <> $this->AG_btwbedrag || $this->omzet <> $this->AG_omzet)
      $this->marker = " <font color='red'>*</font>";
  }

}

/* __END__ */
