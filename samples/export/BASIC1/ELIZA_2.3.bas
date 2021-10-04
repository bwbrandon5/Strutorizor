Rem Concept and lisp implementation published by Joseph Weizenbaum (MIT): 
Rem "ELIZA - A Computer Program For the Study of Natural Language Communication Between Man and Machine" - In: 
Rem Computational Linguistis 1(1966)9, pp. 36-45 
Rem Revision history: 
Rem 2016-10-06 Initial version 
Rem 2017-03-29 Two diagrams updated (comments translated to English) 
Rem 2017-03-29 More keywords and replies added 
Rem 2019-03-14 Replies and mapping reorganised for easier maintenance 
Rem 2019-03-15 key map joined from keyword array and index map 
Rem 2019-03-28 Keyword "bot" inserted (same reply ring as "computer") 
Rem 2019-11-28 New global type "History" (to ensure a homogenous array) 
Rem Generated by Structorizer 3.32-01 

Rem Copyright (C) 2018-05-14 Kay Gürtzig 
Rem License: GPLv3-link 
Rem GNU General Public License (V 3) 
Rem https://www.gnu.org/licenses/gpl.html 
Rem http://www.gnu.de/documents/gpl.de.html 

Rem  
Rem program ELIZA
Rem TODO: Check and accomplish your variable declarations here: 
Dim varPart As String
Dim userInput As String
Dim replyRing() As String
Dim reply As String
Dim replies(,) As String
Dim reflexions(,) As String
Dim posAster As Integer
Dim offsets() As Integer
Dim keyMap() As KeyMapEntry
Dim keyIndex As Integer
Dim isRepeated As boolean
Dim isGone As boolean
Dim history As History
Dim findInfo() As integer
Dim entry As KeyMapEntry
Dim byePhrases(,) As String
Rem  
Rem Title information 
PRINT "************* ELIZA **************"
PRINT "* Original design by J. Weizenbaum"
PRINT "**********************************"
PRINT "* Adapted for Basic on IBM PC by"
PRINT "* - Patricia Danielson"
PRINT "* - Paul Hashfield"
PRINT "**********************************"
PRINT "* Adapted for Structorizer by"
PRINT "* - Kay Gürtzig / FH Erfurt 2016"
PRINT "* Version: 2.3 (2020-02-24)"
PRINT "* (Requires at least Structorizer 3.30-03 to run)"
PRINT "**********************************"
Rem Stores the last five inputs of the user in a ring buffer, 
Rem the second component is the rolling (over-)write index. 
Let history.histArray = Array("", "", "", "", "")
Let history.histIndex = 0
Const replies = setupReplies()
Const reflexions = setupReflexions()
Const byePhrases = setupGoodByePhrases()
Const keyMap = setupKeywords()
offsets(length(keyMap)-1) = 0
isGone = false
Rem Starter 
PRINT "Hi! I\'m your new therapist. My name is Eliza. What\'s your problem?"
Do
  INPUT userInput
  Rem Converts the input to lowercase, cuts out interpunctation 
  Rem and pads the string 
  userInput = normalizeInput(userInput)
  isGone = checkGoodBye(userInput, byePhrases)
  If NOT isGone Then
    reply = "Please don\'t repeat yourself!"
    isRepeated = checkRepetition(history, userInput)
    If NOT isRepeated Then
      findInfo = findKeyword(keyMap, userInput)
      keyIndex = findInfo(0)
      If keyIndex < 0 Then
        Rem Should never happen... 
        keyIndex = length(keyMap)-1
      End If
      var entry: KeyMapEntry = keyMap(keyIndex)
      Rem Variable part of the reply 
      varPart = ""
      If length(entry.keyword) > 0 Then
        varPart = conjugateStrings(userInput, entry.keyword, findInfo(1), reflexions)
      End If
      replyRing = replies(entry.index)
      reply = replyRing(offsets(keyIndex))
      offsets(keyIndex) = (offsets(keyIndex) + 1) % length(replyRing)
      posAster = pos("*", reply)
      If posAster > 0 Then
        If varPart = " " Then
          reply = "You will have to elaborate more for me to help you."
        Else
          delete(reply, posAster, 1)
          insert(varPart, reply, posAster)
        End If
      End If
      reply = adjustSpelling(reply)
    End If
    PRINT reply
  End If
Loop Until isGone
End
