/*
<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2008 by
Luis Majano (Ortus Solutions, Corp) and Mark Mandel (Compound Theory)
www.transfer-orm.org |  www.coldboxframework.com
********************************************************************************
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
********************************************************************************
$Build Date: @@build_date@@
$Build ID:	@@build_id@@
********************************************************************************
----------------------------------------------------------------------->
*/

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
function checkAll(checked,id){
	$("input[@name='"+id+"']").each(function(){
		this.checked = checked;
	});
}