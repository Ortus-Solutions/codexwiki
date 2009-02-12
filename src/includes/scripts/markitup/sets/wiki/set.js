// -------------------------------------------------------------------
// markItUp!
// -------------------------------------------------------------------
// Copyright (C) 2008 Jay Salvat
// http://markitup.jaysalvat.com/
// -------------------------------------------------------------------
// Mediawiki Wiki tags example
// -------------------------------------------------------------------
// Feel free to add more tags
// -------------------------------------------------------------------
mySettings = {
	previewParserPath:	'', // path to your Wiki parser
	onShiftEnter:		{keepDefault:false, replaceWith:'\n\n'},
	onTab		:		{keepDefault:false, replaceWith:'\t'},
	resizeHandle: true,
	beforeInsert:function(h){markupInserted();},
	markupSet: [
		{name:'Heading 1', key:'1', openWith:'== ', closeWith:' ==', placeHolder:'Your title here...' },
		{name:'Heading 2', key:'2', openWith:'=== ', closeWith:' ===', placeHolder:'Your title here...' },
		{name:'Heading 3', key:'3', openWith:'==== ', closeWith:' ====', placeHolder:'Your title here...' },
		{name:'Heading 4', key:'4', openWith:'===== ', closeWith:' =====', placeHolder:'Your title here...' },
		{name:'Heading 5', key:'5', openWith:'====== ', closeWith:' ======', placeHolder:'Your title here...' },
		{separator:'---------------' },		
		{name:'Bold', key:'B', openWith:"'''", closeWith:"'''"}, 
		{name:'Italic', key:'I', openWith:"''", closeWith:"''"}, 
		{name:'Stroke through', key:'S', openWith:'<s>', closeWith:'</s>'}, 
		{separator:'---------------' },
		{name:'Bulleted list', openWith:'(!(* |!|*)!)'}, 
		{name:'Numeric list', openWith:'(!(# |!|#)!)'}, 
		{separator:'---------------' },
		{name:'Picture', key:"P", replaceWith:'[[Image:[![Url:!:http://]!]|[![name]!]]]'}, 
		{name:'Internal Link', key:"L", openWith:"[[[![Link]!]|", closeWith:']]', placeHolder:'Your text to link here...' },
		{name:'Url', openWith:"[[![Url:!:http://]!] ", closeWith:']', placeHolder:'Your text to link here...' },
		{	name:'Table generator', 
			className:'tablegenerator', 
			placeholder:"Your text here...",
			replaceWith:function(h) {
				cols = prompt("How many cols?");
				rows = prompt("How many rows?");
				html = "{|\n";
				if (h.altKey) {
					for (c = 0; c < cols; c++) {
						html += "! [![TH"+(c+1)+" text:]!]\n";	
					}	
				}
				for (r = 0; r < rows; r++) {
					html+= "|-\n";
					for (c = 0; c < cols; c++) {
						html += "| "+(h.placeholder||"")+"\n";	
					}
				}
				html+= "|}\n";
				return html;
			}
		},
		{name:'Category', className:"categories", openWith:'[[Category:[![Category:]!]]]' },
		{	name:'Calculator', 
			className:'calculator',
			replaceWith:function(h) { 
				try { 
					return eval(h.selection); 
				} 
				catch(e){
					alert("The selection is impossible to calculate: '"+h.selection+"'");
				} 
			}
		},
		{separator:'---------------' },
		{name:'No Wiki',className: 'nowikiGen', openWith:'<nowiki>No Wiki', closeWith:'</nowiki>'},
		{name:'Code',className: 'codeGen', openWith:'(!(<source lang="[![Language:!:coldfusion]!]">|!|<pre>)!)', closeWith:'(!(</source>|!|</pre>)!)'},
		{name:'Messagebox', className: 'messageboxGen', openWith:'{{{Messagebox message="[![Message:]!]" type="[![Type:!:info,error or warning]!]"', closeWith:'}}}'},
		{name:'RSS', className: 'rssGen', openWith:'<feed url="[![URL:]!]" display="[![Display (bullet or numbered):!:bullet]!]" cache="[![Cache Timeout:]!]" maxitems="[![Max Items (0=Unlimited):!:0]!]"', closeWith:' />'},
		{name:'Wiki Plugin', className: 'pluginGen', openWith:'{{{[![Plugin Name:]!]', closeWith:'}}}'},
		{separator:'---------------' },
		{name:'Preview', call:'CodexPreview', className:'preview'},
		{name:'Help', className:'helpGen', call:'openHelp'}
		
	]
}

function openHelp(){
	window.open('http://en.wikipedia.org/wiki/Help:Contents');
}