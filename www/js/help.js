/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function Help(code,titel,rubriek) {
  if(!rubriek) rubriek='';
  var win = window.open('/helper/help.php?code='+code+'&titel='+titel+'&rubriek='+rubriek,'Help','resizable,scrollbars,status,width=520,height=430,left=40,top=160');
}
