import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
public class TestServer {

	public static void main(String[] args) throws IOException{
		final int PORT = 81;
		System.out.println("Creating server socket on port " + PORT);
		ServerSocket serverSocket = new ServerSocket(PORT);
		while (true) {
			Socket socket = serverSocket.accept();
			OutputStream os = socket.getOutputStream();
			PrintWriter pw = new PrintWriter(os, true);
			pw.println("What's you name?");

			BufferedReader br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			String str = br.readLine();
			if (str.equalsIgnoreCase("ryan"))
				pw.println("FUCK OFF");
			else
				pw.println("Oh hey man");
			pw.println();
			pw.close();
			socket.close();

			System.out.println("Just said hello to:" + str);
		}

	}

}
