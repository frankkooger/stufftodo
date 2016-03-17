// vim: syntax=javascript fdm=marker fdc=0 so=100
/**
* @version		$Id: ajax.js 293 2015-01-06 15:38:15Z otto $
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

  //
  // eventHandler begin
  //

  function addEvent( obj, type, fn ) {
    if (obj.addEventListener) {
      obj.addEventListener( type, fn, false );
      EventCache.add(obj, type, fn);
    }
    else if (obj.attachEvent) {
      obj["e"+type+fn] = fn;
      obj[type+fn] = function() { obj["e"+type+fn]( window.event ); };
      obj.attachEvent( "on"+type, obj[type+fn] );
      EventCache.add(obj, type, fn);
    }
    else {
      obj["on"+type] = obj["e"+type+fn];
    }
  }

  var EventCache = function(){
    var listEvents = [];
    return {
      listEvents : listEvents,
      add : function(node, sEventName, fHandler){
        listEvents.push(arguments);
      },
      flush : function(){
        var i, item;
        for(i = listEvents.length - 1; i >= 0; i = i - 1){
          item = listEvents[i];
          if(item[0].removeEventListener){
            item[0].removeEventListener(item[1], item[2], item[3]);
          };
          if(item[1].substring(0, 2) !== "on"){
            item[1] = "on" + item[1];
          };
          if(item[0].detachEvent){
            item[0].detachEvent(item[1], item[2]);
          };
          item[0][item[1]] = null;
        };
      }
    };
  }();

  addEvent(window,'unload',EventCache.flush);

  //
  // eventHandler end
  //

  function getHTTPObject() { 
    if (typeof XMLHttpRequest !== 'undefined') { 
      return new XMLHttpRequest(); 
    } 
    try { 
      return new ActiveXObject("Msxml2.XMLHTTP"); 
    } catch (e) { 
      try { 
        return new ActiveXObject("Microsoft.XMLHTTP"); 
        } catch (e) {} 
      } 
    return false; 
  }

  var tekst;
  var TEKSTObject = getHTTPObject();

  function doURL(url) {
    TEKSTObject.open('GET',url ,false);
    TEKSTObject.setRequestHeader('Cache-Control', 'no-cache');
    TEKSTObject.send(null);
    tekst = TEKSTObject.responseText;
    return(true);
    
    // Asynchrounous mode:
    //TEKSTObject.onreadystatechange=function() {
    //  if (TEKSTObject.readyState==4) {
    //    writeOut(TEKSTObject.responseText);
    //  }
    //}
  }

  function writeOut() {
    var inhoudDiv = document.getElementById('inhoud');
    var navDiv    = document.getElementById('nav');
    url = 'index/fetch-nieuw.php?localname=' + local;
    if(haalFetch(url)) {
      // Als tekst == '0' dan zijn er geen topics.
      // Verwijder in dat geval 'Zie ook'
      if(tekst === '0') {
        navDiv.innerHTML = "";
      }
      else {
        inhoudDiv.innerHTML = tekst;
        navDiv.innerHTML = "<img src='index/minus2.gif' class='punter' onClick='closeOut()' />Deze aanwijzing is opgenomen onder de volgende ingangen/trefwoorden:";
      }
    }
    else {
      alert('og niet geladen');
    }
  }
  
  function writeOutKey(a,b) {
    // alert("writeOutKey: " + a); // div-id waar key weer moet staan
    // alert("writeOutKey: " + b); // key1, de zoekterm voor server
    var inhoudDiv = document.getElementById(a);
    url = 'index/fetch-part-key.php?localname=' + local + '&key=' + b;
    if(haalFetch(url)) {
      inhoudDiv.innerHTML = tekst + "\n";
    }
  }
  
  function writeOutSub(a,b,c) {
    // alert(a); // div-id waar key2 weer moet staan
    // alert(b); // key1+key2, samen de zoekterm voor server
    // alert(c); // key2, moet weer worden teruggeschreven na indrukken
    var inhoudDiv = document.getElementById(a);
    // Geef ook het local url mee zodat het herkend wordt tijdens het uitschrijven
    url = 'index/fetch-part-subkey.php?key=' + b + '&url=' + local;
    if(haalFetch(url)) {
      // zorg dat 'algemeen' wordt geprint met haakjes
      cprint = (c === 'algemeen') ? '(algemeen)' : c;
      var content = "<div id='" + a + "'><p class='subkey'><img src='index/minus2.gif' class='punter' onClick='closeOutSub(\"" + a + "\",\"" + b + "\",\"" + c + "\")' />" + cprint + "</p>";
      content = content + tekst + "</div>\n";
      inhoudDiv.innerHTML = content;
      //var inhoud = document.getElementById('inhoud');
      //alert("writeOutSub/inhoud: " + inhoud.innerHTML);
      //SERVER.POSTrequest(sessionurl, "inhoud=" + encodeURI(inhoud.innerHTML));
      //SERVER.POSTrequest(sessionurl, "localname=" + local + "&inhoud=" + inhoud.innerHTML);
    }
  }
  
  function closeOut() {
    var inhoudDiv = document.getElementById('inhoud');
    var navDiv    = document.getElementById('nav');
    inhoudDiv.innerHTML = '';
    navDiv.innerHTML = "<img src='index/plus2.gif' class='punter' onClick='writeOut()' />Deze aanwijzing is opgenomen onder de volgende ingangen/trefwoorden:";
  }
  

  function saveInhoud() {
    // slaat de content van 'inhoud' op in een _SESSION op de server
    TEKSTObject.open('GET',url ,false);
    TEKSTObject.setRequestHeader('Cache-Control', 'no-cache');
    TEKSTObject.send(null);
    tekst = TEKSTObject.responseText;
    return(true);
  } 

  var SERVER = {
    loaded : false,
    requestobj : TEKSTObject,
    load : function() {
      return(true);
    },
    loadrequestobj : function () {
      return(true); 
    },
    GETrequest : function(url,data,func) {
      return(true); 
    },
    POSTrequest : function(url,data,func) {
      if( !this.load() ) return false;
      this.requestobj.open('POST', url, true);
      if( func ) this.requestobj.onreadystatechange = func;
      this.requestobj.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      this.requestobj.setRequestHeader("Content-length", data.length);
      this.requestobj.setRequestHeader("Connection", "close");
      this.requestobj.send(data);
      return true;
    }
  };
