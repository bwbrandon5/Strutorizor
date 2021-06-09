// Generated by Structorizer 3.31-04 

// Copyright (C) 2019-10-02 Kay Gürtzig 
// License: GPLv3-link 
// GNU General Public License (V 3) 
// https://www.gnu.org/licenses/gpl.html 
// http://www.gnu.de/documents/gpl.de.html 

using System;
using System.Threading;

/// <summary>
/// Creates three equal arrays of numbers and has them sorted with different sorting algorithms
/// to allow performance comparison via execution counting ("Collect Runtime Data" should
/// sensibly be switched on).
/// Requested input data are: Number of elements (size) and filing mode.
/// </summary>
public class SORTING_TEST_MAIN {

	// =========== START PARALLEL WORKER DEFINITIONS ============ 
	class Worker2f2c27cf_0{
		// TODO: Check and accomplish the member declarations here 
		private int[] values1;
		public Worker2f2c27cf_0(int[] values1)
		{
			this.values1 = values1;
		}
		public void DoWork()
		{
			bubbleSort(values1);
		}
	};

	class Worker2f2c27cf_1{
		// TODO: Check and accomplish the member declarations here 
		private int[] values2;
		private ??? elementCount;
		public Worker2f2c27cf_1(int[] values2, ??? elementCount)
		{
			this.values2 = values2;
			this.elementCount = elementCount;
		}
		public void DoWork()
		{
			quickSort(values2, 0, elementCount);
		}
	};

	class Worker2f2c27cf_2{
		// TODO: Check and accomplish the member declarations here 
		private int[] values3;
		public Worker2f2c27cf_2(int[] values3)
		{
			this.values3 = values3;
		}
		public void DoWork()
		{
			heapSort(values3);
		}
	};
	// ============ END PARALLEL WORKER DEFINITIONS ============= 

	// =========== START PARALLEL WORKER DEFINITIONS ============ 
	class Worker36044898_0{
		// TODO: Check and accomplish the member declarations here 
		private ??? values;
		private ??? start;
		private ??? p;
		public Worker36044898_0(??? values, ??? start, ??? p)
		{
			this.values = values;
			this.start = start;
			this.p = p;
		}
		public void DoWork()
		{
			// Sort left (lower) array part 
			quickSort(values, start, p);
		}
	};

	class Worker36044898_1{
		// TODO: Check and accomplish the member declarations here 
		private ??? values;
		private ??? p;
		private ??? stop;
		public Worker36044898_1(??? values, ??? p, ??? stop)
		{
			this.values = values;
			this.p = p;
			this.stop = stop;
		}
		public void DoWork()
		{
			// Sort right (higher) array part 
			quickSort(values, p+1, stop);
		}
	};
	// ============ END PARALLEL WORKER DEFINITIONS ============= 

	/// <param name="args"> array of command line arguments </param>
	public static void Main(string[] args) {

		// TODO: Check and accomplish variable declarations: 
		int[] values3;
		int[] values2;
		int[] values1;
		??? show;
		bool ok3;
		bool ok2;
		bool ok1;
		??? modus;
		??? elementCount;

		// TODO: You may have to modify input instructions, 
		//       possibly by enclosing Console.ReadLine() calls with 
		//       Parse methods according to the variable type, e.g.: 
		//          i = int.Parse(Console.ReadLine()); 

		do {
			elementCount = Console.ReadLine();
		} while (! (elementCount >= 1));
		do {
			Console.Write("Filling: 1 = random, 2 = increasing, 3 = decreasing"); modus = Console.ReadLine();
		} while (! (modus == 1 || modus == 2 || modus == 3));
		for (int i = 0; i <= elementCount-1; i += (1)) {
			switch (modus) {
			case 1:
				values1[i] = random(10000);
				break;
			case 2:
				values1[i] = i;
				break;
			case 3:
				values1[i] = -i;
				break;
			}
		}
		// Copy the array for exact comparability 
		for (int i = 0; i <= elementCount-1; i += (1)) {
			values2[i] = values1[i];
			values3[i] = values1[i];
		}

		// ========================================================== 
		// ================= START PARALLEL SECTION ================= 
		// ========================================================== 
		{
			Worker2f2c27cf_0 worker2f2c27cf_0 = new Worker2f2c27cf_0(values1);
			Thread thr2f2c27cf_0 = new Thread(worker2f2c27cf_0.DoWork);
			thr2f2c27cf_0.Start();
		
			Worker2f2c27cf_1 worker2f2c27cf_1 = new Worker2f2c27cf_1(values2, elementCount);
			Thread thr2f2c27cf_1 = new Thread(worker2f2c27cf_1.DoWork);
			thr2f2c27cf_1.Start();
		
			Worker2f2c27cf_2 worker2f2c27cf_2 = new Worker2f2c27cf_2(values3);
			Thread thr2f2c27cf_2 = new Thread(worker2f2c27cf_2.DoWork);
			thr2f2c27cf_2.Start();
		
			thr2f2c27cf_0.Join();
			thr2f2c27cf_1.Join();
			thr2f2c27cf_2.Join();
		}
		// ========================================================== 
		// ================== END PARALLEL SECTION ================== 
		// ========================================================== 

		ok1 = testSorted(values1);
		ok2 = testSorted(values2);
		ok3 = testSorted(values3);
		if (! ok1 || ! ok2 || ! ok3) {
			for (int i = 0; i <= elementCount-1; i += (1)) {
				if (values1[i] != values2[i] || values1[i] != values3[i]) {
					Console.Write("Difference at ["); Console.Write(i); Console.Write("]: "); Console.Write(values1[i]); Console.Write(" <-> "); Console.Write(values2[i]); Console.Write(" <-> "); Console.WriteLine(values3[i]);
				}
			}
		}
		do {
			Console.Write("Show arrays (yes/no)?"); show = Console.ReadLine();
		} while (! (show == "yes" || show == "no"));
		if (show == "yes") {
			for (int i = 0; i <= elementCount - 1; i += (1)) {
				Console.Write("["); Console.Write(i); Console.Write("]:\t"); Console.Write(values1[i]); Console.Write("\t"); Console.Write(values2[i]); Console.Write("\t"); Console.WriteLine(values3[i]);
			}
		}
	}

	/// <summary>
	/// Implements the well-known BubbleSort algorithm.
	/// Compares neigbouring elements and swaps them in case of an inversion.
	/// Repeats this while inversions have been found. After every
	/// loop passage at least one element (the largest one out of the
	/// processed subrange) finds its final place at the end of the
	/// subrange.
	/// </summary>
	/// <param name="values"> TODO </param>
	private static void bubbleSort(??? values) {
		// TODO: Check and accomplish variable declarations: 
		int posSwapped;

		??? ende = length(values) - 2;
		do {
			// The index of the most recent swapping (-1 means no swapping done). 
			posSwapped = -1;
			for (int i = 0; i <= ende; i += (1)) {
				if (values[i] > values[i+1]) {
					??? temp = values[i];
					values[i] = values[i+1];
					values[i+1] = temp;
					posSwapped = i;
				}
			}
			ende = posSwapped - 1;
		} while (! (posSwapped < 0));
	}

	/// <summary>
	/// Given a max-heap 'heap´ with element at index 'i´ possibly
	/// violating the heap property wrt. its subtree upto and including
	/// index range-1, restores heap property in the subtree at index i
	/// again.
	/// </summary>
	/// <param name="heap"> TODO </param>
	/// <param name="i"> TODO </param>
	/// <param name="range"> TODO </param>
	private static void maxHeapify(??? heap, ??? i, ??? range) {
		// TODO: Check and accomplish variable declarations: 

		// Indices of left and right child of node i 
		??? right = (i+1) * 2;
		??? left = right - 1;
		// Index of the (local) maximum 
		??? max = i;
		if (left < range && heap[left] > heap[i]) {
			max = left;
		}
		if (right < range && heap[right] > heap[max]) {
			max = right;
		}
		if (max != i) {
			??? temp = heap[i];
			heap[i] = heap[max];
			heap[max] = temp;
			maxHeapify(heap, max, range);
		}
	}

	/// <summary>
	/// Partitions array 'values´ between indices 'start´ und 'stop´-1 with
	/// respect to the pivot element initially at index 'p´ into smaller
	/// and greater elements.
	/// Returns the new (and final) index of the pivot element (which
	/// separates the sequence of smaller elements from the sequence
	/// of greater elements).
	/// This is not the most efficient algorithm (about half the swapping
	/// might still be avoided) but it is pretty clear.
	/// </summary>
	/// <param name="values"> TODO </param>
	/// <param name="start"> TODO </param>
	/// <param name="stop"> TODO </param>
	/// <param name="p"> TODO </param>
	/// <return> TODO </return>
	private static int partition(??? values, ??? start, ??? stop, ??? p) {
		// TODO: Check and accomplish variable declarations: 

		// Cache the pivot element 
		??? pivot = values[p];
		// Exchange the pivot element with the start element 
		values[p] = values[start];
		values[start] = pivot;
		p = start;
		// Beginning and end of the remaining undiscovered range 
		start = start + 1;
		stop = stop - 1;
		// Still unseen elements? 
		// Loop invariants: 
		// 1. p = start - 1 
		// 2. pivot = values[p] 
		// 3. i < start → values[i] ≤ pivot 
		// 4. stop < i → pivot < values[i] 
		while (start <= stop) {
			// Fetch the first element of the undiscovered area 
			??? seen = values[start];
			// Does the checked element belong to the smaller area? 
			if (seen <= pivot) {
				// Insert the seen element between smaller area and pivot element 
				values[p] = seen;
				values[start] = pivot;
				// Shift the border between lower and undicovered area, 
				// update pivot position. 
				p = p + 1;
				start = start + 1;
			}
			else {
				// Insert the checked element between undiscovered and larger area 
				values[start] = values[stop];
				values[stop] = seen;
				// Shift the border between undiscovered and larger area 
				stop = stop - 1;
			}
		}
		return p;
	}

	/// <summary>
	/// Checks whether or not the passed-in array is (ascendingly) sorted.
	/// </summary>
	/// <param name="numbers"> TODO </param>
	/// <return> TODO </return>
	private static bool testSorted(??? numbers) {
		// TODO: Check and accomplish variable declarations: 
		bool isSorted;
		int i;

		isSorted = true;
		i = 0;
		// As we compare with the following element, we must stop at the penultimate index 
		while (isSorted && (i <= length(numbers)-2)) {
			// Is there an inversion? 
			if (numbers[i] > numbers[i+1]) {
				isSorted = false;
			}
			else {
				i = i + 1;
			}
		}
		return isSorted;
	}

	/// <summary>
	/// Runs through the array heap and converts it to a max-heap
	/// in a bottom-up manner, i.e. starts above the "leaf" level
	/// (index >= length(heap) div 2) and goes then up towards
	/// the root.
	/// </summary>
	/// <param name="heap"> TODO </param>
	private static void buildMaxHeap(??? heap) {
		// TODO: Check and accomplish variable declarations: 
		int lgth;

		lgth = length(heap);
		for (int k = lgth / 2 - 1; k >= 0; k += (-1)) {
			maxHeapify(heap, k, lgth);
		}
	}

	/// <summary>
	/// Recursively sorts a subrange of the given array 'values´. 
	/// start is the first index of the subsequence to be sorted,
	/// stop is the index BEHIND the subsequence to be sorted.
	/// </summary>
	/// <param name="values"> TODO </param>
	/// <param name="start"> TODO </param>
	/// <param name="stop"> TODO </param>
	private static void quickSort(??? values, ??? start, ??? stop) {
		// TODO: Check and accomplish variable declarations: 

		// At least 2 elements? (Less don't make sense.) 
		if (stop >= start + 2) {
			// Select a pivot element, be p its index. 
			// (here: randomly chosen element out of start ... stop-1) 
			??? p = random(stop-start) + start;
			// Partition the array into smaller and greater elements 
			// Get the resulting (and final) position of the pivot element 
			// Partition the array into smaller and greater elements 
			// Get the resulting (and final) position of the pivot element 
			p = partition(values, start, stop, p);
			// Sort subsequances separately and independently ... 

			// ========================================================== 
			// ================= START PARALLEL SECTION ================= 
			// ========================================================== 
			{
				Worker36044898_0 worker36044898_0 = new Worker36044898_0(values, start, p);
				Thread thr36044898_0 = new Thread(worker36044898_0.DoWork);
				thr36044898_0.Start();
			
				Worker36044898_1 worker36044898_1 = new Worker36044898_1(values, p, stop);
				Thread thr36044898_1 = new Thread(worker36044898_1.DoWork);
				thr36044898_1.Start();
			
				thr36044898_0.Join();
				thr36044898_1.Join();
			}
			// ========================================================== 
			// ================== END PARALLEL SECTION ================== 
			// ========================================================== 

		}
	}

	/// <summary>
	/// Sorts the array 'values´ of numbers according to he heap sort
	/// algorithm
	/// </summary>
	/// <param name="values"> TODO </param>
	private static void heapSort(??? values) {
		// TODO: Check and accomplish variable declarations: 
		int heapRange;

		buildMaxHeap(values);
		heapRange = length(values);
		for (int k = heapRange - 1; k >= 1; k += (-1)) {
			heapRange = heapRange - 1;
			// Swap the maximum value (root of the heap) to the heap end 
			??? maximum = values[0];
			values[0] = values[heapRange];
			values[heapRange] = maximum;
			maxHeapify(values, 0, heapRange);
		}
	}

// = = = = 8< = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 


}
