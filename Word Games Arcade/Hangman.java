/*Done by
 *Name: Wong Dan Ning
 *UOL Student Number: 170282246
 */


import java.io.InputStream;
import java.io.PrintStream;
import java.nio.charset.Charset;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/*
 * Part A Question 1
 * 
 * Some improvements that I might want to implement
 * would be, only allow user to enter letters,
 * because as I play the game, when I entered characters
 * such as ',', '/', or '(', the entry is recorded as a 
 * wrong guess but the characters I entered were not 
 * letters. 
 * 
 * When nothing is entered and the user presses the 
 * 'Enter' key, StringIndexOutOfBoundsException occured.
 * In this case, we can use a try/catch block to handle 
 * this exception. If the character entered is a 
 * null value or other special characters, catch 
 * the exception and loop the game again and print a 
 * message to ask the user to enter a valid letter.
 * 
 * We can also write 'showGameBoard()' method as 
 * 'showCurrentGameProgress()', and rename 'mainLoop()' 
 * to 'runningTheGame()'.
 * 
 * The boolean method 'userHasGuessedTheWord()' can be 
 * used to replace the if condition of 
 * 'wordToGuess.equalsIgnoreCase(wordProgress)'
 * of the method 'showEndGameMessage()' since 
 * both the method and the condition will have 
 * the same boolean output.
 * 
 * Furthermore, we can write a String return type method
 * named 'setWordToLowerCase()' that sets the
 * String variable to lower case, so that this method
 * can be used in the first line of 
 * 'updateWordProgress(char guess)' to replace
 * 'String lowerCaseAnswer = wordToGuess.toLowerCase();'.
 * It will look something like this:
 * 'String lowerCaseAnswer = setWordProgressToLowerCase()'
 * and the method 'setWordProgressToLowerCase()' will
 * return the following:
 * 'wordProgress.toLowerCase();'
 * 
 *  
 */

public class Hangman extends AbstractRandomWordGame {
	private List<Character> guesses;
	private String wordToGuess;
	private int badGuesses;
	private String wordProgress;
	private boolean gameRunning;

	private static final String[] hangman = { "", "_________%n", " |%n |%n |%n |%n_|_______%n",
			" ______%n |/%n |%n |%n |%n_|_______%n", " ______%n |/   |%n |%n |%n |%n_|_______%n",
			" ______%n |/   |%n |    O%n |%n |%n_|_______%n", " ______%n |/   |%n |    O%n |    |%n |%n_|_______%n",
			" ______%n |/   |%n |    O%n |   /|%n |%n_|_______%n",
			" ______%n |/   |%n |    O%n |   /|\\%n |%n_|_______%n",
			" ______%n |/   |%n |    O%n |   /|\\%n |   /%n_|_______%n",
			" ______%n |/   |%n |    O%n |   /|\\%n |   / \\%n_|_______%n" };

	public Hangman(InputStream input, PrintStream output) {
		this(input, output, null, null);
	}

	public Hangman(InputStream input, PrintStream output, Path wordsFilePath) {
		this(input, output, wordsFilePath, null);
	}

	public Hangman(InputStream input, PrintStream output, Path wordsFilePath, Charset wordsFileCharset) {
		super(input, output, wordsFilePath, wordsFileCharset);
	}

	public void play() {
		initialiseGameState();
		mainLoop();
	}

	private void initialiseGameState() {
		guesses = new ArrayList<Character>();
		wordToGuess = getRandomWord();
		badGuesses = 0;
		wordProgress = getCensoredAnswer(wordToGuess);
		gameRunning = true;
	}

	private void mainLoop() {
		while (gameRunning) {
			showGameBoard();
			askUserToGuess();
			char guess = getUserGuess();
			updateGameState(guess);
			checkForEndState();
		}
		showGameBoard();// once the loop has ended show the final state to the user
		showEndGameMessage();
	}

	private void updateGameState(char guess) {
		if (isDuplicateGuess(guess)) {
			//output.println("Duplicate Guess");
			return;
		}

		boolean goodGuess = isGoodGuess(guess);
		if (goodGuess) {
			wordProgress = updateWordProgress(guess);
		} else {
			badGuesses++;
			guesses.add(guess);
		}
	}

	private boolean isDuplicateGuess(char guess) {
		return isDuplicateWrongGuess(guess) || isDuplicateCorrectGuess(guess);
	}

	private boolean isDuplicateWrongGuess(char guess) {
		char upper = Character.toUpperCase(guess);
		char lower = Character.toLowerCase(guess);
		return guesses.contains(upper) || guesses.contains(lower);
	}

	private boolean isDuplicateCorrectGuess(char guess) {
		char candidate = Character.toLowerCase(guess);

		// the letters in wordProgress are always lower case. This is enforced in the
		// updateWordProgress() method
		return wordProgress.indexOf(candidate) != -1;
	}

	private void askUserToGuess() {
		output.println();
		output.print("Enter next guess: ");
	}

	private String getCensoredAnswer(String answer) {
		return answer.replaceAll(".", "-");
	}

	private void showGameBoard() {
		String string = "WORD:\t\t\tWRONG GUESSES:%n%s\t\t\t%s%n%n" + hangman[badGuesses];
		output.format(string, wordProgress, guesses);
	}

	private char getUserGuess() {
		String s = input.nextLine();
		return s.charAt(0);
	}

	private boolean isGoodGuess(char guess) {
		String candidate = "" + guess;
		return wordToGuess.toLowerCase().contains(candidate.toLowerCase());
	}

	private String updateWordProgress(char guess) {
		String lowerCaseAnswer = wordToGuess.toLowerCase();
		char lowerCaseGuess = Character.toLowerCase(guess);
		StringBuilder builder = new StringBuilder(wordProgress);
		int index = lowerCaseAnswer.indexOf(lowerCaseGuess);
		while (index >= 0) {
			char answerCharacter = wordToGuess.charAt(index);
			builder.setCharAt(index, answerCharacter);
			index = lowerCaseAnswer.indexOf(lowerCaseGuess, index + 1);
		}

		return builder.toString();
	}

	private void checkForEndState() {
		if (userHasGuessedTheWord() || userHasUsedAllTheirGuesses()) {
			gameRunning = false;
		}
	}

	private boolean userHasGuessedTheWord() {
		return wordToGuess.equalsIgnoreCase(wordProgress);
	}

	private boolean userHasUsedAllTheirGuesses() {
		return badGuesses == hangman.length - 1;
	}

	private void showEndGameMessage() {
		if (wordToGuess.equalsIgnoreCase(wordProgress)) {
			output.println("You won! The word was " + wordToGuess + ". Congratulations.");
		} else {
			output.println("You lose. Better luck next time!");
		}
	}

	public static void main(String[] args) {
		Hangman hangman = new Hangman(System.in, System.out);
		hangman.play();
	}
}
