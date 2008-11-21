package com.codexwiki.bliki.tags;

import java.io.IOException;
import java.util.List;

import info.bliki.Messages;
import info.bliki.wiki.filter.ITextConverter;
import info.bliki.wiki.filter.StringPair;
import info.bliki.wiki.model.IWikiModel;
import info.bliki.wiki.tags.TableOfContentTag;

/**
 * Extension of TableOfContentTag that allows for the use of <base>
 * by providing a way to specify a baseURL for anchor links
 * 
 * @author mark
 *
 */
public class BaseFriendlyTableOfContentTag extends TableOfContentTag
{
	private String TOCBaseURL;

	public BaseFriendlyTableOfContentTag(String name, String TOCBaseURL)
	{
		super(name);
		setTOCBaseURL(TOCBaseURL);
	}
	
	@Override
	public void renderHTML(ITextConverter converter, Appendable writer, IWikiModel model) throws IOException {
		if (isShowToC() && getTableOfContent().size() > 0) {
			String contentString = Messages.getString(model.getResourceBundle(), Messages.WIKI_TAGS_TOC_CONTENT);
			writer.append("<table id=\"toc\" class=\"toc\" summary=\"");
			writer.append(contentString);
			writer.append("\">\n" + "<tr>\n" + "<td>\n" + "<div id=\"toctitle\">\n" + "<h2>");
			writer.append(contentString);
			writer.append("</h2>\n</div>");
			renderToC(writer, getTableOfContent(), 0);
			writer.append("</td></tr></table>\n");
		}
	}

	private void renderToC(Appendable writer, List<Object> toc, int level) throws IOException {
		writer.append("\n<ul>");
		boolean counted = false;
		for (int i = 0; i < toc.size(); i++) {
			if (toc.get(i) instanceof StringPair) {
				if (!counted) {
					level++;
					counted = true;
				}
				StringPair pair = (StringPair) toc.get(i);
				String head = pair.getFirst();
				String anchor = pair.getSecond();
				writer.append("\n<li class=\"toclevel-");
				writer.append(Integer.toString(level));
				writer.append("\"><a href=\"");
				writer.append(getTOCBaseURL());
				writer.append("#");
				writer.append(anchor);
				writer.append("\">");
				writer.append(head);
				writer.append("</a>\n</li>");
			} else {
				renderToC(writer, (List<Object>) toc.get(i), level);
			}
		}
		writer.append("\n</ul>");
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
