<cfscript>
function cleanupComment(comment){
	return Replace(XMLFormat(comment), chr(10), "<br/>", "all");
}
</cfscript>