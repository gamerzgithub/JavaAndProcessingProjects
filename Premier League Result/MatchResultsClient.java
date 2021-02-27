/*Done by
 *Name: Wong Dan Ning
 *UOL Student Number: 17*****46
 */

import java.io.*;
import java.net.*;
import java.util.ArrayList;

public class MatchResultsClient {

	final int PORT = 6006;

	Socket socket;

	public void go(String host) {
		System.out.println("Contacting " + host + " on port " + PORT);
		try {
			socket = new Socket("localhost", PORT);
			deserialize(socket.getInputStream());
			socket.close();
		} catch (IOException e) {
			System.err.println("Error, IOException caught when creating input stream.");
			e.printStackTrace();
		}
		
	}

	public static ArrayList<DatedMatchResultV2> deserialize(InputStream inputStream) {
		ArrayList<DatedMatchResultV2> results = null;
		try {
			ObjectInputStream ois = new ObjectInputStream(inputStream);

			try {
				results = (ArrayList<DatedMatchResultV2>) ois.readObject();
				for (DatedMatchResultV2 i : results) {
					System.out.println(i);
				}
			} catch (ClassNotFoundException e) {
				System.err.println("Error, class of the object not found.");
				e.printStackTrace();
			} catch (IOException e) {
				System.err.println("Error, caught IOException when reading object from ObjectInputStream.");
				e.printStackTrace();
			}
			ois.close();
		} catch (IOException e) {
		}
		return results;
	}

	public static void main(String[] args) {
		new MatchResultsClient().go("localhost");
	}
}
