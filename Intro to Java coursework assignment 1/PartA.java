/*Name: Wong Dan Ning
 *UOL Student number: 170282246
 */

import java.util.Random;

public class PartA {

	static String greetings[] = {"hello", "hallo", "bok", "bonjour", "zdravstvuyte", "namaskaar", "hai", "nee how", "ne ho"};//see loop12()

	//loop 20 times
	/*PROBLEM:
	 * Infinity loop
	 */
	/*REASON: 
	 * The loop will start when i equals to 0, and for every loop
	 * i decreases by 1. However, the stopping condition is set where the maximum 
	 * value i can take is 20, which means i must be less than 20.
	 * As i decreases by 1 for every loop, i will never increase
	 * to reach 20. The stopping condition i more than or equal to 20 
	 * will never be met, so the loop runs indefinitely.
	 */
	/*SOLUTION: 
	 * Code a stopping condition
	 * (1) Change the way i changes for every loop.
	 * OR (2) Since i decreases by 1 for every loop,
	 * change the minimum value of i and the inequality sign.
	 * For solution (1): (i--) can be changed to (i++), i will 
	 * increase by 1 for every loop and stops when i=20.
	 * For solution (2): (i<20) can be changed to (i>-20), such that
	 * the minimum value of i can take is -20, i will decrease by 1 for
	 * every loop and stops when i=-20.
	 */
	private static void loop1() {
		for(int i = 0; i < 20; i--) {
			System.out.println("In loop "+i);
		}
		System.out.println("Out of loop");
	}


	//loop 10 times
	/*PROBLEM: 
	 *Unreachable code and infinity loop.
	 */
	/*REASON: 
	 * 'for(;;)' does not have a initialisation expression, guard, and 
	 * final expression, this allow the loop to run infinitely and will never 
	 * exit the loop, so this for loop becomes an infinity loop.
	 * As the for loop runs infinitely and does not exit, the second statement 
	 * 'System.out.println("Out of loop");' becomes an unreachable 
	 * code.
	 */
	/*SOLUTION:
	 * Add an initialisation expression, a guard and a final expression.
	 * For example, 'for(int i=0; i<10; i++);' will allow the loop 
	 * to start when i=0, increment by 1 for every loop until i reaches 10.
	 * Which means the for loop will run exactly 10 times.
	 * When i=10, exit for loop and runs the second statement.
	 */
	private static void loop2() {
		for(;;) System.out.println("In loop");
		System.out.println("Out of loop");
	}


	//loop 10 times
	/*PROBLEM:
	 * Infinite loop.
	 */
	/*REASON:
	 * There is no stopping condition. i will always be less than 10 since
	 * i = 0. Hence 'System.out.println("In loop "+i);' statement will be 
	 * called infinite number of times.
	 */
	/*SOLUTION:
	 * Add a stopping condition in the doWhile loop. Add 'i++;' such that
	 * every time the doWhile loop is called, i increment by one and eventually
	 * stops when i = 10. This will satisfy the condition of looping 
	 */
	private static void loop3() {
		int i = 0;
		do {
			System.out.println("In loop "+i);
		} while(i < 10);
		System.out.println("Out of loop");
	}


	//loop 5 times
	/*PROBLEM:
	 * Infinity loop and unreacable code.
	 */
	/*REASON: 
	 * The guard of the while loop is (5<10), which is forever true.
	 * Since the while loop is forever true, the loop runs infinitely and
	 * will never exit the loop. Hence, 'System.out.println("Out of loop");'
	 * become an unreachable code.
	 */
	/*SOLUTION:
	 * Change the stopping condition of the while loop.
	 * Change (5 < 10) to (i < 10), this will allow the loop to
	 * run for 5 times and exit the loop to print out "Out of loop".
	 */		
	private static void loop4() {
		int i = 5;
		while(5 < 10) {
			System.out.println("In loop i = "+i);
			i++;
		}
		System.out.println("Out of loop");
	}


	//loop 11 times
	/*PROBLEM: 
	 * While loop is not executed.
	 */
	/*REASON: 
	 * The guard for the while loop is always false, as n=21 is
	 * always larger than m=10. Since the guard of the while loop 
	 * is false, while loop will not be executed and the next
	 * statement 'System.out.println("Out of loop.");' will be called.
	 */
	/*SOLUTION:
	 * Remove the NOT sign '!' from the guard of the while loop.
	 * This will allow the while loop to run exactly 11 times and 
	 * then print out "Out of loop."
	 */
	private static void loop5() {
		int m = 10;
		int n = 21;
		while (!(n > m)) {
			System.out.println("In loop.");
			n--;
		}
		System.out.println("Out of loop.");
	}


	//loop until i is equal to j
	/*PROBLEM:
	 * Unreachable code
	 */
	/*REASON:
	 * By default the guard of a while loop is true.
	 * The guard of the while loop is false, which means 
	 * the while loop is never true and becomes an unreacable code.
	 * Since while loop is an unreachable code, 'System.out.println("out of loop");'
	 * will not be executed too.
	 */
	/*SOLUTION:
	 * Change the guard from 'false' to 'true', while loop will be executed
	 * and runs until i = j.
	 */
	private static void loop6(){
		Random r = new Random();
		int i = 0;
		int j = 10;
		while (false){
			i = r.nextInt(10);
			j = r.nextInt(1000);
			System.out.println("i = "+i+" and j = "+j);
			if (i==j)break;
		}
		System.out.println("out of loop");
	}


	//loop until i is equal to j
	/*PROBLEM:
	 * Infinity loop
	 */
	/*REASON:
	 * i is initialised to 0. In the while loop, i is assigned to
	 * a random number from the range of 0 to j, excluding j, which is 10.
	 * Hence, i will be assigned to any number from 0 to 9 inclusive, but 
	 * will never be equal to 10. This makes i will never be equal to j, 
	 * so the loop runs infinitely.
	 */
	/*SOLUTION: 
	 * Change the range for random numbers to be generated to 'j+1'.
	 * That is, 'i = r.nextInt(j+1);'. In that way the range of 
	 * numbers i can take increases, so i can now assign to any number
	 * from 0 to 10 inclusive. When i=j (which is 10), the system exits
	 * while loop and prints "out of loop".
	 */
	private static void loop7(){
		Random r = new Random();
		int i = 0;
		int j = 10;
		while (true){
			i = r.nextInt(j);
			if (i==j)break;
			System.out.println("i = "+i+" and j = "+j);
		}
		System.out.println("out of loop");
	}



	//loop until we randomly generate a 7
	/*PROBLEM: 
	 * Infinity loop.
	 */
	/*REASON:
	 * boolean stop is initialised to false. In the while loop,
	 * when i is equal to 7, stop is assigned to false again.
	 * This means that while loop is always NOT false, which is true,
	 * so while loop runs infinitely.
	 */
	/*SOLUTION:
	 * Assign stop to true instead of false in the while loop.
	 * This way will allow the system to exit while loop when
	 * i is equal to 7.
	 */
	private static void loop8() {
		boolean stop = false;
		Random r = new Random();
		int i;
		int count = 1;
		while(!stop) {
			i = r.nextInt(100);
			System.out.println("Random number is "+i);
			if(i == 7) {
				stop = false;
			}
			count++;
		}
		System.out.println("Took "+count+" tries");
	}



	//loop 60 times (outer loop 10 times plus inner loop 5 x 10 times)
	/*PROBLEM: 
	 * Infinity loop
	 */
	/*REASON:
	 * The inner loop for j loops infinitely. j is initialised to 0,
	 * and j is always less than 5, because j does not increase after 
	 * every inner loop. Instead, i increment by 1 after every inner loop.
	 * Therefore, the inner loop is forever true and runs infinitely.
	 */
	/*SOLUTION:
	 * Change 'i++;' to 'j++;' of the inner loop. This allows j to increment
	 * by 1 after every inner loop and exits when j is equal to 5. This satisfy
	 * the requirement where inner loop runs 5x10 times, as outer loop runs 10 times.
	 */
	private static void loop9() {
		int i = 0;
		int j = 0;
		while(i < 10) {
			System.out.println("In loop 1 "+i);
			while(j < 5) {
				System.out.println("In loop 2 "+i);
				i++;
			}
			j=0;
			i++;
		}
		System.out.println("Out of loops");
	}


	//draw a 9 x 9 rectangle using asterisks
	/*PROBLEM:
	 * Instead of a 9x9 rectangle, a right angle triangle with a base of
	 * 9 asterisks will be printed instead.
	 * Output:
	 *  
	 *  *
	 *  **
	 *  *** 
	 *  ****
	 *  *****
	 *  ******
	 *  *******
	 *  ********
	 *  *********
	 */
	/*REASON:
	 * The guard for the j loop follows i. For example, if i=2, the guard of 
	 * j will be set to 2, so the for loop of int j will only loop 2 times 
	 * and print 2 asterisks. Hence for every row, for loop of int j will only 
	 * run maximum i number of times, printing i number of asterisks,
	 * forming a right angle triangle shape of 9 rows. Only 9 rows of asterisks 
	 * will be printed out because the first row prints out nothing.
	 */
	/*SOLUTION:
	 * Change the guard for int j to 'j<k', and initialise k to 9, where 
	 * 'int k = 9;', because if guard of the loop of int j is set to k,
	 * 10 rows of asterisks with 10 asterisks in each row will be printed,
	 * in other words, a 10x10 rectangle made of asterisks will be printed 
	 * instead. Hence changing initialise k to 9 will make both loops of int i
	 * and int j to run exactly 9 times, printing a 9x9 rectangle of asterisks. 
	 */
	private static void loop10() {
		int k = 10;
		for (int i = 0; i < k; i++) {
			for (int j = 0; j < i; j++) {
				System.out.print("*");
			}
			System.out.println();
		}
	}


	//Draw a pyramid using asterisks, the pyramid has 7 lines, the top line has 1 star, the next row 2 more (ie 3), rows increase by 2 until the bottom row has 13 stars as follows:
	/*          *
	 *         ***
	 *        *****
	 *       *******
	 *      *********
	 *     ***********
	 *    *************				*/

	/*PROBLEM:
	 * Only the last asterisk in each row is printed out, each row
	 * only print one asterisks. Instead of a pyramid, a slanted line
	 * is printed instead. 
	 * Output:
	 *       *
	 *        *
	 *         *
	 *          *
	 *           *
	 *            *
	 *             *      
	 */
	/*REASON:
	 * int x = y, and x=6. After every inner loop, both x and y increment by 1.
	 * Which means, in the first row x and y =6, second row x and y=7,
	 * so on and so forth. Since x=y and both x and y increment by 1 after every inner loop, 
	 * from the second 'if' statement in the inner loop, only one asterisk will be printed 
	 * in each row. From the first 'if' statement, the number of blanks printed increases
	 * as number of row increase, because x increase by 1 after every inner loop.
	 * Hence, instead of a pyramid, a slanted line made up of asterisk will 
	 * be printed.
	 */
	/*SOLUTION:
	 * Make x decreases by 1 after every loop instead of increase.
	 * Change 'x++;' to 'x--;', this way the number of blanks printed will 
	 * decrease by 1 after every loop, printing one less blank as number of 
	 * rows increases. This will also increase the range between x and y, 
	 * so as number of rows increases more asterisks will be printed. 
	 * Therefore forming a pyramid of 7 lines and a base of 13 asterisks.
	 */
	private static void loop11() {
		int k = 7;
		int m = 13;
		int x = 6; int y = x;
		for (int i = 0; i < k; i++) {
			for (int j = 0; j < m; j++) {
				if (j<x) System.out.print(" ");
				if ((j>=x)&&(j<=y)) System.out.print("*");
			}
			System.out.println();
			x++;
			y++;
		}
	}


	//Search a String array for a particular String. If the search String is found return true, else return false.
	/*PROBLEM:
	 * 1. Array index out of bound only when String is not found in the array.
	 * 2. String compare is incorrect.
	 */
	/*REASON:
	 * 1. There is 9 elements in the array greetings[], so each element is named greetings[0], greetings[1],
	 * so on and so forth, and the last element is greetings[8], because 0 to 8 makes up 
	 * 9 elements. The length of the word greetings is 9, means a.length is 9. Since
	 * "merhaba" is not in the array of String greetings[], when i=8,
	 * as a[i] is not equal to find, and 'i++' cause i to increment by 1, means now i=9.
	 * System will exit for loop as i=9. After exiting for loop, 
	 * 'return (a[i]==find);' cause a problem, because as i=9, a[9] is not within the 
	 * array index of greetings. Hence error of array index out of bound occurs.
	 * 2. For comparing Strings, '.equals' should be used instead of '==' sign. 
	 */
	/*SOLUTION:
	 * 1. Change 'i<a.length && a[i]!=find;' to 'i<a.length-1 && a[i]!=find;', the maximum value 
	 * that i can take becomes 8, so array index will not be out of bound.
	 * 2. Change 'a[i] == find' to 'a[i].equals(find)', such that two string with same spelling will
	 * be returned true.
	 */
	private static boolean loop12(String[]a, String find) {
		int i;
		for (i=0; i<a.length && a[i]!=find; i++);
		return (a[i]==find);
	}


	private static void runLoops() {
		loop1();
		System.out.println();
		loop2();
		System.out.println();
		loop3();
		System.out.println();
		loop4();
		System.out.println();
		loop5();
		System.out.println();
		loop6();
		System.out.println();
		loop7();
		System.out.println();
		loop8();
		System.out.println();
		loop9();
		System.out.println();
		loop10();
		System.out.println();
		loop11();
		System.out.println();
		System.out.println(loop12(greetings, "zdravstvuyte"));
		System.out.println();
		System.out.println(loop12(greetings, "merhaba"));

	}


	public static void main(String[] args) {
		runLoops();
	}

}


