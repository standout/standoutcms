/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview jQuery adapter provides easy use of basic CKEditor functions
 *   and access to internal API. It also integrates some aspects of CKEditor with
 *   jQuery framework.
 *
 * Every TEXTAREA, DIV and P elements can be converted to working editor.
 *
 * Plugin exposes some of editor's event to jQuery event system. All of those are namespaces inside
 * ".ckeditor" namespace and can be binded/listened on supported textarea, div and p nodes.
 *
 * Available jQuery events:
 * - instanceReady.ckeditor( editor, rootNode )
 *   Triggered when new instance is ready.
 * - destroy.ckeditor( editor )
 *   Triggered when instance is destroyed.
 * - getData.ckeditor( editor, eventData )
 *   Triggered when getData event is fired inside editor. It can change returned data using eventData reference.
 * - setData.ckeditor( editor )
 *   Triggered when getData event is fired inside editor.
 *
 * @example
 * <script src="jquery.js"></script>
 * <script src="ckeditor.js"></script>
 * <script src="adapters/jquery/adapter.js"></script>
 */

(function()
{
	/**
	 * Allows CKEditor to override jQuery.fn.val(), making it possible to use the val()
	 * function on textareas, as usual, having it synchronized with CKEditor.<br>
	 * <br>
	 * This configuration option is global and executed during the jQuery Adapter loading.
	 * It can't be customized across editor instances.
	 * @type Boolean
	 * @example
	 * &lt;script&gt;
	 * CKEDITOR.config.jqueryOverrideVal = true;
	 * &lt;/script&gt;
	 * &lt;!-- Important: The JQuery adapter is loaded *after* setting jqueryOverrideVal --&gt;
	 * &lt;script src="/ckeditor/adapters/jquery.js"&gt;&lt;/script&gt;
	 * @example
	 * // ... then later in the code ...
	 *
	 * $( 'textarea' ).ckeditor();
	 * // ...
	 * $( 'textarea' ).val( 'New content' );
	 */
	CKEDITOR.config.jqueryOverrideVal = typeof CKEDITOR.config.jqueryOverrideVal == 'undefined'
		? true : CKEDITOR.config.jqueryOverrideVal;

	var jQuery = window.jQuery;

	if ( typeof jQuery == 'undefined' )
		return;

	// jQuery object methods.
	jQuery.extend( jQuery.fn,
	/** @lends jQuery.fn */
	{
		/**
		 * Return existing CKEditor instance for first matched element.
		 * Allows to easily use internal API. Doesn't return jQuery object.
		 *
		 * Raised exception if editor doesn't exist or isn't ready yet.
		 *
		 * @name jQuery.ckeditorGet
		 * @return CKEDITOR.editor
		 * @see CKEDITOR.editor
		 */
		ckeditorGet: function()
		{
			var instance = this.eq( 0 ).data( 'ckeditorInstance' );
			if ( !instance )
				throw "CKEditor not yet initialized, use ckeditor() with callback.";
			return instance;
		},
		/**
		 * Triggers creation of CKEditor in all matched elements (reduced to DIV, P and TEXTAREAs).
		 * Binds callback to instanceReady event of all instances. If editor is already created, than
		 * callback is fired right away.
		 *
		 * Mixed parameter order allowed.
		 *
		 * @param callback Function to be run on editor instance. Passed parameters: [ textarea ].
		 * Callback is fiered in "this" scope being ckeditor instance and having source textarea as first param.
		 *
		 * @param config Configuration options for new instance(s) if not already created.
		 * See URL
		 *
		 * @example
		 * $( 'textarea' ).ckeditor( function( textarea ) {
		 *   $( textarea ).val( this.getData() )
		 * } );
		 *
		 * @name jQuery.fn.ckeditor
		 * @return jQuery.fn
		 */
		ckeditor: function( callback, config )
		{
			if ( !CKEDITOR.env.isCompatible )
				return this;

			if ( !jQuery.isFunction( callback ))
			{
				var tmp = config;
				config = callback;
				callback = tmp;
			}
			config = config || {};

			this.filter( 'textarea, div, p' ).each( function()
			{
				var $element = jQuery( this ),
					editor = $element.data( 'ckeditorInstance' ),
					instanceLock = $element.data( '_ckeditorInstanceLock' ),
					element = this;

				if ( editor && !instanceLock )
				{
					if ( callback )
						callback.apply( editor, [ this ] );
				}
				else if ( !instanceLock )
				{
					// CREATE NEW INSTANCE

					// Handle config.autoUpdateElement inside this plugin if desired.
					if ( config.autoUpdateElement
						|| ( typeof config.autoUpdateElement == 'undefined' && CKEDITOR.config.autoUpdateElement ) )
					{
						config.autoUpdateElementJquery = true;
					}

					// Always disable config.autoUpdateElement.
					config.autoUpdateElement = false;
					$element.data( '_ckeditorInstanceLock', true );

					// Set instance reference in element's data.
					editor = CKEDITOR.replace( element, config );
					$element.data( 'ckeditorInstance', editor );

					// Register callback.
					editor.on( 'instanceReady', function( event )
					{
						var editor = event.editor;
						setTimeout( function()
						{
							// Delay bit more if editor is still not ready.
							if ( !editor.element )
							{
								setTimeout( arguments.callee, 100 );
								return;
							}

							// Remove this listener.
							event.removeListener( 'instanceReady', this.callee );

							// Forward setData on dataReady.
							editor.on( 'dataReady', function()
							{
								$element.trigger( 'setData' + '.ckeditor', [ editor ] );
							});

							// Forward getData.
							editor.on( 'getData', function( event ) {
								$element.trigger( 'getData' + '.ckeditor', [ editor, event.data ] );
							}, 999 );

							// Forward destroy event.
							editor.on( 'destroy', function()
							{
								$element.trigger( 'destroy.ckeditor', [ editor ] );
							});

							// Integrate with form submit.
							if ( editor.config.autoUpdateElementJquery && $element.is( 'textarea' ) && $element.parents( 'form' ).length )
							{
								var onSubmit = function()
								{
									$element.ckeditor( function()
									{
										editor.updateElement();
									});
								};

								// Bind to submit event.
								$element.parents( 'form' ).submit( onSubmit );

								// Bind to form-pre-serialize from jQuery Forms plugin.
								$element.parents( 'form' ).bind( 'form-pre-serialize', onSubmit );

								// Unbind when editor destroyed.
								$element.bind( 'destroy.ckeditor', function()
								{
									$element.parents( 'form' ).unbind( 'submit', onSubmit );
									$element.parents( 'form' ).unbind( 'form-pre-serialize', onSubmit );
								});
							}

							// Garbage collect on destroy.
							editor.on( 'destroy', function()
							{
								$element.data( 'ckeditorInstance', null );
							});

							// Remove lock.
							$element.data( '_ckeditorInstanceLock', null );

							// Fire instanceReady event.
							$element.trigger( 'instanceReady.ckeditor', [ editor ] );

							// Run given (first) code.
							if ( callback )
								callback.apply( editor, [ element ] );
						}, 0 );
					}, null, null, 9999);
				}
				else
				{
					// Editor is already during creation process, bind our code to the event.
					CKEDITOR.on( 'instanceReady', function( event )
					{
						var editor = event.editor;
						setTimeout( function()
						{
							// Delay bit more if editor is still not ready.
							if ( !editor.element )
							{
								setTimeout( arguments.callee, 100 );
								return;
							}

							if ( editor.element.$ == element )
							{
								// Run given code.
								if ( callback )
									callback.apply( editor, [ element ] );
							}
						}, 0 );
					}, null, null, 9999);
				}
			});
			return this;
		}
	});

	// New val() method for objects.
	if ( CKEDITOR.config.jqueryOverrideVal )
	{
		jQuery.fn.val = CKEDITOR.tools.override( jQuery.fn.val, function( oldValMethod )
		{
			/**
			 * CKEditor-aware val() method.
			 *
			 * Acts same as original jQuery val(), but for textareas which have CKEditor instances binded to them, method
			 * returns editor's content. It also works for settings values.
			 *
			 * @param oldValMethod
			 * @name jQuery.fn.val
			 */
			return function( newValue, forceNative )
			{
				var isSetter = typeof newValue != 'undefined',
					result;

				this.each( function()
				{
					var $this = jQuery( this ),
						editor = $this.data( 'ckeditorInstance' );

					if ( !forceNative && $this.is( 'textarea' ) && editor )
					{
						if ( isSetter )
							editor.setData( newValue );
						else
						{
							result = editor.getData();
							// break;
							return null;
						}
					}
					else
					{
						if ( isSetter )
							oldValMethod.call( $this, newValue );
						else
						{
							result = oldValMethod.call( $this );
							// break;
							return null;
						}
					}

					return true;
				});
				return isSetter ? this : result;
			};
		});
	}
})();


CKEDITOR.editorConfig = function( config )
{
  
  config.PreserveSessionOnFileBrowser = true;
  
  config.height = '400px';
  config.width = '600px';
  config.language = 'en';
  config.extraPlugins = "embed,attachment";
  config.pasteFromWordPromptCleanup = true;
  
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	
  /* Filebrowser routes */
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
  config.filebrowserBrowseUrl = "/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
  config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";

  // The location of a script that handles file uploads in the Flash dialog.
  config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";
  
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
  config.filebrowserImageBrowseLinkUrl = "/admin/pictures";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
  config.filebrowserImageBrowseUrl = "/admin/pictures";

  // The location of a script that handles file uploads in the Image dialog.
  config.filebrowserImageUploadUrl = "/admin/pictures";
  
  // The location of a script that handles file uploads.
  config.filebrowserUploadUrl = "/ckeditor/attachment_files";
  
  // Rails CSRF token
  config.filebrowserParams = function(){
    var csrf_token = jQuery('meta[name=csrf-token]').attr('content'),
        csrf_param = jQuery('meta[name=csrf-param]').attr('content'),
        params = new Object();
    
    if (csrf_param !== undefined && csrf_token !== undefined) {
      params[csrf_param] = csrf_token;
    }
    
    return params;
  };
  
  /* Extra plugins */
  // works only with en, ru, uk locales
  config.extraPlugins = "embed,attachment";
  config.startupOutlineBlocks = true;
  
  /* Toolbars */
  config.toolbar = 'Easy';
  
  config.toolbar_Easy =
    [
        ['Source','-','Preview'],
        ['Cut','Copy','Paste','PasteText','PasteFromWord'],
        ['Undo','Redo','-','SelectAll','RemoveFormat'],
        ['Styles','Format'], ['Subscript', 'Superscript', 'TextColor'], '/',
        ['Bold','Italic','Underline','Strike'], ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
        ['Link','Unlink','Anchor'], ['Image', 'Attachment', 'Flash', 'Embed'],
        ['Table','HorizontalRule','Smiley','SpecialChar','PageBreak']
    ];
};


