package com.codexwiki.bliki;

import info.bliki.wiki.tags.code.AbstractCPPBasedCodeFilter;
import info.bliki.wiki.tags.code.SourceCodeFormatter;
import java.util.*;

public class ColdFusionCodeFilter extends AbstractCPPBasedCodeFilter implements
	SourceCodeFormatter
{

    private static HashMap<String, String> KEYWORD_SET = new HashMap<String, String>();

    private static final String[] KEYWORDS = { "break", "case", "catch", 
			"continue", "default", "do", "else", "false", "eq", "neq", "not", "gt", "lt", "lte", "gte",
			"finally", "for", "function", "if", "instanceof",
			"createObject", "private", "public", "return", "super", "switch",
			"this", "throw", "true", "try", "var", "void", "while" };

    private static HashSet<String> OBJECT_SET = new HashSet<String>();

    static 
    {
        for (int i = 0; i < KEYWORDS.length; i++) 
        {
            createHashMap(KEYWORD_SET, KEYWORDS[i]);
        }
    }

    public ColdFusionCodeFilter()
    {  
    }
        
    public String filter(String input) {
	char[] source = input.toCharArray();
	int currentPosition = 0;
	int identStart = 0;
	char currentChar = ' ';

	HashMap<String, String> keywordsSet = getKeywordSet();
	HashSet<String> objectsSet = getObjectSet();
	StringBuilder result = new StringBuilder(input.length() + input.length() / 4);
	boolean identFound = false;
	// result.append("<font color=\"#000000\">");
	try {
		while (true) {
			currentChar = source[currentPosition++];
			if (currentChar == '<') { // opening tags
				if (source[currentPosition] == '!' && source[currentPosition + 1] == '-' && source[currentPosition + 2] == '-') {
					// html comment
					currentPosition++;
					result.append(FONT_COMMENT);
					appendChar(result, currentChar);
					appendChar(result, source[currentPosition++]);
					appendChar(result, source[currentPosition++]);
					appendChar(result, source[currentPosition++]);
					
					currentChar = source[currentPosition];
					
					while (currentPosition < input.length()) {
						appendChar(result, currentChar);
						if (currentChar == '-' && source[currentPosition] == '-' && source[currentPosition + 1] == '>') {
							appendChar(result, source[currentPosition++]);
							appendChar(result, source[currentPosition++]);
							break;
						}
						currentChar = source[currentPosition++];
					}
					result.append(FONT_END);

					continue;
				} else {
					result.append("<strong>");
					result.append(FONT_KEYWORD);
					appendChar(result, currentChar);
					// start of identifier ?
					currentChar = source[currentPosition++];
					if (currentChar == '/') {
						appendChar(result, currentChar);
						currentChar = source[currentPosition++];
					}
					while ((currentChar >= 'a' && currentChar <= 'z') || (currentChar >= 'A' && currentChar <= 'Z')
							|| (currentChar >= '0' && currentChar <= '9') || currentChar == '_' || currentChar == '-') {
						appendChar(result, currentChar);
						currentChar = source[currentPosition++];
					}
					if (currentChar == '>') {
						appendChar(result, currentChar);
					} else {
						currentPosition--;
					}
					result.append(FONT_END);
					result.append("</strong>");
					continue; // while loop
				}
			} else if (currentChar == '/' && currentPosition < input.length() && source[currentPosition] == '/') {
				// line comment
				result.append(FONT_COMMENT);
				appendChar(result, currentChar);
				appendChar(result, source[currentPosition++]);
				while (currentPosition < input.length()) {
					currentChar = source[currentPosition++];
					appendChar(result, currentChar);
					if (currentChar == '\n') {
						break;
					}
				}
				result.append(FONT_END);
				continue;
			} else if (currentChar == '/' && currentPosition < input.length() && source[currentPosition] == '*') {
				if (currentPosition < (input.length() - 1) && source[currentPosition + 1] == '*') {
					// javadoc style
					result.append(FONT_JAVADOC);
				} else {
					// multiline comment
					result.append(FONT_COMMENT);
				}
				appendChar(result, currentChar);
				appendChar(result, source[currentPosition++]);
				while (currentPosition < input.length()) {
					currentChar = source[currentPosition++];
					appendChar(result, currentChar);
					if (currentChar == '/' && source[currentPosition - 2] == '*') {
						break;
					}
				}
				result.append(FONT_END);
				continue;
			} else if (currentChar == '/') { // closing tags
				result.append(FONT_KEYWORD);
				appendChar(result, currentChar);
				if (source[currentPosition] == '>') {
					currentChar = source[currentPosition++];
					appendChar(result, currentChar);
				}
				result.append(FONT_END);
				continue;
			} else if (currentChar == '>') { // closing tags
				result.append(FONT_KEYWORD);
				appendChar(result, currentChar);
				result.append(FONT_END);
				continue;
			} else if (currentChar == '\"') { // strings
				result.append(FONT_STRINGS);
				appendChar(result, currentChar);
				while (currentPosition < input.length()) {
					currentChar = source[currentPosition++];
					appendChar(result, currentChar);
					if (currentChar == '\\') {
						currentChar = source[currentPosition++];
						appendChar(result, currentChar);
						continue;
					}
					if (currentChar == '\"') {
						break;
					}
				}
				result.append(FONT_END);
				continue;
			}
			else if ((currentChar >= 'A' && currentChar <= 'Z') || (currentChar == '_') || (currentChar >= 'a' && currentChar <= 'z')) {
				identStart = currentPosition - 1;
				identFound = true;
				// start of identifier ?
				while ((currentChar >= 'a' && currentChar <= 'z') || (currentChar >= 'A' && currentChar <= 'Z') || currentChar == '_') {
					currentChar = source[currentPosition++];
				}
				currentPosition = appendIdentifier(input, identStart, currentPosition, keywordsSet, objectsSet, result);
				identFound = false;
				continue; // while loop
			} else if (currentChar == '\"') { // strings
				result.append(FONT_STRINGS);
				appendChar(result, currentChar);
				while (currentPosition < input.length()) {
					currentChar = source[currentPosition++];
					appendChar(result, currentChar);
					if (currentChar == '\\') {
						currentChar = source[currentPosition++];
						appendChar(result, currentChar);
						continue;
					}
					if (currentChar == '\"') {
						break;
					}
				}
				result.append(FONT_END);
				continue;
			} else if (currentChar == '\'') { // strings
				result.append(FONT_STRINGS);
				appendChar(result, currentChar);
				while (currentPosition < input.length()) {
					currentChar = source[currentPosition++];
					appendChar(result, currentChar);
					if (currentChar == '\\') {
						currentChar = source[currentPosition++];
						appendChar(result, currentChar);
						continue;
					}
					if (currentChar == '\'') {
						break;
					}
				}
				result.append(FONT_END);
				continue;
			}
			appendChar(result, currentChar);

		}
	} catch (IndexOutOfBoundsException e) {
		if (identFound) {
			currentPosition = appendIdentifier(input, identStart, currentPosition, keywordsSet, null, result);
		}
	}
	// result.append(FONT_END);
	return result.toString();
    }
    

    /**
     * @return Returns the KEYWORD_SET.
     */
    @Override
    public HashMap<String, String> getKeywordSet()
    {
	return KEYWORD_SET;
    }

    /**
     * @return Returns the OBJECT_SET.
     */
    @Override
    public HashSet<String> getObjectSet()
    {
	return OBJECT_SET;
    }    
    
	public String xxx(String input) {
		char[] source = input.toCharArray();
		int currentPosition = 0;
		char currentChar = ' ';
		StringBuilder result = new StringBuilder(input.length() + input.length() / 4);
				currentChar = source[currentPosition++];
				
				appendChar(result, currentChar);


		// result.append(FONT_END);
		return result.toString();
	}

 
    
}
