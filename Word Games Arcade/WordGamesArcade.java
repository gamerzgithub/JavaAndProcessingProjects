/*Done by
 *Name: Wong Dan Ning
 *UOL Student Number: 17*****46
 */


import java.io.InputStream;
import java.io.PrintStream;
import java.util.Scanner;

public class WordGamesArcade {
	
	private static final int MENU_CHOICE_HANGMAN = 1;
	private static final int MENU_CHOICE_QUIT = 0;
	private static final int MENU_CHOICE_WORDSLEUTH = 2;
	private Scanner input;
	private PrintStream output;
	private InputStream inputStream;
	private boolean running;
	private Hangman hangman;
	private WordSleuth wordSleuth;

	public WordGamesArcade() {
		inputStream = System.in;
		output = System.out;
		input = new Scanner(inputStream);
	}

	public void play() {
		running = true;
		showWelcomeMessage();
		mainLoop();
	}

	private void showWelcomeMessage() {
		output.println("WORD GAMES ARCADE");
		output.println();
	}

	private void mainLoop() {
		while (running) {
			showMenu();
			askUserToChoose();
			int choice = getUserChoice();
			executeChoice(choice);
		}
	}

	private void showMenu() {
		output.println("Choose one of the following options:");
		output.println(MENU_CHOICE_HANGMAN + ". Hangman");
		output.println(MENU_CHOICE_WORDSLEUTH + ". Word Sleuth");
		output.println(MENU_CHOICE_QUIT + ". Quit");
		
		output.println();
	}
	
	private void askUserToChoose() {
		output.print("Enter your choice: ");
	}

	private int getUserChoice() {
		while (true) {
			try {
				String s = input.nextLine();
				int i = Integer.parseInt(s);
				return i;
			} catch (NumberFormatException e) {
				output.print("Invalid number. Try again: ");
			}
		}
	}

	private void executeChoice(int choice) {
		if (choice == MENU_CHOICE_HANGMAN) {
			playHangman();
		}else if (choice == MENU_CHOICE_WORDSLEUTH) {
			playWordSleuth();
		}else if (choice == MENU_CHOICE_QUIT) {
			quit();
		} else {
			unknownChoiceResponse();
		}
		output.println();
	}

	private void playHangman() {
		if (hangman == null) {
			hangman = new Hangman(inputStream, output);
		}

		output.println("Starting Hangman...");
		hangman.play();
	}

	private void playWordSleuth() {
		if (wordSleuth == null) {
			wordSleuth = new WordSleuth(inputStream, output);
		}
		
		output.println("Starting Word Sleuth...");
		wordSleuth.play();
	}
	
	private void quit() {
		output.println("Thanks for playing!");
		running = false;
	}

	private void unknownChoiceResponse() {
		output.println("Not a valid menu choice");
	}

	public static void main(String[] args) {
		WordGamesArcade wordGamesArcade = new WordGamesArcade();
		wordGamesArcade.play();
	}
}
