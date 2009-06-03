package com.codexwiki.bliki.model;

import com.codexwiki.bliki.tags.BaseFriendlyTableOfContentTag;

import info.bliki.wiki.filter.Encoder;
import info.bliki.wiki.model.Configuration;
import info.bliki.wiki.model.ImageFormat;
import info.bliki.wiki.tags.TableOfContentTag;
import java.util.HashSet;

/**
 * Extension of WikiModel to allow for custom pieces, such as the 
 * baseURL for the TableOfContents tag, internal and external 
 * image links
 * @author mark mandel, luis majano
 *
 */
public class WikiModel extends info.bliki.wiki.model.WikiModel
{

	private String TOCBaseURL;
	
	/**
	 * Constructor with a base TOC URL
	 * @param configuration the configuration bean
	 * @param imageBaseURL url pattern for images
	 * @param linkBaseURL url pattern for links
	 * @param TOCBaseURL url pattern for TOC's links
	 */
	public WikiModel(Configuration configuration, String imageBaseURL, String linkBaseURL, String TOCBaseURL)
	{
		super(configuration, imageBaseURL, linkBaseURL);
		
		setTOCBaseURL(TOCBaseURL);
	}
	
	/**
	 * Constructor with empty TOC Base URL 
	 * @param configuration the configuration bean
	 * @param imageBaseURL url pattern for images
	 * @param linkBaseURL url pattern for links
	 */
	public WikiModel(Configuration configuration, String imageBaseURL, String linkBaseURL)
	{
		super(configuration, imageBaseURL, linkBaseURL);
		
		setTOCBaseURL("");
	}
	

	/* (non-Javadoc)
	 * @see info.bliki.wiki.model.AbstractWikiModel#getTableOfContentTag(boolean)
	 */
	public TableOfContentTag createTableOfContent(boolean isTOCIdentifier) {
		if (fTableOfContentTag == null) {
			TableOfContentTag tableOfContentTag = new BaseFriendlyTableOfContentTag("div", getTOCBaseURL());
			tableOfContentTag.addAttribute("id", "tableofcontent", true);
			tableOfContentTag.setShowToC(false);
			tableOfContentTag.setTOCIdentifier(isTOCIdentifier);
			fTableOfContentTag = tableOfContentTag;
			this.append(fTableOfContentTag);
		} else {
			if (isTOCIdentifier) {
				TableOfContentTag tableOfContentTag = (TableOfContentTag) fTableOfContentTag.clone();
				fTableOfContentTag.setShowToC(false);
				tableOfContentTag.setShowToC(true);
				tableOfContentTag.setTOCIdentifier(isTOCIdentifier);
				fTableOfContentTag = tableOfContentTag;
				this.append(fTableOfContentTag);
			} else {
			}
		}
		if (fTableOfContentTag != null) {
			if (fTableOfContent == null) {
				fTableOfContent = fTableOfContentTag.getTableOfContent();
			}
		}
		if (fToCSet == null) {
			fToCSet = new HashSet<String>();
		}
		return fTableOfContentTag;
	}	
	
	/* (non-Javadoc)
	 * @see info.bliki.wiki.model.WikiModel#parseInternalImageLink(java.lang.String, java.lang.String)
	 */
	@Override
	public void parseInternalImageLink(String imageNamespace, String rawImageLink) {
		if (fExternalImageBaseURL != null) {
			ImageFormat imageFormat = ImageFormat.getImageFormat(rawImageLink, imageNamespace);
			String imageName = imageFormat.getFilename();
			
			//Check for external Images and leave them intact, so you can 
			//include [[Image:http://image here]]
			String targetImageURL = imageName.toLowerCase();
			if( targetImageURL.startsWith("http") || targetImageURL.startsWith("ftp") ){
				//Append Link As IS
				appendInternalImageLink(imageName, imageName, imageFormat);
			}
			else{
				super.parseInternalImageLink(imageNamespace, rawImageLink);
			}
		}
	}// end parseInternalImageLink
	
	/**
	 * 
	 * @return The base URL for the TOC
	 */
	private String getTOCBaseURL()
	{
		return TOCBaseURL;
	}
	
	/**
	 * @param baseURL The base URL for the TOC
	 */
	private void setTOCBaseURL(String baseURL)
	{
		TOCBaseURL = baseURL;
	}
}
