$(document).ready(function(){

	//Remote links
	$('a.remote_link').click(function(){
		jQuery.ajax({dataType:'script', type:'post', url:this.href}); return false;
	});

	//Style tables
	$('table tbody tr:odd').addClass('odd');
	$('table tbody tr:even').addClass('even');

	var sendRemoteCreate = function(href){
		$.ajax({
			url: href.replace('/new',''),
			dataType: 'script',
			type: 'POST'
		});
	};

	//Remote send rating or vote
	$('a.like, .vote_controls a').click(function(){
		sendRemoteCreate(this.href);
		return false;
	});

	$("#dialog").html(
		"Recuerda que esta opción es para denunciar contenido ofensivo, no ideas con las que no estas de acuerdo.<br/>"+
		" ¿Estás seguro de que este contenido es ofensivo?"
	);
	var offensiveDialog = $("#dialog").dialog({
		autoOpen: false,
		title: 'Contenido ofensivo',
		bgiframe: true,
		resizable: false,
		height:200,
		width: 300,
		modal: true,
		overlay: {
			backgroundColor: '#000',
			opacity: 0.5
		},
		buttons: {
			'Cancelar': function() {
				$(this).dialog('close');
			},
			'Sí, es ofensivo': function() {
				$(this).dialog('close');
				sendRemoteCreate(offensiveDialog.href);
			}
		}
	});

	//Show confirmation dialog for offensive
	$('a.dont_like').click(function(){
		offensiveDialog.href = this.href;
		offensiveDialog.dialog('open');
		return false;
	});


	$('.admin_section').draggable();

	//OpenID
	$("#openid_field").hide();
	$("#openid_links").show();

	function sendOpenIdForm(identifier){
		$("#openid_field").hide();
		$field = $("#user_session_openid_identifier, #user_openid_identifier");
		$field.val(identifier);
		$field.parents('form').submit();
	}

	//OpenId Selection
	$('.id_provider').click(function(){
		var provider = this.id;
		$("#openid_provider").val(provider);

		if (provider == 'google'){
			sendOpenIdForm('https://www.google.com/accounts/o8/id');
		}
		else if(provider == 'yahoo'){
			sendOpenIdForm('http://www.yahoo.com/');
		}
		else if(provider == 'openid'){
			$("#user_session_openid_identifier, #user_openid_identifier").val('');
			$("#openid_field").show();
		}
		return false;
	});

	//Close announcements
	$('.close_announcement a').click(function(){
		$.getScript('/announcements/hide.js');
		return false;
	});

	//WMD Markdown preview
	var $markdown = $('textarea.markdown');
	if ($markdown.length > 0){
		$markdown.markedit({
			'preview': false,
			'toolbar': {
				'backgroundMode': 'light',
				'layout': 'bold italic | link quote image | bulletlist heading | undo redo | help',
				'buttons' :
				 	[
						{
							'id' : 'help',
							'css' : 'help_button',
							'tip' : 'Ayuda',
							'click' : function(){ window.open("/help/editor/");}
						}
					]
			},
			'postload' : function() { 
				$markdown.markeditBindAutoPreview('#mark_preview');
				$markdown.keyup(function(){
					if( $markdown.val().length > 0 ){
						$('#editor_preview').fadeIn();
					}
					else{
						$('#editor_preview').fadeOut();	
					}	
				});
			}
		});
	}
});

//Disable addthis tracking
var addthis_config = {
  data_use_flash: false
}