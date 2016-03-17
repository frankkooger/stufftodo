// vim: syntax=javascript fdm=manual fdc=0 so=100
/**
* @version		$Id: journaal.js 272 2013-08-22 13:48:15Z otto $
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

function doLoad(a) {
  var x = document.forms['frm1'];
  x.aktie.value='journaalpostload';
  x.submit();
}

function doLoadId(a) {
  var x = document.forms['frm1'];
  var b = a.options[a.selectedIndex].value;
  if(b) {
    x.aktie.value='journaalpostload';
    //x.journaalpost.value = b;
    x.journaalid.value = b;
    x.submit();
  }
}

function dagboekLoad(a) {
  var x = document.forms['frm1'];
  var b = a.options[a.selectedIndex].value;
  if(b) {
    x.aktie.value='dagboekload';
    x.dagboekcode.value = b;
    x.submit();
  }
}

function periodeLoad(a) {
  var x = document.forms['frm1'];
  var b = a.options[a.selectedIndex].value;
  if(b) {
    x.aktie.value='periodeload';
    x.periode.value = b;
    x.submit();
  }
}

// boekregel naar editmode
//
function editLine(a, b) {
  var x = document.forms['frm1'];
  if(a && b) {
    x.aktie.value = 'editline';
    //x.journaalpost.value = a;
    x.journaalid.value = a;
    x.boekregel.value = b;
    x.submit();
  }
  else if(a) { // nieuwe boekregel
    // Controleer eerst of het journaalsaldo 0 is in een kas of
    // bankjournaalpost. Is dat het geval dan een waarschuwing geven alvorens
    // een nieuwe boekregel te openen; doorsnee is het niet wenselijk nog een
    // boekregel te openen als het kas/bankblad al is doorgeboekt.
    if((x.m_dagboektype.value == 'kas' || x.m_dagboektype.value == 'bank') && x.journaalsaldo.value == 0 && x.aantalboekregels.value > 1) {
      // if(!confirm("Het is niet wenselijk een nieuwe boekregel te openen in een gesloten journaalpost!")) {
      alert("Het is niet toegestaan een nieuwe boekregel te openen in een gesloten kas- of bankblad!") ;
      return(false);
    }
    x.aktie.value = 'editline';
    //x.journaalpost.value = a;
    x.journaalid.value = a;
    x.boekregel.value = b;
    x.submit();
  }
}

// sla een veranderde boekregel op (nieuw en edit)
//
function saveLine(a,b) {
  var x = document.forms['frm1'];
  //
  // als we in deze functie terechtkomen (Enter gedrukt) en we staan in modus
  // 'boeking afronden' controleer dan verschillende scenarios alvorens de boeking af te ronden.
  //
  if(x.finalebutton && x.grootboekrekening.value=='' && x.debet.value=='' && x.credit.value=='') {
    // Finaleboeken zonder ingevulde grootboekrekening kan alleen maar bij kas
    if(x.m_dagboektype.value != 'kas') {
      alert("Vul een grootboekrekening in waarop je het resterende saldo wilt wegboeken!");
      return(false);
    }
    else {
      if(confirm("Wil je de boeking afronden en het saldo wegboeken \nop rekening: " + x.dagboekgrootboekrekening.value + " van dagboek: " + x.m_dagboekcode.value + " ?")) {
        x.aktie.value = 'savelinefinale';
      } // END IF confirm
      else return(false);
    } // END ELSE 
  } // END IF first choice
  //
  // anders, als wel een grootboekrekening is ingegeven maar geen bedrag en er is geen finaletoets
  // dan veronderstellen we dat het resterende  journaalsaldo op die grootboekrekening moet
  // worden geboekt (een shortcut om niet het laatste bedrag te hoeven invullen)
  //
  else if(x.grootboekrekening.value!='' && x.debet.value=='' && x.credit.value=='' && x.journaalsaldo.value != 0) {
    // var tjs=Math.round((x.journaalsaldo.value )*100)/100 ;
    var tjs = parseFloat(x.journaalsaldo.value).toFixed(2);
    //
    // We hebben nu het resterende saldo in 'tjs'. Kijk nu of er een BTW button
    // is ingedrukt. Ook hier moeten we rekening houden met het feit dat het
    // eindsaldo via een bank of andere rekening wordt geboekt. De status
    // hiervan is te vinden in 'x.reverse'
    //
    if(x.reverse.value) {
      if(tjs < 0) { tjs = tjs * -1; decr = 'als uitgave (debet)' } else decr = 'als ontvangst (credit)';
    }
    else {
      if(tjs < 0) { tjs = tjs * -1; decr = 'debet' } else decr = 'credit';
    }
    if(! confirm("Ik boek nu het resterende journaalsaldo: " + tjs + " " + decr + " op rekening: " + x.grootboekrekening.value)) 
      return(false);
    else {
      if(x.reverse.value) {
        if(decr.match(/credit/)) x.debet.value = tjs;
        else x.credit.value = tjs; 
      }
      else {
        if(decr=='credit') x.credit.value = tjs;
        else x.debet.value = tjs; 
      }
      x.aktie.value = 'saveline';
    }
  }
  else if(x.grootboekrekening.value!='' && x.debet.value=='' && x.credit.value=='' && x.journaalsaldo.value == 0) {
    alert("Het resterende journaalsaldo is nul: " + (x.journaalsaldo.value * -1) + "\nen kan niet op rekening: " + x.grootboekrekening.value + " geboekt worden!"); 
    return(false);
  }
  else if(x.grootboekrekening.value=='' && x.debet.value=='' && x.credit.value=='') {
    alert("Een verplicht veld: grootboekrekening/debet/credit is nog niet ingevuld!");
    return(false);
  }
  else if(b == 'finale' && (x.debet.value!='' || x.credit.value!='')) {
    alert("Kan geen eindeboeking doen als een bedrag is ingevuld!");
    return(false);
  }
  else if(b == 'finale') 
    x.aktie.value = 'savelinefinale';
  else              
    x.aktie.value = 'saveline';

  x.boekregel.value = a;
  x.submit();
}

// verwijder een boekregel
//
function deleteLine(b) {
  var x = document.forms['frm1'];
  if(b != '') {
    if(confirm("Weet je zeker dat je boekregel " + b + " wilt verwijderen?!")) {
      x.aktie.value = 'deleteline';
      x.boekregel.value = b;
      x.submit();
    }
  }
}

// sluit een boekregel
//
function closeLine(a) {
  var x = document.forms['frm1'];
  if(a) {
    x.submit();
  }
}

// verwijder een journaalpost
//
function doDelete(a) {
  var x = document.forms['frm1'];
  if(a) {
    if(confirm("Weet je zeker dat je journaalpost " + a + " wilt verwijderen?!")) {
      x.aktie.value = 'deletepost';
      //x.journaalpost.value = a;
      x.journaalid.value = a;
      x.submit();
    }
  }
}

function calcbtw(a) {
  var x = document.forms['frm1'];
  //
  // op tijd typecasting is belangrijk in javascript
  // ga ervan uit dat bedragen waarmee gerekend wordt
  // eerst getypecast moeten worden
  //
  var hoog   = parseFloat(x.btwhoog.value);
  var laag   = parseFloat(x.btwlaag.value);
  var jsaldo = parseFloat(x.journaalsaldo.value);
  var d = x.debet.value.replace(/[.,]/g, ".");
  var c = x.credit.value.replace(/[.,]/g, ".");
  var b = x.bedrag;

  //
  // Als er geen bedrag in debet en credit is dan veronderstellen we een
  // calculatie op het journaalsaldo. Breng dit naar 'bedrag' en reken er
  // verder mee. 
  //
  if(d == '' && c == '' && jsaldo != 0) {
    //
    // Deze expressie moet voor dagboeken met 'ontvangen/betaald' andersom
    // werken.
    //
    if(x.reverse.value) {
      if(jsaldo < 0) { b.value = jsaldo; }
      else if(jsaldo > 0) { b.value = jsaldo; }
    }
    else {
      if(jsaldo > 0) { b.value = jsaldo * -1; }
      else if(jsaldo < 0) { b.value = jsaldo * -1; }
    }
  }
  
  //
  // Is er een waarde in bedrag?  Anders de waarde invullen
  //
  if(b.value == '') {
    if(d != '') {
      b.value = d;
    }
    else if(c != '') {
      b.value = "-" + c;
    }
  }
  else { } // er is een bedrag, afblijven

  //
  // begin calculatie
  //
  if(a == 1 || a == 2) { // in, maak ex en rest is btw
    //
    // expressies voor btw-vrij maken
    //
    if(a == 1) calc = 100/(100 + hoog);
    else if(a == 2) calc = 100/(100 + laag);
    bedrag = (calc * b.value).toFixed(2);
    rest = (b.value - bedrag).toFixed(2);
    // bedrag = Math.round((calc * b.value)*100)/100;
    // rest = Math.round((b.value - bedrag)*100)/100;
  }
  else if(a == 3 || a == 4) { // ex, bereken btw
    if(a == 3) tmp = b.value * (hoog/100);
    else if(a == 4) tmp = b.value * (laag/100);
    rest = tmp.toFixed(2);
    // rest = Math.round(tmp*100)/100;
    bedrag = b.value;
  }
  else if(a == 5) { // geen btw
    bedrag = b.value;
    rest = '';
  }

  //
  // vul de velden met het resultaat
  //
  if(bedrag>0) {
    x.debet.value=parseFloat(bedrag).toFixed(2);
    x.btwbedrag.value=rest;
  }
  else if(bedrag<0) {
    x.credit.value=(bedrag * -1).toFixed(2);
    if(rest=='') x.btwbedrag.value='';
    else         x.btwbedrag.value=rest;
  }
}

// disable BTW velden op instigatie van een 'GEENBTW' grootboeknummer
// reset ook evt het oorspronkelijke bedrag en maak de btw velden leeg
// NOOT: deze functies zijn ook in _grootboeklookup.inc gekopieerd. Als
//       ze hier veranderen, verander ze dan ook daar.
//
function disableBtw() {
  var x = document.forms['frm1'];
  // is er al iets in x.bedrag? ja: zet dat terug in x.debet of x.credit
  if(x.bedrag.value != '') {
    if(x.bedrag.value > 0) x.debet.value = parseFloat(x.bedrag.value).toFixed(2);
    else if(x.bedrag.value < 0) x.credit.value = (x.bedrag.value * -1).toFixed(2);
  }
  x.elements['btwbedrag'].disabled = true;
  x.elements['btwbedrag'].value = '';
  for(i=0;i<5;i++) {
    x.elements['btw'][i].checked = false;
    x.elements['btw'][i].disabled = true;
  }
}

// enable BTW velden op instigatie van een 'BTW' grootboeknummer
//
function enableBtw() {
  var x = document.forms['frm1'];
  x.elements['btwbedrag'].disabled = false;
  for(i=0;i<5;i++)
    x.elements['btw'][i].disabled = false;
}

// verstuur het journaal formulier; laat er eerst de nodige controles op los
//
function sendForm(optie){
  var x = document.forms['frm1'];

  // als m_dagboekcode niet is ingevuld kan er uberhaupt niets worden opgeslagen
  if(! x.elements['m_dagboekcode'].value || x.elements['m_dagboekcode'].value == 'none') return(false);

  // Indien bankboek, controleer of het eindsaldoveld een saldo heeft. Indien
  // niet, kan het vergeten zijn in te vullen en moet een waarschuwing worden
  // gegenereerd.
  // Hetzelfde geldt voor viewbeginsaldo en viewboeknummer maar daar alleen als het een
  // eerste boeking in dit bankboek betreft dus die velden nog niet disabled
  // staan en we geacht worden hierin zelf de begingegevens in te vullen.
  // NOTE: als een bedrag wordt ingegeven als 2.234,75 dan wordt het niet goed
  // gezien door parseFloat en is het antwoord 0. Het bedrag moet worden
  // ingegeven als 2234,75 of 2234.75
  // alert(eindsaldo); return(false);
  //
  if(x.elements['m_dagboektype'].value == 'bank') {

    if(x.elements['viewboeknummer'].disabled == false) { // eerste boeking op dit bankboek
      if(x.elements['viewboeknummer'].value == '') {
        alert('Het boeknummer is nog niet ingevuld!'); 
        return(false);
      }
      else {
        // Vul nu automatisch het jomschrijving veld als hierin nog geen boeknummer is ingevuld
        //
        if(x.jomschrijving.value == 'Bankafschrift: ') x.jomschrijving.value = 'Bankafschrift: ' + x.viewboeknummer.value;
      }
      if(parseFloat(x.elements['viewbeginsaldo'].value) == 0) {
        if(! confirm('Het beginsaldo is "0,00". \nIS DIT DE BEDOELING?!!! \nDruk anders op "Cancel" en vul alsnog in!')) return(false);
      }
    }

    if(parseFloat(x.elements['eindsaldo'].value) == 0)
      if(! confirm('Het eindsaldo is "0,00". \nIS DIT DE BEDOELING?!!! \nDruk anders op "Cancel" en vul alsnog in!')) return(false);

    // Op dit punt hebben we de metavelden van de journaalpost goed ingevuld

  }
  
  // Controleer of alle verplichte velden zijn ingevuld, 
  // anders focus op dat valed leggen en een alert geven dat het veld verplicht is.
  
  var verpl = " is een verplicht veld. Eerst invullen alvorens op 'opslaan' te klikken A.U.B";

  if(x.elements['m_dagboektype'].value == 'inkoop' || x.elements['m_dagboektype'].value == 'verkoop') {
    if(x.elements['viewrelatieid'].value == '0') {
      alert("Er moet altijd een debiteur/crediteur gekozen zijn! Kies een debiteur/crediteur.");
      x.elements['viewrelatieid'].focus();
      return(false);
    }
    else if(x.elements['viewfactuurnummer'].value == '') {
      alert("factuurnr" + verpl);
      x.elements['viewfactuurnummer'].focus();
      return(false);
    }
    else if(parseFloat(x.elements['viewfactuurbedrag'].value) == 0) {
      alert("factuurbedrag" + verpl);
      x.elements['viewfactuurbedrag'].focus();
      return(false);
    }
  }

//    var ischecked = false;
//    if(document.forms['frm1'].elements['gebruikerstype'][0].checked
//       || document.forms['frm1'].elements['gebruikerstype'][1].checked
//       || document.forms['frm1'].elements['gebruikerstype'][2].checked
//       || document.forms['frm1'].elements['gebruikerstype'][3].checked
//       || document.forms['frm1'].elements['gebruikerstype'][4].checked ) {
//      ischecked = true;
//    }

  if(document.forms['frm1'].elements['datum'].value=="") {
    alert("Datum" + verpl);
    document.forms['frm1'].elements['datum'].focus();
    return(false);
  }else if(document.forms['frm1'].elements['jomschrijving'].value=="") {
    alert("Omschrijving" + verpl);
    document.forms['frm1'].elements['jomschrijving'].focus();
    return(false);
  }else {
    var x=document.forms['frm1'];
    x.aktie.value='save';
    x.submit();
    return(true);
  }
  return(false);
}

// open grootboekrekening selectie popup
// Als param!=empty, geef dan gegevens mee aan aanroep.
//
// definieer window globaal
//
var grb = '';

function grbSelectie(e) {
  var x = window.document.forms['frm1'];
  var url='';
  var empty=e;

  if(empty)
    url = '/run.php?app=grbprint&aktie=lookup';
  else
    url = '/run.php?app=grbprint&dagboektype=' + x.m_dagboektype.value + '&periode=' + x.periode.value + '&aktie=lookup#' + x.grootboekrekening.value;
  
	if (!grb.closed && grb.location) {
		grb.location.href = url;
	}
	else {
		// ['WINDOW_OPTIONS']['LOOKUPGRB']
		grb=window.open(url,'name','resizable,scrollbars,status,width=430,height=670,left=450,top=200');
		if (!grb.opener) grb.opener = self;
	}
	if (window.focus) grb.focus();
	return false;
}

// Open journaaledit popup
//
var jedit = '';

function editJournaalMeta(journaalid) {
  var x = window.document.forms['frm1'];
  var url = '/run.php?app=journaaledit&aktie=edit&journaalid=' + journaalid;
  
	if (!jedit.closed && jedit.location) {
		jedit.location.href = url;
	}
	else {
		// ['WINDOW_OPTIONS']['LOOKUPGRB']
		jedit=window.open(url,'name','resizable,scrollbars,status,width=660,height=200,left=390,top=280');
		if (!jedit.opener) jedit.opener = self;
	}
	if (window.focus) jedit.focus();
	return false;
}

// Open debiteuren of crediteurenkaart popup
//
function pop_app(app,url) {
  var x = window.document.forms['frm1'];
  var set = '';

  switch(app) {
    case 'debiteuren'   : 
    case 'crediteuren'  : 
      set = 'resizable,scrollbars,status,width=850,height=590,left=450,top=0'; break;
    default                : return; break;
  }
  url = url + x.elements['viewrelatieid'].value;

  if (!app.closed && app.location) {
    app.location.href = url;
  }
  else {
    app=window.open(url,app,set);
    if (!app.opener) app.opener = self;
  }
  if (window.focus) app.focus();
  return false;
}

