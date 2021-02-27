/*Done by
 *Name: Wong Dan Ning
 *UOL Student Number: 170282246
 */


import java.io.InputStream;
import java.io.PrintStream;
import java.nio.charset.Charset;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

public class WordSleuth extends AbstractRandomWordGame {
	
	private List<String> duplicateGuessChecker;
	private String wordToBeGuessed;
	private char firstLetter;
	private List<Character> letterHint;
	private List<Character> sortedLetterHint;
	private int score;
	private int initialScore;
	private int[] randomNumbers;
	private int chooseRandomNumber;
	private double numberOfGuesses;
	private boolean gameRunning;
	
	public static void main(String[] args) {
		WordSleuth game = new WordSleuth(System.in, System.out);
		game.play();
	}

	public WordSleuth(InputStream input, PrintStream output) {
		this(input, output, null, null);
	}

	public WordSleuth(InputStream input, PrintStream output, Path wordsFilePath) {
		this(input, output, wordsFilePath, null);
	}

	public WordSleuth(InputStream input, PrintStream output, Path wordsFilePath, Charset wordsFileCharset) {
		super(input, output, wordsFilePath, wordsFileCharset);
	}

	public void play() {
		initialiseGameState();
		displayGameInstructions();
		runTheGame();
	}

	private void initialiseGameState() {
		duplicateGuessChecker = new ArrayList<String>();		
		wordToBeGuessed = getRandomWord();
		firstLetter = wordToBeGuessed.charAt(0);
		letterHint = new ArrayList<Character>();
		sortedLetterHint = new ArrayList<Character>();
		randomNumbers = new int[roundUpWordHalfLength()-1];
		chooseRandomNumber = 0;
		numberOfGuesses = roundUpWordHalfLength()+1;
		score = 2 * wordToBeGuessed.length();
		initialScore = score;
		gameRunning = true;
	}
	
	private void runTheGame() {
		String guess = null;
		randomNumbers = generateDistinctRandomNumbers();
		while (gameRunning) {
			if (guess != null) {
				displayLetterHints();
			}
			askUserToGuess();
			guess = getUserGuess();
			checkForWrongGuess(guess);
			checkEndGameState(guess);
		}
		displayEndGameMessage(guess);
	}
	
	private void checkForWrongGuess (String guess) {
		boolean correctGuess = userHasGuessedTheWord(guess);
		if (!correctGuess) {	
			output.println("Wrong guess!");
			duplicateGuessChecker.add(guess);
			numberOfGuesses--;
			updateScoreAndLetterHints();
		}			
	}
	
	private void updateScoreAndLetterHints() {
		if (chooseRandomNumber < randomNumbers.length && !allLetterHintsGiven()) {
			addCharactersToLetterHints();
			score--;
		} 
		else if (allLetterHintsGiven()) {
			sortLetterHints();
			score -= 2;
		}
	}
	
	
	
	private void checkEndGameState(String guess) {
		if (userHasGuessedTheWord(guess) || userHasUsedAllGuesses()) {
			gameRunning = false;
		}
	}

	private int roundUpWordHalfLength() {
		return (int)Math.ceil((double)wordToBeGuessed.length()/2);
	}

	/*
	 *This method was derived from the supplementary java file
	 *'CustomerVerifier.java' of the Coursework assignment 1 2017-2018
	 *for CO1109 Intro to Java and OO Programming, with some changes 
	 *made to the original method algorithm.
	 */
	private int[] generateDistinctRandomNumbers() {
		Random random = new Random();
		int temp = 0;
		int i = 0;
		while (i < randomNumbers.length) {
			boolean nonRepeatedOrZeroNumber = true;
			temp = random.nextInt(wordToBeGuessed.length());
			for (int j = 0; j < randomNumbers.length; j++) {
				if (randomNumbers[j] == temp || temp == 0) {
					nonRepeatedOrZeroNumber = false;
				}
			}
			if (nonRepeatedOrZeroNumber) {
				randomNumbers[i] = temp;
				i++;
			}
		}
		return randomNumbers;
	}

	private int[] sortRandomNumbers (int[] randomNumberArray) {		
		Arrays.sort(randomNumberArray);
		return randomNumberArray;
	}
	
	private boolean allLetterHintsGiven() {
		return letterHint.size() == (int)Math.ceil((double)wordToBeGuessed.length() / 2)-1;
	}

	private boolean isDuplicateGuess(String guess) {
		boolean duplicateGuess = false;
		for (int i = 0; i < duplicateGuessChecker.size(); i++) {
			if (duplicateGuessChecker.get(i).equalsIgnoreCase(guess)) {
				duplicateGuess = true;
			}
		}
		return duplicateGuess;
	}
	
	private boolean isEmptyInput(String guess) {
		return guess.isEmpty();
	}

	private void askUserToGuess() {
		if (numberOfGuesses == 1) {
			output.println("Letter hints are now arranged in order.");
			output.println("This is your last chance!");
		}
		output.println("Can you guess what is the word?");
	}

	private String getUserGuess() {
		String guess = input.nextLine();
		if(isDuplicateGuess(guess)) {
			output.println("A duplicate guess, please try with a different word.");
			guess = getUserGuess();
		}
		if (isEmptyInput(guess)) {
			System.err.println("No input detected, please enter something.");
			guess = getUserGuess();
		}
		return guess;
	}
	
	private boolean userHasGuessedTheWord(String guess) {
		return wordToBeGuessed.equalsIgnoreCase(guess);
	}

	private boolean userHasUsedAllGuesses() {
		return numberOfGuesses ==  0;
	}

	private void addCharactersToLetterHints()	{
		letterHint.add(wordToBeGuessed.charAt(randomNumbers[chooseRandomNumber]));
		chooseRandomNumber++;
	}
	
	private void sortLetterHints() {
		randomNumbers = sortRandomNumbers(randomNumbers);
		sortedLetterHint.add(wordToBeGuessed.charAt(0));
		for (int i: randomNumbers) {
			sortedLetterHint.add(wordToBeGuessed.charAt(i));
		}
		letterHint = sortedLetterHint;
	}
	
	private void displayGameInstructions()	{
		output.println("\n******************** WORD SLEUTH PUZZLE ********************\n");
		output.println("The word starts with the letter "+firstLetter+". ");
		output.println("The word has "+wordToBeGuessed.length()+" letters.");
		output.println("You have "+(int)numberOfGuesses+" tries.");
	}
 
	private void displayLetterHints() {
		String string = "%nThe word contains the following letter(s):%n%s%n%n%n";
		output.format(string, letterHint);
	}
	
	private void displayEndGameMessage(String guess) {
		if (userHasGuessedTheWord(guess) && score == initialScore) {
			output.println("You've won the game! Your score is "+ score + "/" + initialScore + ". ");
			output.println("Well done!");
		} else if (userHasGuessedTheWord(guess)) {
			output.println("You've won the game! Your score is "+ score + "/" + initialScore + ". ");
			output.println("Good try!");
		}else {
			output.println("Game over. Your score is 0. The correct word is " + wordToBeGuessed + ". ");
			output.println("You can do better next time!");
		}
	}

}
