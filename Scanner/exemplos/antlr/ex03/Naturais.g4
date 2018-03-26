lexer grammar Naturais;

NUMBER : '0'|'1'..'9'('0'..'9')*;
NON_WS : ~(' '|'\t'|'\r'|'\n')+;
WS     : [ \t\r\n]+ -> skip ;
