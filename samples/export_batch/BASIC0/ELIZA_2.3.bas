10 REM Concept and lisp implementation published by Joseph Weizenbaum (MIT): 
20 REM "ELIZA - A Computer Program For the Study of Natural Language Communication Between Man and Machine" - In: 
30 REM Computational Linguistis 1(1966)9, pp. 36-45 
40 REM Revision history: 
50 REM 2016-10-06 Initial version 
60 REM 2017-03-29 Two diagrams updated (comments translated to English) 
70 REM 2017-03-29 More keywords and replies added 
80 REM 2019-03-14 Replies and mapping reorganised for easier maintenance 
90 REM 2019-03-15 key map joined from keyword array and index map 
100 REM 2019-03-28 Keyword "bot" inserted (same reply ring as "computer") 
110 REM 2019-11-28 New global type "History" (to ensure a homogenous array) 
120 REM Generated by Structorizer 3.30-11 
130 
140 REM Copyright (C) 2018-05-14 Kay Gürtzig 
150 REM License: GPLv3-link 
160 REM GNU General Public License (V 3) 
170 REM https://www.gnu.org/licenses/gpl.html 
180 REM http://www.gnu.de/documents/gpl.de.html 
190 
200 REM  
210 REM program ELIZA
220 REM TODO: add the respective type suffixes to your variable names if required 
230 REM Title information 
240 PRINT "************* ELIZA **************"
250 PRINT "* Original design by J. Weizenbaum"
260 PRINT "**********************************"
270 PRINT "* Adapted for Basic on IBM PC by"
280 PRINT "* - Patricia Danielson"
290 PRINT "* - Paul Hashfield"
300 PRINT "**********************************"
310 PRINT "* Adapted for Structorizer by"
320 PRINT "* - Kay Gürtzig / FH Erfurt 2016"
330 PRINT "* Version: 2.3 (2020-02-24)"
340 PRINT "* (Requires at least Structorizer 3.30-03 to run)"
350 PRINT "**********************************"
360 REM Stores the last five inputs of the user in a ring buffer, 
370 REM the second component is the rolling (over-)write index. 
380 DIM history AS History
390 LET history.histArray = {"", "", "", "", ""}
400 LET history.histIndex = 0
410 LET replies = setupReplies()
420 LET reflexions = setupReflexions()
430 LET byePhrases = setupGoodByePhrases()
440 LET keyMap = setupKeywords()
450 LET offsets(length(keyMap)-1) = 0
460 LET isGone = false
470 REM Starter 
480 PRINT "Hi! I\'m your new therapist. My name is Eliza. What\'s your problem?"
490 DO
500   INPUT userInput
510   REM Converts the input to lowercase, cuts out interpunctation 
520   REM and pads the string 
530   LET userInput = normalizeInput(userInput)
540   LET isGone = checkGoodBye(userInput, byePhrases)
550   IF NOT isGone THEN
560     LET reply = "Please don\'t repeat yourself!"
570     LET isRepeated = checkRepetition(history, userInput)
580     IF NOT isRepeated THEN
590       LET findInfo = findKeyword(keyMap, userInput)
600       LET keyIndex = findInfo(0)
610       IF keyIndex < 0 THEN
620         REM Should never happen... 
630         LET keyIndex = length(keyMap)-1
640       END IF
650       LET var entry: KeyMapEntry = keyMap(keyIndex)
660       REM Variable part of the reply 
670       LET varPart = ""
680       IF length(entry.keyword) > 0 THEN
690         LET varPart = conjugateStrings(userInput, entry.keyword, findInfo(1), reflexions)
700       END IF
710       LET replyRing = replies(entry.index)
720       LET reply = replyRing(offsets(keyIndex))
730       LET offsets(keyIndex) = (offsets(keyIndex) + 1) % length(replyRing)
740       LET posAster = pos("*", reply)
750       IF posAster > 0 THEN
760         IF varPart = " " THEN
770           LET reply = "You will have to elaborate more for me to help you."
780         ELSE
790           delete(reply, posAster, 1)
800           insert(varPart, reply, posAster)
810         END IF
820       END IF
830       LET reply = adjustSpelling(reply)
840     END IF
850     PRINT reply
860   END IF
870 LOOP UNTIL isGone
880 END
890 REM  
900 REM Cares for correct letter case among others 
910 REM TODO: Add type-specific suffixes where necessary! 
920 FUNCTION adjustSpelling(sentence AS String) AS String
930   REM TODO: add the respective type suffixes to your variable names if required 
940   LET result = sentence
950   LET position = 1
960   DO WHILE (position <= length(sentence)) AND (copy(sentence, position, 1) = " ")
970     LET position = position + 1
980   LOOP
990   IF position <= length(sentence) THEN
1000     LET start = copy(sentence, 1, position)
1010     delete(result, 1, position)
1020     insert(uppercase(start), result, 1)
1030   END IF
1040   DIM array6eee1d24() AS String = {" i ", " i\'"}
1050   FOR EACH word IN array6eee1d24
1060     LET position = pos(word, result)
1070     DO WHILE position > 0
1080       delete(result, position+1, 1)
1090       insert("I", result, position+1)
1100       LET position = pos(word, result)
1110     LOOP
1120   NEXT word
1130   RETURN result
1140 END FUNCTION
1150 REM  
1160 REM Checks whether the given text contains some kind of 
1170 REM good-bye phrase inducing the end of the conversation 
1180 REM and if so writes a correspding good-bye message and 
1190 REM returns true, otherwise false 
1200 REM TODO: Add type-specific suffixes where necessary! 
1210 FUNCTION checkGoodBye(text AS String, phrases AS array of array[0..1] of string) AS boolean
1220   REM TODO: add the respective type suffixes to your variable names if required 
1230   FOR EACH pair IN phrases
1240     IF pos(pair(0), text) > 0 THEN
1250       PRINT pair(1)
1260       RETURN true
1270     END IF
1280   NEXT pair
1290   return false
1300 END FUNCTION
1310 REM  
1320 REM Checks whether newInput has occurred among the recently cached 
1330 REM input strings in the histArray component of history and updates the history. 
1340 REM TODO: Add type-specific suffixes where necessary! 
1350 FUNCTION checkRepetition(history AS History, newInput AS String) AS boolean
1360   REM TODO: add the respective type suffixes to your variable names if required 
1370   LET hasOccurred = false
1380   IF length(newInput) > 4 THEN
1390     LET histDepth = length(history.histArray)
1400     FOR i = 0 TO histDepth-1
1410       IF newInput = history.histArray(i) THEN
1420         LET hasOccurred = true
1430       END IF
1440     NEXT i
1450     LET history.histArray(history.histIndex) = newInput
1460     LET history.histIndex = (history.histIndex + 1) % (histDepth)
1470   END IF
1480   return hasOccurred
1490 END FUNCTION
1500 REM  
1510 REM TODO: Add type-specific suffixes where necessary! 
1520 FUNCTION conjugateStrings(sentence AS String, key AS String, keyPos AS integer, flexions AS array of array[0..1] of string) AS String
1530   REM TODO: add the respective type suffixes to your variable names if required 
1540   LET result = " " + copy(sentence, keyPos + length(key), length(sentence)) + " "
1550   FOR EACH pair IN flexions
1560     LET left = ""
1570     LET right = result
1580     LET position = pos(pair(0), right)
1590     DO WHILE position > 0
1600       LET left = left + copy(right, 1, position-1) + pair(1)
1610       LET right = copy(right, position + length(pair(0)), length(right))
1620       LET position = pos(pair(0), right)
1630     LOOP
1640     LET result = left + right
1650   NEXT pair
1660   REM Eliminate multiple spaces 
1670   LET position = pos("  ", result)
1680   DO WHILE position > 0
1690     LET result = copy(result, 1, position-1) + copy(result, position+1, length(result))
1700     LET position = pos("  ", result)
1710   LOOP
1720   RETURN result
1730 END FUNCTION
1740 REM  
1750 REM Looks for the occurrence of the first of the strings 
1760 REM contained in keywords within the given sentence (in 
1770 REM array order). 
1780 REM Returns an array of 
1790 REM 0: the index of the first identified keyword (if any, otherwise -1), 
1800 REM 1: the position inside sentence (0 if not found) 
1810 REM TODO: Add type-specific suffixes where necessary! 
1820 FUNCTION findKeyword(keyMap AS const array of KeyMapEntry, sentence AS String) AS array[0..1] of integer
1830   REM TODO: add the respective type suffixes to your variable names if required 
1840   REM Contains the index of the keyword and its position in sentence 
1850   REM TODO: Check indexBase value (automatically generated) 
1860   LET indexBase = 0
1870   LET result(indexBase + 0) = -1
1880   LET result(indexBase + 1) = 0
1890   LET i = 0
1900   DO WHILE (result(0) < 0) AND (i < length(keyMap))
1910     LET var entry: KeyMapEntry = keyMap(i)
1920     LET position = pos(entry.keyword, sentence)
1930     IF position > 0 THEN
1940       LET result(0) = i
1950       LET result(1) = position
1960     END IF
1970     LET i = i+1
1980   LOOP
1990   RETURN result
2000 END FUNCTION
2010 REM  
2020 REM Converts the sentence to lowercase, eliminates all 
2030 REM interpunction (i.e. ',', '.', ';'), and pads the 
2040 REM sentence among blanks 
2050 REM TODO: Add type-specific suffixes where necessary! 
2060 FUNCTION normalizeInput(sentence AS String) AS String
2070   REM TODO: add the respective type suffixes to your variable names if required 
2080   LET sentence = lowercase(sentence)
2090   REM TODO: Specify an appropriate element type for the array! 
2100   DIM array6692672a() AS FIXME_6692672a = {'.', ',', ';', '!', '?'}
2110   FOR EACH symbol IN array6692672a
2120     LET position = pos(symbol, sentence)
2130     DO WHILE position > 0
2140       LET sentence = copy(sentence, 1, position-1) + copy(sentence, position+1, length(sentence))
2150       LET position = pos(symbol, sentence)
2160     LOOP
2170   NEXT symbol
2180   LET result = " " + sentence + " "
2190   RETURN result
2200 END FUNCTION
2210 REM  
2220 REM TODO: Add type-specific suffixes where necessary! 
2230 FUNCTION setupGoodByePhrases() AS array of array[0..1] of string
2240   REM TODO: add the respective type suffixes to your variable names if required 
2250   REM TODO: Check indexBase value (automatically generated) 
2260   LET indexBase = 0
2270   LET phrases(0)(indexBase + 0) = " shut"
2280   LET phrases(0)(indexBase + 1) = "Okay. If you feel that way I\'ll shut up. ... Your choice."
2290   REM TODO: Check indexBase value (automatically generated) 
2300   LET indexBase = 0
2310   LET phrases(1)(indexBase + 0) = "bye"
2320   LET phrases(1)(indexBase + 1) = "Well, let\'s end our talk for now. See you later. Bye."
2330   return phrases
2340 END FUNCTION
2350 REM  
2360 REM The lower the index the higher the rank of the keyword (search is sequential). 
2370 REM The index of the first keyword found in a user sentence maps to a respective 
2380 REM reply ring as defined in `setupReplies()´. 
2390 REM TODO: Add type-specific suffixes where necessary! 
2400 FUNCTION setupKeywords() AS array of KeyMapEntry
2410   REM TODO: add the respective type suffixes to your variable names if required 
2420   REM The empty key string (last entry) is the default clause - will always be found 
2430   LET keywords(39).keyword = ""
2440   LET keywords(39).index = 29
2450   LET keywords(0).keyword = "can you "
2460   LET keywords(0).index = 0
2470   LET keywords(1).keyword = "can i "
2480   LET keywords(1).index = 1
2490   LET keywords(2).keyword = "you are "
2500   LET keywords(2).index = 2
2510   LET keywords(3).keyword = "you\'re "
2520   LET keywords(3).index = 2
2530   LET keywords(4).keyword = "i don't "
2540   LET keywords(4).index = 3
2550   LET keywords(5).keyword = "i feel "
2560   LET keywords(5).index = 4
2570   LET keywords(6).keyword = "why don\'t you "
2580   LET keywords(6).index = 5
2590   LET keywords(7).keyword = "why can\'t i "
2600   LET keywords(7).index = 6
2610   LET keywords(8).keyword = "are you "
2620   LET keywords(8).index = 7
2630   LET keywords(9).keyword = "i can\'t "
2640   LET keywords(9).index = 8
2650   LET keywords(10).keyword = "i am "
2660   LET keywords(10).index = 9
2670   LET keywords(11).keyword = "i\'m "
2680   LET keywords(11).index = 9
2690   LET keywords(12).keyword = "you "
2700   LET keywords(12).index = 10
2710   LET keywords(13).keyword = "i want "
2720   LET keywords(13).index = 11
2730   LET keywords(14).keyword = "what "
2740   LET keywords(14).index = 12
2750   LET keywords(15).keyword = "how "
2760   LET keywords(15).index = 12
2770   LET keywords(16).keyword = "who "
2780   LET keywords(16).index = 12
2790   LET keywords(17).keyword = "where "
2800   LET keywords(17).index = 12
2810   LET keywords(18).keyword = "when "
2820   LET keywords(18).index = 12
2830   LET keywords(19).keyword = "why "
2840   LET keywords(19).index = 12
2850   LET keywords(20).keyword = "name "
2860   LET keywords(20).index = 13
2870   LET keywords(21).keyword = "cause "
2880   LET keywords(21).index = 14
2890   LET keywords(22).keyword = "sorry "
2900   LET keywords(22).index = 15
2910   LET keywords(23).keyword = "dream "
2920   LET keywords(23).index = 16
2930   LET keywords(24).keyword = "hello "
2940   LET keywords(24).index = 17
2950   LET keywords(25).keyword = "hi "
2960   LET keywords(25).index = 17
2970   LET keywords(26).keyword = "maybe "
2980   LET keywords(26).index = 18
2990   LET keywords(27).keyword = " no"
3000   LET keywords(27).index = 19
3010   LET keywords(28).keyword = "your "
3020   LET keywords(28).index = 20
3030   LET keywords(29).keyword = "always "
3040   LET keywords(29).index = 21
3050   LET keywords(30).keyword = "think "
3060   LET keywords(30).index = 22
3070   LET keywords(31).keyword = "alike "
3080   LET keywords(31).index = 23
3090   LET keywords(32).keyword = "yes "
3100   LET keywords(32).index = 24
3110   LET keywords(33).keyword = "friend "
3120   LET keywords(33).index = 25
3130   LET keywords(34).keyword = "computer"
3140   LET keywords(34).index = 26
3150   LET keywords(35).keyword = "bot "
3160   LET keywords(35).index = 26
3170   LET keywords(36).keyword = "smartphone"
3180   LET keywords(36).index = 27
3190   LET keywords(37).keyword = "father "
3200   LET keywords(37).index = 28
3210   LET keywords(38).keyword = "mother "
3220   LET keywords(38).index = 28
3230   return keywords
3240 END FUNCTION
3250 REM  
3260 REM Returns an array of pairs of mutualy substitutable  
3270 REM TODO: Add type-specific suffixes where necessary! 
3280 FUNCTION setupReflexions() AS array of array[0..1] of string
3290   REM TODO: add the respective type suffixes to your variable names if required 
3300   REM TODO: Check indexBase value (automatically generated) 
3310   LET indexBase = 0
3320   LET reflexions(0)(indexBase + 0) = " are "
3330   LET reflexions(0)(indexBase + 1) = " am "
3340   REM TODO: Check indexBase value (automatically generated) 
3350   LET indexBase = 0
3360   LET reflexions(1)(indexBase + 0) = " were "
3370   LET reflexions(1)(indexBase + 1) = " was "
3380   REM TODO: Check indexBase value (automatically generated) 
3390   LET indexBase = 0
3400   LET reflexions(2)(indexBase + 0) = " you "
3410   LET reflexions(2)(indexBase + 1) = " I "
3420   REM TODO: Check indexBase value (automatically generated) 
3430   LET indexBase = 0
3440   LET reflexions(3)(indexBase + 0) = " your"
3450   LET reflexions(3)(indexBase + 1) = " my"
3460   REM TODO: Check indexBase value (automatically generated) 
3470   LET indexBase = 0
3480   LET reflexions(4)(indexBase + 0) = " i\'ve "
3490   LET reflexions(4)(indexBase + 1) = " you\'ve "
3500   REM TODO: Check indexBase value (automatically generated) 
3510   LET indexBase = 0
3520   LET reflexions(5)(indexBase + 0) = " i\'m "
3530   LET reflexions(5)(indexBase + 1) = " you\'re "
3540   REM TODO: Check indexBase value (automatically generated) 
3550   LET indexBase = 0
3560   LET reflexions(6)(indexBase + 0) = " me "
3570   LET reflexions(6)(indexBase + 1) = " you "
3580   REM TODO: Check indexBase value (automatically generated) 
3590   LET indexBase = 0
3600   LET reflexions(7)(indexBase + 0) = " my "
3610   LET reflexions(7)(indexBase + 1) = " your "
3620   REM TODO: Check indexBase value (automatically generated) 
3630   LET indexBase = 0
3640   LET reflexions(8)(indexBase + 0) = " i "
3650   LET reflexions(8)(indexBase + 1) = " you "
3660   REM TODO: Check indexBase value (automatically generated) 
3670   LET indexBase = 0
3680   LET reflexions(9)(indexBase + 0) = " am "
3690   LET reflexions(9)(indexBase + 1) = " are "
3700   return reflexions
3710 END FUNCTION
3720 REM  
3730 REM This routine sets up the reply rings addressed by the key words defined in 
3740 REM routine `setupKeywords()´ and mapped hitherto by the cross table defined 
3750 REM in `setupMapping()´ 
3760 REM TODO: Add type-specific suffixes where necessary! 
3770 FUNCTION setupReplies() AS array of array of string
3780   REM TODO: add the respective type suffixes to your variable names if required 
3790   var replies: array of array of String
3800   REM We start with the highest index for performance reasons 
3810   REM (is to avoid frequent array resizing) 
3820   REM TODO: Check indexBase value (automatically generated) 
3830   LET indexBase = 0
3840   LET replies(29)(indexBase + 0) = "Say, do you have any psychological problems?"
3850   LET replies(29)(indexBase + 1) = "What does that suggest to you?"
3860   LET replies(29)(indexBase + 2) = "I see."
3870   LET replies(29)(indexBase + 3) = "I'm not sure I understand you fully."
3880   LET replies(29)(indexBase + 4) = "Come come elucidate your thoughts."
3890   LET replies(29)(indexBase + 5) = "Can you elaborate on that?"
3900   LET replies(29)(indexBase + 6) = "That is quite interesting."
3910   REM TODO: Check indexBase value (automatically generated) 
3920   LET indexBase = 0
3930   LET replies(0)(indexBase + 0) = "Don't you believe that I can*?"
3940   LET replies(0)(indexBase + 1) = "Perhaps you would like to be like me?"
3950   LET replies(0)(indexBase + 2) = "You want me to be able to*?"
3960   REM TODO: Check indexBase value (automatically generated) 
3970   LET indexBase = 0
3980   LET replies(1)(indexBase + 0) = "Perhaps you don't want to*?"
3990   LET replies(1)(indexBase + 1) = "Do you want to be able to*?"
4000   REM TODO: Check indexBase value (automatically generated) 
4010   LET indexBase = 0
4020   LET replies(2)(indexBase + 0) = "What makes you think I am*?"
4030   LET replies(2)(indexBase + 1) = "Does it please you to believe I am*?"
4040   LET replies(2)(indexBase + 2) = "Perhaps you would like to be*?"
4050   LET replies(2)(indexBase + 3) = "Do you sometimes wish you were*?"
4060   REM TODO: Check indexBase value (automatically generated) 
4070   LET indexBase = 0
4080   LET replies(3)(indexBase + 0) = "Don't you really*?"
4090   LET replies(3)(indexBase + 1) = "Why don't you*?"
4100   LET replies(3)(indexBase + 2) = "Do you wish to be able to*?"
4110   LET replies(3)(indexBase + 3) = "Does that trouble you*?"
4120   REM TODO: Check indexBase value (automatically generated) 
4130   LET indexBase = 0
4140   LET replies(4)(indexBase + 0) = "Do you often feel*?"
4150   LET replies(4)(indexBase + 1) = "Are you afraid of feeling*?"
4160   LET replies(4)(indexBase + 2) = "Do you enjoy feeling*?"
4170   REM TODO: Check indexBase value (automatically generated) 
4180   LET indexBase = 0
4190   LET replies(5)(indexBase + 0) = "Do you really believe I don't*?"
4200   LET replies(5)(indexBase + 1) = "Perhaps in good time I will*."
4210   LET replies(5)(indexBase + 2) = "Do you want me to*?"
4220   REM TODO: Check indexBase value (automatically generated) 
4230   LET indexBase = 0
4240   LET replies(6)(indexBase + 0) = "Do you think you should be able to*?"
4250   LET replies(6)(indexBase + 1) = "Why can't you*?"
4260   REM TODO: Check indexBase value (automatically generated) 
4270   LET indexBase = 0
4280   LET replies(7)(indexBase + 0) = "Why are you interested in whether or not I am*?"
4290   LET replies(7)(indexBase + 1) = "Would you prefer if I were not*?"
4300   LET replies(7)(indexBase + 2) = "Perhaps in your fantasies I am*?"
4310   REM TODO: Check indexBase value (automatically generated) 
4320   LET indexBase = 0
4330   LET replies(8)(indexBase + 0) = "How do you know you can't*?"
4340   LET replies(8)(indexBase + 1) = "Have you tried?"
4350   LET replies(8)(indexBase + 2) = "Perhaps you can now*."
4360   REM TODO: Check indexBase value (automatically generated) 
4370   LET indexBase = 0
4380   LET replies(9)(indexBase + 0) = "Did you come to me because you are*?"
4390   LET replies(9)(indexBase + 1) = "How long have you been*?"
4400   LET replies(9)(indexBase + 2) = "Do you believe it is normal to be*?"
4410   LET replies(9)(indexBase + 3) = "Do you enjoy being*?"
4420   REM TODO: Check indexBase value (automatically generated) 
4430   LET indexBase = 0
4440   LET replies(10)(indexBase + 0) = "We were discussing you--not me."
4450   LET replies(10)(indexBase + 1) = "Oh, I*."
4460   LET replies(10)(indexBase + 2) = "You're not really talking about me, are you?"
4470   REM TODO: Check indexBase value (automatically generated) 
4480   LET indexBase = 0
4490   LET replies(11)(indexBase + 0) = "What would it mean to you if you got*?"
4500   LET replies(11)(indexBase + 1) = "Why do you want*?"
4510   LET replies(11)(indexBase + 2) = "Suppose you soon got*..."
4520   LET replies(11)(indexBase + 3) = "What if you never got*?"
4530   LET replies(11)(indexBase + 4) = "I sometimes also want*."
4540   REM TODO: Check indexBase value (automatically generated) 
4550   LET indexBase = 0
4560   LET replies(12)(indexBase + 0) = "Why do you ask?"
4570   LET replies(12)(indexBase + 1) = "Does that question interest you?"
4580   LET replies(12)(indexBase + 2) = "What answer would please you the most?"
4590   LET replies(12)(indexBase + 3) = "What do you think?"
4600   LET replies(12)(indexBase + 4) = "Are such questions on your mind often?"
4610   LET replies(12)(indexBase + 5) = "What is it that you really want to know?"
4620   LET replies(12)(indexBase + 6) = "Have you asked anyone else?"
4630   LET replies(12)(indexBase + 7) = "Have you asked such questions before?"
4640   LET replies(12)(indexBase + 8) = "What else comes to mind when you ask that?"
4650   REM TODO: Check indexBase value (automatically generated) 
4660   LET indexBase = 0
4670   LET replies(13)(indexBase + 0) = "Names don't interest me."
4680   LET replies(13)(indexBase + 1) = "I don't care about names -- please go on."
4690   REM TODO: Check indexBase value (automatically generated) 
4700   LET indexBase = 0
4710   LET replies(14)(indexBase + 0) = "Is that the real reason?"
4720   LET replies(14)(indexBase + 1) = "Don't any other reasons come to mind?"
4730   LET replies(14)(indexBase + 2) = "Does that reason explain anything else?"
4740   LET replies(14)(indexBase + 3) = "What other reasons might there be?"
4750   REM TODO: Check indexBase value (automatically generated) 
4760   LET indexBase = 0
4770   LET replies(15)(indexBase + 0) = "Please don't apologize!"
4780   LET replies(15)(indexBase + 1) = "Apologies are not necessary."
4790   LET replies(15)(indexBase + 2) = "What feelings do you have when you apologize?"
4800   LET replies(15)(indexBase + 3) = "Don't be so defensive!"
4810   REM TODO: Check indexBase value (automatically generated) 
4820   LET indexBase = 0
4830   LET replies(16)(indexBase + 0) = "What does that dream suggest to you?"
4840   LET replies(16)(indexBase + 1) = "Do you dream often?"
4850   LET replies(16)(indexBase + 2) = "What persons appear in your dreams?"
4860   LET replies(16)(indexBase + 3) = "Are you disturbed by your dreams?"
4870   REM TODO: Check indexBase value (automatically generated) 
4880   LET indexBase = 0
4890   LET replies(17)(indexBase + 0) = "How do you do ...please state your problem."
4900   REM TODO: Check indexBase value (automatically generated) 
4910   LET indexBase = 0
4920   LET replies(18)(indexBase + 0) = "You don't seem quite certain."
4930   LET replies(18)(indexBase + 1) = "Why the uncertain tone?"
4940   LET replies(18)(indexBase + 2) = "Can't you be more positive?"
4950   LET replies(18)(indexBase + 3) = "You aren't sure?"
4960   LET replies(18)(indexBase + 4) = "Don't you know?"
4970   REM TODO: Check indexBase value (automatically generated) 
4980   LET indexBase = 0
4990   LET replies(19)(indexBase + 0) = "Are you saying no just to be negative?"
5000   LET replies(19)(indexBase + 1) = "You are being a bit negative."
5010   LET replies(19)(indexBase + 2) = "Why not?"
5020   LET replies(19)(indexBase + 3) = "Are you sure?"
5030   LET replies(19)(indexBase + 4) = "Why no?"
5040   REM TODO: Check indexBase value (automatically generated) 
5050   LET indexBase = 0
5060   LET replies(20)(indexBase + 0) = "Why are you concerned about my*?"
5070   LET replies(20)(indexBase + 1) = "What about your own*?"
5080   REM TODO: Check indexBase value (automatically generated) 
5090   LET indexBase = 0
5100   LET replies(21)(indexBase + 0) = "Can you think of a specific example?"
5110   LET replies(21)(indexBase + 1) = "When?"
5120   LET replies(21)(indexBase + 2) = "What are you thinking of?"
5130   LET replies(21)(indexBase + 3) = "Really, always?"
5140   REM TODO: Check indexBase value (automatically generated) 
5150   LET indexBase = 0
5160   LET replies(22)(indexBase + 0) = "Do you really think so?"
5170   LET replies(22)(indexBase + 1) = "But you are not sure you*?"
5180   LET replies(22)(indexBase + 2) = "Do you doubt you*?"
5190   REM TODO: Check indexBase value (automatically generated) 
5200   LET indexBase = 0
5210   LET replies(23)(indexBase + 0) = "In what way?"
5220   LET replies(23)(indexBase + 1) = "What resemblance do you see?"
5230   LET replies(23)(indexBase + 2) = "What does the similarity suggest to you?"
5240   LET replies(23)(indexBase + 3) = "What other connections do you see?"
5250   LET replies(23)(indexBase + 4) = "Could there really be some connection?"
5260   LET replies(23)(indexBase + 5) = "How?"
5270   LET replies(23)(indexBase + 6) = "You seem quite positive."
5280   REM TODO: Check indexBase value (automatically generated) 
5290   LET indexBase = 0
5300   LET replies(24)(indexBase + 0) = "Are you sure?"
5310   LET replies(24)(indexBase + 1) = "I see."
5320   LET replies(24)(indexBase + 2) = "I understand."
5330   REM TODO: Check indexBase value (automatically generated) 
5340   LET indexBase = 0
5350   LET replies(25)(indexBase + 0) = "Why do you bring up the topic of friends?"
5360   LET replies(25)(indexBase + 1) = "Do your friends worry you?"
5370   LET replies(25)(indexBase + 2) = "Do your friends pick on you?"
5380   LET replies(25)(indexBase + 3) = "Are you sure you have any friends?"
5390   LET replies(25)(indexBase + 4) = "Do you impose on your friends?"
5400   LET replies(25)(indexBase + 5) = "Perhaps your love for friends worries you."
5410   REM TODO: Check indexBase value (automatically generated) 
5420   LET indexBase = 0
5430   LET replies(26)(indexBase + 0) = "Do computers worry you?"
5440   LET replies(26)(indexBase + 1) = "Are you talking about me in particular?"
5450   LET replies(26)(indexBase + 2) = "Are you frightened by machines?"
5460   LET replies(26)(indexBase + 3) = "Why do you mention computers?"
5470   LET replies(26)(indexBase + 4) = "What do you think machines have to do with your problem?"
5480   LET replies(26)(indexBase + 5) = "Don't you think computers can help people?"
5490   LET replies(26)(indexBase + 6) = "What is it about machines that worries you?"
5500   REM TODO: Check indexBase value (automatically generated) 
5510   LET indexBase = 0
5520   LET replies(27)(indexBase + 0) = "Do you sometimes feel uneasy without a smartphone?"
5530   LET replies(27)(indexBase + 1) = "Have you had these phantasies before?"
5540   LET replies(27)(indexBase + 2) = "Does the world seem more real for you via apps?"
5550   REM TODO: Check indexBase value (automatically generated) 
5560   LET indexBase = 0
5570   LET replies(28)(indexBase + 0) = "Tell me more about your family."
5580   LET replies(28)(indexBase + 1) = "Who else in your family*?"
5590   LET replies(28)(indexBase + 2) = "What does family relations mean for you?"
5600   LET replies(28)(indexBase + 3) = "Come on, How old are you?"
5610   LET setupReplies = replies
5620   RETURN setupReplies
5630 END FUNCTION

REM = = = = 8< = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
