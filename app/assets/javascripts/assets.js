$(function(){
  // Reloads and rerenders processed files in "browserwindow"
  setInterval(function(){
    $('.processing').each(function(){
      var me = $(this);
      $.get(me.attr('data-url'), function(partial){
        me.replaceWith(partial);
      });
    });
  }, 5000);
});

