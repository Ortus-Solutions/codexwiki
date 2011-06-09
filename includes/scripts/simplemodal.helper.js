function getLoadingText(){
	return '<div class="loadingContainer"><span class="loading">Loading...</span></div>'
}
function closeModal(){
	$.modal.close();
}
function openModal(link,data,w,h){
	if( h ){ var props = {width: w, height:h}	}
	else{ var props = {width: w} }
	var preview = $(getLoadingText()).modal({
		containerCss: props,
		onOpen: function(dialog){ openDialog(dialog) },
		onShow: function(dialog){ showDialog(dialog,link,data) },
		onClose: function(dialog){ closeDialog(dialog) }
		})
}
function openDialog(dialog){
	dialog.overlay.fadeIn("normal", function()
	 	{
	 		dialog.container.slideDown("normal");
			dialog.data.fadeIn("fast");
	 	}
	 )
}
function showDialog(dialog,postURL,incomingData){
	//Post Preview
	$.post(postURL,incomingData,
		function(html, status)
		{
			dialog.data.html('<div class="modalContent">' + html + '</div>');
		}
	);
}
function closeDialog(dialog){
	dialog.data.fadeOut("fast", function()
	 	{
	 		dialog.container.slideUp("normal");
	 		dialog.overlay.fadeOut("normal",function(){
				$.modal.close();
			});
	 	}
	 )
}
