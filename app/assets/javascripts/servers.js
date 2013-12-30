$(function(){
  $("div.publish_to_server form.edit_server").live('submit', function(e){
    e.preventDefault();
    var server = $(this),
    status = server.find(".publishstatus").show();
    $.post($(this).attr('action'), $(this).serialize(), function(data){
      $(".publishstatus").hide();
      //$('#servers').replaceWith(data);
    }, 'html')
    .error(function(e, j, x){
      status.html(x);
    })
    return false;
  });

  var status = "";
  $('.force_sync').live("click", function(e){
    e.preventDefault();
    var server = $(this);
    status = server.parent(".publish_to_server").find(".publishstatus").show();
    $.get(server.attr("href"), function(){
      $('.publishstatus').hide();
    })
    .error(function(e, j, x){
      status.html(x);
    });
  })

});
