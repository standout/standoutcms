$(function(){
  $('.forgot').click(function(){
    $('#password_order').toggle();
  });

  $('#login').focus();
  
  
  $("div#login-box form:first").submit(function(){
    $(this).find('input[type=submit]:first').replaceWith("<img src='/assets/spinner.gif' alt='Loading ...'>");
  });
  
});
