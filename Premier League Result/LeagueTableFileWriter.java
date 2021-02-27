/*Done by
 *Name: Wong Dan Ning
 *UOL Student Number: 170282246
 */
import java.io.*;
import java.nio.charset.StandardCharsets;

public class LeagueTableFileWriter {
    public static void write(String league, File file) throws IOException {
			
    	FileOutputStream fos = new FileOutputStream(file);
    	OutputStreamWriter writer = new OutputStreamWriter(fos, "UTF-8"); 
    	
    	writer.write(league);
    	writer.close();
	}
}
