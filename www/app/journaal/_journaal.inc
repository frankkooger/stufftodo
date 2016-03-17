<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _journaal.inc 289 2015-01-04 09:09:40Z otto $
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

// We gaan hier kijken wat er gebeurt als we obj niet meer gebruiken maar wel de al geladen post
// Ergens in de code werd nl. een journaalpost als apart obj geladen terwijl het al geladen is als post.

// We gaan deze routine bewerken: als een periode is geconsolideerd kunnen geen
// nieuwe journaalposten in die periode worden ingegeven (behalve memoriaal) en
// kunnen bestaande journaalposten niet worden verwijderd of veranderd (behalve
// memoriaal). In memoriaal kunnen geen automatische BTW boekingen worden
// gemaakt dus de BTW regel moet disabled zijn.
//
// We bepalen standaard of een journaalpost in een geconsolideerde periode valt
// tijdens het laden van een journaalpost dus in journaal-beheer.

// no direct access
defined('_JEXEC') or die('Restricted access');

$render->body .= "\n          <!-- journaal.inc -->\n";
$render->titel = "Journaalposten invoeren/beheren";
$render->subtitle[] = 'journaal.inc';
$render->schriftstijl = 'journaal';

// Housekeeping
$scriptfile = basename(__FILE__);

$disablethis = DISABLED;

$buttons = array('button_opslaan'=>0,'button_x'=>0,'button_reset'=>0,'button_nieuwejournaalpost'=>0,'button_nieuweboekregel'=>0,'button_sluiten'=>1,'button_editjournaalpost'=>0,'button_verwijder'=>0);

$disabled = array('periodes'=>'','dagboeken'=>'','jomschrijving'=>'','datum'=>'');

function open_input() {
  global $buttons, $disabled;
  $disabled['jomschrijving'] = $disabled['datum'] = '';
  $buttons['button_opslaan'] = 1;
  $buttons['button_nieuweboekregel'] = 0; 
  $buttons['button_verwijder'] = 0; 
  $buttons['button_editjournaalpost'] = 0; 
}

function close_input() {
  global $buttons, $disabled;
  $disabled['jomschrijving'] = $disabled['datum'] = DISABLED;
  $buttons['button_opslaan'] = 0;
}

function edit_journaalpost() {
  global $buttons, $disabled;
  $buttons['button_nieuweboekregel'] = 1; 
  $buttons['button_verwijder'] = 1; 
  $buttons['button_editjournaalpost'] = 1; 
}

// Het is belangrijk dat het dagboektype 'begin' als gevolg van periode=0 goed
// in de routine wordt herkend. Denk erom dat wordt getest met === anders
// scoort een lege periode (ten gevolg van het eerst inkomen van dit scherm)
// ook.
($post->periode === '0') and $post->dagboekcode = $post->dagboektype = 'begin';

// Hetzelfde geldt voor dagboektype 'memo' als gevolg van periode=5. Ook hier
// wordt geen goede indicatie aan $post doorgegeven dus doen we het hier.
($post->periode == $GLOBALS['stam']->periodeextra['value']) and $post->dagboekcode = $post->dagboektype = 'memo';

// Als een journaalpostid in het spel is, wordt een journaalpost geladen en kan
// de knop nieuweboekregel worden getoond.
if($post->journaalid > 0) { 
  edit_journaalpost();
  close_input(); 
  $render->onload .= "document.forms['frm1'].boekregelnieuw.focus();";
} 
else { 
  $buttons['button_nieuweboekregel'] = 0; 
  open_input(); 
} 

//
// ! Een post lege of gevulde journaalobject wordt default geladen in de starter
//

switch($aktie) { // verschillende akties testen

  case 'deleteline'   :
    //
    // verwijder boekregel, altijd als eerste testen
    // we hebben hiervoor een gevuld post object nodig en dat wordt geladen in de starter.
    // Na de deleteprocedure verderop weer opnieuw laden zodat 
    // we met de juiste gegevens verder gaan (zoald het formulier schrijven)
    //
    if($post->Delete_line($p->boekregel,$msg)) {
      $post = reloadPost($post);
    }
    break;

  case 'deletepost'   :
    //
    // aktie 'delete' altijd als tweede testen
    // we hebben hiervoor wel een gevuld post object nodig.
    // Na de deleteprocedure verderop weer opnieuw laden zodat 
    // we met de juiste gegevens verder gaan
    //
    if($post->deletePost($post->journaalid)) { 
      $msg['blue'][] = "Journaalpost: {$post->journaalid}/{$post->journaalpost} is verwijderd!";

      // Als de dagboekcode en periode nog bekend is in $p dan worden deze
      // automatisch in het nieuwe, lege journaalpost hersteld.
      //
      $post->journaalid='';
      $post = reloadPost($post);

      // Herstel de velden en knoppen en zet deze klaar voor een nieuwe journaalpost
      //
      open_input();
    }
    else 
      $msg['red'][] = "Kan Journaalpost: {$journaalpost} niet verwijderen!";
    break;

  case 'journaalpostload' :
    $render->onload .= "document.forms['frm1'].overzicht.focus();";
    break;

  case 'dagboekload'      :
    $render->onload .= "document.forms['frm1'].dagboekcode.focus();";
    break;

  case 'periodeload'      :
    $render->onload .= "document.forms['frm1'].periode.focus();";
    break;

  case 'save'      :

    // na een save kan het nodig zijn om de journaalpost opnieuw in te laden
    // teneinde de initiele boekregel (b.v. 1600 van een inkoopboeking)
    // zichtbaar te maken.
    //
    $post = reloadPost($post);

    $render->onload .= "document.forms['frm1'].boekregelnieuw.focus();";
    break;

} // END switch aktie


// akties waarvoor een value uit het journaalobject nodig is
//
switch($aktie) { // 

  case "savelinefinale"   :
  case 'saveline'         :

    // Preprocessing van boekregelgegevens vindt plaats in _journaal_preprocessing.inc
    // Daarin ook uitgebreide uitleg over het boekregel en journaalpost proces
    //
    require("_journaal_preprocessing.inc");

    // We hebben nu in preprocessing $p->boekregelbedrag en evt
    // $p->btwboekregelbedrag gevuld. Hiermee gaan we naar:
    //
    $post->opslaanLine($p);

    // Als de bedragen aldus verwerkt zijn, ververs het journaalobject met de
    // zojuist opgeslagen gegevens
    //
    $post = reloadPost($post);

    // Als er een p->bomschrijving terugkomt, die in het post object laden om te
    // gebruiken bij een volgende boekregel, die waarschijnlijk eenzelfde
    // omschrijving heeft dan de zojuist ingegevene BEHALVE in kas en bankboek
    // waar elke regel meestal verschillend is.
    //
    if($post->dagboektype != 'kas'  AND $post->dagboektype != 'bank') {

      if(! empty($p->bomschrijving)) 
        $post->bomschrijving = $p->bomschrijving;
   
    }

    // Idem voor de boekdatum maar hier geldt het ook voor kas en bank. Maak
    // hier wel eerst een isodatum van want die wordt bij het printen van de
    // boekregel weer teruggezet naar normdatum.
    // Tijdens een eindboeking is het niet gewenst om de vorige datum over te
    // nemen. Hier moet de datum van de journaalpost weer terugkomen.
    //
    if($aktie != 'savelinefinale' )
      if(! empty($p->boekdatum)) 
        $post->boekdatum = $GLOBALS['timer']->norm2iso($p->boekdatum);

    // Postprocessing van boekregelgegevens vindt plaats in _journaal_postprocessing.inc
    //
    require("_journaal_postprocessing.inc");

    break;

}  // END switch aktie 2

printrc2($post,"\npost na de akties: _journaal.inc\n");

//
// GEGEVENS INLEZEN

//
// Vul de periodes pulldown
//
// Het algorithme om de periode te ontlenen aan de huidige datum is: huidige_periode = ceil(deze_maand * (hoogste_periode / 12))
//
// 2009-01-03:
// Bovengenoemde aanpak geeft reden tot vergissingen. Als in het begin van het
// nieuwe jaar boekingen uit het vorig jaar worden gepleegd (wat regelmatig
// voorkomt als de maand nog niet zover is gevorderd) dan staat de periode
// steeds op 1 terwijl we willen boeken in periode 4. We gaan dus nu uit van de
// periode waarin nog wordt geboekt en zetten dit als default. Deze boekperiode
// wordt bepaald in _preload.inc en maakt onderdeel uit van de stamgegevens.
//
// LET OP: deze periode wordt ook default gezet in een lege journaalpost dus we
// gaan verder voor alle situaties uit van de periode waarde in de
// journaalpost.

// LET OP: als p->periode === 0 dan hebben we echt gekozen voor deze periode
// (beginbalans) en moet deze periode worden ingesteld.
//
$periodes = "\n<option value='0'>--</option>";

for($i=$stam->periodevan['value'];$i<=$stam->periodeextra['value'];$i++) {
  $periodes .= ($i == $post->periode) ?
    "\n<option selected='selected' value='{$i}'>{$i}</option>" :
    "\n<option value='{$i}'>{$i}</option>";
}

// Vul de dagboeken pulldown
//
switch($post->periode) {
  case 0 : // als periode 0 gekozen wordt alleen dagboek beginbalans tonen
    $dagboeken = $post->dagboekenPullDown("\"type\"='begin'"); break;
  case $GLOBALS['stam']->periodeextra['value'] : // als extra periode is gekozen alleen dagboek memoriaal tonen
    $dagboeken = $post->dagboekenPullDown("\"code\"='memo'"); break;
  default : // bij periodes > 0 dagboek beginbalans niet tonen
    $dagboeken = $post->dagboekenPullDown("\"type\" NOT LIKE 'begin'"); break;
}

// Als $post->code_gevonden is false betekent dat er geen dagboekcode uit het vorige
// scherm is aangeleverd of de dagboekcode 'begin' was. In beide gevallen highlight
// er in dit scherm nog geen dagboek, moeten de metavelden worden disabled en
// de opslaan knop (weer) verdwijnen.
//
if (! $post->code_gevonden) close_input();
 
// Journaalposten inlezen
//

// Eerst het overzicht van journaalposten dat hoort bij de gekozen selecte (periode/dagboek)
// Maak daarvan vulling voor de select box
// Als er journaalposten zijn laat dat dan zien door een tekentje achter de
// selectbox (het aantal posten erachter)
// Als er journaalposten zijn met een niet-nul saldo laat dan een opvallend
// tekentje zien (het aantal posten in rood en de ongelijke postid's in
// blokhaken erachter).

$andperiode = (! empty($post->periode)) ? "AND \"periode\"=$post->periode" : '';

$stam->query = "SELECT * FROM \"vw_journaalposten\" "
              ."WHERE \"dagboekcode\"='{$post->dagboekcode}' {$andperiode} "
              ."ORDER BY \"dagboekcode\",\"journaalpost\"";

$stam->Do_sql(basename(__FILE__)."::".__LINE__);

// als er resultaat is, zet dan het sign op resultaat (= aantal gevonden journaalposten)
// Mogelijk kan het sign straks nog veranderd worden naar critical als er journaalposten
// met een saldo tussenzitten. 
// TODO Bij kasboeken is dat waarschijnlijk zo als er nog een kasblad in bewerking
// is, maw. niet naar kas is afgeboekt. Dit kasprincipe moeten we nog nader bekijken.
// Voorlopig boeken we kasboekingen direct het grootboek in, dus zonder kasbladen of iets.
// 28-10-2008: principe kasbladen ingevoerd, net zoals een bankafschrift maar zonder locking

$jpsign = $stam->N_rows(basename(__FILE__).'::'.__LINE__);

// Als er een journaalpost voor beginbalans bestaat, dan scherminput afsluiten. Per
// beginbalans kan er maar 1 journaalpost zijn.
// In het overzicht verschijnt dan ook direct het betreffende journaalpost.
// Tevens moet de journaalpost nu automatisch geladen worden omdat er geen
// activatie meer plaats vindt vanuit het journaalposten pulldown menu. Dit
// staat immers al op de betreffende post.
if($post->dagboekcode == 'begin' && $jpsign) { 
  close_input();
  $buttons['button_nieuweboekregel'] = 1; 
  $overzicht = '';
  $post->getJournaalpost($stam->Do_object()->journaalid);
  printrc2($post, "\nBeginbalanspost geladen: \n");
  // We hebben een record geladen van de recordset. Bevraag de recordset
  // opnieuw om dalijk weer aan het begin te beginnen (dit is een bypass voor
  // het ontbreken van Data_seek in bepaalde dbase-drivers)
  $stam->Do_sql(basename(__FILE__)."::".__LINE__);
  //$stam->Herhaal(); // TODO Herhaal werkt niet in _dbasefirebird.lib
}
else {
  // Als er geen dagboek is geselecteerd is dit een stippellijn, anders keuze
  // voor een Nieuwe journaalpost.
  if($post->dagboekcode == 'none' || $post->dagboekcode == '')
    $overzicht = "\n<option value='0'>-------------------</option>";
  else
    $overzicht = "\n<option value='0'>Nieuwe journaalpost</option>";
}

// Pulldown gevonden journaalposten verder vullen
//

while($obj = $stam->Do_object()) {
  // als teruggekomen wordt van een nieuw record dan moet het
  // nieuwe record hier wel geselecteerd worden maar het moet niet verder geladen worden zodat 
  // het form leeg blijft voor evt. nog een nieuw record.
  // Gebruik dan hier het lastid uit het save scherm om de selectie zichtbaar te maken.
  $str = "{$obj->journaalpost} {$obj->jomschrijving}";
printrc2($post, "post1: ");
printrc2($obj, "obj1: ");
  if($obj->saldo <> 0) $jpsign = "<font color='red'>".$jpsign." [{$obj->journaalpost}]</font>";
  if($obj->journaalid == $post->journaalid) 
    $overzicht .= "\n<option selected='selected' value='{$obj->journaalid}'>{$str}</option>";
  else if(! empty($lastid) && $obj->journaalpost == $lastid) 
    $overzicht .= "\n<option selected='selected' value='{$obj->journaalid}'>{$str}</option>";
  else 
    $overzicht .= "\n<option value='{$obj->journaalid}'>{$str}</option>";
}

// END GEGEVENS INLEZEN

// Hebben we dit hier nodig??
// Is iets van boekregels.
//
$selected['btwdefault'] = array( INHOOG =>'', INLAAG =>'', EXHOOG =>'', EXLAAG =>'', GEENBTW =>'');

// START BUILDING BODYTEXT

  $render->iscript[] = '/js/validation.js';
  $render->iscript[] = '/app/journaal/journaal.js';

// Javascripts verlegd naar journaal.js.

// Onderstaand hebben we alleen nodig als een boekregel is geladen.
//
// Hieronder een dynamisch opgebouwde javascript: de grootboekrekeningen
// waarop GEENBTW van toepassing is. Bij zo'n rekening worden de BTW velden
// uitgeschakeld en evt. het 'bedrag' geheugen weer terug in debet of credit gestopt.
// Ook worden de btw velden geschoond
//
  if($p->aktie == 'editline') {

    if($post->periode == $GLOBALS['stam']->periodeextra['value']) { // extra periode, disable de automatische BTW velden
      $tmp = "";
    }
    else {
      require("_grootboek.lib");
      $grootboek = new Grootboek();
      $tmp = $grootboek->selectJSGeenBtwKaarten($stam);
    }

    $render->jscript .=<<<EOJ
  
  function checkGrbBtw(b) {
    // a moet een string zijn.
    var a = b.value;
    {$tmp}
  }
    
EOJ;

  }

// Create buttons

  $button_opslaan=<<<EOT

        <input type="button" name="opslaanpost" value="opslaan" size="10" class='bsmall2' class='bsmall2' onClick="sendForm('');"/>
EOT;
  $button_verwijder=<<<EOT

        <img src='/img/b_drop.png' class="pointer" onClick="doDelete({$post->journaalid});" title='Verwijder journaalpost'/>
EOT;
  $button_reset=<<<EOT

        <input type='reset' name='reset' value='reset' size='10' class='bsmall2' />
EOT;
  $button_nieuweboekregel=<<<EOT

        <input type="button" name="boekregelnieuw" value="nieuwe boekregel" size="10" class='bsmall2' onClick="editLine('{$post->journaalid}','');" />
EOT;
  $button_sluiten=<<<EOT

        <input type='button' name='sluiten' value='sluit scherm' size='10' class='bsmall2' onClick='window.close()'/>
EOT;

  $button_editjournaalpost=<<<EOT

        <img src='/img/b_edit.png' class="pointer" onClick="editJournaalMeta('{$post->journaalid}','');" title='Edit gegevens journaalpost'/>
EOT;

  $button_printen=<<<EOT

        <img src='/img/printer1.gif' class='pointer' onClick='window.print();'/>
EOT;

  $button_printenx=<<<EOT

        <img src='/img/printer1.gif' class="pointer" onClick="win=window.open('/run.php?app=journaalpost&aktie=print','',{$GLOBALS['WINDOW_OPTIONS']['SCHEMAS']});"/>
EOT;

// Welke buttons moeten we tonen?
  $printbuttons = $formbuttons = '';
  foreach($buttons AS $key=>$val) {
    if($val) {
      switch($key) {
        case 'button_opslaan' : 
        case 'button_sluiten' : 
        case 'button_nieuweboekregel' : $printbuttons .= $$key; break;
        case 'button_verwijder' : 
        case 'button_editjournaalpost' : 
          // De formbuttons mogen niet altijd enabled zijn. B.v. niet als de
          // journaalpost een automatische oorsprong heeft zoals BTW
          // egalisatie. 
          if($post->joorsprong != 'egalisatie')
            $formbuttons .= $$key." &nbsp;"; 
          break;
      }
    }
  }

//
// Start het formulier
//

$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          'aktie'=>''
                         ,'m_dagboekcode'=>$post->dagboekcode
                         ,'m_dagboektype'=>$post->dagboektype
                         ,'journaalsaldo'=>$post->saldo
                         ,'btwhoog'=>$stam->btwverkoophoog['value']
                         ,'btwlaag'=>$stam->btwverkooplaag['value']
                         ,'dagboekgrootboekrekening'=>$post->dagboekgrootboekrekening
                         ,'boekregel'=>''
                         ,'aantalboekregels'=>count($post->boekregel)
                         ) );

  $form->mainTableStart();

  // Eerste fieldblock
  // Keuzevelden: periode, dagboekcode, bestaande journaalposten

    $form->fieldSetStart("Journaalposten &nbsp; - &nbsp; Boekjaar: {$stam->boekjaar}",array('','Journaal..journaalpost','Journaalpost'));
    
      $form->blockLine('',
                       array("periode: <select name='periode' onChange='periodeLoad(this);' {$disabled['periodes']} >{$periodes}</select>"
                            ,"dagboek: <select name='dagboekcode' onChange='dagboekLoad(this);' {$disabled['dagboeken']} >{$dagboeken}</select>"
                            ,"post: <select name='overzicht' onChange='doLoadId(this);'>{$overzicht}</select> &nbsp; {$jpsign}"), 
                       array("","","") );

    $form->fieldSetBridge("Gegevens journaalpost",array('','Journaal..gegevensJournaalpost','Gegevens Journaalpost'));

    // messages
    //
    $form->messagePrint();

  // Journaalnummer, periode, journaalpostsaldo
    
      $form->blockLine('',
                       array("Journaalpostnummer:",
                             "<input type='text' name='viewid' value='{$post->journaalpost}' size='5' {$disablethis} /> &nbsp;
                              periode: <input type='text' name='viewperiode' value='{$post->periode}' size='2' {$disablethis} /> &nbsp;
                              saldo journaalpost: <input type='text' name='viewsaldo' value='".formatbedrag($post->saldo,$null=true)."' size='10' onChange='c_saldo.value=true;setType(this);' {$disablethis} style='text-align:right' /> &nbsp;
                              record: <span class='veldsub'>{$post->journaalid}</span>
                              <input type='hidden' name='journaalid' value='{$post->journaalid}' />"),
                       array("nowrap='nowrap', width='100'","","width='70%'") );
      

    //
    // Vanaf hier een voor het dagboektype specifieke regels en logica
    //

    switch($post->dagboektype) {
      case 'kasX'    : break; // TODO kas dagboektype nader uitwerken
      case 'kas'     : include('_dagboektype_kas.inc'); break;
      case 'memo'    : include('_dagboektype_memo.inc'); break;
      case 'begin'   : include('_dagboektype_begin.inc'); break;
      case 'bank'    : include('_dagboektype_bank.inc'); break;
      case 'inkoop'  : include('_dagboektype_inkoop.inc'); break;
      case 'verkoop' : include('_dagboektype_verkoop.inc'); break;
      case 'pin'     : include('_dagboektype_pin.inc'); break;
    }

  // Buttonstrap

    $form->fieldSetBridge();

      $form->blockLine('2',array($printbuttons,$button_printen),
                           array("width='90%'","width='10%' style='text-align:right'") );

  // Boekregel edit

  // een nieuwe regel openen ingeval zojuist een nieuwe regel opgeslagen
  // en het saldo is nog niet 0.00. Om een vreemde reden is het saldo een '0' ipv '0.00'
  if($aktie == 'saveline' && $p->isnieuw && $post->saldo != '0') {
    $post->Boekregel_edit($form, '');
    $render->onload .= "document.forms['frm1'].boekdatum.focus();";
  }
  elseif(preg_match("/^saveline/",$aktie) && $p->isnieuw && $post->saldo == '0') {
    $render->onload .= "document.forms['frm1'].dagboekcode.focus();";
  }
  else if($aktie == 'editline' && $p->boekregel == '') { // 1e aanroep voor een nieuwe regel
    $post->Boekregel_edit($form, '');
    $render->onload .= "document.forms['frm1'].boekdatum.focus();";
  }
  else if($aktie == 'editline' && $p->boekregel != '') { // edit een bestaande regel
    $post->Boekregel_edit($form, $p->boekregel);
    $render->onload .= "document.forms['frm1'].boekdatum.focus();";
  }

  // Als een nieuwe relatieid is gekozen uit de relatie-pulldown, dan focus
  // leggen op het volgende veld (is viewfactuurnummer)
  if(isset($p->viewrelatieid)) { 
    if($p->viewrelatieid != '' && $p->relatieid == '') 
      $render->onload .= "document.forms['frm1'].viewfactuurnummer.focus();";
  }

  // Overzicht boekregels van deze journaapost

  if(! empty($post->boekregel)) {

    $post->Journaal_body($form);

  } // END Boekregels

    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();
 
/* __END__ */
