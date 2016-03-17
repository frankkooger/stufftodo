<?php // vim: syntax=php fdm=marker fdc=0 so=100
/**
* @version		$Id: dagboekenedit.php 215 2011-09-25 18:54:41Z otto $
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

$p = new Params(array("aktie"=>""
                     ,"historie"=>""
                     ,"active"=>""
                     ,"dagboekid"=>""
                     ,"dagboeknaam"=>""
                     ,"dagboekcode"=>""
                     ,"dagboektype"=>""
                     ,"grootboekrekening"=>""
                     ,"saldo"=>""
), "_PG", $clean=true, $quote="{$GLOBALS['config']->data['db']['driver']}" );

define('RUBRIEK','Dagboekenedit.');

printrc1($p, "Parms ". basename(__FILE__) .": ");

Class Dagboek {
  var $id = '';
  var $historie = '';
  var $active = '';
  var $naam = '';
  var $type = '';
  var $code = '';
  var $grootboekrekening = '';
  var $boeknummer = '';
  var $saldo = '';
  var $slot = '';
  var $occupied = false;

  /*
   * Constructor. Indien een id is meegegeven, vul het object met het record.
   */
  function Dagboek($id='') {
    if($id) $this->fillup($id);
  }

  /*
   * Vul de objectparms met de gegevens uit het formulier. Indien er disabled
   * invoervelden zijn (niet zichtbaar dus !isset) gebruik dan de
   * duplicaatvalues die in de overeenkomstige hiddens zijn opgeslagen.
   */
  function voorbereiden(&$p) {
    $this->type = (isset($p->view_dagboektype)) ? $p->view_dagboektype : $p->dagboektype;
    $this->code = (isset($p->view_dagboekcode)) ? $p->view_dagboekcode : $p->dagboekcode;
    $this->naam = (isset($p->view_dagboeknaam)) ? $p->view_dagboeknaam : $p->dagboeknaam;
    $this->historie = (isset($p->historie)) ? $p->historie : $p->m_historie;
    $this->active = (isset($p->active)) ? $p->active : $p->m_active;
    $this->grootboekrekening = (isset($p->grootboekrekening)) ? $p->grootboekrekening : $p->m_grootboekrekening;
    $this->boeknummer = (isset($p->view_boeknummer)) ? $p->view_boeknummer : $p->boeknummer;
    $this->saldo = (isset($p->view_saldo)) ? formatInputBedrag($p->view_saldo) : $p->saldo;
    $this->slot = (isset($p->view_lock)) ? $p->view_lock : $p->lock;
  } // END FUNCTION voorbereiden

  /*
   * Schoon alle objectpars.
   */
  function cleanup() {
    $this->historie = '';
    $this->active = '';
    $this->type = '';
    $this->code = '';
    $this->naam = '';
    $this->grootboekrekening = '';
    $this->boeknummer = '';
    $this->saldo = '';
    $this->slot = '';
    $this->occupied = false;
  } // END FUNCTION cleanup

  /*
   * Vul het object met de values uit het gevraagde record.
   */
  function fillup($id) {
    if($obj = $GLOBALS['stam']->Get_object("SELECT * FROM {$GLOBALS['stam']->dagboeken} WHERE \"id\"={$id}")) {
      $this->id = $obj->id;
      $this->historie = $obj->historie;
      $this->active = $obj->active;
      $this->naam = $obj->naam;
      $this->type = $obj->type;
      $this->code = $obj->code;
      $this->grootboekrekening = $obj->grootboekrekening;
      $this->boeknummer = $obj->boeknummer;
      $this->saldo = $obj->saldo;
      $this->slot = $obj->slot;
      $this->desettle();
    }

    // Bekijk of op dit dagboek al een boeking is gepleegd. Indien niet: editable, indien wel: niet editable
    // Dit gaat alleen op als een grootboekrekeningnummer aan het dagboek is gekoppeld
    if($this->grootboekrekening) {
    ($GLOBALS['stam']->Get_field('COUNT("boekregelid")', "{$GLOBALS['stam']->boekregels}", "\"grootboekrekening\"='{$this->grootboekrekening}' AND \"dagboekcode\"='{$this->code}'"
                                 , basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__ )) and $this->occupied = true;
    }

  } // END FUNCTION fillup

  /*
   * Update het record met objectvar-values die via settle geschikt zijn gemaakt voor de db.
   * LET OP: sinds we voor dagboek ook het nieuwe historie mechanisme gebruiken moeten we intelligent updaten:
   * - als historie is van dit jaar of nieuwer, dan updaten we een actueel record. Dit is een normale update
   * - als historie is ouder dan dit jaar dan schrijven we een nieuw record met
   *   het huidige boekjaar als historie. Dit nieuwe record overschaduwt het
   *   oude als je in nieuwere jaren opvraagt.
   *
   */
  function update($id) {
    $this->settle();
    if($this->historie < $GLOBALS['stam']->boekjaar) { // maak nieuw
      $this->historie = $GLOBALS['stam']->boekjaar;
      $this->active = 1;
      $this->insert();
    }
    else {
      $GLOBALS['stam']->query =<<<EOT
UPDATE {$GLOBALS['stam']->dagboekentbl} SET
 "boekjaar"={$this->historie}
,"active"={$this->active}
,"type"='{$this->type}'
,"code"='{$this->code}'
,"naam"='{$this->naam}'
,"grootboekrekening"={$this->grootboekrekening}
,"boeknummer"={$this->boeknummer}
,"saldo"='{$this->saldo}'
,"slot"={$this->slot}
WHERE "id"={$id}
EOT;
      $GLOBALS['stam']->Do_sql( basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__ );
      // En doe onmiddelijk weer een opvraag van dit recod teneinde het object een reeel beeld te geven.
      $this->fillup($id);
    } // END else

  } // END FUNCTION update

  /*
   * Insert een nieuw record met objectvar-values die via settle geschikt zijn
   * gemaakt voor de db. Maak de objectvar-values na insert weer geschikt voor het
   * scherm en geef het nieuwe record-id terug.
   * Alvorens te inserten, kijk eerst of er niet een record met dezelfde code/type op dit boekjaar met een active=0 staat.
   *  indien zo: herstel deze
   */
  function insert() {
    if($id=$GLOBALS['stam']->Get_field('"id"', $GLOBALS['stam']->dagboekentbl, "\"code\"='{$this->code}' AND \"type\"='{$this->type}' AND \"active\"=0"
                                      , basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__ )) { // er is al een dergelijk record doe update
      $this->active=1;
      $this->update($id);
    }
    else { // doe een insert
      $this->settle();
      // vraag een id op
      $id = $GLOBALS['stam']->newId($GLOBALS['stam']->dagboekentbl);
      $fields = '("id","boekjaar","active","type","code","naam","grootboekrekening","boeknummer","saldo","slot")';
      $values = "({$id},{$this->historie},{$this->active},'{$this->type}','{$this->code}','{$this->naam}',{$this->grootboekrekening},{$this->boeknummer},'{$this->saldo}',{$this->slot})";
      $GLOBALS['stam']->query = "INSERT INTO {$GLOBALS['stam']->dagboekentbl} {$fields} VALUES {$values}";

      if($GLOBALS['stam']->Do_sql( basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__ )) {
        $this->desettle();
        return($id);
      }
      else
        return(false);
    }
  } // END FUNCTION insert

  /*
   * Verwijder het gevraagde record of het record dat op dit moment in het object actief is (id='').
   * LET OP: sinds we voor dagboek ook het nieuwe historie mechanisme gebruiken moeten we intelligent deleten:
   * - als historie is van dit jaar of nieuwer, dan deleten we een actueel record. Dit is een normale delete
   * - als historie is ouder dan dit jaar dan schrijven we een nieuw record met
   *   het huidige boekjaar als historie en active=0. Dit nieuwe record overschaduwt het
   *   oude als je in nieuwere jaren opvraagt.
   *
   */
  function delete($id='') {
    if(! $id) $id = $this->id;
    if($this->historie < $GLOBALS['stam']->boekjaar) { // maak nieuw met active=0
      $this->historie = $GLOBALS['stam']->boekjaar;
      $this->active = 0;
      $this->insert();
      $this->cleanup();
    }
    else {
      $GLOBALS['stam']->query = "DELETE FROM {$GLOBALS['stam']->dagboekentbl} WHERE \"id\"={$id}";
      if($GLOBALS['stam']->Do_sql( basename(__FILE__).'::'.__FUNCTION__.'::'.__LINE__ )) {
        $this->cleanup();
        return(true);
      }
      return(false);
    } // END ELSE
  } // END FUNCTION delete

  /*
   * Controleer of een code al in gebruik is in de dagboekendbase
   * Als de code niet aangeboden wordt, gebruik dan de interne code $this->code
   */
  function checkCode($code='') {
    if(! $code) $code = $this->code;
    if($GLOBALS['stam']->Get_field('COUNT(*)', $GLOBALS['stam']->dagboeken, "\"code\"='{$code}'")) return(true); else return(false);
  } // END FUNCTION checkCode

  /*
   * Maak het object klaar om aan de database aan te bieden
   */
  function settle() {
    ($this->grootboekrekening == '') and $this->grootboekrekening = '0';
    ($this->historie === '') and $this->historie = $GLOBALS['stam']->boekjaar;
    ($this->active === '') and $this->active = '1';
    ($this->boeknummer == '') and $this->boeknummer = '0';
    ($this->saldo == '') and $this->saldo = '0.00';
    ($this->slot == '') and $this->slot = '0';
  } // END FUNCTION settle

  /*
   * Maak het object klaar om aan het scherm aan te bieden
   */
  function desettle() {
    ($this->grootboekrekening == '0') and $this->grootboekrekening = '';
    ($this->historie == '0') and $this->historie = '';
    ($this->active == '0') and $this->active = '';
    ($this->boeknummer == '0') and $this->boeknummer = '';
    ($this->saldo == '0.00') and $this->saldo = '';
    ($this->slot == '0') and $this->slot = '';
  } // END FUNCTION desettle

} // END Class dagboek


$aktie = $p->aktie;
$id = $p->dagboekid;

// Process
//
require("_dagboekenedit.inc");

$render->output();

/* __END__ */
