/*CO1109 CW2
 * NAME: WONG DAN NING
 * UOL SRN: 170282246
 */

import java.util.*;
import java.io.*;

public class ProcessDegreeMark{
	

	private static ArrayList<Finalist> finalistsInList(String s) {
		ArrayList<Finalist> finalists = new ArrayList<Finalist>();
		String id;
		double mark;
		try {
		Scanner in =new Scanner(new FileReader(s));
			while(in.hasNextLine()){
				id =in.nextLine();
				mark = Double.parseDouble(in.nextLine());
				finalists.add(new Finalist(id,mark));
				
			}
			in.close();//finished with the Scanner object, tidy up.
		}
		catch (Exception e){
			System.out.println("file "+ s + " not found");
		}
			
		return finalists;
	 }


	private static void displayFinalists(ArrayList<Finalist> finalists) throws Exception {
			
		for (int i = 0; i < finalists.size(); i++) {
		   System.out.println(finalists.get(i));
		}
	  
  	}

	//Question 3 
	private static void findFinalistID(ArrayList<Finalist> a, String s){
		int i;	
		for (i=1;i<a.size();i++) {
			if (((a.get(i)).getId()).equals(s)) { 
				System.out.println(a.get(i));	
				break;
			}
		}
		if (i == a.size()) {
			System.out.println("No candidate found with ID number "+ s);
		}
	}
	
	//Question 4
	 private static void findFinalistClass(ArrayList<Finalist> a, String s) {
	    	int i;
	    	String check = "";
	    	for (i = 0; i < a.size(); i++) {
	    		if (a.get(i).getDegreeClass().equals(s))
	    			check += a.get(i)+ System.lineSeparator();
	    		else 
	    			check += "";
	    	}
	    	if (check.equals(""))
	    		System.out.println("No candidate found with degree class "+ s + System.lineSeparator());
	    	else 
	    		System.out.print(check);
		}

	 //Original finalistsToFile method commented and rewrote into 2 other methods.
	/* public static void finalistsToFile(ArrayList<Finalist> finalists, String s) throws Exception{
			ArrayList<Finalist> sortedFinalists = new ArrayList<Finalist>();
			sortedFinalists.addAll(finalists);

			//sort by degree mark (descending)
			Collections.sort(sortedFinalists, new FinalistComparator());

			//save sorted arraylist to a file called s
			PrintStream out = new PrintStream(new FileOutputStream(s));
			for(int i = 0; i < sortedFinalists.size(); i++)
			out.println(sortedFinalists.get(i));
			out.close();
		}*/
	 
	 //Question 6 sortDegreeMark method
	 private static ArrayList<Finalist> sortDegreeMark(ArrayList<Finalist> finalists) {
		 ArrayList<Finalist> sortedFinalists = new ArrayList<Finalist>();
		 sortedFinalists.addAll(finalists);

		 //sort by degree mark (descending)
		 Collections.sort(sortedFinalists, new FinalistComparator());
		 return sortedFinalists;
	 }

	 //Question 6 finalistsToFile2 method
	 private static void finalistsToFile2(ArrayList<Finalist> sortedFinalists, String s) {
		 //save sorted arraylist to a file called s
		 PrintStream out = null;
		 try {
			 out = new PrintStream(new FileOutputStream(s));
			 for(int i = 0; i < sortedFinalists.size(); i++) {
				 out.print(sortedFinalists.get(i) + System.lineSeparator());
			 }
			 out.close();
		 } catch (FileNotFoundException e) {
			 System.out.println("File not found");
		 }

	 }

	 private static void findAndSaveFinalistClass(ArrayList<Finalist> finalists, String s) {
	    	int i;
	    	String check = "";
	    	ArrayList<Finalist> list = new ArrayList<Finalist>() ;
	    	for (i = 0; i < finalists.size(); i++) {
	    		if (finalists.get(i).getDegreeClass().equals(s)) {
	    			check += finalists.get(i)+ System.lineSeparator();
	    			list.add(new Finalist(finalists.get(i).getId(), finalists.get(i).getDegreeMark()));
	    			finalistsToFile2(list, s+"finalist.txt");
	    		}
	    		else { 
	    			check += "";
	    		}
	    	}
	    	if (check.equals(""))
	    		System.out.println("No candidate found with degree class "+ s + System.lineSeparator());
	    	else 
	    		System.out.print(check);
	 }

	public static void main(String[] args) throws Exception{
 System.out.println("/****************************************************/");
		 System.out.println("/*******finalistsInList with invalid file name*******/");
		 System.out.println();
		 ArrayList<Finalist> testList = finalistsInList("***.txt");//find out what happens with an invalid file name
		 System.out.println();
		 System.out.println("/****************************************************/");
		 System.out.println("/********finalistsInList with valid file name********/");
		 System.out.println("/********display to check arraylist populated********/");
		 System.out.println();
		 ArrayList<Finalist> finalists = finalistsInList("finalMark.txt");//populate an arraylist of finalist from the file
		 displayFinalists(finalists); //check above successful
		 System.out.println();
		 System.out.println("/****************************************************/");
		 System.out.println("/*testing findFinalistID with valid and invalid data*/");
		 System.out.println();
		 findFinalistID(finalists, "75021");  //eheck method finds
		 findFinalistID(finalists, "21050");     //check no false positives, and not found message
		 System.out.println();
		 System.out.println("/****************************************************/");
		 System.out.println("/*test findFinalistClass with valid and invalid data*/");
		 System.out.println();
		 findFinalistClass(finalists, "FIRST"); //check method finds
		 findFinalistClass(finalists, "THIRD"); //check no false positives, and not found message
		 System.out.println();
		 System.out.println("/****************************************************/");
		 System.out.println("/*****run sortedFinalists then test with display*****/");
		 System.out.println();
		 ArrayList<Finalist> sortedFinalists = sortDegreeMark(finalists); //make an arraylist of Finalist sorted by degreeMark
		 displayFinalists(sortedFinalists); //test that the sorting worked
		 System.out.println();
		 System.out.println("/****************************************************/");
		 System.out.println("/*****test finalistsToFile2 with sorted arraylist*****/");
		 System.out.println("/**************check file testSorted.txt**************/");
		 System.out.println();
		 finalistsToFile2(sortedFinalists, "textSorted.txt"); //save the sorted arraylist to a new file, check by opening file
		 System.out.println();
		 System.out.println("/****************************************************/");
		 System.out.println("/*test findAndSaveFinalistClass with valid and invalid data*/");
		 System.out.println();
		 findAndSaveFinalistClass(finalists, "FIRST"); //test method finds
		 findAndSaveFinalistClass(finalists, "THRID"); //check appropriate error message when nothing found, open new text file
		 System.out.println();
		 System.out.println("/*********************THE END************************/");
	 }






}
