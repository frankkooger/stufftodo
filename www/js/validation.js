// vim: syntax=javascript fdm=indent fdc=4 so=100
/**
* @version		$Id: validation.js 293 2015-01-06 15:38:15Z otto $
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
 * validation routines voor:
 * - datum  doCheckDatum(inputobject, opties)
 * - datum, ouder dan vandaag mustbeOldwerthan(this)
 * - datum, nieuwer dan vandaag mustbeNewerthan(this), vandaag ook nog geldig
 * - emailadres  doCeckEmail(inputobject)
 * - telefoonnummer  doCheckTelephone(inputobject)

 * datumroutines:
 * - vandaag returnToday() in euro formaat dd-mm-jjjj
 * - plaats voorloopnul bij tientallen  x = LZ(y)
 * - plaats voorlopnullen bij hondertallen  x = LZZ(y)

 * systemroutines
 * -  return dom object based on ElementById
 * 
 * helproutines
 * - toon helptekst in popup  Help(code,tag) {
 *   <td><a href="#" onClick="Help('veld_verbergen','Item plaatsen of verbergen');return false;"><img src="/img/helpbubble.gif" width="14" height="14" hspace=2 border=0 align=absmiddle style="cursor:help;"></a></td>
 *
 * @abstract
 * @package		OpenAdmin.nl
 * @since		1.0
 */

// 
// more about javascript annotations:
// http://ariya.ofilabs.com/2014/04/tracking-javascript-annotations.html
//

/**  
 * return dom object based on ElementById
 * 
 * @param {type} x
 * @returns {Element}
 */
function _(x) {
  return window.document.getElementById(x);
}

// Frank Kooger, May 1999
//
// Deze versie is millenniumproof tot 2050
// en zet data om naar:
// a)  maand als engelstalige strings volgens RFC (d-M-yyyy)
// b)  datum volgens ISO 8601 (yyyy-mm-dd)
// c)  datum volgens Western-European habit (dd-mm-yyyy)
/**
 * 
 * @param {type} deze
 * @param {type} options
 * @param {type} huidigjaar
 * @returns {Boolean}
 */
function doCheckDatum(deze, options, huidigjaar) {
  var b2 = true; 
  var isodate = false;
  var maandstring = false;
  var datum = deze.value ;
  var nofuture = false;
  var tijd = '';

  if(options === "nofuture")
    nofuture = true;

// alert(datum);
// alert(huidigjaar);

//doe dit slechts als er iets in het veld is ingevuld
  if (datum.length > 0)  {

// controleer eerst of er een tijdtag met de datum is meegeleverd (<datum> 11:22:33)

    re = new RegExp(" [0-9]{2}:[0-9]{2}:[0-9]{2}$");
    if(re.test(datum)) { // er is een tijdtag, splits de datum in een datum en tijdvar
      x = datum.length;
      tijd = datum.substring(x-8);
      datum = datum.substring(0,x-9);
      // alert("'" + datum + "'" );
      // alert("'" + tijd + "'" );
    }
    
// check op isodatum zonder scheidingstekens

    re = new RegExp("^[12][0-9]{3}[01][0-9][0-3][0-9]$");
    if(re.test(datum)) { // is isodatum zonder scheidingstekens
      d = datum;
      datum = d.substr(0,4) + "-" + d.substr(4,2) + "-" + d.substr(6,2);
    }

//vervang mogelijke datumscheidingstekens door "-"

    d = datum.replace(/[ \/.,]/g, "-");

//    d = datum; le = datum.length;
//    for ( x = 1 ; x <= le; x++ )  {
//      a = datum.charAt(x) ;
//      if ( a == "/" || a == " " )  {
//        d = d.substring(0,x) + "-" + d.substring(x+1, le);
//      }
//    }

// Ga na of alleen een jaartal is ingevuld
// Als dat juist is, return
// Ga anders door

    re = new RegExp("^[1-2][0-9]{3}$");
    if(re.test(d)) { return true; }

// Scheidt datum in tokens
    datearray=d.split("-");    //splits in een array

// als datum bestaat uit twee leden dan wordt default
// het huidige jaar verondersteld; voeg dat hier toe
// 2009-01-03:
// Begin van het jaar is het niet raadzaam om aan te vullen met het nieuwe jaar
// omdat de meeste boekingen dan nog plaatsvinden vanuit het vorige jaar. Als
// daarom een argument 'huidigjaar' is meegegeven, gebruik dat dan om de datum
// aan te vullen.

    if (datearray.length === 2) {
      if(huidigjaar) {
        datearray[2] = huidigjaar;
      }
      else {
        var Today = new Date();
        datearray[2] = Today.getFullYear().toString() ;
      }
    }

// datum moet nu uit minstens drie delen bestaan

    if (datearray.length < 3) {
      alert("Datum is niet juist! " + deze.value + "\n");
      deze.value = "";
      return false;
    }
    a = datearray[0]; b = datearray[1]; var c = datearray[2];



// Bepaal nu of token a voldoet aan jaarkenmerken
// Indien ja: neem isodate aan, verwissel de inhoud van a en c 
//            tbv de verdere interne verwerking.

    re = new RegExp("^[1-2][0-9]{3}$");
    rf = new RegExp("^([0-9]|[0-3][0-9])$");

    if(re.test(a)) { 
      temp = a; a = c; c = temp;
    }
    else if(rf.test(a)) { // normal date is true
    }
    else { // false
      return exception1(deze);
    }

// Jaartalcheck
    if (c.length === 2) {
      if (c >= 30) { c = "19" + c ; }
      if (c < 30) { c = "20" + c ; }
    }
    else  {
      if (c.length !== 4) {
        alert("\nVerkeerd jaartal: "+c+"\nJuiste formaat is: jj of jjjj");
        deze.value="";
        deze.focus() ;
        return false ;
      }
    }

//    if (parseInt(c) < 1950 || parseInt(c) > 2050) {
//      alert("\nVerkeerd jaartal: "+c+"\nMoet liggen tussen 1950 en 2050\n");
//      deze.value="";
//      deze.focus() ;
//      return false ;
//      }

// Bepaal lengte van maanden
    
    veel = 31; weinig = 30; schrikkel=28;

    if ( c%4 === 0)  {
      if ( c%100 === 0 && c%400 > 0)  {
        schrikkel=28;
      }
      else  {
        schrikkel=29;
      }
    }

// Bepaal invoer van maanden
// Tbv deze functie worden maanden omgezet naar numerieke waarden

//    if (b < 1 || b > 12)  {
      b1 = b.toUpperCase();
      b1 = b1.substring(0, 3);
      if      ( b1 === "JAN" )                  { b="1";}
      else if ( b1 === "FEB" )                  { b="2";}
      else if ( b1 === "MAR" || b1 === "MAA" )  { b="3";}
      else if ( b1 === "APR" )                  { b="4";}
      else if ( b1 === "MAY" || b1 === "MEI" )  { b="5";}
      else if ( b1 === "JUN" )                  { b="6";}
      else if ( b1 === "JUL" )                  { b="7";}
      else if ( b1 === "AUG" )                  { b="8";}
      else if ( b1 === "SEP" )                  { b="9";}
      else if ( b1 === "OCT" || b1 === "OKT" )  { b="10";}
      else if ( b1 === "NOV" )                  { b="11";}
      else if ( b1 === "DEC" )                  { b="12";}
//    }
//alert(b+"="+b1+"-"+b.length);

    if (b.length === 1)  { b = "0" + b ; }
    if (b > 12)  {
      alert("\nMaand niet juist: "+b+"\nJuiste formaat is: dd-mm-jjjj of dd-M-jjj");
      deze.value="";
      deze.focus() ;
      return false ;
    }

    if (a.length === 1)  { a = "0" + a ; }
    
    if (b === 1 || b === 3 || b === 5 || b === 7 || b === 8 || b === 10 || b === 12)  {
      if (a < 1 || a > veel)  {
        alert("\nDag niet juist: "+a+"\nMoet liggen tussen 1 en " + veel);
        deze.value="";
        deze.focus() ;
        return false ;
      }
    }
    else  {
      if (b === 4 || b === 6 || b === 9 || b === 11)  {
        if (a < 1 || a > weinig)  {
          alert("\nDag niet juist: "+a+"\nMoet liggen tussen 1 en " + weinig);
          deze.value="";
          deze.focus() ;
          return false ;
        }
      }
    }

    if (b === 2)  {
      if (a < 1 || a > schrikkel)  {
        alert("\nDag niet juist: "+a+"\nMoet liggen tussen 1 en " + schrikkel);
        deze.value="";
        deze.focus() ;
        return false ;
      }
    }

// we hebben nu een schone datum
// kijk of de datum niet in de toekomst ligt als
// het argument 'nofuture' is meegegeven

    if(nofuture) {

        alert("\nDatum ligt in de toekomst \nDat is niet toegestaan ");
        deze.value="";
        deze.focus() ;
        return false ;
    }

// Zet maand weer terug naar een engelstalige stringwaarde
// als switch maandstring aanstaat

    if (maandstring && !isodate)  {
      switch(b) {
        case "01": b="Jan"; break;
        case "02": b="Feb"; break;
        case "03": b="Mar"; break;
        case "04": b="Apr"; break;
        case "05": b="May"; break;
        case "06": b="Jun"; break;
        case "07": b="Jul"; break;
        case "08": b="Aug"; break;
        case "09": b="Sep"; break;
        case "10": b="Oct"; break;
        case "11": b="Nov"; break;
        case "12": b="Dec"; break;
        default  : b2=false; break;
      }
    }
    else  {
      switch(b) {
        case "01": b2=true; break;
        case "02": b2=true; break;
        case "03": b2=true; break;
        case "04": b2=true; break;
        case "05": b2=true; break;
        case "06": b2=true; break;
        case "07": b2=true; break;
        case "08": b2=true; break;
        case "09": b2=true; break;
        case "10": b2=true; break;
        case "11": b2=true; break;
        case "12": b2=true; break;
        default  : b2=false; break;
      }
    }

    if(!b2)  {
      alert("\n(2)Maand niet juist: "+b+"\n");
      deze.value="";
      deze.focus() ;
    }
    else  { // alles akkoord, vul de nieuwe datum in
      if(tijd !== '') tijd = " " + tijd; // als het tijdtag is ingevuld, doe er een spatie voor
                                        // en voeg hem weer aan de datum toe
      if(isodate) { deze.value = c + "-" + b + "-" + a + tijd; }
      else  { deze.value = a + "-" + b + "-" + c + tijd; }
    }
    veranderd=1 ;
    return true;
  }
}

/**
 * 
 * @param {type} deze
 * @returns {Boolean}
 */
function doCheckTelephone(deze) {
  var telStr = deze.value ;
  var telPat=/^[+0-9][-+0-9 ()]+$/; 
  var matchArray=telStr.match(telPat); 

  if (deze.value.length < 10) {
    alert("Het telefoonnummer moet minimaal 10 posities bevatten!");
    return false;
  }
  
  if (matchArray === null) { 
    alert("Het telefoonnummer bevat niet-valide tekens!"); 
    return false; 
  } 
  return true;
} 

/**
 * 
 * @param {type} deze
 * @returns {Boolean}
 */
function doCheckEmail(deze) {
  var emailStr = deze.value ;
  var checkTLD=0; 
  var knownDomsPat=/ ^(com|net|org|edu|int|mil|gov|arpa|biz|aero|name|coop|info|pro|museum)$/; 
  var emailPat=/^(.+)@(.+)$/; 
  var specialChars="\\(\\)><@,;:\\\\\\\"\\.\\[\\]"; 
  var validChars="\[^\\s" + specialChars + "\]"; 
  var quotedUser="(\"[^\"]*\")"; 
  var ipDomainPat=/^\[(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\]$/; 
  var atom=validChars + '+'; 
  var word="(" + atom + "|" + quotedUser + ")"; 
  var userPat=new RegExp("^" + word + "(\\." + word + ")*$"); 
  var matchArray=emailStr.match(emailPat); 
  if (matchArray === null) { 
    alert("Het E-mail adres is niet juist!"); 
    return false; 
  } 
  var user=matchArray[1]; 
  var domain=matchArray[2]; 
  for (i=0; i<user.length; i++) { 
    if (user.charCodeAt(i)>127) { 
      alert("De gebruikersnaam bevat niet-valide tekens."); 
      return false; 
    } 
  } 
  for (i=0; i<domain.length; i++) { 
    if (domain.charCodeAt(i)>127) { 
      alert("De domeinnaam bevat niet-valide tekens."); 
      return false; 
    } 
  } 
  if (user.match(userPat) === null) { 
    alert("De gebruikersnaam is niet juist."); 
    return false; 
  } 
  var IPArray=domain.match(ipDomainPat); 
  if (IPArray !== null) { 
    for (var i=1;i<=4;i++) { 
      if (IPArray>255) { 
        alert("Het IP Adres is niet juist."); 
        return false; 
      } 
    } 
  return true; 
  } 
  var atomPat=new RegExp("^" + atom + "$"); 
  var domArr=domain.split("."); 
  var len=domArr.length; 
  for (i=0;i<len;i++) { 
    if (domArr[i].search(atomPat) === -1) { 
      alert("De domeinnaam is niet juist."); 
      return false; 
    } 
  } 
  if (checkTLD && domArr[domArr.length-1].length !== 2 && 
    domArr[domArr.length-1].search(knownDomsPat) === -1) { 
    alert("De domeinnaam extentie is niet juist"); 
    return false; 
  } 
  if (len<2) { 
    alert("Er is geen hostnaam bekend."); 
    return false; 
  }
  return true;
} 

function returnToday() {
  var Today = new Date();
  var strDate = LZ(Today.getDate().toString());
	strDate += "-" + LZ(Today.getMonth()+1) + "-" + Today.getFullYear().toString() ;
	return strDate;
}

/** Leading Zero in decimals
 * 
 * @param {type} x
 * @returns {String}
 */
function LZ(x) {
  return (x < 0 || x >= 10 ? "" : "0") + x.toString();
}

/** Leading Zeros in hundreds
 * 
 * @param {type} x
 * @returns {String}
 */
function LZZ(x) {
  return x < 0 || x >= 100 ? "" + x : "0" + LZ(x);
}

/**
 * 
 * @param {type} TRIM_VALUE
 * @returns {String}
 */
function Trim(TRIM_VALUE){
  if(TRIM_VALUE.length < 1){
    return"";
  }
  TRIM_VALUE = RTrim(TRIM_VALUE);
  TRIM_VALUE = LTrim(TRIM_VALUE);
  if(TRIM_VALUE === ""){
    return "";
  }
  else{
    return TRIM_VALUE;
  }
} //End Function Trim

/**
 * 
 * @param {type} VALUE
 * @returns {String}
 */
function RTrim(VALUE){
  var w_space = String.fromCharCode(32);
  var v_length = VALUE.length;
  var strTemp = "";
  if(v_length < 0){
    return"";
  }
  var iTemp = v_length -1;

  while(iTemp > -1){
    if(VALUE.charAt(iTemp) === w_space){
    }
    else{
      strTemp = VALUE.substring(0,iTemp +1);
      break;
    }
    iTemp = iTemp-1;

  } //End While
  return strTemp;
} //End Function RTrim

/**
 * 
 * @param {type} VALUE
 * @returns {String}
 */
function LTrim(VALUE){
  var w_space = String.fromCharCode(32);
  if(v_length < 1){
    return"";
  }
  var v_length = VALUE.length;
  var strTemp = "";

  var iTemp = 0;

  while(iTemp < v_length){
    if(VALUE.charAt(iTemp) === w_space){
    }
    else{
      strTemp = VALUE.substring(iTemp,v_length);
      break;
    }
    iTemp = iTemp + 1;
  } //End While
  return strTemp;
} //End Function LTrim

/**
 * 
 * @param {type} deze
 * @returns {Boolean}
 */
function mustbeOlderthan(deze) {
  var Today = new Date();
  var strDate = Today.valueOf();

  var oldArr = deze.value.split("-");
  var oldDate1 = new Date(oldArr[2], oldArr[1]-1, oldArr[0]);

  // check of de aangeboden datum ouder of gelijk is dan vandaag
  // dwz. kleiner is dan vandaag
  if(oldDate1.valueOf() > Today.valueOf()) {
    // groter dan vandaag dus de aangeboden datum moet minstens
    // op morgen staan
    alert("\nAangeboden datum "+deze.value+" is nieuwer dan vandaag \nDat is hier niet toegestaan\n");
    deze.value="";
    deze.focus() ;
    return false ;
  }
  return true;
}

/**
 * 
 * @param {type} deze
 * @returns {Boolean}
 */
function mustbeNewerthan(deze) {
  var Today = new Date();
  var strDate = Today.valueOf();

  var oldArr = deze.value.split("-");
  // type casting anders wordt de string "1" erbij opgeteld
  // bij aftrekken is geen typcasting nodig
  var x = Number(oldArr[0])+1;
  var oldDate1 = new Date(oldArr[2], oldArr[1]-1, x);

  // check of de aangeboden datum nieuwer is dan vandaag
  // dwz. groter is dan vandaag
  if(oldDate1.valueOf() < Today.valueOf()) {
    // groter dan vandaag dus de aangeboden datum moet minstens
    // op morgen staan
    //alert("\nAangeboden datum "+deze.value+" is ouder dan vandaag\nDat is hier niet toegestaan\n");
    alert("Datum kan niet in het verleden zijn. Vul toekomstige datum in.");
    deze.value="";
    deze.focus() ;
    return false ;
  }
  return true;
}

/**
 * 
 * @param {type} a
 * @param {type} b
 * @returns {Boolean}
 */
function mustbeSmaller(a,b) {
  var Today = new Date();
  var strDate = Today.valueOf();
  if (a.value === "" || b.value === "") { return true; }
  var oldArr = a.value.split("-");
  // type casting anders wordt de string "1" erbij opgeteld
  // bij aftrekken is geen typcasting nodig
  var x = Number(oldArr[0])+1;
  var oldDate1 = new Date(oldArr[2], oldArr[1]-1, x);

  var newArr = b.value.split("-");
  // type casting anders wordt de string "1" erbij opgeteld
  // bij aftrekken is geen typcasting nodig
  var x = Number(newArr[0])+1;
  var newDate1 = new Date(newArr[2], newArr[1]-1, x);

  // check of de aangeboden datum nieuwer is dan vandaag
  // dwz. groter is dan vandaag
  if(oldDate1.valueOf() > newDate1.valueOf()) {
    // groter dan vandaag dus de aangeboden datum moet minstens
    // op morgen staan
    alert("\nAangeboden datum "+a.value+" is groter dan "+b.value+" \nDat is hier niet toegestaan\n");
    a.value="";
    a.focus() ;
    return false ;
  }
  return true;
}

/**
 * 
 * @returns {undefined}
 */
function returnTest() {
  var Today = new Date();
  var strDate = Today.valueOf();

  var oldate = "09-06-2004";
  var oldArr = oldate.split("-");
  var oldDate1 = new Date(oldArr[2], oldArr[1]-1, oldArr[0]);
  var oldDate2 = new Date("2004/06/09");
  
  document.write("Today is : " + strDate);
  document.write("<br />\n");
  document.write("Olddate1 is: " + oldDate1.valueOf());
  document.write("<br />\n");
  document.write("Olddate2 is: " + oldDate2.valueOf());
}

/**
 * 
 * @param {type} name
 * @param {type} value
 * @param {type} expires
 * @param {type} path
 * @param {type} domain
 * @param {type} secure
 * @returns {Number|setRawCookie@pro;window@pro;document@pro;cookier@call;join|Boolean}
 */
function setRawCookie (name, value, expires, path, domain, secure) {
    // Send a cookie with no url encoding of the value  
    // 
    // version: 909.322
    // discuss at: http://phpjs.org/functions/setrawcookie
    // +   original by: Brett Zamir (http://brett-zamir.me)
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   derived from: setcookie
    // *     example 1: setcookie('author_name', 'Kevin van Zonneveld');
    // *     returns 1: true
    if (expires instanceof Date) {
        expires = expires.toGMTString();
    } else if (typeof(expires) === 'number') {
        expires = (new Date(+(new Date()) + expires * 1e3)).toGMTString();
    }

    var r = [name + "=" + value], s={}, i='';
    s = {expires: expires, path: path, domain: domain};
    for (i in s){
        s[i] && r.push(i + "=" + s[i]);
    }
    
    return secure && r.push("secure"), this.window.document.cookie = r.join(";"), true;
}

/**
 * 
 * @param {type} name
 * @param {type} value
 * @param {type} expires
 * @param {type} path
 * @param {type} domain
 * @param {type} secure
 * @returns {setCookie@call;setRawCookie}
 */
function setCookie (name, value, expires, path, domain, secure) {
    // Send a cookie  
    // 
    // version: 909.322
    // discuss at: http://phpjs.org/functions/setcookie
    // +   original by: Jonas Raoni Soares Silva (http://www.jsfromhell.com)
    // +   bugfixed by: Andreas
    // +   bugfixed by: Onno Marsman
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // -    depends on: setrawcookie
    // *     example 1: setcookie('author_name', 'Kevin van Zonneveld');
    // *     returns 1: true
    return this.setRawCookie(name, encodeURIComponent(value), expires, path, domain, secure);
}

/**
 * 
 * @param {type} Name
 * @returns {getCookie.returnvalue|String}
 */
function getCookie(Name) {
  var search = Name + "=";
  var returnvalue = "";
  if (document.cookie.length > 0) {
    offset = document.cookie.indexOf(search);
    // if cookie exists
    if (offset !== -1) {
      offset += search.length;
      // set index of beginning of value
      end = document.cookie.indexOf(";", offset);
      // set index of end of cookie value
      if (end === -1) end = document.cookie.length;
      returnvalue=unescape(document.cookie.substring(offset, end));
    }
  }
  return returnvalue;
}
