import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.Token;

public class ArticlesUsage {
	public static void main(String[] args) {
		scan("Hi, this is a test!");
	}

	public static void scan(String text) {
		CharStream stream = new ANTLRInputStream(text);
		Lexer lexer = new Articles(stream);
		for (Token token : lexer.getAllTokens()) {
                    if (token.getType() == Articles.ARTICLE) {
			System.out.println(token.getText() + ": eh um artigo.");
                    } else if (token.getType() == Articles.OTHER) {
                        System.out.println(token.getText() + ": ???");
                    }
                }
	}
}
