#!/usr/bin/php -q
<?php

# #######################################
#   Laadt een schema in een bestaande database
#   De database moet dus al bestaan en leeg zijn; geen tables bevatten
#
#   De databasenaam en de tabellenstructuur (gerelateerd aan de db-drivernaam)
#   komen uit _const.ini
#
# #######################################

ini_set('include_path', '.:/pub/webs/openadmin/lib');

# Zorg dat _preload.inc geen stamgegevens opvraagt!
# er is immers nog geen database
#
$_GET['load'] = true;

require('_init.inc');

//$connect  = mysql_connect('localhost','root','poedel21');
$db = new DbFactory();

printr($db, "db: ");

$arr = array();
$schema = 'schema.test2-administratie.php';
$schema = 'schema.test-administratie.php';

loadTabellen($db);
loadSchema($db);
loadUpdates($db);
loadViews($db);

#loadTabellen($db->connect);
#loadSchema($db->connect);

// Laadt een schema file into database


// //////////////////////////////////////////////////////////////////
// 3b1) laad de tabellen
// //////////////////////////////////////////////////////////////////
function loadTabellen(&$connect) {
  global $arr, $config;
  // kijk eerst of het Schema bestaat
  $structfile = $config->data['dir']['struct'].PS
               .$config->data['db']['driver'].PS
               .'template.struct.'.$config->data['db']['driver'].'.php';
  if(! file_exists($structfile)) {
    $arr[] = redline("template '{$structfile}' is er niet! Kan tabellen niet laden!");
    return(false);
  }
  else { // laad de structfile en execute die
    require($structfile);
    if(! isset($struct) || ! is_array($struct)) {
      $arr[] = redline("Template '{$structfile}' niet in orde!");
      return(false);
    }
    return(loadSql($struct,"Tabellen niet aangemaakt!",$connect));
  }
} // END FUNCTION loadTabellen


// //////////////////////////////////////////////////////////////////
// 3b1) laad de updates
// //////////////////////////////////////////////////////////////////
function loadUpdates(&$connect) {
  global $arr, $config;
  // kijk eerst of het Schema bestaat
  $structfile = $config->data['dir']['struct'].PS
               .$config->data['db']['driver'].PS
               .'template.updates.'.$config->data['db']['driver'].'.php';
  if(! file_exists($structfile)) {
    $arr[] = redline("template '{$structfile}' is er niet! Kan tabellen niet laden!");
    return(false);
  }
  else { // laad de structfile en execute die
    require($structfile);
    if(! isset($struct) || ! is_array($struct)) {
      $arr[] = redline("Template '{$structfile}' niet in orde!");
      return(false);
    }
    return(loadSql($struct,"Tabellen niet aangemaakt!",$connect));
  }
} // END FUNCTION loadUpdates


// //////////////////////////////////////////////////////////////////
// 3b1) laad de views, dit moet na de updates omdat de updates fields van de views bevatten
// //////////////////////////////////////////////////////////////////
function loadViews(&$connect) {
  global $arr, $config;
  // kijk eerst of het Schema bestaat
  $structfile = $config->data['dir']['struct'].PS
               .$config->data['db']['driver'].PS
               .'template.views.'.$config->data['db']['driver'].'.php';
  if(! file_exists($structfile)) {
    $arr[] = redline("template '{$structfile}' is er niet! Kan tabellen niet laden!");
    return(false);
  }
  else { // laad de structfile en execute die
    require($structfile);
    if(! isset($struct) || ! is_array($struct)) {
      $arr[] = redline("Template '{$structfile}' niet in orde!");
      return(false);
    }
    return(loadSql($struct,"Tabellen niet aangemaakt!",$connect));
  }
} // END FUNCTION loadViews


// //////////////////////////////////////////////////////////////////
// laad het gevraagde rekeningschema
// //////////////////////////////////////////////////////////////////
function loadSchema(&$connect) {
  global $arr, $config;
  global $schema;
  // kijk eerst of het schema bestaat
  $schemafile = $config->data['dir']['struct'].PS
               .'schemas'.PS.$schema;
  if(! file_exists($schemafile)) {
    $arr[] = redline("schema file '{$schema}' is er niet! Kan rekeningschema niet laden!");
    return(false);
  }
  else { // laad de schema file en execute die
    require($schemafile);
    if(! isset($schema) || ! is_array($schema)) {
      $arr[] = redline("Schemafile '{$schemafile}' niet in orde!");
      return(false);
    }
    return(loadSql($schema,"Schema niet geladen!",$connect));
  }
} // END FUNCTION loadSchema


function loadSql(&$struct, $error='',&$connect) {
  global $arr;

  foreach($struct AS $val) {
    $connect->beginTransaction();
    // elke struct kan uit meerdere sql statements bestaan
    $ar = explode(';', $val);
    foreach($ar AS $val2) {
      // beware of lege queries
      if(empty($val2) || strlen($val2) < 5 ) continue;
      printrc2($val2);
      if($connect->exec($val2) === false) {
        $arr[] = redline($error);
        $connect->rollBack();
        return(false);
      }
    }
    $connect->commit();
  }
  return(true);
} // END FUNCTION loadSql


function greenLine($msg) {
  return("<div class='greenline'>$msg</div>");
}

function redLine($msg) {
  return("<div class='redline'>$msg</div>");
}

/* __END__ */
