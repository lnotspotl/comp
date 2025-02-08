%{
#include <stdio.h>
#include <iostream>
#include <math.h>

#define print quiet

void quiet(const char *, ...) {
}
  
%}


%option noyywrap
%option debug

%% // begin tokens

[ \n\t]    // ignore a space, a tab, a newline

[Rr][0-7]  {printf("REG: %d ", atoi(yytext+1));}

[0-9]+    {printf("IMM: %d ", atoi(yytext));}
          
"="          {printf("ASSIGN ");}

;          {printf("SEMI ");}

"("        {printf("LPAREN ");}

")"        {printf("RPAREN ");}

"["        {printf("LBRACKET ");}

"]"        {printf("RBRACKET ");}

"-"        {printf("MINUS ");}

"+"        { printf("PLUS "); }  

"*"        { printf("MULTIPLY "); }

"%"        { printf("MOD "); }

"/"        { printf("DIVIDE "); }


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
