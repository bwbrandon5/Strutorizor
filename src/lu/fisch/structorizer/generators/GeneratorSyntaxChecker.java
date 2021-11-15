/*
    Structorizer
    A little tool which you can use to create Nassi-Shneiderman Diagrams (NSD)

    Copyright (C) 2009, 2020  Bob Fisch

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or any
    later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package lu.fisch.structorizer.generators;

import lu.fisch.structorizer.elements.Element;

/******************************************************************************************************
 *
 *      Author:         Kay Gürtzig
 *
 *      Description:    Interface for generator-related syntax checkers (parsers)
 *
 ******************************************************************************************************
 *
 *      Revision List
 *
 *      Author          Date            Description
 *      ------          ----            -----------
 *      Kay Gürtzig     2021-11-11      First Issue
 *
 ******************************************************************************************************
 *
 *      Comment:
 *      
 *
 ******************************************************************************************************///

/**
 * Interface for generator-related syntax checkers
 * @author Kay Gürtzig
 */
public interface GeneratorSyntaxChecker {

	/**
	 * Parses the string {@code _lineToParse} in order to check its syntax
	 * depending on the given source Element considering the associated line
	 * number {@code _lineNo} if it plays a role.<br/>
	 * 
	 * @param _lineToParse - the (possibly preprocessed) Element line to be checked
	 *        for the syntax accepted by the associated Generator subclass
	 * @param _element - the source {@link Element} the line stems from
	 * @param _lineNo - number of the text line {@code _lineToParse}
	 * @return A possible error description string, or {@code null}.
	 */
	public String checkSyntax(String _lineToParse, Element _element, int _lineNo);
	
	/**
	 * Retrieves a possibly occurred exception on parsing
	 * @return either an {@link Exception} object or {@code null}
	 */
	public Exception getParsingException();

}
