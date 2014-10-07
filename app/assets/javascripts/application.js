//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.ui.timepicker
//= require jquery.ui.nestedSortable.js
//= require jquery.ui.datepicker-sv.js
//= require jquery.layout
//= require jquery.Jcrop.min
//= require jquery.remotipart
//= require jrails
//= require common
//= require ckeditor/init
//= require ckcustom.js
//= require string_to_slug
//= require best_in_place
//= require products
//= require angular
//= require angular-resource
//= require angular-route
//= require_tree ./angular
//= require jquery-fileupload/basic
//= require ace/ace
//= require ace/worker-html
//= require ace/worker-css
//= require ace/theme-tomorrow


function reload_gallery_photos()
{
  url = $("#gallery_photos_container").data('source');
  if(url != undefined){
    $.get($("#gallery_photos_container").data('source'), function(data){
      $("#admin-gallery-photos").html(data);
    });
  }
}

$(document).ajaxSend(function(e, xhr, options) {
  var token = $("meta[name='csrf-token']").attr("content");
  xhr.setRequestHeader("X-CSRF-Token", token);
});

var Editorlayout;

$(document).ready(function(){

  load_ckeditors_in("#new_viewport");
  jQuery(".best_in_place").best_in_place();

  // Submit forms with ajax if they are in a div with class 'ajax'
  $("div.ajax form").submit(function(){
    $.post($(this).attr('action'), $(this).serialize());
    return false;
  });


  $("span.in_place_edit_text").live('click', function(){
    $(this).hide();
    $(this).next('span.in_place_edit_field').toggle().focus();
  });

  $("span.in_place_edit_field").live('blur', function(){
    $(this).parents('form:first').trigger('submit');
    $(this).prev('span.in_place_edit_text').text($(this).find('input:first').val()).show();
    $(this).hide();
  });

  $("form.edit_gallery_photo, form.edit_attachment_file").live('submit', function(){
    $.post($(this).attr('action'), $(this).serialize());
    return false;
  });

  $("#settings").delegate("form", "submit", function(){
    if($(this).attr('enctype') != 'multipart/form-data')
    {
      $.post($(this).attr('action'), $(this).serialize(), function(data){
        frames['edit'].load_editables_and_menus();
        $("#settings").hide();
        Editorlayout.close('south');
        $("iframe#edit").height($(window).height() - 50);
        }, 'script');
    return false;
    }
  });


  // Show listconnection select field in custom data fields
  $("select#custom_data_field_fieldtype").change(function(){
    if($(this).val() == 'listconnection' || $(this).val() == 'listconnections')
    {
      $("#listconnection_picker").show('slow');
    } else {
      $("#listconnection_picker").hide('slow');
    }
  });

  // Adding and removing pages.
  // $("form#add_page").submit(function(){
  //   $.post($(this).attr('action'), $(this).serialize(), function(data){
  //     $('#pages_list').html(data);
  //     $("#pages").scrollTop($("#pages")[0].scrollHeight);
  //   }, "script");
  //   return false;
  // });

  $("form#rem_page").submit(function(e){
    var msg = $("#remove_page").attr("data-confirm");
    if(!confirm(msg)){
      e.preventDefault();
    }
  });

  $("#tab_publish").click(function(){
    $("#page_publish").load($(this).attr('href'), function(){
      activate_tab('publish');
    });
    return false;
  });

  $("#page_blogposts a.ajax").live('click', function(){
    remove_ckeditors_in("#page_blogposts");
    $("#page_blogposts").load($(this).attr('href'), function(){
      load_ckeditors_in("#page_blogposts");
    });
    return false;
  });

  $("#page_blogposts input.ajaxdelete").live('click', function(){
    form = $(this).parents('form:first');
    $.post(form.attr('action'), form.serialize(), function(){
      form.parents('tr:first').hide('slow');
    });
    return false;
  });

  $("#page_blogposts form").live('submit', function(){
    $.post($(this).attr('action'), $(this).serialize(), function(data){
      debug("Data returned: " + data);
      $("#tab_blogposts").trigger('click');
    });
    return false;
  });

  $(".cms_date").datepicker();
  $(".cms_datetime").datetimepicker();
  $(".cms_time").timepicker({});


});

// Applies the CKeditor to all elements within the given div.
function load_ckeditors_in(div_id)
{
  try {
  // debug("Loading ckeditors in " + div_id);
  // Add CKEditor to text fields with class .ckeditor

  $(div_id + " textarea.ckeditable").ckeditor(function(){},
  {
      height : 250 + 'px',
      width : '98%',
      filebrowserImageUploadUrl: '/admin/pictures',
      filebrowserBrowseUrl: '/ckeditor/files',
      filebrowserUploadUrl: '/ckeditor/create?kind=file',
      filebrowserImageBrowseUrl: '/admin/pictures',
      defaultLanguage : 'sv' }
  );
  } catch(e) {
    debug("Error (application.js line 160):" + e);
    // Just catch the error
  }
}

function remove_ckeditors_in(div_id)
{
  $(div_id + ' textarea.ckeditable').each(function(index, el){
    debug("checking instance " + el.id);
    try {
      var editorinstance = $("#" + el.id).ckeditorGet();
    } catch(e) {
      debug("Error caught " + e);
    }
    if(editorinstance){
      debug("Editor instance was found. Removing it.");
      CKEDITOR.remove(editorinstance);
    } else {
      debug("Editor could not be found.");
    }
  });
}

function load_gallery(content_item_id)
{
    // Load page details
    $("#overlay-content").load('/admin/galleries/' + content_item_id + '/edit');
    $("#overlay-container").show('slow');
    $("#text_editor").hide();
  //  $("iframe#edit").height($(window).height() - 350);
}


// When a user clicks a remote item it should be loaded in the bottom area.
function load_remote( content_item_id ) {
  Editorlayout.open('south');

  $.get('/extras/' + content_item_id + '/settings', { 'language': $('#language_setting').val(), 'authenticity_token': $("#authenticity_token").val()}, function(data){
    $("#settings").html(data);
    $("#settings a.plugin_tab_link").click(); // auto select the second tab, could be either settings or content.
  });
  $("#settings").show();
  $("#settings").css('height', '95%');
  $("#text_editor").hide();
}

// Menu settings loaded in a popup window
function load_menu_settings(page_template_id, div_id)
{
  // Load page details
  $("#settings").load('/menu/edit/1', { '_method' : 'put', 'page_template_id': page_template_id, 'div_id': div_id, 'authenticity_token': $("#authenticity_token").val() });
  $("#settings").show();
  $("#settings").height(300);
  $("#text_editor").hide();
  $("iframe#edit").height($(window).height() - 350);
}

// Triggered when the user selects another language from the menu
function switch_language()
{
  new_url = String($("iframe#edit").attr('src')).replace(/(#|\?).*/, '') + '?language=' + $("#language_setting").val();
  $("iframe#edit").attr('src', new_url);
}

function activate_tab(tab_name, authenticity_token)
{
    // Mark the tab as active, all others as inactive
    var tabs = $("#menu a");
    tabs.addClass('unselected').removeClass('selected');
    $('#tab_' + tab_name).addClass('selected').removeClass('unselected');

    // Show the viewport
    var viewports = $(".viewport");
    viewports.hide();

    $('#page_' + tab_name).show();

    // Maximize size
    set_content_height('0');

}

var editor;

function load_editor(html)
{
  // debug("Trying to set this data into ckeditor");
  // debug(html);
  // set_editor_height();

  if ( editor ){
    if(editor.setData)
    {
      //debug("case 1: editor is set");
      editor.resetDirty();
      editor.setData(html, function(e){
        // debug("Ready loading ...");
        return true;
      });
    }
  } else {

    // debug("case 2: creating a new editor");
      // Create a new editor inside the <div id="editor">
      editor = window.CKEDITOR.appendTo( 'editor', {
        height : $("#editor").height() - 80,
        width : '98%',
        filebrowserImageUploadUrl: '/admin/pictures',
        filebrowserBrowseUrl: '/admin/files',
        filebrowserUploadUrl: '/admin/files/new',
        filebrowserImageBrowseUrl: '/admin/pictures',
        defaultLanguage : 'sv' },
        html
       );
       window.editor.focus();
       load_editor(html);
  }
  return true;
}

function maximum_editor_height()
{
  maximum_height = $(window).height();
  if(maximum_height > 522)
  {
    maximum_height = 500;
  }
  return maximum_height - 25;
}

function load_liquid(div_id, some_variable)
{
  debug('loading liquid');
  Editorlayout.open('south');
  $("#settings").show();
  $("#text_editor").hide();
  $("#editor").hide();
  $("#settings").css('height', '95%');
  $("#settings").load('/admin/content_items/' + div_id.replace('content_item_', '') + '/edit');
  return false;
}


function load_texteditor(div_id, sticky)
{
  Editorlayout.open('south');

  if(sticky == '1')
  {
    $('#content_item_sticky').attr("checked", true);
  } else {
    $('#content_item_sticky').attr("checked", false);
  }
  $("#settings").hide();
    $('#text_editor').show().css('height', '100%');
    $("#editor").show().width($(window).width() - 200);

    $.get('/admin/content_items/' + div_id.replace('content_item_', '') + '?dont_parse=true', function(data) {

        $('#text_editor').css('width', '100%');
        $('#text_editor').css('width', frames['edit'].document.getElementById(div_id).width);
        set_editor_height();
        setTimeout(function(){ load_editor(data) }, 500);
    });

    $('#selected_content_item').val(div_id);
}

// Automatically resize the CKeditor in the bottom field.
function set_editor_height()
{
 $("#cke_editor1").css('height', $('#editor').css('height'));
 $("#cke_editor1 td.cke_contents").css('height', $('#editor').height() - 80);
 $("#cke_contents_editor1").css('height', $('#editor').height() - 80);
}

// Maximize the viewport for content editing
function set_content_height(reserved_space)
{
    if(reserved_space == '')
    {
        reserved_space = 25;
    }
    available = $(window).height() - 25;
    $('#page_content').height(available);
    $(".viewport").height(available);
    $(".viewport").width($(window).width() - 220);
    $(".with_margin").width($(window).width() - 220 - 60);
    $('#page_content').css({ margin: '0px'});
    $('#page_content_iframe').height((available - reserved_space - 50));
    $('#page_content').width($(window).width() - 190);
    $('#page_content_iframe').width($('#page_content').width() - 20);
    set_pages_height();
    set_editor_height();
}

// Perform our own save function instead of the default one in FCK Editor
function doSave(){

    var editor_data = editor.getData();
    div_id = $('#selected_content_item').val();
    frames['edit'].document.getElementById(div_id).innerHTML = editor_data;
    $('#text_editor').height('1');
    $("iframe#edit").height($(window).height() - 50);
    set_content_height('0');

    // Make the update
    authenticity_token = $('#authenticity_token').val();
    id = div_id.replace('content_item_', '');

    var sticky = $('#content_item_sticky').is(":checked") ? '1' : '0';

    $.post('/admin/content_items/' + id, { '_method': 'put', 'id': id, authenticity_token: encodeURIComponent(authenticity_token), 'content_item[sticky]': sticky, 'content_item[text_content]': editor_data }, function(data){
      // Data was saved.
      frames['edit'].document.getElementById(div_id).innerHTML = data;
    });
    Editorlayout.close('south');

    return false; //this disables default action (submitting the form)
}

function cancel_editing()
{
  Editorlayout.close('south');
  return false;
}

function unselect_item_temp(div_id)
{
    if($('#selected_content_item').val() != div_id)
    {
        // frames['page_content_iframe'].document.getElementById(div_id).css('outline', 'invert none medium');
    }
}

function unselect_element_temp(div_id)
{
  if($('#selected_element'))
  {
    if($('#selected_element').val() != div_id)
    {
        // frames['page_content_iframe'].document.getElementById(div_id).css('outline', 'invert none medium');
    }
  }
}

function select_item(content_item_id)
{
  // Select our current content_item
  $('#page_content_iframe').contents().find('.content_item').removeClass('standoutcms_selected').addClass('standoutcms_unselected');
  $('#page_content_iframe').contents().find('#' + content_item_id).removeClass('standoutcms_unselected').addClass('standoutcms_selected');

  // Set our current_value in the form
  $('#selected_content_item').val(content_item_id);

  // Activate our remove button
  $('#remove_element_button').attr('disabled', false);

  // Set content height
  set_content_height();
}

function select_element(element_id)
{
  $('#selected_element').val(element_id);
}

function remove_item(content_item_id){
  if(confirm('Vill du verkligen ta bort det markerade innehållet?')){
    $.post('/admin/content_items/' + content_item_id, {
      '_method' : 'delete',
      'id' : content_item_id,
      success: function(){
        $('#edit').contents().find('#content_item_' + content_item_id).parents('div:first').remove();
      }
    });
  }
}

// called during template selection
function select_template_for_page (selected, new_id) {
  // Remove the current selected look and select the new look
  $('a.template-clickable').removeClass('selected');
  $(selected).addClass('selected');

  // Set our new value
  $('#page_look_id').val(new_id);

}

function load_editarea()
{
  $('#looks_manager').hide();
  $('#look_details').show();
}

// Set the height of pages div to the left
function set_pages_height()
{
  // viewport height - 25px (top) - 45px (bottom)
  if($('#pages')){
    $('#pages').css({ height: $(window).height() - 25 - 45 + 'px' });
  }
}

// Make sure pages height is set on load
$(document).ready(function() {
  set_pages_height();
  try {
    // We are adding the nested sortable for drag/drop of pages in left side menu.
    // This handles callbacks to the server side when the dragging stops.
    $('ul#pages_list').nestedSortable({ forcePlaceholderSize: true, items: 'li', handle: 'a', listType: 'l',t: '> a',
    stop: function(event, ui) {
      // var movedItem = ui.item.attr('id');
      var pages = $('ul#pages_list').nestedSortable('forBackend');
      $.post('/admin/pages/order', pages, function(){

        // Mark first page with home class
        $("ul#pages_list li.home").removeClass('home');
        $("ul#pages_list li:first").addClass('home');
      });
    }
  });
  $("ul#pages_list li:first").addClass('home');
  } catch(e) {

  }
});

$(document).bind("resize", function() {
  set_pages_height();
});


// shows the selected tab and hides all other tabs. Used in Extras.
function enable_tab(plugin)
{
  $('.plugin_tab').hide();
  $("#" + plugin).show();

  switch(plugin)
  {
    case 'plugin_content':
      load_iframe_for_extra();
    break;
  }

}

// Extra: Loading of iframe contents based on current value of remote edit url.
function load_iframe_for_extra()
{
  var location = $('#extra_edit_url').val().match(/http:\/\//) ? $('#extra_edit_url').val() : $('#extra_domain').text() + $('#extra_edit_url').val();
  $('#plugin_iframe').attr('src', location + (location.indexOf("?") == -1 ? "?" : "&") + (new Date()).getTime() + "&page_id=" + $('#current_page').val());
}

// Displays or hides subpages in left page menu
function toggle_subpages(image, page_id)
{
  $('#page_' + page_id + '_children').toggle();

  if(image.src == '/assets/arrow_expanded.png')
  {
    image.src = '/assets/arrow_contracted.png';
  } else {
    image.src = '/assets/arrow_expanded.png';
  }

}
