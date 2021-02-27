/*Name: Wong Dan Ning
 *UOL Student number: 17*****46
 */

import java.util.Random;
import java.util.Scanner;

public class CustomerVerifier {
	private static int[] pins = new int[]{1234, 1111, 4321, 5555, 7777, 1010, 9876};
	private static String[] customers = new String[]{"Bob", "Rob", "Tim", "Jim", "Sam", "Jon", "Tom"};
	private static String[] memorableWords= new String[]{"fishing", "Mittens", "Arsenal", "6packYeah", "Porsche911", "puppies", "CSI4Ever"};
	private static Scanner scanner = new Scanner(System.in);

	//Question 3
    public static void main (String[] args) { 	
    	Verify();
    }

    //Question 1
    private static boolean userKnowsRandomCharsFromMemorableWord (String customer) {
    	String word = getMemorableWord(customer);
    	int randomNums[] = getDiscreteRandomInts(2, word.length());
    	String chars = getMemorableWordCharsFromUser(randomNums);

    	return charsAt(word, randomNums).equals(chars);
    }

    //Question 2
    private static void Verify() {
    	String customer;
    	int pin;
    	boolean charPin;

    	while (true) {
    		customer = getCustomerFromUser();
    		if (!isValidCustomer(customer)) {
    			invalidCustomer(customer);
    			if(!askUserToContinue()) {
    				System.out.println("Thank you and Goodbye.");
    				break;
    			}
    		} else {
    			pin = getPinFromUser();
    			if(isValidPin(customer, pin) == false) {
    				incorrectPin(customer, pin);
    				if(!askUserToContinue()) {
    					System.out.println("Thank you and Goodbye.");
    					break;
    				}
    			}else {
    				charPin = userKnowsRandomCharsFromMemorableWord (customer);
    				if(charPin == false) {
    					invalidMemorableWord(customer);
    					if(!askUserToContinue()) {
    						System.out.println("Thank you and Goodbye.");
    						break;
    					}
    				}else {
    					String memorableWord = getMemorableWord(customer);
    					verifiedCustomer(customer, pin, memorableWord);
    					if(askUserToContinue()) {
    					}
    					else {
    						System.out.println("Thank you and Goodbye.");
    						break;
    					}
    				}
    			}
    		}
    	}  	
    }

    private static boolean askUserToContinue() {
        String input = getUserInput("Verify another customer? ");
        return input.trim().toLowerCase().startsWith("y"); //see the String API for documentation of the trim() method
    }

    private static String getCustomerFromUser() {
        return getUserInput("Enter customer name: ");
    }

    private static int getPinFromUser() {
        String input = getUserInput("Enter PIN: ");
        return Integer.parseInt(input);  //see the subject guide volume 1 section 9.6 for more on the parseInt(String) method
    }

    private static String getUserInput(String msg) {
        System.out.print(msg);
        return scanner.nextLine();
    }

    private static boolean isValidPin(String customer, int pin) {
        int customerIndex = -1;
        for (int i = 0; i < customers.length; i++) {
            if (customer.equals((customers[i]))) {  //see the String API for documentation of the equals(Object) method
                customerIndex = i;
            }
        }
        return pin == pins[customerIndex];
    }

    private static boolean isValidCustomer(String customer) {
        for (int i = 0; i < customers.length; i++) {
            if (customer.equals(customers[i])) {
                return true;
            }
        }
        return false;
    }


    //return random integers that are distinct from each other
    private static int[] getDiscreteRandomInts(int quantity, int bound) {
        Random random = new Random();
        int[] store = new int[quantity];
        int r;
        int i = 0;
        while (i < quantity) {
            r = random.nextInt(bound);
            boolean insert = true;
            for (int j = 0; j < i; j++) {
                if (store[j] == r) {
                    insert = false;
                }
            }
            if (insert) {
                store[i] = r;
                i++;
            }
        }
        return store;
    }

    private static String charsAt(String word, int[] indexes) {
        String result = "";
        for (int i = 0; i < indexes.length; i++) {
            result += word.charAt(indexes[i]);
        }
        return result;
    }

    private static String getMemorableWordCharsFromUser(int[] chars) {
        String result = "";
        //computers start counting characters in a string from 0 but humans start at 1 so we add 1 to every number shown to the user
        for (int i = 0; i < chars.length; i++) {
            result += getUserInput("Enter character " + (chars[i]+1) + " from your memorable word: ");
        }
        return  result;
    }

    private static String getMemorableWord(String customer) {
        for (int i = 0; i < customers.length; i++) {
            if (customer.equals(customers[i])) {
                return memorableWords[i];
            }
        }

        //won't get here if the customer exists
        return "";
    }

    private static void verifiedCustomer(String customer, int pin, String memorableWord) {
        System.out.println("Verified customer " + customer + " with pin " + pin + " and memorable word " + memorableWord);
    }

    private static void incorrectPin(String customer, int pin) {
        System.out.println("Incorrect PIN (" + pin + ") for customer " + customer);
    }

    private static void invalidMemorableWord(String customer) {
        System.out.println("Invalid memorable word for " + customer);
    }

    private static void invalidCustomer(String customer) {
        System.out.println("Invalid customer " + customer);
    }
}
