<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _dagboeken.inc 215 2011-09-25 18:54:41Z otto $
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

// no direct access
defined('_JEXEC') or die('Restricted access');

$render->body .= "\n          <!-- dagboeken.inc -->\n";
$render->subtitle[] = "dagboeken.inc";
$render->titel = "Dagboeken overzicht/invoeren/beheren";

//
// Gegevens inlezen
//
$stam->query =<<<EOT
SELECT 
   d."id"
  ,d."historie"
  ,d."active"
  ,d."type"
  ,d."naam"
  ,d."code"
  ,d."grootboekrekening"
  ,d."boeknummer"
  ,d."saldo"
  ,d."slot"
  ,g."naam" AS "grbnaam"
FROM 
  {$stam->dagboeken} AS d
  LEFT JOIN
  {$stam->grootboekstam} AS g
  ON (d."grootboekrekening"=g."nummer")
EOT;

$stam->Do_sql(basename(__FILE__).'::'.__LINE__);

$p = array();

while($obj = $stam->Do_object()) {
  $obj->grootboekrekening == 0 and $obj->grootboekrekening = '';
  $obj->historie == 0 and $obj->historie = '';
  $obj->active == 0 and $obj->active = '';
  $obj->boeknummer == 0 and $obj->boeknummer = '';
  $obj->saldo == 0 and $obj->saldo = '';
  $obj->slot == 0 and $obj->slot = '';
  $p[$obj->id] = array('id'=>$obj->id
                      ,'historie'=>$obj->historie
                      ,'active'=>$obj->active
                      ,'type'=>$obj->type
                      ,'naam'=>$obj->naam
                      ,'code'=>$obj->code
                      ,'grootboekrekening'=>$obj->grootboekrekening
                      ,'boeknummer'=>$obj->boeknummer
                      ,'saldo'=>$obj->saldo
                      ,'slot'=>$obj->slot
                      ,'grbnaam'=>$obj->grbnaam);
}
printrc2($p, "Dagboekobjecten: \n");

// START BUILDING BODYTEXT
//

  $render->iscript[] = "/js/validation.js";

  $render->jscript .=<<<EOJ

function Nieuw(a) {
  var win2 = location.href='dagboeken.phtml?aktie=nieuw' ;
}


// Open dagboekedit popup
//
var dedit = '';
//
function editDagboek(dagboekid,aktie) {
  var x = window.document.forms['frm1'];

  if(aktie == '' && dagboekid == '') aktie = 'nieuw';
  else if(aktie == '') aktie = 'edit';
  var url = '/run.php?app=dagboekenedit&aktie='+ aktie +'&dagboekid=' + dagboekid;
  
  if (!dedit.closed && dedit.location) {
    dedit.location.href = url;
  }
  else {
    // ['WINDOW_OPTIONS']['LOOKUPGRB']
    dedit=window.open(url,'deditwindow','resizable,scrollbars,status,width=400,height=300,left=390,top=280');
    if (!dedit.opener) dedit.opener = self;
  }
  if (window.focus) dedit.focus();
  return false;
}


function sendForm(optie){
  // Controleer of alle verplichte velden zijn ingevuld, 
  // anders focus op dat valed leggen en een alert geven dat het veld verplicht is.
  
  var verpl = " is een verplicht veld. Eerst invullen alvorens op 'opslaan' te klikken A.U.B";

  if(document.forms['frm1'].elements['naam'].value=="") {
    alert("Naam " + verpl);
    document.forms['frm1'].elements['naam'].focus();
    return(false);
  }else if(document.forms['frm1'].elements['code'].value=="") {
    alert("Code " + verpl);
    document.forms['frm1'].elements['code'].focus();
    return(false);
  }else {
    document.forms['frm1'].submit();
    return(true);
  }
  return(false);

}

EOJ;


$form = new aForm($render->body);

// Er moeten wat GET parms van de REQUEST_URI af anders wordt een nieuwe aktie niet geladen.
$again = preg_replace("/^([^&]*).*$/", "$1", $_SERVER['REQUEST_URI']);

$form->formStart('frm1', $again, 
                   array(
                          "aktie"=>""
                         ) );

  $form->mainTableStart();

  if($stam->boekjaarBlocked) 
    $form->fieldSetStart("Dagboeken ".$stam->boekjaar,array('',RUBRIEK.'.dagboeken','Dagboeken') );
  else
    $form->fieldSetStart("Dagboeken",array('',RUBRIEK.'.dagboeken','Dagboeken') );
    
       $veldarr = array("width='24%'","width='16%'","width='14%'","width='10%'","width='10%'","width='16%'","width='8%'","width='2%'");

      $form->blockLine('#a9d0ff',
                       array("<div class='schemarow_head' title='Naam hoeft niet uniek te zijn maar is wel handig natuurlijk!' style='padding:2 0 2 0; cursor:pointer;' onClick=\"editDagboek('','nieuw');\">naam</div>"
                            ,"<div class='schemarow_head' title='Code moet uniek zijn; hiermee wordt intern gewerkt!'>code</div>"
                            ,"<div class='schemarow_head' title='Type bepaalt het gedrag van het dagboek.'>type</div>"
                            ,"<div class='schemarow_head' title='De grootboekrekening waaraan een dagboek evt. is gekoppeld' align='right'>grb.rek.</div>"
                            ,"<div class='schemarow_head' title='Het laatste boeknummer b.v. bij kas of bank' align='right'>boeknr.</div>"
                            ,"<div class='schemarow_head' title='Het laatste saldo b.v. bij kas of bank' align='right'>saldo</div>" 
                            ,"<div class='schemarow_head' title='Een dagboek is gelockt met het journaalnummer als er een journaalpost in bewerking is. Geldt alleen voor bank/kas' align='middle' align='right'>lock</div>"
                            ,"<div class='schemarow_head' title='Edit dagboek indien toegestaan' align='right'></div>" 
                            ),
                       $veldarr );

    foreach($p AS $arr) {

  $button_editdagboek='';

    // $button_editdagboek="<img src='/img/b_edit.png' style=\"cursor:pointer;\" onClick=\"editDagboek('{$arr['id']}','');\" title='Edit dagboekgegevens'/>";

    // alleen in het lopend en nog actief jaar mogen veranderingen gemaakt worden
    $row = (! $stam->boekjaarSemiBlocked) ?
       "<div class='schemarow_std' style='cursor:pointer;' onClick=\"editDagboek('{$arr['id']}','');\">{$arr['naam']}</div>" :
       "<div class='schemarow_std'>{$arr['naam']}</div>" ;

      $form->blockLine('',
                       array($row
                            ,"<div class='schemarow_std'>{$arr['code']}</div>"
                            ,"<div class='schemarow_std'>{$arr['type']}</div>"
                            ,"<div class='schemarow_std' align='right' title='{$arr['grbnaam']}' align='middle' class='schemarow_std'>{$arr['grootboekrekening']}</div>"
                            ,"<div class='schemarow_std' align='right'>{$arr['boeknummer']}</div>"
                            ,"<div class='schemarow_std' align='right'>".formatbedrag($arr['saldo'],false)."</div>"
                            ,"<div class='schemarow_std' align='right'>{$arr['slot']}</div>"
                            ,"<div class='schemarow_std' align='right'>{$button_editdagboek}</div>"
                            ),
                       $veldarr );

    } // END FOREACH


  // Buttonstrap

    $form->fieldSetBridge();

    $buttons = '';

    if(! $stam->boekjaarSemiBlocked) { 
      // alleen in het lopend en nog actief jaar mogen veranderingen gemaakt worden
      $buttons=<<<EOT

        <input type="button" name="nieuw" value="nieuw" size="10" class='bsmall2' class='bsmall2' onClick="editDagboek('','');"/>
EOT;
    }

      $buttons.=<<<EOT

        &nbsp;<input type="button" name="sluiten" value="sluiten" size="10" class='bsmall2' class='bsmall2' onClick="window.close()"/>
EOT;

      $form->blockLine('2',array($buttons));


    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();

/* __END__ */
