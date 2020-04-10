10 REM Computes the sum and average of the numbers read from a user-specified 
20 REM text file (which might have been created via generateRandomNumberFile(4)). 
30 REM  
40 REM This program is part of an arrangement used to test group code export (issue 
50 REM #828) with FileAPI dependency. 
60 REM The input check loop has been disabled (replaced by a simple unchecked input 
70 REM instruction) in order to test the effect of indirect FileAPI dependency (only the 
80 REM called subroutine directly requires FileAPI now). 
90 REM Generated by Structorizer 3.30-07 
100 
110 REM Copyright (C) 2020-03-21 Kay Gürtzig 
120 REM License: GPLv3-link 
130 REM GNU General Public License (V 3) 
140 REM https://www.gnu.org/licenses/gpl.html 
150 REM http://www.gnu.de/documents/gpl.de.html 
160 
170 REM  
180 REM program ComputeSum
190 REM TODO: add the respective type suffixes to your variable names if required 
200 LET fileNo = 1000
210 REM Disable this if you enable the loop below! 
220 PRINT "Name/path of the number file"; : INPUT file_name
230 REM If you enable this loop, then the preceding input instruction is to be disabled 
240 REM and the fileClose instruction in the alternative below is to be enabled. 
250 REM DO 
260 REM   PRINT "Name/path of the number file"; : INPUT file_name 
270 REM   LET fileNo = fileOpen(file_name) 
280 REM LOOP UNTIL fileNo > 0 OR file_name = "" 
290 IF fileNo > 0 THEN
300   REM This should be enabled if the input check loop above gets enabled. 
310 REM   fileClose(fileNo) 
320   REM TODO: Check indexBase value (automatically generated) 
330   LET indexBase = 0
340   LET nValues = 0
350   ON ERROR GOTO 390
360   LET nValues = readNumbers(file_name, values, 1000)
370   GOTO 420
380   REM Start of error handler, FIXME: variable 'failure' should conatain error info ... 
390     PRINT failure
400     STOP
410   REM End of error handler, resume here ... 
420   ON ERROR GOTO 0
430   LET sum = 0.0
440   FOR k = 0 TO nValues-1
450     LET sum = sum + values(k)
460   NEXT k
470   PRINT "sum = "; sum
480   PRINT "average = "; sum / nValues
490 END IF
500 END
510 REM  
520 REM Tries to read as many integer values as possible upto maxNumbers 
530 REM from file fileName into the given array numbers. 
540 REM Returns the number of the actually read numbers. May cause an exception. 
550 REM TODO: Add type-specific suffixes where necessary! 
560 FUNCTION readNumbers(fileName AS String, numbers AS array of integer, maxNumbers AS integer) AS integer
570   REM TODO: add the respective type suffixes to your variable names if required 
580   LET nNumbers = 0
590   LET fileNo = fileOpen(fileName)
600   IF fileNo <= 0 THEN
610     REM FIXME: Only a number is allowed as parameter: 
620     ERROR "File could not be opened!"
630   END IF
640   ON ERROR GOTO 720
650   DO WHILE NOT fileEOF(fileNo) AND nNumbers < maxNumbers
660     LET number = fileReadInt(fileNo)
670     LET numbers(nNumbers) = number
680     LET nNumbers = nNumbers + 1
690   LOOP
700   GOTO 750
710   REM Start of error handler, FIXME: variable 'error' should conatain error info ... 
720     REM FIXME: Only a number is allowed as parameter: 
730     ERROR 
740   REM End of error handler, resume here ... 
750   ON ERROR GOTO 0
760   fileClose(fileNo)
770   RETURN nNumbers
780 END FUNCTION
