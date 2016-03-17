<?php // vim: syntax=php so=100

$config->setValue('meta', 'auteur', 'Frank Kooger');

// Grootboektypen

define("BALANS", 1);
define("RESULTAAT", 2);
define("TOTAALKAART", 3);


// BTWtypen, adh hiervan wordt tijdens het boeken een btw bedrag berekend

define("INHOOG", 1);
define("INLAAG", 2);
define("EXHOOG", 3);
define("EXLAAG", 4);
define("GEENBTW", 5);

// sql statement om rekeningen zonder btwdefault te selecteren
// komt in de plaats van bovenstaande define in grootboek.lib
define("SELECTGEENBTW", " \"btwdefault\" LIKE '' OR \"btwdefault\" LIKE 'verkopen_geenbtw' ");

// Polariteit

define("DEBET", 1);
define("CREDIT", 2);

// Eindejaarscheck

define("RED",0);
define("GREENLIT",1);
define("BLUE",2);
define("BLUELIT",3);

// Diversen

define("DISABLED", "disabled='disabled' class='disabled'");
define("ASSOC",1);

switch($config->data['system']['platform']) {
  case 'linux'  : define("CAT",'cat'); define('BINPATH',''); break;
  case 'windows': define("CAT",'type'); define('BINPATH',$config->data['dir']['bin']); break;
}

if($config->data['system']['https'])
  $config->setValue('url', 'base_url', 'https://'.$config->data['system']['webadres'] );
else
  $config->setValue('url', 'base_url', 'http://'.$config->data['system']['webadres'] );

/* __END__ */

