$(document).ready(function(){
  var codeEditor = ace.edit('code_editor'),
      HTMLMode   = require('ace/mode/html').Mode;

  codeEditor.setTheme('ace/theme/tomorrow');
  codeEditor.getSession().setMode(new HTMLMode());
  codeEditor.getSession().setTabSize(2);
  codeEditor.getSession().setUseSoftTabs(true);
  codeEditor.getSession().setValue($('#page_template_html').val());

  // Submit look changes via ajax.
  $("form.edit_page_template").submit(function(){
    $('#page_template_html').val(codeEditor.getSession().getValue());
    $("#saving_and_info_spinner").show();
    $.post($(this).attr('action'), $(this).serialize(), function(data){
      $("#saving_and_info_spinner").hide();
    });
    return false;
  });

  // Remove page templates
  $('.remove a').click(function(e){
    e.preventDefault();
    var self = $(this),
      used = self.parents("span").attr("data-used_on") == "true";

    if(used){
      $('.used_on').highlight();
      alert("This template is used on one or more pages.\nPlease switch those pages templates before deleting this.")
    }else{
      $.post(self.attr("href"), {
        '_method' : 'delete',
        success: function(){
          self.parents("li").remove();
        }
      });
    }
  });

  $('#files li').hover(function(e){
    $(this).find(".remove").fadeIn(200);
  }, function(e){
    $(this).find(".remove").fadeOut(200);
  })
});
