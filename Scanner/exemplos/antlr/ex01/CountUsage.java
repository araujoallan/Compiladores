import java.io.IOException;
import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.Token;

public class CountUsage {
	public static void main(String[] args) {
		scan(args[0]);
	}

	public static void scan(String filename) {
                int lines = 0;
                int chars = 0;
                CharStream stream = null;
                try {
                     stream = new ANTLRFileStream(filename);
                } catch (IOException e) {
                    // empty
                }
		Lexer lexer = new Count(stream);
		for (Token token : lexer.getAllTokens()) {
			if (token.getType() == Count.NEWLINE) {
                            lines++;
                            chars++;
			} else  if (token.getType() == Count.ANYCHAR) {
                            chars++;
			}
		}
		System.out.println("Line count: " + lines + ", chars count: " + chars);
	}
}
