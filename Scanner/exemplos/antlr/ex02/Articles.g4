lexer grammar Articles;

ARTICLE : 'a'|'an'|'the';
OTHER   : [a-zA-Z]+;
WS      : [ \t\r\n]+ -> skip ;
