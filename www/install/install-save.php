<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: install-save.php 147 2010-11-09 22:34:04Z otto $
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

// Het ingevulde formulier komt hier binnen. We vergelijken nu of de input
// parms <parm> en <m_parm> niet gelijk zijn. Zo niet dan de betreffende
// parameter vervangen alvorens de dist file op te slaan als _const.inc.

/*
NOOT: .seperated keys in het formulier komen hier binnen als _seperated keys
<pre>Params Object
(
    [_ADMIN_SID] => h55lhpjgk270rjqkr7li9k0pv4
    [mainmenu] => 2
    [aktie] => save
    [system_platform] => linux
    [m_system_platform] => linux
    [system_webadres] => localhost
    [m_system_webadres] => localhost
    [system_https] => nee
    [m_system_https] => nee
    [system_autoupdates] => nee
    [m_system_autoupdates] => nee
    [system_gzip] => nee
    [m_system_gzip] => nee
    [system_administrator] => ja
    [m_system_administrator] => ja
    [db_host] => localhost
    [m_db_host] => localhost
    [db_user] => dbaseuser
    [m_db_user] => 
    [db_passwd] => dbasepasswd
    [m_db_passwd] => 
    [db_template] => algemeen-beperkt
    [m_db_template] => algemeen-uitgebreid
    [dingen] => 
)
</pre>
*/

// Maak een array van het p object zodat we kunnen vergelijken
$vars = get_object_vars($p);

foreach($vars AS $key=>$val) {
  if(preg_match("/^m_(.+)/",$key,$ar)) {
    // indien gevonden dan is de oorspronkelijk key in ar[1]. De nieuwe val is in $p->$ar[1]
    // vertaal nee/false etc naar een 0 en ja/true etc naar een 1
    $p->$ar[1] = preg_replace(array("/^nee$/","/^false$/","/^0$/","/^ja$/","/^true$/","/^1$/"),
                              array(0,0,0,1,1,1),
                              $p->$ar[1]);
    // splits de key (b.v. db_passwd) in 2 delen
    $ar2 = split("_", $ar[1]);
    // de const string wordt nu:
    $GLOBALS['config']->setValue($ar2[0], $ar2[1], $p->$ar[1]);
  }
}

// Zet eventuele debug parameters op 0
foreach($config->data['debug'] AS $key=>$var)
  $config->setValue('debug', $key, 0);

// Creeer een url-entity
$config->setValue('url', 'base_url', 
  ($config->data['system']['https'] ? 'https' : 'http') . '://' . $config->data['system']['webadres'] );

// Schrijf de ini file
if(!$test->write_file(DEST, <<<EOT

;; This file is autogeneretad by means of the install procedure

{$GLOBALS['config']->save()}
; __END__ ;

EOT
))
  die("Kan de configuratie '{DEST}' niet wegschrijven! Controleer of je schrijfrechten hebt in '".CONFIGDIR.PS."'");

/* __END__ */
