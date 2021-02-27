import java.io.*;
import java.net.*;
import java.util.ArrayList;

public class ThreadedMatchResultsServer {

	final int PORT = 6006;
	
	public class ClientHandler implements Runnable {

		Socket socket;

		public ClientHandler(Socket clientSocket) {
			socket = clientSocket;
		}

		public void run() {

			try {
				ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
				ObjectInputStream ois = new ObjectInputStream(new FileInputStream("2017-18-PLResults.ser"));

				oos.writeObject((ArrayList<DatedMatchResultV2>)ois.readObject());

				ois.close();
				oos.close();
				socket.close();

			} catch (IOException e) {
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
		}
	}

		
	public void go() {

		boolean running = true;
		try {

			ServerSocket serverSocket = new ServerSocket(PORT);
			System.out.println("Server started on port " + PORT);

			while (running) {

					Socket clientSocket = serverSocket.accept();
					Thread t = new Thread(new ClientHandler(clientSocket));
					t.start();
			}

			serverSocket.close();
			System.out.println("Server closed");

		} catch (IOException e) {
		}
	}


		
	public static void main(String[] args) {

		ThreadedMatchResultsServer server = new ThreadedMatchResultsServer();
		server.go();
	}
}
