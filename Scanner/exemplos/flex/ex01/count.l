%{
  #include<stdio.h>
  int lines = 0, chars = 0;
%}

%%
\n      { lines++; chars++; }
.       { chars++; }

%%
int main() {
  yylex();
  printf("Line count: %d, chars count: %d\n", lines, chars);
  return 0;
}
