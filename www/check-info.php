<? // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: check-info.php 215 2011-09-25 18:54:41Z otto $
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
 * Testscript for testing server parameters and phpinfo
 *
 *
 * @abstract
 * @package		OpenAdmin.nl
 * @since		1.0
 */

Header("Pragma: no-cache");
Header("Cache-control: no-cache, must-revalidate");
Header("Fruits: banaan");

putenv("PGPASSWORD=dingen");


$parms = new Params(array(
			 "tijd"=>""
			,"globals"=>""
			,"cook"=>""
			,"safe"=>""
			,"naam"=>""
			,"val"=>""
			,"pad"=>""
			,"domein"=>""
      ,"dateunixstring"=>""
      ,"timeunixstring"=>""
      ,"unixdatestring"=>""
      ,"md5inputstring"=>""
      ,"uinputstring"=>""
      ,"base64string"=>""
      ,"CharacterToEncode"=>""
      ,"godate2unix"=>""
      ,"gounixdate"=>""
      ,"gocrytp"=>""
      ,"urlencode"=>""
      ,"urldecode"=>""
      ,"base64encode"=>""
      ,"base64decode"=>""
      ,"characterencode"=>""
      ,"sess"=>""
      ,"info"=>""
      ,"intekst"=>""
      ,"instring"=>""
      ,"outtekst"=>""
      ,"outstring"=>""
      ,"ascval"=>""
      ,"octval"=>""
      ,"hexval"=>""
      ,"xmlval"=>""
      ,"utfval"=>""
      ,"session_name"=>""
			)
			,""
			,false);

$table = array();

if($parms->sess)  {
  $table[2] = lees_session($parms->session_name);
}

if($parms->cook):

  if($parms->tijd) { $ttijd = time()+ $parms->tijd; } // tijd in seconden
  
  if     ($parms->safe)    { setCookie($parms->naam,$parms->val,$ttijd,$parms->pad,$parms->domein,$parms->safe); }
  else if($parms->domein)  { setCookie($parms->naam,$parms->val,$ttijd,$parms->pad,$parms->domein); }
  else if($parms->pad)     { setCookie($parms->naam,$parms->val,$ttijd,$parms->pad); }
  else if($parms->tijd)    { setCookie($parms->naam,$parms->val,$ttijd); }
  else if($parms->val)     { setCookie($parms->naam,$parms->val); }
  else if($parms->naam)    { setCookie($parms->naam,""); }

endif;


// Header line

$unixtijd = time();

isset($_SERVER['PHP_AUTH_USER']) ? $php_auth_user = $_SERVER['PHP_AUTH_USER'] : $php_auth_user = "&nbsp;";
isset($_SERVER['PHP_AUTH_PW']) ? $php_auth_pw = $_SERVER['PHP_AUTH_PW'] : $php_auth_pw = "&nbsp;";

$table[0] =<<<EOF

<TABLE id='collapsed'>
  <TR>
    <TD>Client adres: </TD>
    <TD>Eigen path: </TD>
    <TD>Servername: </TD>
    <TD>Unixtime: </TD>
    <TD>Uid/pwd: </TD>
  </TR>

  <TR>
    <TD> {$_SERVER['REMOTE_ADDR']} </TD>
    <TD> {$_SERVER['PHP_SELF']} </TD>
    <TD> {$_SERVER['SERVER_NAME']} </TD>
    <TD> {$unixtijd} </TD>
    <TD> {$php_auth_user}:{$php_auth_pw} </TD>
  </TR>
</TABLE>

EOF;

// String/date/etc decode/encode

if($parms->godate2unix){
  $ard = split("-", $parms->dateunixstring);
  $art = split(":", $parms->timeunixstring);
  if(empty($ard[2]) && empty($ard[1]) && ! empty($ard[0])) {
    $ard[2] = $ard[0]; $ard[0] = "01"; $ard[1] = "01";
  }
  empty($art[0]) AND $art[0] = "00";
  empty($art[1]) AND $art[1] = "00";
  empty($art[2]) AND $art[2] = "00";
  $parms->outstring = mktime ( $art[0], $art[1], $art[2], $ard[1], $ard[0], $ard[2]);
  $parms->instring = "{$ard[0]}-{$ard[1]}-{$ard[2]} {$art[0]}:{$art[1]}:{$art[2]}";
  $parms->intekst = "Date/time in: ";
  $parms->outtekst = "Unixdate uit: ";
  $parms->unixdatestring = $parms->outstring;
  $parms->dateunixstring = "{$ard[0]}-{$ard[1]}-{$ard[2]}";
  $parms->timeunixstring = "{$art[0]}:{$art[1]}:{$art[2]}";
}
if($parms->gounixdate){
  $parms->outstring = date("d M Y H:i:s",$parms->unixdatestring);
  $parms->dateunixstring = date("d-m-Y", $parms->unixdatestring);
  $parms->timeunixstring = date("H:i:s", $parms->unixdatestring);
  $parms->instring = $parms->unixdatestring;
  $parms->intekst = "Unixdate in: ";
  $parms->outtekst = "Datum uit: ";
}
if($parms->gocrytp){
  $parms->md5inputstring=stripslashes($parms->md5inputstring);
  $parms->outstring = md5($parms->md5inputstring);
  $parms->instring = $parms->md5inputstring;
  $parms->intekst = "String in: ";
  $parms->outtekst = "MD5 hash uit: ";
}
if($parms->urlencode){
  $parms->uinputstring=stripslashes($parms->uinputstring);
  $parms->outstring = urlencode($parms->uinputstring);
  $parms->instring = $parms->uinputstring;
  $parms->intekst = "String in: ";
  $parms->outtekst = "URLencoded string: ";
}
if($parms->urldecode){
  $parms->uinputstring=stripslashes($parms->uinputstring);
  $parms->outstring = urldecode($parms->uinputstring);
  $parms->instring = $parms->uinputstring;
  $parms->intekst = "URLencoded string: ";
  $parms->outtekst = "String: ";
}
if($parms->base64encode){
  $parms->base64string=stripslashes($parms->base64string);
  $parms->outstring = base64_encode($parms->base64string);
  $parms->instring = $parms->base64string;
  $parms->intekst = "String in: ";
  $parms->outtekst = "Base64 string: ";
}
if($parms->base64decode){
  $parms->base64string=stripslashes($parms->base64string);
  $parms->outstring = base64_decode($parms->base64string);
  $parms->instring = $parms->base64string;
  $parms->intekst = "Base64 String: ";
  $parms->outtekst = "String: ";
}
if($parms->characterencode){
  $parms->CharacterToEncode=stripslashes($parms->CharacterToEncode);
  if($parms->CharacterToEncode) { 
    $parms->ascval = ord($parms->CharacterToEncode);
    $parms->octval = decoct($parms->ascval);
    $parms->hexval = dechex($parms->ascval);
    $parms->utfval = utf8_encode($parms->CharacterToEncode);
    $parms->xmlval = characterEntities($parms->CharacterToEncode);
  }
  $parms->outstring =<<<EOT
  <table id='collapsed'>
    <tr><td> dec </td><td> oct </td><td> hex </td><td> xml </td><td> utf </td></tr>
    <tr><td> {$parms->ascval} </td><td> \\0{$parms->octval} </td><td> \\0x{$parms->hexval} </td><td> {$parms->xmlval} </td><td> {$parms->utfval} </td></tr>
  </table>
EOT;
  $parms->instring = $parms->CharacterToEncode;
  $parms->intekst = "Character in: ";
  $parms->outtekst = "Coding: ";
}


$table[1] =<<<EOF

<TABLE id='collapsed'>
  <TR><TD>{$parms->intekst}</TD>
      <TD>{$parms->instring}</TD>
  </TR>

  <TR><TD>{$parms->outtekst}</TD>
      <TD>{$parms->outstring}</TD>
  </TR>
</TABLE>

EOF;

$table[3] = lees_cookies($_COOKIE);

// Start output

print_html_header();

if(! $parms->info) {

  $phpinfobutton = '<INPUT TYPE=SUBMIT VALUE="PHP info">';

if($parms->globals) {
  print("<pre>");
  print_r($GLOBALS);
  print("</pre>");
}

?>

<table>

  <tr>
    <td><?= $table[0] ?></td>
  </tr>

  <tr>
    <td style='padding: 5px'></td>
  </tr>

<? if($parms->instring || $parms->outstring) { ?>
  <tr>
    <td><?= $table[1] ?></td>
  </tr>

  <tr>
    <td style='padding: 5px'></td>
  </tr>
<? } ?>

<? if($parms->sess) { ?>
  <tr>
    <td><?= $table[2] ?></td>
  </tr>

  <tr>
    <td style='padding: 5px'></td>
  </tr>
<? } ?>

  <tr>
    <td><?= $table[3] ?></td>
  </tr>

  <tr>
    <td style='padding: 5px'></td>
  </tr>

</table>

<? } 

  else $phpinfobutton =<<<EOT
<INPUT TYPE=BUTTON VALUE="PHP info uit" onClick="document.slave.action='{$_SERVER['PHP_SELF']}?info=0';document.slave.submit();">
EOT;

?>

<FORM NAME=master METHOD=POST ACTION="<?= $_SERVER['PHP_SELF'] ?>?cook=true">
Naam:<INPUT TYPE=TEXT NAME="naam" VALUE="<?= $parms->naam ?>" SIZE=10>
Waarde:<INPUT TYPE=TEXT NAME="val" VALUE="<?= $parms->val ?>" SIZE=10>
Tijd(+sec):<INPUT TYPE=TEXT NAME="tijd" VALUE="<?= $parms->tijd ?>" SIZE=5>
Pad:<INPUT TYPE=TEXT NAME="pad" VALUE="<?= $parms->pad ?>" SIZE=10>
Domein:<INPUT TYPE=TEXT NAME="domein" VALUE="<?= $parms->domein ?>" SIZE=10>
Safety bit:<INPUT TYPE=TEXT NAME="safe" VALUE="<?= $parms->safe ?>" SIZE=2>


<BR><BR><INPUT TYPE=SUBMIT VALUE="voer cookie in">
<INPUT TYPE=BUTTON VALUE="refresh window" onClick="window.location.reload();">
</FORM>

<table>
  <tr>
    <td>
      <FORM NAME=encrypt METHOD=POST ACTION="<?= $_SERVER['PHP_SELF']; ?>?gocrytp=true">
      MD5 Inputstring: 
    </td>
    <td>
      <INPUT TYPE=TEXT NAME="md5inputstring" VALUE="<?= $parms->md5inputstring ?>" SIZE=30>&nbsp;&nbsp;&nbsp;
    </td>
    <td>
      <INPUT TYPE=SUBMIT VALUE="voer string in">
      </FORM>
    </td>
  </tr>

  <tr>
    <td>
      <FORM NAME=urlc METHOD=POST ACTION="<?= $_SERVER['PHP_SELF']; ?>?gourlencode=true">
      String to URLencode: 
    </td>
    <td>
      <INPUT TYPE=TEXT NAME="uinputstring" VALUE="<?= $parms->uinputstring ?>" SIZE=30>&nbsp;&nbsp;&nbsp;
    </td>
    <td>
      <INPUT TYPE=BUTTON VALUE="urlencode" 
        onClick="x=document.urlc;x.action='<?= $_SERVER['PHP_SELF'] ?>?urlencode=true';x.submit();">
      <INPUT TYPE=BUTTON VALUE="urldecode" 
        onClick="x=document.urlc;x.action='<?= $_SERVER['PHP_SELF'] ?>?urldecode=true';x.submit();">
      </FORM>
    </td>
  </tr>

  <tr>
    <td>
      <FORM NAME=b64 METHOD=POST ACTION="<?= $_SERVER['PHP_SELF']; ?>?base64decode=true">
      String in: 
    </td>
    <td>
      <INPUT TYPE=TEXT NAME="base64string" VALUE="<?= $parms->base64string ?>" SIZE=30>&nbsp;&nbsp;&nbsp;
    </td>
    <td>
      <INPUT TYPE=BUTTON VALUE="base64encode" 
        onClick="x=document.b64;x.action='<?= $_SERVER['PHP_SELF'] ?>?base64encode=true';x.submit();">
      <INPUT TYPE=BUTTON VALUE="base64decode" 
        onClick="x=document.b64;x.action='<?= $_SERVER['PHP_SELF'] ?>?base64decode=true';x.submit();">
      </FORM>
    </td>
  </tr>

  <tr>
    <td>
      <FORM NAME=cenc METHOD=POST ACTION="<?= $_SERVER['PHP_SELF']; ?>?characterencode=true">
      Character in: 
    </td>
    <td>
      <INPUT TYPE=TEXT NAME="CharacterToEncode" VALUE="<?= $parms->CharacterToEncode ?>" SIZE=30>&nbsp;&nbsp;&nbsp;
    </td>
    <td>
      <INPUT TYPE=BUTTON VALUE="encode character" 
        onClick="x=document.cenc;x.action='<?= $_SERVER['PHP_SELF'] ?>?characterencode=true';x.submit();">
      </FORM>
    </td>
  </tr>

  <tr>
    <td>
      <FORM NAME=unixdate METHOD=POST ACTION="<?= $_SERVER['PHP_SELF']; ?>?gounixdate=true">
      Unixdate to date: 
    </td>
    <td>
      <INPUT TYPE=TEXT NAME="unixdatestring" VALUE="<?= $parms->unixdatestring ?>" SIZE=30>&nbsp;&nbsp;&nbsp;
    </td>
    <td>
      <INPUT TYPE=SUBMIT VALUE="voer string in">
      </FORM>
    </td>
  </tr>

  <tr>
    <td>
      <FORM NAME=date2unix METHOD=POST ACTION="<?= $_SERVER['PHP_SELF']; ?>?godate2unix=true">
      Date to Unixdate: 
    </td>
    <td>
      <INPUT TYPE=TEXT NAME="dateunixstring" VALUE="<?= $parms->dateunixstring ?>" onChange="doCheckDatum(this)" SIZE=13>
      <INPUT TYPE=TEXT NAME="timeunixstring" VALUE="<? if(! empty($parms->timeunixstring)) echo $parms->timeunixstring; else echo "00:00:00"; ?>" SIZE=13>
      &nbsp;&nbsp;&nbsp;
    </td>
    <td>
      <INPUT TYPE=SUBMIT VALUE="voer date en time in">
      </FORM>
    </td>
  </tr>


  <tr>
    <td>
      <FORM NAME='session' METHOD=POST ACTION="<?= $_SERVER['PHP_SELF']; ?>?sess=true">
      Session name:
    </td>
    <td>
      <INPUT TYPE=TEXT NAME="session_name" VALUE="<?= $parms->session_name ?>" SIZE=30>
      &nbsp;&nbsp;&nbsp;
    </td>
    <td>
      <INPUT TYPE=SUBMIT VALUE="session parms">
      </FORM>
    </td>
  </tr>


  <tr>
    <td colspan='3'>
      <br />
<FORM NAME=slave METHOD=POST ACTION="<?= $_SERVER['PHP_SELF']; ?>?info=true">
<?= $phpinfobutton ?>&nbsp;
<INPUT TYPE=BUTTON VALUE="global parms" onClick="document.slave.action='<?= $_SERVER['PHP_SELF']; ?>?globals=true';document.slave.submit();">
</FORM>

    </td>
  </tr>

</table>

<?
if($parms->info)  {
  echo "&nbsp;<p>\n";
  phpinfo();
  echo "<p>\n";
}
?>

</BODY></HTML>

<?

/*****************************************************************/

// LEES HET sessions RECORD DAT OVEREENKOMT MET session_name

function lees_session($session_name) {

  if(! empty($session_name)) session_name($session_name);
  session_start();

  $tel=0;
  $str  = '<P><B>Session:</B><BR>';
  $str .= "<TABLE id='collapsed'>\n";

  foreach($_SESSION AS $key=>$val) {  
    $tel++;
    $str .= "<TR>";
    $str .= "<TD>$tel</TD><TD>$key</TD>";
    if(is_array($val))
      $str .= "<TD><pre>".print_r($val,true)."</pre></TD></TR>\n";
    else
      $str .= "<TD>".$val."</TD></TR>\n";
  }

  $str .= "</TABLE><P>\n";
  return($str);

} // END FUNCTION less_session


function lees_cookies($cookie) {

  $str = '<P><B>Cookies:</B><BR>';
  $str .= "<TABLE id='collapsed'>\n";

  foreach($_COOKIE AS $header=>$value) {
    $str .=<<<EOF

    <TR>
      <TD> $header </TD>
      <TD> $value </TD>
    </TR>
EOF;
  }

  $str .= "</TABLE><p>\n";
  return($str);
  
} // END FUNCTION lees_cookie


function print_html_header() {

  echo <<<EOF
<HTML><HEAD>
  <TITLE>Check de inhoud van cookie</TITLE>

  <SCRIPT language=javascript src=/js/validation.js></SCRIPT>

  <style type="text/css">
    .titelbalkOranje
    {
      background: #FDAA32;
      line-height: 21px;
      padding-left: 6px;
      font-size: 100%;
      font-weight: bold;
      font-family: Arial;
    }
    table
    {
      border: 0px solid black;
    }
    td
    {
      font-family: Arial;
      font-size: 100%;
      padding: 2px;
      border: 0px solid black;
    }
    .noborder {
      border: 0px;
    }
    td.noborder {
      border: 0px;
    }

    table#collapsed{border-collapse: collapse;  border: 2px solid black; float: left;caption-side:bottom;}
    table#collapsed thead{}
    table#collapsed tbody tr{}
    table#collapsed tbody td{border: 1px solid gray;}
    table#collapsed colgroup{}
    table#collapsed col{}
    table#collapsed td{}
    table#collapsed th{}
    table#collapsed tfoot{}

    body
    {
      background: #A3D38B;
    }

  </style>

  
</HEAD>
<BODY>

EOF;

} // END FUNCTION print_html_header


function characterEntities($str) {

  $search = array(
  '/[&]/',
  '/["]/',
  "/[']/",
  '/[<]/',
  '/[>]/',
  '/[`]/',
  '/\x8F/',
  '/\x90/',
  '/\x91/',
  '/\x92/',
  '/\x93/',
  '/\x94/',
  '/À/',
  '/Á/',
  '/Â/',
  '/Ã/',
  '/Ä/',
  '/Ç/',
  '/È/',
  '/É/',
  '/Ê/',
  '/Ë/',
  '/Ì/',
  '/Í/',
  '/Î/',
  '/Ï/',
  '/Ñ/',
  '/Ò/',
  '/Ó/',
  '/Ô/',
  '/Õ/',
  '/Ö/',
  '/Ù/',
  '/Ú/',
  '/Û/',
  '/Ü/',
  '/à/',
  '/á/',
  '/â/',
  '/ã/',
  '/ä/',
  '/ç/',
  '/è/',
  '/é/',
  '/ê/',
  '/ë/',
  '/ì/',
  '/í/',
  '/î/',
  '/ï/',
  '/ð/',
  '/ñ/',
  '/ò/',
  '/ó/',
  '/ô/',
  '/õ/',
  '/ö/',
  '/÷/',
  '/ø/',
  '/ù/',
  '/ú/',
  '/û/',
  '/ü/',
  '/ý/',
  '/þ/',
  '/ÿ/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/',
  '/¿/'
  );

  // zet de ampersand tussen code-tags zodat niet
  // het feitelijke karakter wordt getoond in de html pagina
  // maar de xml codering
  $replace = array(
  '&amp;',
  '&quot;',
  '&apos;',
  '&lt;',
  '&gt;',
  '&#096;',
  '&#143;',
  '&#144;',
  '&#145;',
  '&#146;',
  '&#147;',
  '&#148;',
  '&#192;',
  '&#193;',
  '&#194;',
  '&#195;',
  '&#196;',
  '&#199;',
  '&#200;',
  '&#201;',
  '&#202;',
  '&#203;',
  '&#204;',
  '&#205;',
  '&#206;',
  '&#207;',
  '&#209;',
  '&#210;',
  '&#211;',
  '&#212;',
  '&#213;',
  '&#214;',
  '&#217;',
  '&#218;',
  '&#219;',
  '&#220;',
  '&#224;',
  '&#225;',
  '&#226;',
  '&#227;',
  '&#228;',
  '&#231;',
  '&#232;',
  '&#233;',
  '&#234;',
  '&#235;',
  '&#236;',
  '&#237;',
  '&#238;',
  '&#239;',
  '&#240;',
  '&#241;',
  '&#242;',
  '&#243;',
  '&#244;',
  '&#245;',
  '&#246;',
  '&#247;',
  '&#248;',
  '&#249;',
  '&#250;',
  '&#251;',
  '&#252;',
  '&#253;',
  '&#254;',
  '&#255;',
  '&#338;',
  '&#339;',
  '&#352;',
  '&#353;',
  '&#376;',
  '&#381;',
  '&#382;',
  '&#402;',
  '&#710;',
  '&#732;',
  '&#8211;',
  '&#8212;',
  '&#8216;',
  '&#8217;',
  '&#8218;',
  '&#8220;',
  '&#8221;',
  '&#8222;',
  '&#8224;',
  '&#8225;',
  '&#8226;',
  '&#8230;',
  '&#8240;',
  '&#8249;',
  '&#8250;',
  '&#8364;',
  '&#8482;',
  '&#8729;'
  );

  //return(preg_replace($search, $replace, $str));
  return(preg_replace("/([&])(.+)$/", "<span>$1</span>$2", (preg_replace($search, $replace, $str))));

} // END FUNCTION characterEntities


class Params {
  public function __construct($arr="", $type="", $clean=false, $quote='', $globals=false) {
    switch($type) {
      case '_POST'   : $p = $_POST; break;
      case '_GET'    : $p = $_GET; break;
      case '_PG'     : $p = array_merge($_POST, $_GET); break;
      case '_COOKIE' : $p = $_COOKIE; break;
      case '_SESSION': $p = $_SESSION; break;
      default        :
        // _SESSION niet in de merge meenemen want kan interfereren met andere parms zoals _COOKIE
        $p = array_merge($_COOKIE, $_POST);
        $p = array_merge($p, $_GET);
        break;
    }
    // defaults checken
    if(is_array($arr)) { // er zijn default waarden meegegeven
      // controleer of er default-vars ontbreken in de hierboven aangeboden parms
      // en voeg die, met hun default waarde, toe aan het object
      foreach($arr AS $k=>$v) if(! isset($p[$k])) $p[$k] = $v;
    }
    // clean and quote
    if($clean) {
      foreach($p AS $k=>$val) { 
        if(is_array($val)) continue;
        else $p[$k] = $this->cleanFF($val); 
      }
    }
    if($quote) {
      switch($quote) {
        case 'firebird' :
        case 'sqlite'   : foreach($p AS $k=>$val) { if(is_array($val)) continue; else $p[$k] = $this->quoteSybase($val); } break;
        case 'mysql'    : foreach($p AS $k=>$val) { if(is_array($val)) continue; else $p[$k] = $this->quoteMysql($val); } break;
      }
    }
    // voeg de hierboven aangeboden parms, met hun waarde, toe aan het 
    // object en evt. aan de GLOBALS
    foreach($p AS $k=>$v) {
      ($globals) ? $this->$k = $GLOBALS[$k] = $v : $this->$k = $v;
    }
  } // END CONSTRUCTOR

  // clean input
  function cleanFF($input) {
    return(strtr($input,';<>!()`','       '));
  }

  // quote sybase
  function quoteSybase($input) {
    return(preg_replace("/[']/","''",$input));
  }

  // clean input
  function quoteMysql($input) {
    return(addslashes($input));
  }

} // END CLASS Params }}}

/* __END__ */
