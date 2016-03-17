
function myCustomInitInstance(inst) {
  return;
  if(inst.editorId != 'mce_fullscreen')
    inst.execCommand('mceFullScreen');
}

tinyMCE.init({
  // General options
  mode : "textareas",
  theme : "advanced",
  plugins : "safari,style,table,save,fullscreen,template",
  save_enablewhendirty : true,
     
  // Theme options
  theme_advanced_buttons1 : "save,|,bold,italic,underline,strikethrough,|,bullist,numlist,|,undo,redo,|,outdent,indent,formatselect,|,code,fullscreen",
  theme_advanced_buttons2 : "blockquote,cite,nonbreaking,|,image,insertimage,insertfile,tablecontrols",
  theme_advanced_buttons3 : "",
  theme_advanced_buttons4 : "",

  // theme_advanced_buttons1 : "save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect",
  // theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
  // theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen",
  // theme_advanced_buttons4 : "insertlayer,moveforward,movebackward,absolute,|,styleprops,spellchecker,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,blockquote,pagebreak,|,insertfile,insertimage",

  // fullscreen_new_window : true,

  theme_advanced_toolbar_location : "top",
  theme_advanced_toolbar_align : "left",
  theme_advanced_statusbar_location : "bottom",
  theme_advanced_resizing : true,
   
  // Example content CSS (should be your site CSS)
  //content_css : "css/example.css",
  content_css : "/css/editor.css",
   
  // Drop lists for link/image/media/template dialogs
  template_external_list_url : "js/template_list.js",
  //external_link_list_url : "js/link_list.js",
  //external_image_list_url : "js/image_list.js",
  //media_external_list_url : "js/media_list.js",
  init_instance_callback : "myCustomInitInstance",
   
  // Replace values for the template plugin
  template_replace_values : {
  username : "Wega 13",
  staffid : "0001"
  }

});

