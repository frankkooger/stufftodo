<?php // vim: syntax=php so=100

// Laad een rendering object
$render = new Rendering();

$p = new Params(array(
                      'aktie'=>''
                     ));
printrc1($p);

$form = new aForm($render->body);

$form->dprint("\n<div class='container'>\n<div class='center'>\n\n");

$form->formStart('frm1', $_SERVER['REQUEST_URI'],
                   array(
                          "aktie"=>""
                         ) );
  $form->mainTableStart();

  // Eerste fieldblock
  // Keuzevelden: periode, dagboekcode, bestaande dagboeken

    $form->fieldSetStart("Fout installatie administratie");

    // messages
    //
    $GLOBALS['msg']['red'][] = $test->msg;

    $form->messagePrint();

      $tdarray = array("nowrap='nowrap', width='100'","");
      $harray  = array("width='100' colspan='2' style='padding-top:8px;'","");

      $form->blockLine('',
                       array("",
                       ""
                      ),
                       $tdarray );

// buttons
//
$str =<<<EOT
<input type='button' value='Probeer opnieuw' onClick='again();' />

EOT;

    $form->fieldSetBridge();
    
      $form->blockLine('',
                       array(""
                            ,$str 
                            ),
                       $tdarray );

    $form->fieldSetEnd();

  $form->mainTableEnd();

$form->formEnd();

$form->dprint("</div></div>");

// JAVASCRIPT
//
$render->jscript =<<<EOT

function again() {
  var x = document.forms['frm1'];
  x.aktie.value = '';
  x.submit();
}

EOT;

// STYLES
//
$render->extra_headers .= "<link rel='stylesheet' type='text/css' href='install.css' />";

$render->output();

die();

?>
