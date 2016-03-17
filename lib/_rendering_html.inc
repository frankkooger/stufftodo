<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: _rendering_html.inc 200 2011-07-23 09:07:14Z otto $
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

// padding left 50 is gekoppeld aan schriftstijl
// Bij IE heeft dat de vervelende eigenschap dat het beeld altijd 50px rechts uit het
// beeld scrollt, ook als je het venster vergroot.
// Bij IE gebruik dus schriftstijl uitschakelen

if($this->schriftstijl) {
  if(preg_match("/MSIE/", $_SERVER['HTTP_USER_AGENT'])) $this->schriftstijl = false;
  else 
    switch($this->schriftstijl) {
      case 'journaal'    : $schriftstijl_body = "background='/img/backlijn-journaal.gif'"; break;
      default            : $schriftstijl_body = "background='/img/backlijn.gif'"; break;
    }
  $schriftstijl_start = "<div style='padding-left:50;'>"; 
  $schriftstijl_end = "</div>"; }
else { $schriftstijl_body = $schriftstijl_start = $schriftstijl_end = ""; }

// postgresql data is default UTF-8
// TODO Van andere database drivers moeten we dat nog bekijken
$codepage = preg_match("/postgres/", $GLOBALS['config']->data['db']['driver']) ?
    '<meta http-equiv="content-type" content="text/html; charset=UTF-8" />' :
    '<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />' ;

// START PAGERENDERING
// Denk erom dat deze pagina alleen maar kan worden uitgeroepen
// vanuit de classmethode 'Rendering->output()'
// omdat daar pas alle parameters goed staan (c.q. gevuld zijn)

echo<<<EOT
<html>
  <head>

    <title>{$this->titel}</title>

    {$codepage}
    <meta name="description" content="{$this->titel}" />
    <meta name="keywords" content="{$this->keywords}" />
    <meta name="author" content="{$GLOBALS['config']->data['meta']['auteur']}" />
EOT;

//
// subtitles
//
if(! empty($this->subtitle) and is_array($this->subtitle)) {
  foreach($this->subtitle AS $val)
    print("\n    <meta name='subs' content='{$val}' />");
}

//
// stylesheets
//
if(isset($GLOBALS['config']->data['style']['stylesheet'])) {
  print("\n");
  if(is_array($GLOBALS['config']->data['style']['stylesheet']))
    foreach($GLOBALS['config']->data['style']['stylesheet'] AS $val)
      print("\n    <link rel='stylesheet' type='text/css' href='{$val}' />");
  else 
    print("\n    <link rel='stylesheet' type='text/css' href='{$GLOBALS['config']->data['style']['stylesheet']}' />");
}

//
// included javascript files
//
$iscript = '';
if($this->iscript) {
  foreach($this->iscript AS $val) {
    $iscript .= "    <script type='text/javascript' src='{$val}'></script>\n";
  }
}

echo<<<EOT

    {$this->extra_headers}

EOT;
if($this->pscript)
echo<<<EOT

    <script type="text/javascript">
      {$this->pscript}
    </script>

EOT;

echo $iscript;

if($this->jscript)
echo<<<EOT

    <script type="text/javascript">
      {$this->jscript}
    </script>

EOT;

if($this->extra_styles)
echo<<<EOT

    <style type="text/css">
      {$this->extra_styles}
    </style>

EOT;

echo<<<EOT
 </head>

EOT;

if($this->schriftstijl)
  echo<<<EOT

  <body {$schriftstijl_body} onLoad="{$this->onload}">

  <div style='padding-left:50;'>

  {$this->body} 

  </div>

EOT;
else
  echo<<<EOT

  <body onLoad="{$this->onload}">

  {$this->body} 

EOT;

if($GLOBALS['config']->data['debug']['globals']) { 

  print("\n<pre>\n");
  print_r($GLOBALS);
  print("\n</pre>\n");

} 

echo<<<EOT

  </body>
</html>
  
EOT;

?>
