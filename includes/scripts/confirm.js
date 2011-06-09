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

/* generic confirm dialog */

var confirmDialog = $('<div><p id="message" class"align-center"></p><p class="align-right"><input type="button" id="yes" value="yes" /> <input type="button" class="modalClose" id="no" value="no" /></p></div>');

function confirm(msg, callback)
{
	confirmDialog.clone().modal(
		{
			close: true,
			containerId: "modalConfirmContainer",
			onShow: function(dialog)
				{	
                    dialog.data.find("#message").append(msg);
					var yes = dialog.data.find("#yes");
					var no = dialog.data.find("#no");
					yes.click(function(){
							if($.isFunction(callback)){
								callback.call();
							}
							$.modal.close();
						}
					);
					no.click(function(){
							$.modal.close();
						}
					);
					
				}
		}
	);

	return false;
}
function gotoLink(alink)
{
	window.location.href = $(alink).attr("href");
}