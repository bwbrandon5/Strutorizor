#!/bin/bash

# Creates three equal arrays of numbers and has them sorted with different sorting algorithms 
# to allow performance comparison via execution counting ("Collect Runtime Data" should 
# sensibly be switched on). 
# Requested input data are: Number of elements (size) and filing mode. 
# (generated by Structorizer 3.32-04) 

# Copyright (C) 2019-10-02 Kay Gürtzig 
# License: GPLv3-link 
# GNU General Public License (V 3) 
# https://www.gnu.org/licenses/gpl.html 
# http://www.gnu.de/documents/gpl.de.html 

# Implements the well-known BubbleSort algorithm. 
# Compares neigbouring elements and swaps them in case of an inversion. 
# Repeats this while inversions have been found. After every 
# loop passage at least one element (the largest one out of the 
# processed subrange) finds its final place at the end of the 
# subrange. 
function bubbleSort() {
 declare -n values=$1

 # TODO: Check and revise the syntax of all expressions! 

 local temp
 declare -i posSwapped
 declare -i i
 local ende
 ende=$(( length(${values}) - 2 ))

 # NOTE: Represents a REPEAT UNTIL loop, see conditional break at the end. 
 while :
 do
  # The index of the most recent swapping (-1 means no swapping done). 
  posSwapped=$(( -1 ))

  for (( i=0; i<=${ende}; i++ ))
  do

   if (( ${values[${i}]} > ${values[${i}+1]} ))
   then
    temp=${values[${i}]}
    values[${i}]=$(( ${values[${i}+1]} ))
    values[${i}+1]=${temp}
    posSwapped=${i}
   fi

  done

  ende=$(( ${posSwapped} - 1 ))
  (( ! (${posSwapped} < 0) )) || break
 done

}

# Given a max-heap 'heap´ with element at index 'i´ possibly 
# violating the heap property wrt. its subtree upto and including 
# index range-1, restores heap property in the subtree at index i 
# again. 
function maxHeapify() {
 declare -n heap=$1
 local i=$2
 local range=$3

 # TODO: Check and revise the syntax of all expressions! 

 local temp
 local right
 local max
 local left
 # Indices of left and right child of node i 
 right=$(( (${i}+1) * 2 ))
 left=$(( ${right} - 1 ))
 # Index of the (local) maximum 
 max=${i}

 if [[ ${left} < ${range} && ${heap[${left}]} > ${heap[${i}]} ]]
 then
  max=${left}
 fi

 if [[ ${right} < ${range} && ${heap[${right}]} > ${heap[${max}]} ]]
 then
  max=${right}
 fi

 if [[ ${max} != ${i} ]]
 then
  temp=${heap[${i}]}
  heap[${i}]=${heap[${max}]}
  heap[${max}]=${temp}
  maxHeapify heap "${max}" "${range}"
 fi

}

# Partitions array 'values´ between indices 'start´ und 'stop´-1 with 
# respect to the pivot element initially at index 'p´ into smaller 
# and greater elements. 
# Returns the new (and final) index of the pivot element (which 
# separates the sequence of smaller elements from the sequence 
# of greater elements). 
# This is not the most efficient algorithm (about half the swapping 
# might still be avoided) but it is pretty clear. 
function partition() {
 declare -n values=$1
 local start=$2
 local stop=$3
 local p=$4

 # TODO: Check and revise the syntax of all expressions! 

 local seen
 local pivot
 # Cache the pivot element 
 pivot=${values[${p}]}
 # Exchange the pivot element with the start element 
 values[${p}]=${values[${start}]}
 values[${start}]=${pivot}
 p=${start}
 # Beginning and end of the remaining undiscovered range 
 start=$(( ${start} + 1 ))
 stop=$(( ${stop} - 1 ))

 # Still unseen elements? 
 # Loop invariants: 
 # 1. p = start - 1 
 # 2. pivot = values[p] 
 # 3. i < start → values[i] ≤ pivot 
 # 4. stop < i → pivot < values[i] 
 while [[ ${start} <= ${stop} ]]
 do
  # Fetch the first element of the undiscovered area 
  seen=${values[${start}]}

  # Does the checked element belong to the smaller area? 
  if [[ ${seen} <= ${pivot} ]]
  then
   # Insert the seen element between smaller area and pivot element 
   values[${p}]=${seen}
   values[${start}]=${pivot}
   # Shift the border between lower and undicovered area, 
   # update pivot position. 
   p=$(( ${p} + 1 ))
   start=$(( ${start} + 1 ))

  else
   # Insert the checked element between undiscovered and larger area 
   values[${start}]=${values[${stop}]}
   values[${stop}]=${seen}
   # Shift the border between undiscovered and larger area 
   stop=$(( ${stop} - 1 ))
  fi

 done

 result10737218=${p}
}

# Checks whether or not the passed-in array is (ascendingly) sorted. 
function testSorted() {
 local numbers=$1

 # TODO: Check and revise the syntax of all expressions! 

 local isSorted
 declare -i i
 isSorted=1
 i=0

 # As we compare with the following element, we must stop at the penultimate index 
 while (( ${isSorted} && (${i} <= length(${numbers})-2) ))
 do

  # Is there an inversion? 
  if (( ${numbers[${i}]} > ${numbers[${i}+1]} ))
  then
   isSorted=0

  else
   i=$(( ${i} + 1 ))
  fi

 done

 result439d0beb=${isSorted}
}

# Runs through the array heap and converts it to a max-heap 
# in a bottom-up manner, i.e. starts above the "leaf" level 
# (index >= length(heap) div 2) and goes then up towards 
# the root. 
function buildMaxHeap() {
 local heap=$1

 # TODO: Check and revise the syntax of all expressions! 

 declare -i lgth
 declare -i k
 lgth=$( length "${heap}" )

 for (( k=(( ${lgth} / 2 - 1 )); k>=0; k-- ))
 do
  maxHeapify "${heap}" "${k}" "${lgth}"
 done

}

# Recursively sorts a subrange of the given array 'values´.  
# start is the first index of the subsequence to be sorted, 
# stop is the index BEHIND the subsequence to be sorted. 
function quickSort() {
 local values=$1
 local start=$2
 local stop=$3

 # TODO: Check and revise the syntax of all expressions! 

 local p

 # At least 2 elements? (Less don't make sense.) 
 if (( ${stop} >= ${start} + 2 ))
 then
  # Select a pivot element, be p its index. 
  # (here: randomly chosen element out of start ... stop-1) 
  p=$(( random(${stop}-${start}) + ${start} ))
  # Partition the array into smaller and greater elements 
  # Get the resulting (and final) position of the pivot element 
  partition "${values}" "${start}" "${stop}" "${p}"
  p=${result10737218}
  # Sort subsequances separately and independently ... 
  # ========================================================== 
  # ================= START PARALLEL SECTION ================= 
  # ========================================================== 
  pids1151c3b=""
  (
   # Sort left (lower) array part 
   quickSort "${values}" "${start}" "${p}"
  ) &
  pids1151c3b="${pids1151c3b} $!"
  (
   # Sort right (higher) array part 
   quickSort "${values}" $(( ${p}+1 )) "${stop}"
  ) &
  pids1151c3b="${pids1151c3b} $!"
  wait ${pids1151c3b}
  # ========================================================== 
  # ================== END PARALLEL SECTION ================== 
  # ========================================================== 
 fi

}

# Sorts the array 'values´ of numbers according to he heap sort 
# algorithm 
function heapSort() {
 declare -n values=$1

 # TODO: Check and revise the syntax of all expressions! 

 local maximum
 declare -i k
 declare -i heapRange
 buildMaxHeap values
 heapRange=$( length values )

 for (( k=(( ${heapRange} - 1 )); k>=1; k-- ))
 do
  heapRange=$(( ${heapRange} - 1 ))
  # Swap the maximum value (root of the heap) to the heap end 
  maximum=${values[0]}
  values[0]=${values[${heapRange}]}
  values[${heapRange}]=${maximum}
  maxHeapify values 0 "${heapRange}"
 done

}
# TODO: Check and revise the syntax of all expressions! 

# NOTE: Represents a REPEAT UNTIL loop, see conditional break at the end. 
while :
do
 read elementCount
 (( ! (${elementCount} >= 1) )) || break
done

# NOTE: Represents a REPEAT UNTIL loop, see conditional break at the end. 
while :
do
 echo -n "Filling: 1 = random, 2 = increasing, 3 = decreasing" ; read modus
 [[ ! (${modus} == 1 || ${modus} == 2 || ${modus} == 3) ]] || break
done

for (( i=0; i<=(( ${elementCount}-1 )); i++ ))
do

 case ${modus} in

  1)
    values1[${i}]=$( random 10000 )
  ;;

  2)
    values1[${i}]=${i}
  ;;

  3)
    values1[${i}]=$(( -${i} ))
  ;;
 esac

done

# Copy the array for exact comparability 
for (( i=0; i<=(( ${elementCount}-1 )); i++ ))
do
 values2[${i}]=${values1[${i}]}
 values3[${i}]=${values1[${i}]}
done

# ========================================================== 
# ================= START PARALLEL SECTION ================= 
# ========================================================== 
pids1b4c8697=""
(
 bubbleSort values1
) &
pids1b4c8697="${pids1b4c8697} $!"
(
 quickSort values2 0 "${elementCount}"
) &
pids1b4c8697="${pids1b4c8697} $!"
(
 heapSort values3
) &
pids1b4c8697="${pids1b4c8697} $!"
wait ${pids1b4c8697}
# ========================================================== 
# ================== END PARALLEL SECTION ================== 
# ========================================================== 
testSorted values1
ok1=${result439d0beb}
testSorted values2
ok2=${result439d0beb}
testSorted values3
ok3=${result439d0beb}

if [[ ! ${ok1} || ! ${ok2} || ! ${ok3} ]]
then

 for (( i=0; i<=(( ${elementCount}-1 )); i++ ))
 do

  if [[ ${values1[${i}]} != ${values2[${i}]} || ${values1[${i}]} != ${values3[${i}]} ]]
  then
   echo "Difference at [" ${i} "]: " ${values1[${i}]} " <-> " ${values2[${i}]} " <-> " ${values3[${i}]}
  fi

 done

fi

# NOTE: Represents a REPEAT UNTIL loop, see conditional break at the end. 
while :
do
 echo -n "Show arrays (yes/no)?" ; read show
 [[ ! (${show} == "yes" || ${show} == "no") ]] || break
done

if [[ ${show} == "yes" ]]
then

 for (( i=0; i<=(( ${elementCount} - 1 )); i++ ))
 do
  echo "[" ${i} "]:\t" ${values1[${i}]} "\t" ${values2[${i}]} "\t" ${values3[${i}]}
 done

fi
