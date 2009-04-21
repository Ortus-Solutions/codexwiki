package com.codexwiki.bliki.model;

import com.codexwiki.bliki.tags.BaseFriendlyTableOfContentTag;

import info.bliki.wiki.filter.Encoder;
import info.bliki.wiki.model.Configuration;
import info.bliki.wiki.model.ImageFormat;
import info.bliki.wiki.tags.TableOfContentTag;

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
	 * Constructor 
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
	

	/* (non-Javadoc)
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
	
	/* (non-Javadoc)
	 * @see info.bliki.wiki.model.WikiModel#parseInternalImageLink(java.lang.String, java.lang.String)
	 */
	@Override
	public void parseInternalImageLink(String imageNamespace, String rawImageLink) {
		if (fExternalImageBaseURL != null) {
			String imageHref = fExternalWikiBaseURL;
			String imageSrc = fExternalImageBaseURL;
			ImageFormat imageFormat = ImageFormat.getImageFormat(rawImageLink, imageNamespace);

			String imageName = imageFormat.getFilename();
			String sizeStr = imageFormat.getSizeStr();
			
			//Check for external Images and leave them intact, so you can 
			//include [[Image:http://image here]]
			String targetImageURL = imageName.toLowerCase();
			if( targetImageURL.startsWith("http") || targetImageURL.startsWith("ftp") ){
				imageHref = targetImageURL;
				imageSrc = targetImageURL;
			}
			else{
				//Internal Image Link
				if (sizeStr != null) {
					imageName = sizeStr + '-' + imageName;
				}
				if (imageName.endsWith(".svg")) {
					imageName += ".png";
				}
				imageName = Encoder.encodeUrl(imageName);
				if (replaceColon()) {
					imageName = imageName.replaceAll(":", "/");
				}
				if (replaceColon()) {
					imageHref = imageHref.replace("${title}", imageNamespace + '/' + imageName);
					imageSrc = imageSrc.replace("${image}", imageName);
				} else {
					imageHref = imageHref.replace("${title}", imageNamespace + ':' + imageName);
					imageSrc = imageSrc.replace("${image}", imageName);
				}
			}
			//Append Link
			appendInternalImageLink(imageHref, imageSrc, imageFormat);
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
