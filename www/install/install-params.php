<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: install-params.php 171 2011-01-13 19:49:15Z joan $
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

// Instellingen

$ud = array();
$udb = array();
$udm = array();

// SYSTEM

$ud['system.platform'] = array(
       'default'=>$GLOBALS['config']->data['system']['platform']
      ,'choices'=>array('linux','windows')
      ,'title'=>'Op welk platform draait de software?'
      ,'help'=>'Kies op wat voor type platform de administratie wordt geïnstalleerd:'
              .'<ul><li>linux: een linux of unix platform;</li><li>windows: een windows PC met XAMP, WAMP of de meegeleverde PHP serverinstallatie. Als je installeert van het OpenAdmin.nl-installatieprogramma dan wordt automatisch een PHP installatie meegeleverd. Als je het programma onder X/WAMP wilt draaien kijk dan op <a href="http://www.openadmin.nl/Wiki">openadmin.nl</a> hoe dat te installeren.</li></ul>'
      );

$ud['system.webadres'] = array(
       'default'=>$GLOBALS['config']->data['system']['webadres']
      ,'choices'=>''
      ,'title'=>'Wat is het webadres (zonder http(s)://) waaronder de administratie gaat draaien?'
      ,'help'=> <<<EOT
Bij een Windows installatie is dit vrijwel altijd 'localhost'.<br />
Bij een serverinstallatie op linux is dit vaak een 'echt' adres, b.v. 
'administratie.detimmerman.nl' of 'www.detimmerman.nl/administratie'.<br />
Vermeld het adres ZONDER http:// of https:// .
EOT
      );
// webadres waaronder de administratie gaat draaien 
// ingeval van Windows is dat meestal 'localhost'


$GLOBALS['config']->setValue('system', 'https', jaNee($GLOBALS['config']->data['system']['https']) ) ;

$ud['system.https'] = array(
       'default'=>$GLOBALS['config']->data['system']['https']
      ,'choices'=>array('ja','nee')
      ,'title'=>'Draait de applicatie onder https?'
      ,'help'=>"Draait de applicatie onder een beveiligde verbinding b.v.: 'https://administratie.detimmerman.nl/'."
      );
// draait de site onder https?


$GLOBALS['config']->setValue('system', 'autoupdates', jaNee($GLOBALS['config']->data['system']['autoupdates']) ) ;

$ud['system.autoupdates'] = array(
       'default'=>$GLOBALS['config']->data['system']['autoupdates']
      ,'choices'=>array('ja','nee')
      ,'title'=>'Moet het systeem automatisch checken of er updates zijn?'
      ,'help'=>'Momenteel werkt dit nog niet maar in de toekomst willen we het systeem automatisch kunnen laten controleren of er nieuwe updates beschikbaar zijn. Dus als je dat in de toekomst wilt, kies dan ja.'
      );
// Wordt er tijdens het opstarten gecontroleerd of nieuwe updates beschikbaar zijn?

/*
$default = ($GLOBALS['config']->data['system']['gzip'] == 1 || $GLOBALS['config']->data['system']['gzip'] == 'ja') ? 'ja' : 'nee';
$ud['system.gzip'] = array(
       'default'=>$default
      ,'choices'=>array('ja','nee')
      ,'title'=>'Worden backupfiles gecomprimeerd?'
      ,'help'=>''
      );
// Worden de backupfiles ge-gzipt? (geldt alleen voor linux)
*/
/*
$default = ($GLOBALS['config']->data['system']['administrator'] == 1 || $GLOBALS['config']->data['system']['administrator'] == 'ja') ? 'ja' : 'nee';
$ud['system.administrator'] = array(
       'default'=>$default
      ,'choices'=>array('ja','nee')
      ,'title'=>'Draait de administratie als administrator?'
      ,'help'=>''
      );
*/
// Draait de administratie als administrator?
// Als administrator zijn meer functies beschikbaar zoals editfuncties in het
// helpsysteem, aanmaken en laden van nieuwe administraties...

// STYLE

$ud['style.bg'] = array(
       'default'=>$GLOBALS['config']->data['style']['bg']
      ,'choices'=>array('geel','blauw','groen','purple')
      ,'title'=>'Kleur van de toegangspagina'
      ,'help'=>'Kies een kleur voor de toegangspagina. Dit heeft verder geen bijzonder nut maar soms wil je verschillende administraties kunnen herkennen aan b.v. een kleurtje.'
      );


$GLOBALS['config']->setValue('system', 'netbook', jaNee($GLOBALS['config']->data['system']['netbook']) ) ;

$ud['system.netbook'] = array(
       'default'=>$GLOBALS['config']->data['system']['netbook']
      ,'choices'=>array('ja','nee')
      ,'title'=>'Draait het programma op een Netbook?'
      ,'help'=>'OpenAdmin.nl draait prima op een Netbook maar omdat een Netbook-scherm nogal klein is (1024x768) zet je met deze instelling de schermformulieren wat kleiner zodat ze op het scherm passen.'
      );
// Wordt er tijdens het opstarten gecontroleerd of nieuwe updates beschikbaar zijn?

// DB

$ud['db.default'] = array(
       'default'=>$GLOBALS['config']->data['db']['default']
      ,'choices'=>''
      ,'title'=>'Naam van de administratie database'
      ,'help'=> <<<EOT
Vul hier in de naam van de administratie-database. Meestal kies je 'administratie'.<br />
Als de database nog niet bestaat zal het installatieprogramma proberen om hem aan te maken.<br />
LET OP: De databasegebruiker moet hiervoor wel voldoende rechten bezitten.
EOT
      );

// Laad de schemas uit de struct/schemas directory
//
$File = new File();
$schemafiles = $File->get_files($GLOBALS['config']->data['dir']['struct'].PS.'schemas','','',false,true);
foreach($schemafiles AS $id=>$val) {
  // toon alleen bestanden die beginnen met 'schema.' en die eindigen op '.php'
  if(!preg_match("/^schema\./",$val)) {unset($arr[$id]);}
  else $arr[$id] = preg_replace("/^.+\.(.+)\.php$/","$1",$val);
}

      //,'choices'=>array('leeg','algemeen-uitgebreid','algemeen-beperkt','test-administratie')

$ud['db.schema'] = array(
       'default'=>$GLOBALS['config']->data['db']['schema']
      ,'choices'=>$arr
      ,'title'=>'Welk basisschema wil je voor je administratie gebruiken?'
      ,'help'=>'<ul><li>leeg: laat de administratie leeg. Ik wil een eigen schema maken;</li>'
              .'<li>algemeen-uitgebreid: een algemeen schema met uitgebreide kostensoorten en personeelsrekeningen;</li>'
              .'<li>algemeen-beperkt: een algemeen schema met basis-kostensoorten zonder personeelsrekeningen;</li>'
              .'</ul>'
      );
// Met welk bedrijfsschema werkt de administratie?
// Het schema bepaalt de grootboekrekeningen en dagboeken die in een nieuwe
// administratie aangemaakt worden. 
// Templates zijn opgeslagen in directory: $GLOBALS['config']->data['dir']['struct']/schemas
// het template test-administratie laten we er nog even uit totdat we een echte testadministratie beschikbaar hebben.
              //.'<li>test-administratie: een complete test-administratie met enkele jaren aan boekingen;</li>'


$ud['db.driver'] = array(
       'default'=>$GLOBALS['config']->data['db']['driver']
      ,'choices'=>array('mysql','sqlite','firebird','postgres')
      ,'title'=>'Database engine'
      ,'help'=>'Kies de database-engine die je wilt gebruiken. Als je niet weet wat hier bedoeld wordt kies dan voor \'sqlite\''
      );

$udb['db.host'] = array(
       'default'=>$GLOBALS['config']->data['db']['host']
      ,'choices'=>''
      ,'title'=>'Database host (meestal \'localhost\')'
      ,'help'=>''
      );

$udb['db.user'] = array(
       'default'=>$GLOBALS['config']->data['db']['user']
      ,'choices'=>''
      ,'title'=>'Database gebruiker'
      ,'help'=>'Let op dat de database gebruiker rechten moet hebben om een database aan te maken.'
      );

$udb['db.passwd'] = array(
       'default'=>$GLOBALS['config']->data['db']['passwd']
      ,'choices'=>''
      ,'title'=>'Password database gebruiker'
      ,'help'=>''
      );
$udm['path.mysqlbin'] = array(
       'default'=>$GLOBALS['config']->data['path']['mysqlbin']
      ,'choices'=>''
      ,'title'=>'Pad naar de mysql utilities'
      ,'help'=> <<<EOT
Pad naar de mysql utilities 'mysql', 'mysqladmin' en 'mysqldump'.<br />
Dit is meestal alleen van belang bij een Windows installatie! Als het pad al in PATH is opgenomen dan mag dit leegblijven.
EOT
      );
$udf['path.firebirdbin'] = array(
       'default'=>$GLOBALS['config']->data['path']['firebirdbin']
      ,'choices'=>''
      ,'title'=>'Pad naar de isql-fb command processor'
      ,'help'=> <<<EOT
Pad naar de firebird command-processor en utilities ('isql' of 'isql-fb', 'gbak' en 'nbackup').<br />
Als het pad al in PATH is opgenomen (b.v. /usr/bin) dan hoef je hier niets in te vullen.<br />
Als command-processor wordt op Linux: 'isql-fb' (zoals op Ubuntu en CentOS) en op Windows: 'isql' verwacht. 
Heet jouw Firebird command-processor op Linux 'isql' of 'fbisql', maak dan een logical naar 'isql-fb'.
EOT
      );
$udp['path.postgresbin'] = array(
       'default'=>$GLOBALS['config']->data['path']['postgresbin']
      ,'choices'=>''
      ,'title'=>'Pad naar de postgreSQL utilities'
      ,'help'=>"Pad naar de postgreSQL utilities 'psql', 'pg_dump' en 'pg_restore'. Als het pad al in PATH is opgenomen dan mag dit leegblijven."
      );

$udt['path.sqlitebin'] = array(
       'default'=>$GLOBALS['config']->data['path']['sqlitebin']
      ,'choices'=>''
      ,'title'=>'Pad naar sqlite3.exe'
      ,'help'=>"Pad naar sqlite3.exe. Dit is doorgaans alleen van belang bij een Windows installatie. Als het pad al in PATH is opgenomen dan mag dit leegblijven."
      );


// LOCAL FUNCTIONS

function jaNee($parm) {
  switch($parm) {
    case 'nee'   : 
    case 'false' : 
    case '0'     : $default = 'nee'; break;
    case 'ja'    : 
    case 'true'  : 
    case '1'     : $default = 'ja'; break;
    default      : $default = $parm; break;
  }
  return $default;
} // END FUNCTION jaNee

/* __END__ */
