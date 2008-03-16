/* generic confirm dialog */

var confirmDialog = $('<div><p id="message" class"align-center"></p><p class="align-right"><input type="button" id="yes" value="yes" /> <input type="button" class="modalClose" id="no" value="no" /></p></div>');

function confirm(msg, callback)
{
	confirmDialog.clone().modal(
		{
			close: false,
			containerId: "modalConfirmContainer",
			onShow: function(dialog)
				{
					dialog.data.find("#message").append(msg);
					var yes = dialog.data.find("#yes");
					yes.click(function()
						{
							if($.isFunction(callback))
							{
								callback.call();
							}

							$.modal.close();
						}
					)
				}
		}
	);

	return false;
}

function gotoLink(alink)
{
	window.location.href = $(alink).attr("href");
}