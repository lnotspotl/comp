%{
#include <stdio.h>
#include <iostream>
#include <math.h>
#include "expr.y.hpp"

#define printf quiet

void quiet(const char *, ...) {
}
  
%}


%option noyywrap

%% // begin tokens

[ \n\t]    // ignore a space, a tab, a newline

[Rr][0-7]  {printf("REG: %d ", atoi(yytext+1)); yylval.reg_val = atoi(yytext+1); return REG;}

[0-9]+    {printf("IMMEDIATE: %d ", atoi(yytext)); yylval.immediate = atoi(yytext); return IMMEDIATE;}
          
"="          {printf("ASSIGN "); return ASSIGN;}

;          {printf("SEMI "); return SEMI;}

"("        {printf("LPAREN "); return LPAREN;}

")"        {printf("RPAREN "); return RPAREN;}

"["        {printf("LBRACKET "); return LBRACKET;}

"]"        {printf("RBRACKET "); return RBRACKET;}

"-"        {printf("MINUS "); return MINUS;}

"+"        { printf("PLUS "); return PLUS;}  

"//".*\n  {printf("COMMENT");}


%% // end tokens


// put more C code that I want in the final scanner

#ifdef SCANNER_ONLY

// This is the main function when we compile just the scanner: make scanner
int main(int argc, char *argv[])
{
  // all the rules above are combined into a single function called yylex, we call it to trigger
  // the scanner to read the input and match tokens:

  yylex();
  // yylex has a return value, but we ignore it for now.
 
  return 0;
}

#endif
