REM Concept and lisp implementation published by Joseph Weizenbaum (MIT): 
REM "ELIZA - A Computer Program For the Study of Natural Language Communication Between Man and Machine" - In: 
REM Computational Linguistis 1(1966)9, pp. 36-45 
REM Revision history: 
REM 2016-10-06 Initial version 
REM 2017-03-29 Two diagrams updated (comments translated to English) 
REM 2017-03-29 More keywords and replies added 
REM 2019-03-14 Replies and mapping reorganised for easier maintenance 
REM 2019-03-15 key map joined from keyword array and index map 
REM 2019-03-28 Keyword "bot" inserted (same reply ring as "computer") 
REM Generated by Structorizer 3.30-02 
REM  
REM Copyright (C) 2018-05-14 ??? 
REM License: GPLv3-link 
REM GNU General Public License (V 3) 
REM https://www.gnu.org/licenses/gpl.html 
REM http://www.gnu.de/documents/gpl.de.html 
REM  
REM  
REM program ELIZA
REM TODO: declare your variables here: 
  REM DIM varPart AS <type> 
  REM DIM userInput AS <type> 
  REM DIM replyRing AS <type> 
  REM DIM reply AS <type> 
  REM DIM replies AS <type> 
  REM DIM reflexions AS <type> 
  REM DIM posAster AS <type> 
  REM DIM offsets AS <type> 
  REM DIM keyMap AS <type> 
  REM DIM keyIndex AS <type> 
  REM DIM isRepeated AS <type> 
  REM DIM isGone AS <type> 
  REM DIM history AS <type> 
  REM DIM findInfo AS <type> 
  REM DIM entry AS <type> 
  REM DIM byePhrases AS <type> 
REM  
REM Title information 
PRINT "************* ELIZA **************"
PRINT "* Original design by J. Weizenbaum"
PRINT "**********************************"
PRINT "* Adapted for Basic on IBM PC by"
PRINT "* - Patricia Danielson"
PRINT "* - Paul Hashfield"
PRINT "**********************************"
PRINT "* Adapted for Structorizer by"
PRINT "* - Kay Gürtzig / FH Erfurt 2016"
PRINT "* Version: 2.2 (2019-03-28)"
PRINT "**********************************"
REM Stores the last five inputs of the user in a ring buffer, 
REM the first element is the current insertion index 
history = Array(0, "", "", "", "", "")
CALL const replies = setupReplies()
CALL const reflexions = setupReflexions()
CALL const byePhrases = setupGoodByePhrases()
CALL const keyMap = setupKeywords()
offsets(length(keyMap)-1) = 0
isGone = false
REM Starter 
PRINT "Hi! I\'m your new therapist. My name is Eliza. What\'s your problem?"
DO
  INPUT userInput
  REM Converts the input to lowercase, cuts out interpunctation 
  REM and pads the string 
  CALL userInput = normalizeInput(userInput)
  CALL isGone = checkGoodBye(userInput, byePhrases)
  IF NOT isGone THEN
    reply = "Please don\'t repeat yourself!"
    CALL isRepeated = checkRepetition(history, userInput)
    IF NOT isRepeated THEN
      CALL findInfo = findKeyword(keyMap, userInput)
      keyIndex = findInfo(0)
      IF keyIndex < 0 THEN
        REM Should never happen... 
        keyIndex = length(keyMap)-1
      END IF
      var entry: KeyMapEntry = keyMap(keyIndex)
      REM Variable part of the reply 
      varPart = ""
      IF length(entry.keyword) > 0 THEN
        CALL varPart = conjugateStrings(userInput, entry.keyword, findInfo(1), reflexions)
      END IF
      replyRing = replies(entry.index)
      reply = replyRing(offsets(keyIndex))
      offsets(keyIndex) = (offsets(keyIndex) + 1) % length(replyRing)
      posAster = pos("*", reply)
      IF posAster > 0 THEN
        IF varPart = " " THEN
          reply = "You will have to elaborate more for me to help you."
        ELSE
          delete(reply, posAster, 1)
          insert(varPart, reply, posAster)
        END IF
      END IF
      CALL reply = adjustSpelling(reply)
    END IF
    PRINT reply
  END IF
LOOP UNTIL isGone
END
REM  
REM Cares for correct letter case among others 
REM TODO: Check (and specify if needed) the argument and result types! 
FUNCTION adjustSpelling(sentence AS String) AS String
  REM TODO: declare your variables here: 
    REM DIM word AS <type> 
    REM DIM start AS <type> 
    REM DIM result AS <type> 
    REM DIM position AS <type> 
  REM  
  result = sentence
  position = 1
  DO WHILE (position <= length(sentence)) AND (copy(sentence, position, 1) = " ")
    position = position + 1
  LOOP
  IF position <= length(sentence) THEN
    start = copy(sentence, 1, position)
    delete(result, 1, position)
    insert(uppercase(start), result, 1)
  END IF
  DIM array6e2d7c61() AS String = {" i ", " i\'"}
  FOR EACH word IN array6e2d7c61
    position = pos(word, result)
    DO WHILE position > 0
      delete(result, position+1, 1)
      insert("I", result, position+1)
      position = pos(word, result)
    LOOP
  NEXT word
  RETURN result
END FUNCTION
REM  
REM Checks whether the given text contains some kind of 
REM good-bye phrase inducing the end of the conversation 
REM and if so writes a correspding good-bye message and 
REM returns true, otherwise false 
REM TODO: Check (and specify if needed) the argument and result types! 
FUNCTION checkGoodBye(text AS String, phrases AS array of array[0..1] of string) AS boolean
  REM TODO: declare your variables here: 
    REM DIM saidBye AS <type> 
    REM DIM pair AS <type> 
  REM  
  FOR EACH pair IN phrases
    IF pos(pair(0), text) > 0 THEN
      saidBye = true
      PRINT pair(1)
      RETURN true
    END IF
  NEXT pair
  return false
END FUNCTION
REM  
REM Checks whether newInput has occurred among the last 
REM length(history) - 1 input strings and updates the history 
REM TODO: Check (and specify if needed) the argument and result types! 
FUNCTION checkRepetition(history AS array, newInput AS String) AS boolean
  REM TODO: declare your variables here: 
    REM DIM i AS <type> 
    REM DIM hasOccurred AS <type> 
    REM DIM currentIndex AS <type> 
  REM  
  hasOccurred = false
  IF length(newInput) > 4 THEN
    currentIndex = history(0);
    FOR i = 1 TO length(history)-1
      IF newInput = history(i) THEN
        hasOccurred = true
      END IF
    NEXT i
    history(history(0)+1) = newInput
    history(0) = (history(0) + 1) % (length(history) - 1)
  END IF
  return hasOccurred
END FUNCTION
REM  
REM TODO: Check (and specify if needed) the argument and result types! 
FUNCTION conjugateStrings(sentence AS String, key AS String, keyPos AS integer, flexions AS array of array[0..1] of string) AS String
  REM TODO: declare your variables here: 
    REM DIM right AS <type> 
    REM DIM result AS <type> 
    REM DIM position AS <type> 
    REM DIM pair AS <type> 
    REM DIM left AS <type> 
  REM  
  result = " " + copy(sentence, keyPos + length(key), length(sentence)) + " "
  FOR EACH pair IN flexions
    left = ""
    right = result
    position = pos(pair(0), right)
    DO WHILE position > 0
      left = left + copy(right, 1, position-1) + pair(1)
      right = copy(right, position + length(pair(0)), length(right))
      position = pos(pair(0), right)
    LOOP
    result = left + right
  NEXT pair
  REM Eliminate multiple spaces 
  position = pos("  ", result)
  DO WHILE position > 0
    result = copy(result, 1, position-1) + copy(result, position+1, length(result))
    position = pos("  ", result)
  LOOP
  RETURN result
END FUNCTION
REM  
REM Looks for the occurrence of the first of the strings 
REM contained in keywords within the given sentence (in 
REM array order). 
REM Returns an array of 
REM 0: the index of the first identified keyword (if any, otherwise -1), 
REM 1: the position inside sentence (0 if not found) 
REM TODO: Check (and specify if needed) the argument and result types! 
FUNCTION findKeyword(keyMap AS const array of KeyMapEntry, sentence AS String) AS array[0..1] of integer
  REM TODO: declare your variables here: 
    REM DIM result AS <type> 
    REM DIM position AS <type> 
    REM DIM i AS <type> 
    REM DIM entry AS <type> 
  REM  
  REM Contains the index of the keyword and its position in sentence 
  result = Array(-1, 0)
  i = 0
  DO WHILE (result(0) < 0) AND (i < length(keyMap))
    var entry: KeyMapEntry = keyMap(i)
    position = pos(entry.keyword, sentence)
    IF position > 0 THEN
      result(0) = i
      result(1) = position
    END IF
    i = i+1
  LOOP
  RETURN result
END FUNCTION
REM  
REM Converts the sentence to lowercase, eliminates all 
REM interpunction (i.e. ',', '.', ';'), and pads the 
REM sentence among blanks 
REM TODO: Check (and specify if needed) the argument and result types! 
FUNCTION normalizeInput(sentence AS String) AS String
  REM TODO: declare your variables here: 
    REM DIM symbol AS <type> 
    REM DIM result AS <type> 
    REM DIM position AS <type> 
  REM  
  sentence = lowercase(sentence)
  REM TODO: Specify an appropriate element type for the array! 
  DIM array45d0a8fd() AS FIXME_45d0a8fd = {'.', ',', ';', '!', '?'}
  FOR EACH symbol IN array45d0a8fd
    position = pos(symbol, sentence)
    DO WHILE position > 0
      sentence = copy(sentence, 1, position-1) + copy(sentence, position+1, length(sentence))
      position = pos(symbol, sentence)
    LOOP
  NEXT symbol
  result = " " + sentence + " "
  RETURN result
END FUNCTION
REM  
REM TODO: Check (and specify if needed) the argument and result types! 
FUNCTION setupGoodByePhrases() AS array of array[0..1] of string
  REM TODO: declare your variables here: 
    REM DIM phrases AS <type> 
  REM  
  phrases(0) = Array(" shut", "Okay. If you feel that way I\'ll shut up. ... Your choice.")
  phrases(1) = Array("bye", "Well, let\'s end our talk for now. See you later. Bye.")
  return phrases
END FUNCTION
REM  
REM The lower the index the higher the rank of the keyword (search is sequential). 
REM The index of the first keyword found in a user sentence maps to a respective 
REM reply ring as defined in `setupReplies()´. 
REM TODO: Check (and specify if needed) the argument and result types! 
FUNCTION setupKeywords() AS array of KeyMapEntry
  REM TODO: declare your variables here: 
    REM DIM keywords AS <type> 
  REM  
  REM The empty key string (last entry) is the default clause - will always be found 
  keywords(39) = KeyMapEntryArray("", 29)
  keywords(0) = KeyMapEntryArray("can you ", 0)
  keywords(1) = KeyMapEntryArray("can i ", 1)
  keywords(2) = KeyMapEntryArray("you are ", 2)
  keywords(3) = KeyMapEntryArray("you\'re ", 2)
  keywords(4) = KeyMapEntryArray("i don't ", 3)
  keywords(5) = KeyMapEntryArray("i feel ", 4)
  keywords(6) = KeyMapEntryArray("why don\'t you ", 5)
  keywords(7) = KeyMapEntryArray("why can\'t i ", 6)
  keywords(8) = KeyMapEntryArray("are you ", 7)
  keywords(9) = KeyMapEntryArray("i can\'t ", 8)
  keywords(10) = KeyMapEntryArray("i am ", 9)
  keywords(11) = KeyMapEntryArray("i\'m ", 9)
  keywords(12) = KeyMapEntryArray("you ", 10)
  keywords(13) = KeyMapEntryArray("i want ", 11)
  keywords(14) = KeyMapEntryArray("what ", 12)
  keywords(15) = KeyMapEntryArray("how ", 12)
  keywords(16) = KeyMapEntryArray("who ", 12)
  keywords(17) = KeyMapEntryArray("where ", 12)
  keywords(18) = KeyMapEntryArray("when ", 12)
  keywords(19) = KeyMapEntryArray("why ", 12)
  keywords(20) = KeyMapEntryArray("name ", 13)
  keywords(21) = KeyMapEntryArray("cause ", 14)
  keywords(22) = KeyMapEntryArray("sorry ", 15)
  keywords(23) = KeyMapEntryArray("dream ", 16)
  keywords(24) = KeyMapEntryArray("hello ", 17)
  keywords(25) = KeyMapEntryArray("hi ", 17)
  keywords(26) = KeyMapEntryArray("maybe ", 18)
  keywords(27) = KeyMapEntryArray(" no", 19)
  keywords(28) = KeyMapEntryArray("your ", 20)
  keywords(29) = KeyMapEntryArray("always ", 21)
  keywords(30) = KeyMapEntryArray("think ", 22)
  keywords(31) = KeyMapEntryArray("alike ", 23)
  keywords(32) = KeyMapEntryArray("yes ", 24)
  keywords(33) = KeyMapEntryArray("friend ", 25)
  keywords(34) = KeyMapEntryArray("computer", 26)
  keywords(35) = KeyMapEntryArray("bot ", 26)
  keywords(36) = KeyMapEntryArray("smartphone", 27)
  keywords(37) = KeyMapEntryArray("father ", 28)
  keywords(38) = KeyMapEntryArray("mother ", 28)
  return keywords
END FUNCTION
REM  
REM Returns an array of pairs of mutualy substitutable  
REM TODO: Check (and specify if needed) the argument and result types! 
FUNCTION setupReflexions() AS array of array[0..1] of string
  REM TODO: declare your variables here: 
    REM DIM reflexions AS <type> 
  REM  
  reflexions(0) = Array(" are ", " am ")
  reflexions(1) = Array(" were ", " was ")
  reflexions(2) = Array(" you ", " I ")
  reflexions(3) = Array(" your", " my")
  reflexions(4) = Array(" i\'ve ", " you\'ve ")
  reflexions(5) = Array(" i\'m ", " you\'re ")
  reflexions(6) = Array(" me ", " you ")
  reflexions(7) = Array(" my ", " your ")
  reflexions(8) = Array(" i ", " you ")
  reflexions(9) = Array(" am ", " are ")
  return reflexions
END FUNCTION
REM  
REM This routine sets up the reply rings addressed by the key words defined in 
REM routine `setupKeywords()´ and mapped hitherto by the cross table defined 
REM in `setupMapping()´ 
REM TODO: Check (and specify if needed) the argument and result types! 
FUNCTION setupReplies() AS array of array of string
  REM TODO: declare your variables here: 
    REM DIM setupReplies AS <type> 
    REM DIM replies AS <type> 
  REM  
  var replies: array of array of String
  REM We start with the highest index for performance reasons 
  REM (is to avoid frequent array resizing) 
  replies(29) = Array(\
  "Say, do you have any psychological problems?",\
  "What does that suggest to you?",\
  "I see.",\
  "I'm not sure I understand you fully.",\
  "Come come elucidate your thoughts.",\
  "Can you elaborate on that?",\
  "That is quite interesting.")
  replies(0) = Array(\
  "Don't you believe that I can*?",\
  "Perhaps you would like to be like me?",\
  "You want me to be able to*?")
  replies(1) = Array(\
  "Perhaps you don't want to*?",\
  "Do you want to be able to*?")
  replies(2) = Array(\
  "What makes you think I am*?",\
  "Does it please you to believe I am*?",\
  "Perhaps you would like to be*?",\
  "Do you sometimes wish you were*?")
  replies(3) = Array(\
  "Don't you really*?",\
  "Why don't you*?",\
  "Do you wish to be able to*?",\
  "Does that trouble you*?")
  replies(4) = Array(\
  "Do you often feel*?",\
  "Are you afraid of feeling*?",\
  "Do you enjoy feeling*?")
  replies(5) = Array(\
  "Do you really believe I don't*?",\
  "Perhaps in good time I will*.",\
  "Do you want me to*?")
  replies(6) = Array(\
  "Do you think you should be able to*?",\
  "Why can't you*?")
  replies(7) = Array(\
  "Why are you interested in whether or not I am*?",\
  "Would you prefer if I were not*?",\
  "Perhaps in your fantasies I am*?")
  replies(8) = Array(\
  "How do you know you can't*?",\
  "Have you tried?","Perhaps you can now*.")
  replies(9) = Array(\
  "Did you come to me because you are*?",\
  "How long have you been*?",\
  "Do you believe it is normal to be*?",\
  "Do you enjoy being*?")
  replies(10) = Array(\
  "We were discussing you--not me.",\
  "Oh, I*.",\
  "You're not really talking about me, are you?")
  replies(11) = Array(\
  "What would it mean to you if you got*?",\
  "Why do you want*?",\
  "Suppose you soon got*...",\
  "What if you never got*?",\
  "I sometimes also want*.")
  replies(12) = Array(\
  "Why do you ask?",\
  "Does that question interest you?",\
  "What answer would please you the most?",\
  "What do you think?",\
  "Are such questions on your mind often?",\
  "What is it that you really want to know?",\
  "Have you asked anyone else?",\
  "Have you asked such questions before?",\
  "What else comes to mind when you ask that?")
  replies(13) = Array(\
  "Names don't interest me.",\
  "I don't care about names -- please go on.")
  replies(14) = Array(\
  "Is that the real reason?",\
  "Don't any other reasons come to mind?",\
  "Does that reason explain anything else?",\
  "What other reasons might there be?")
  replies(15) = Array(\
  "Please don't apologize!",\
  "Apologies are not necessary.",\
  "What feelings do you have when you apologize?",\
  "Don't be so defensive!")
  replies(16) = Array(\
  "What does that dream suggest to you?",\
  "Do you dream often?",\
  "What persons appear in your dreams?",\
  "Are you disturbed by your dreams?")
  replies(17) = Array(\
  "How do you do ...please state your problem.")
  replies(18) = Array(\
  "You don't seem quite certain.",\
  "Why the uncertain tone?",\
  "Can't you be more positive?",\
  "You aren't sure?",\
  "Don't you know?")
  replies(19) = Array(\
  "Are you saying no just to be negative?",\
  "You are being a bit negative.",\
  "Why not?",\
  "Are you sure?",\
  "Why no?")
  replies(20) = Array(\
  "Why are you concerned about my*?",\
  "What about your own*?")
  replies(21) = Array(\
  "Can you think of a specific example?",\
  "When?",\
  "What are you thinking of?",\
  "Really, always?")
  replies(22) = Array(\
  "Do you really think so?",\
  "But you are not sure you*?",\
  "Do you doubt you*?")
  replies(23) = Array(\
  "In what way?",\
  "What resemblance do you see?",\
  "What does the similarity suggest to you?",\
  "What other connections do you see?",\
  "Could there really be some connection?",\
  "How?",\
  "You seem quite positive.")
  replies(24) = Array(\
  "Are you sure?",\
  "I see.",\
  "I understand.")
  replies(25) = Array(\
  "Why do you bring up the topic of friends?",\
  "Do your friends worry you?",\
  "Do your friends pick on you?",\
  "Are you sure you have any friends?",\
  "Do you impose on your friends?",\
  "Perhaps your love for friends worries you.")
  replies(26) = Array(\
  "Do computers worry you?",\
  "Are you talking about me in particular?",\
  "Are you frightened by machines?",\
  "Why do you mention computers?",\
  "What do you think machines have to do with your problem?",\
  "Don't you think computers can help people?",\
  "What is it about machines that worries you?")
  replies(27) = Array(\
  "Do you sometimes feel uneasy without a smartphone?",\
  "Have you had these phantasies before?",\
  "Does the world seem more real for you via apps?")
  replies(28) = Array(\
  "Tell me more about your family.",\
  "Who else in your family*?",\
  "What does family relations mean for you?",\
  "Come on, How old are you?")
  setupReplies = replies
  RETURN setupReplies
END FUNCTION
