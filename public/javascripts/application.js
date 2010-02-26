$.extend({
	URLEncode:function(c){var o='';var x=0;c=c.toString();var r=/(^[a-zA-Z0-9_.]*)/;
  while(x<c.length){var m=r.exec(c.substr(x));
    if(m!=null && m.length>1 && m[1]!=''){o+=m[1];x+=m[1].length;
    }else{if(c[x]==' ')o+='+';else{var d=c.charCodeAt(x);var h=d.toString(16);
    o+='%'+(h.length<2?'0':'')+h.toUpperCase();}x++;}}return o;},
	URLDecode:function(s){var o=s;var binVal,t;var r=/(%[^%]{2})/;
  while((m=r.exec(o))!=null && m.length>1 && m[1]!=''){b=parseInt(m[1].substr(1),16);
  t=String.fromCharCode(b);o=o.replace(m[1],t);}return o;}
});

$(document).ready(function(){

	//Remote links
	$('a.remote_link').click(function(){
		jQuery.ajax({dataType:'script', type:'post', url:this.href}); return false;
	});

	//Style tables
	$('table tbody tr:odd').addClass('odd');
	$('table tbody tr:even').addClass('even');
	
	var paramsForUrl = function(url){
		var params = {};
		var queryString = url.match(/\?(.+)/)[1];
		var pairs = queryString.split('&');
		for(var i=0; i < pairs.length ; i++){
			var param = pairs[i].split('=');
			params[$.URLDecode(param[0])] = $.URLDecode(param[1]);
		}
		return params;
	};

	var sendRemoteCreate = function(href){
		var data = paramsForUrl(href);
		var url = href.replace(/new.*/,'');
		$.ajax({
			url: url,
			dataType: 'script',
			type: 'POST',
			data: data
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