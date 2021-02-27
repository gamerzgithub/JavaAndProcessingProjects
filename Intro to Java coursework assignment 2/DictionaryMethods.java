import java.util.*;
import java.io.*;


/*
 *
 * 1. loop showing a list of options (including quit)
 * 2. go back to 1 each time the user selects an option that isn't 'quit' (after performing the option)
 * 3. when the user selects 'quit', end the program
 *
 */

public class DictionaryMethods {

	private Scanner in;
	private boolean proceed;
	private static String filename;
	private ArrayList<String> dictionary;


	public DictionaryMethods() {
		in = new Scanner(System.in);
		proceed = true;
		filename = "smallDictionary.txt";
		dictionary = new ArrayList<String>();
		readDictionary(filename);
		startLoop();
	}

	private void readDictionary(String dictFile) {
		Scanner in = null;
		try {
			in = new Scanner(new FileReader(dictFile));
		} catch (IOException e) {
			System.err.println("Dictionary file does not exist! Aborting.");
		}
		while(in.hasNextLine()) {
			String word = in.nextLine();
			addWord(word);
		}
		in.close();
		sortDictionary();
	}

	private void addWord(String word) {
		dictionary.add(sanitiseWord(word));
	}

	private String sanitiseWord(String word) {
		return word.toLowerCase();
	}

	private boolean isWordInDictionary(String word) {
		return dictionary.contains(sanitiseWord(word));
	}

	private void sortDictionary() {
		Collections.sort(dictionary);
	}

	private void startLoop() {
		//main loop. when we exit this loop the program is over
		while (proceed) {
				showOptions();
				String userInput = getUserSelectedOption();

				int option = validateUserInput(userInput);
				if (option == 7) { //option to quit
					proceed = false;
				} else {
					executeUserSelectedOption(option);
			}
		}
		//the end.
		System.out.println("Bye.");
		in.close();
	}

	private String getUserInput() {
		return in.nextLine();
	}

	private void showOptions() {
		System.out.println("Choose one of the following options:");
		System.out.println();
		System.out.println("1) check that a word is in the dictionary");
		System.out.println("2) show all words in dictionary");
		System.out.println("3) show all words in dictionary containing a search String");
		System.out.println("4) show all words in dictionary starting with a search String");
		System.out.println("5) show all words in dictionary ending with a search String");
		System.out.println("6) show all words in dictionary of a certain length");
		System.out.println("7) Quit");
		System.out.println();
	}

	private String getUserSelectedOption() {
		System.out.print("Enter your choice: ");
		String s = getUserInput();
		System.out.println();
		return s;
	}

	private int validateUserInput(String data) {
		if (data == null || data.trim().length() == 0) {
			return -1;
		}

		String possibleNumber = data.trim();
		if (possibleNumber.length() > 1) { //length will be > 1 if a number greater than 9 entered
			return -1;
		}

		if (possibleNumber.equals("1")) return 1;
		if (possibleNumber.equals("2")) return 2;
		if (possibleNumber.equals("3")) return 3;
		if (possibleNumber.equals("4")) return 4;
		if (possibleNumber.equals("5")) return 5;
		if (possibleNumber.equals("6")) return 6;
		if (possibleNumber.equals("7")) return 7;

		return -1;
	}

	private void executeUserSelectedOption(int option) {
		if (option < 1) {
			System.out.println("Unknown option.");
			return;
		}

		switch (option) {
			case 1: findWord(); break;
			case 2: display(); break;
			case 3: errorMessage(); break;
			case 4: errorMessage(); break;
			case 5: errorMessage(); break;
			case 6: errorMessage(); break;

			default: System.out.print("Error executing option.");
		}
		System.out.println();
	}

	private void findWord() {
		System.out.println("This method checks if your word is in the dictionary ");
		System.out.println("Enter your word ");
		String word = getUserInput();
		System.out.println();
		if (isWordInDictionary(word))
		System.out.println("Word entered is in the dictionary");
	}

	private void display() {
	   String text = "";
	   for (int i = 0; i < dictionary.size(); i++) {
		   text += dictionary.get(i) + System.lineSeparator();
	   }
	   System.out.println(text);
	}

	private void errorMessage(){
		System.out.println("I don't know how to do that!");
	}

	private void changeDictionary() {
		System.out.println("This method changes the file used to load the dictionary");
		System.out.println("Enter the filename ");
		String s = getUserInput();
		readDictionary(s);
	}

	public static void main(String[] args) {
		new DictionaryMethods();
	}
}
