//********************************************************************************
//AJAX INTERACTION
//********************************************************************************
function doFormEvent (e, targetID, frm) {
	var params = {};
	for(i=0;i<frm.length;i++) {
		if(!(frm[i].type=="radio" && !frm[i].checked) && frm[i].value != undefined)  {
			params[frm[i].name] = frm[i].value;
		}
	}
	doEvent(e, targetID, params, "POST");
}
function doEvent (route, targetID, params, methodType, onComplete ) {
	//set event
	var pars = "";
	//Check for Method.
	var methodType = (methodType == null) ? "GET" : methodType;
	//onComplete
	var onComplete = (onComplete == null) ? global_onComplete : onComplete;
	//parse params
	for(p in params) pars = pars + p + "=" + escape(params[p]) + "&";
	//do Ajax Updater
	$.ajax( {type: methodType, 
		     url:route,
		     dataType:"html",
		     data: pars,
		     error: global_onError,
		     complete: onComplete,
		     success: function(req){ $("#"+targetID).html(req) }
	});
}
function global_onComplete(){

}
function global_onError(request) {
	alert('Sorry. An error ocurred while calling a server side component. Please try again.');
}