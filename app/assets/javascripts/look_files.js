$(function() {
  var extension = $('#look_file_text_content').data('type');
  var modes = ['js', 'css'];

  if (modes.indexOf(extension) >= 0) {
    var codeEditor = ace.edit('code_editor');
    var modes = {
      js: require('ace/mode/javascript').Mode,
      css: require('ace/mode/css').Mode
    };

    codeEditor.setTheme('ace/theme/tomorrow');
    codeEditor.getSession().setMode(new modes[extension]);
    codeEditor.getSession().setTabSize(2);
    codeEditor.getSession().setUseSoftTabs(true);
    codeEditor.getSession().setValue($('#look_file_text_content').val());
  }

  // Submit look changes via ajax.
  $("form.edit_look_file").submit(function(){
    $('#look_file_text_content').val(codeEditor.getSession().getValue());
    $("#saving_and_info_spinner").show();
    $.post($(this).attr('action'), $(this).serialize(), function(data){
      $("#saving_and_info_spinner").hide();
    });
    return false;
  });

  // Remove template files
  $('.remove a').click(function(e){
    e.preventDefault();
    var self = $(this);
    $.post(self.attr("href"), {
      '_method' : 'delete',
      success: function(){
        self.parents("li").remove();
      }
    });
  });

  $('#files li').hover(function(e){
    $(this).find(".remove").fadeIn(200);
  }, function(e){
    $(this).find(".remove").fadeOut(200);
  });
});
