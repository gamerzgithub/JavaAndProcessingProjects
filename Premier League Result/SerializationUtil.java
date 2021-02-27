/*Done by
 *Name: Wong Dan Ning
 *UOL Student Number: 170282246
 */

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class SerializationUtil {

	private SerializationUtil(){
	}
	
    public static ArrayList<DatedMatchResult> deserialize(File file) throws FileNotFoundException, IOException, ClassNotFoundException {
        ArrayList<DatedMatchResult> clubs = null;
        ObjectInputStream in = new ObjectInputStream(new FileInputStream(file));
        clubs = (ArrayList<DatedMatchResult>) in.readObject(); //casting to a parameterized type (in this case ArrayList<DatedMatchResult>. DatedMatchResult is the parameterized type) will always result in an unchecked warning from the compiler.
        in.close();
        return clubs;
    }

	public static void serialize(File file, List<DatedMatchResult> result) throws FileNotFoundException, IOException, ClassNotFoundException {
		ArrayList<DatedMatchResult> matchResult = (ArrayList<DatedMatchResult>) result; 
		FileOutputStream fileOutputStream = new FileOutputStream(file);
		ObjectOutputStream objectOutputStream = new ObjectOutputStream(fileOutputStream);
		objectOutputStream.writeObject(matchResult);
		objectOutputStream.close();
	}
}
