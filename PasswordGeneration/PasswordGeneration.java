import java.util.*;
public class PasswordGeneration {
	public static void main(String[] args) {
		//test command line arguements really quick
		String i = args[0];
		int len = Integer.parseInt(i);
		len += 1;
		String Capital_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"; 
	    String Small_chars = "abcdefghijklmnopqrstuvwxyz"; 
	    String numbers = "0123456789"; 
	    String symbols = "!@#$%?";
	    
	    String values = Capital_chars + Small_chars + numbers + symbols;
	    Random rng = new Random();
	    String pswrd2 = "";
	    //build passwrd
	    for(int j = 0; j < len; j++) {
	    	pswrd2+=values.charAt(rng.nextInt(values.length()));
	    }
	    
	    System.out.println(pswrd2); //output RNG password
	}

}
