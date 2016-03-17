<?php // vim: syntax=php so=100

// Opties voor de pop-up windows

// De maximale hoogte bij een netbook 1024x600 is 515
if($config->data['system']['netbook']) {

$GLOBALS['WINDOW_OPTIONS']['STAMGEGEVENS']     = "'resizable,scrollbars,status,width=580,height=515,left=230,top=0'";
$GLOBALS['WINDOW_OPTIONS']['GROOTBOEKSTAM']    = "'resizable,scrollbars,status,width=650,height=490,left=350,top=0'";
$GLOBALS['WINDOW_OPTIONS']['SCHEMAS']          = "'resizable,scrollbars,status,width=550,height=515,left=450,top=200'";
$GLOBALS['WINDOW_OPTIONS']['LOOKUPGRB']        = "'resizable,scrollbars,status,width=400,height=515,left=450,top=200'";
$GLOBALS['WINDOW_OPTIONS']['JOURNAALPOST']     = "'resizable,scrollbars,status,width=870,height=515,left=140,top=0'";
$GLOBALS['WINDOW_OPTIONS']['DAGBOEKEN']        = "'resizable,scrollbars,status,width=600,height=300,left=400,top=200'";
$GLOBALS['WINDOW_OPTIONS']['ADMINISTRATIES']   = "'resizable,scrollbars,status,width=600,height=440,left=350,top=0'";
$GLOBALS['WINDOW_OPTIONS']['BTWKAART']         = "'resizable,scrollbars,status,width=930,height=515,left=80,top=0'";
$GLOBALS['WINDOW_OPTIONS']['GROOTBOEKKAART']   = "'resizable,scrollbars,status,width=880,height=515,left=130,top=0'";
$GLOBALS['WINDOW_OPTIONS']['GROOTBOEKKAARTPRINT'] = "'resizable,scrollbars,status,width=870,height=515,left=200,top=0'";
$GLOBALS['WINDOW_OPTIONS']['JOURNAALKAART']    = "'resizable,scrollbars,status,width=870,height=515,left=140,top=0'";
$GLOBALS['WINDOW_OPTIONS']['BTWRUBRIEKEN']     = "'resizable,scrollbars,status,width=880,height=515,left=150,top=0'";
$GLOBALS['WINDOW_OPTIONS']['BTWAANGIFTE']      = "'resizable,scrollbars,status,width=900,height=515,left=80,top=0'";

}
else {

$GLOBALS['WINDOW_OPTIONS']['STAMGEGEVENS']     = "'resizable,scrollbars,status,width=580,height=740,left=230,top=50'";
$GLOBALS['WINDOW_OPTIONS']['GROOTBOEKSTAM']    = "'resizable,scrollbars,status,width=650,height=490,left=350,top=0'";
$GLOBALS['WINDOW_OPTIONS']['SCHEMAS']          = "'resizable,scrollbars,status,width=550,height=670,left=450,top=200'";
$GLOBALS['WINDOW_OPTIONS']['LOOKUPGRB']        = "'resizable,scrollbars,status,width=400,height=670,left=450,top=200'";
$GLOBALS['WINDOW_OPTIONS']['JOURNAALPOST']     = "'resizable,scrollbars,status,width=900,height=590,left=320,top=190'";
$GLOBALS['WINDOW_OPTIONS']['DAGBOEKEN']        = "'resizable,scrollbars,status,width=600,height=300,left=450,top=220'";
$GLOBALS['WINDOW_OPTIONS']['ADMINISTRATIES']   = "'resizable,scrollbars,status,width=600,height=440,left=450,top=220'";
$GLOBALS['WINDOW_OPTIONS']['BTWKAART']         = "'resizable,scrollbars,status,width=930,height=590,left=250,top=200'";
$GLOBALS['WINDOW_OPTIONS']['GROOTBOEKKAART']   = "'resizable,scrollbars,status,width=900,height=590,left=250,top=200'";
$GLOBALS['WINDOW_OPTIONS']['GROOTBOEKKAARTPRINT'] = "'resizable,scrollbars,status,width=870,height=590,left=350,top=150'";
$GLOBALS['WINDOW_OPTIONS']['JOURNAALKAART']    = "'resizable,scrollbars,status,width=870,height=590,left=350,top=250'";
$GLOBALS['WINDOW_OPTIONS']['BTWRUBRIEKEN']     = "'resizable,scrollbars,status,width=880,height=750,left=370,top=150'";
$GLOBALS['WINDOW_OPTIONS']['BTWAANGIFTE']      = "'resizable,scrollbars,status,width=900,height=820,left=320,top=20'";

}
/* __END__ */
