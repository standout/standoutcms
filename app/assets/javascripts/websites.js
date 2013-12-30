$(function(){
  $("#new_website_membership").submit(function(){
    $.post($(this).attr('action'), $(this).serialize(), function(data){
      $("#website_users").html(data);
    }, "html");
    return false;
  });

  $('form.button-to').live("submit", function(e){
    e.preventDefault();
    var row = $(this).parents("tr");
    $.post($(this).attr('action'), $(this).serialize(), function(data){
      row.remove();
    });
    return false;
  });
});
