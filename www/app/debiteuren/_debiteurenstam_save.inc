<?php // vim: syntax=php fdm=manual fdc=0 so=100
/**
* @version		$Id: _debiteurenstam_save.inc 155 2010-12-12 23:12:03Z otto $
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

$render->body .= "\n          <!-- debiteurenstam_save.inc -->\n";
$render->subtitle[] = "debiteurenstam_save.inc";

// HOUSEKEEPING
//

$fields = array('datum','naam','code','contact','telefoon','fax','email','adres');
$textfields = array('naam','code','contact','adres');

$lastid = $lastinserted = $toupdate = false;

//
// Is het id 0?
//
if(! $p->id) { 
  // er wordt nog geen id meegeleverd, dit is dus een nieuw record
  if($p->naam && $p->codeview) { // sla op als nieuw
    if($code = $stam->Get_field('"code"',$stam->debiteurenstam, "\"code\"='{$p->codeview}'")) {
      // het code het bestaat al, mag niet opgeslagen worden.
      $msg['red'][] = "De code: {$p->code} bestaat al! Kies een andere code";
      // save de informatie zodat de velden weer ingevuld zijn
      $sobj = new Dummy();
      foreach($fields AS $val) {
        if(in_array($val, $textfields)) $p->$val = stripslashes($p->$val);
        $sobj->$val = $p->$val;
      }
    }
    else {
      $id = $stam->newId($stam->debiteurenstam);
      $fields = '("id","datum","naam","code","contact","telefoon","fax","email","adres")';
      $values = "($id,'{$GLOBALS['timer']->vandaagIso}','{$p->naam}','{$p->codeview}','{$p->contact}','{$p->telefoon}','{$p->fax}','{$p->email}','{$p->adres}')";
      $stam->query = "INSERT INTO {$stam->debiteurenstam} {$fields} VALUES {$values} ";
      $stam->Do_sql(basename(__FILE__).'::'.__METHOD__.'::'.__LINE__);
      if($id) $msg['blue'][] = "Toegevoegd: {$lastid} - {$p->naam} ";
      // als we id leegmaken is het form weer opnieuw leeg voor een volgend record
      // als we id gevuld laten dan opent het form met het nieuwe record.
      // $id = '';
      $lastinserted = $id;
    }
  }
  else
    $msg['red'][] = "Er moet een naam en code ingevuld zijn!";
}
else if($p->id) { // dit is een update
  if($p->code != $p->code_old) { // het code is veranderd, ga na of het al niet gebruikt wordt
    if($code = $stam->Get_field('"code"',$stam->debiteurenstam,"\"code\"='{$p->codeview}'")) {
      // het code het bestaat al, mag niet opgeslagen worden.
      $msg['red'][] = "De code: {$p->code} bestaat al! Kies een andere code";
      $code = $p->code_old;
    }
    else if($p->id && $p->code) { // controles accoord, sla op als update
      $toupdate = true;
    }
  }
  else if($p->id && $p->code) { // controles accoord, sla op als update
    $toupdate = true;
  }
}

if($toupdate) {
  // update alleen als er iets veranderd is
  if($p->c_id || $p->c_naam || $p->c_contact || $p->c_telefoon || $p->c_fax || $p->c_email || $p->c_adres || $p->c_tekst) {
    // stel de update string samen
    $values = "";
    foreach($fields AS $val) {
      $tmp = "c_".$val;
      if($p->$tmp) {
        $values .= ",\"{$val}\"='{$p->$val}'";
      }
    }
    $values = substr($values,1);
    $stam->query = "UPDATE {$stam->debiteurenstam} SET {$values} WHERE \"id\"='{$id}' ";
    $stam->Do_sql(basename(__FILE__).'::'.__METHOD__.'::'.__LINE__);
  }
}

?>
