$(function() {
  var extension = $('#look_file_text_content').data('type');
  var mode;
  switch (extension) {
    case 'js':
      mode = 'javascript';
      break;
    case 'css':
      mode = 'css';
  }

  if (mode) {
    codeEditor = ace.edit('code_editor');
    codeEditor.setTheme('ace/theme/tomorrow');
    codeEditor.getSession().setMode('ace/mode/' + mode);
    codeEditor.getSession().setTabSize(2);
    codeEditor.getSession().setUseSoftTabs(true);
    codeEditor.getSession().setValue($('#look_file_text_content').val());
  }

  // Submit look changes via ajax.
  $("form.LookFileContent").submit(function(){
    $("#look_file_text_content").val(codeEditor.getValue());

    $("#saving_and_info_spinner").show();
    $.ajax({
        type: 'POST',
        url: $(this).attr('action'),
        data: $(this).serialize(),
        dataType: "HTML"
    }).success(function(json){
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
