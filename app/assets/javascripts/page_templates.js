$(document).ready(function(){


  var codeEditor = ace.edit('code_editor');

  codeEditor.setTheme('ace/theme/tomorrow');
  codeEditor.getSession().setMode('ace/mode/liquid');
  codeEditor.getSession().setTabSize(2);
  codeEditor.getSession().setUseSoftTabs(true);
  codeEditor.getSession().setValue($('#page_template_html').val());

  // Submit look changes via ajax.
  $("form.edit_page_template").submit(function(){
    $('#page_template_html').val(codeEditor.getValue());
    $("#saving_and_info_spinner").show();
    $.post($(this).attr('action'), $(this).serialize(), function(data){
      $("#saving_and_info_spinner").hide();
    });
    return false;
  });
});
