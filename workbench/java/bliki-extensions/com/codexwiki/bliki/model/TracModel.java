package com.codexwiki.bliki.model;

import com.codexwiki.bliki.tags.BaseFriendlyTableOfContentTag;

import info.bliki.wiki.model.Configuration;
import info.bliki.wiki.tags.TableOfContentTag;

/**
 * Extension of TracModel to allow for custom pieces, such as the 
 * baseURL for the TableOfContents tag
 * @author luis
 *
 */
public class TracModel extends info.bliki.wiki.model.TracModel
{
	
	/**
	 * The TOC BaseURL to use when creating the TOC Links.
	 */
	private String TOCBaseURL;
	
	/**
	 * Constructor 
	 * @param configuration the configuration bean
	 * @param imageBaseURL url pattern for images
	 * @param linkBaseURL url pattern for links
	 * @param TOCBaseURL url pattern for TOC's links
	 */
	public TracModel(Configuration configuration, String imageBaseURL, String linkBaseURL, String TOCBaseURL){
		super(configuration, imageBaseURL, linkBaseURL);
		//Set the local property of the TOCBaseURL
		setTOCBaseURL(TOCBaseURL);
	}
	

	/**
	 * @see info.bliki.wiki.model.AbstractWikiModel#getTableOfContentTag(boolean)
	 */
	public TableOfContentTag getTableOfContentTag(boolean isTOCIdentifier) {
		if (fTableOfContentTag == null) {
			TableOfContentTag tableOfContentTag = new BaseFriendlyTableOfContentTag("div", getTOCBaseURL());
			tableOfContentTag.addAttribute("id", "tableofcontent", true);
			tableOfContentTag.setShowToC(false);
			tableOfContentTag.setTOCIdentifier(isTOCIdentifier);
			fTableOfContentTag = tableOfContentTag;
		} else {
			if (isTOCIdentifier) {
				TableOfContentTag tableOfContentTag = (TableOfContentTag) fTableOfContentTag.clone();
				fTableOfContentTag.setShowToC(false);
				tableOfContentTag.setShowToC(true);
				tableOfContentTag.setTOCIdentifier(isTOCIdentifier);
				fTableOfContentTag = tableOfContentTag;
			} else {
				return fTableOfContentTag;
			}
		}
		this.append(fTableOfContentTag);
		return fTableOfContentTag;
	}	
	
	private String getTOCBaseURL()
	{
		return TOCBaseURL;
	}
	
	private void setTOCBaseURL(String baseURL)
	{
		TOCBaseURL = baseURL;
	}
}
