import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.Token;

public class NaturaisUsage {
	public static void main(String[] args) {
		scan("0 123 0123");
	}

	public static void scan(String text) {
		CharStream stream = new ANTLRInputStream(text);
		Lexer lexer = new Naturais(stream);
		for (Token token : lexer.getAllTokens()) {
                    if (token.getType() == Naturais.NUMBER) {
			System.out.println("Encontrado numero: " + token.getText());
                    } else if (token.getType() == Naturais.NON_WS) {
                        System.out.println("Encontrado nao-numero: " + token.getText());
                    }
                }
	}
}
