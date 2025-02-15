%{
#include <stdio.h>
#include <iostream>
#include <math.h>

#include <llvm/IR/Value.h>
using namespace llvm;

#include "expr.y.hpp" 
%}

%option noyywrap

%% // begin tokens

[ \n\t]  // ignore a space, a tab, a newline

[Rr][0-9]+ {
              yylval.reg = atoi(yytext+1);
	           return REG;
           }
[Aa][0-3]+ {
              yylval.reg = atoi(yytext+1);
              return ARGUMENT;
           }
"return"   { 
              return RETURN;
           }
[0-9]+     { 
              yylval.imm = atoi(yytext);
              return IMMEDIATE;
           }
"="        { 
              return ASSIGN; }
;          { 
              return SEMI;
           }
"("        { 
              return LPAREN;
           }
")"        { 
              return RPAREN;
           } 
"["        { 
              return LBRACKET;
           } 
"]"        { 
              return RBRACKET;
           } 
"-"        { 
              return MINUS;
           } 
"+"        { 
              return PLUS;
           }

"//".*\n


%% // end tokens

// put more C code that I want in the final scanner
