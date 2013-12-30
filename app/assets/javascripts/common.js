// for rails > 2.3.11 csrf protection
function CSRFProtection(xhr) {
  var token = $('meta[name="csrf-token"]').attr('content');
  if (token) xhr.setRequestHeader('X-CSRF-Token', token);
}
if ('ajaxPrefilter' in $) $.ajaxPrefilter(function(options, originalOptions, xhr) { CSRFProtection(xhr); });
else $(document).ajaxSend(function(e, xhr) { CSRFProtection(xhr); });

// Use our own debug function. This will only run if the Firebug console is present,
// which won't sabotage for clients if we forget a debug call in the code.
function debug(string)
{
  if(typeof(console) === "undefined" || typeof(console.log) === "undefined"){
    // debugging inactive, output nothing.
  } else {
    console.log(string);
  }
}

// Ckeditor needs to know the base path in production
var CKEDITOR_BASEPATH = '/assets/ckeditor/';
window.CKEDITOR_BASEPATH = '/assets/ckeditor/';
