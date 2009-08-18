function getLoadingText(){
	return '<div class="loadingContainer"><span class="loading">Loading...</span></div>'
}
function closeModal(){
	$.modal.close();
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
