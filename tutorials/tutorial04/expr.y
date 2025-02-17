%{
#include <cstdio>
#include <list>
#include <vector>
#include <map>
#include <iostream>
#include <string>
#include <memory>
#include <stdexcept>

#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/IRBuilder.h"

#include "llvm/Bitcode/BitcodeReader.h"
#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/Support/SystemUtils.h"
#include "llvm/Support/ToolOutputFile.h"
#include "llvm/Support/FileSystem.h"

using namespace llvm;
using namespace std;

static Module *M = nullptr;
static LLVMContext TheContext;
static IRBuilder<> Builder(TheContext);
  
extern FILE *yyin;
int yylex();
void yyerror(const char*);

extern "C" {
  int yyparse();
}
 
%}

// %verbose
// %define parse.trace

%union {
  int reg;
  int imm;
  Value *val;
}
// Put this after %union and %token directives

%type <args> arglist arglist_opt
%type <vals> exprlist exprlist_opt
%token <id> IDENTIFIER
%type <val> expr
%token <reg> REG
%token <reg> ARG
%token <imm> IMMEDIATE
%token ASSIGN SEMI PLUS MINUS LPAREN RPAREN LBRACE RBRACE COMMA MULTIPLY DIVIDE NOT IF WHILE
%token RETURN

%type expr

%right NOT
%left  MULTIPLY DIVIDE
%left  PLUS MINUS

%%

program : function
| program function
| program SEMI SEMI // end of file
{
  return 0;
}
;

function: IDENTIFIER LPAREN arglist_opt RPAREN LBRACE stmtlist RBRACE
;

arglist_opt : arglist
| %empty
;

arglist : IDENTIFIER
|  arglist COMMA IDENTIFIER
;

stmtlist :    stmt
           |  stmtlist stmt

;

stmt: IDENTIFIER ASSIGN expr SEMI              /* expression stmt */
| IF LPAREN expr RPAREN LBRACE stmtlist RBRACE   /*if stmt*/     
| WHILE LPAREN expr RPAREN LBRACE stmtlist RBRACE /*while stmt*/
| SEMI /* null stmt */
| RETURN expr SEMI
{
  Builder.CreateRet($2);
}
;

exprlist_opt : exprlist
| %empty
;

exprlist : expr
| exprlist COMMA expr
;

expr: IMMEDIATE
{
  Value *v = Builder.getInt32($1);
  $$ = v;
}
| IDENTIFIER
| IDENTIFIER LPAREN exprlist_opt RPAREN
| expr PLUS expr
{
  $$ = Builder.CreateAdd($1, $3);
}
| expr MINUS expr
{
  $$ = Builder.CreateSub($1, $3);
}
| expr MULTIPLY expr
{

}
| expr DIVIDE expr
{
  
}
| MINUS expr
{
  $$ = Builder.CreateNeg($2);
}
| NOT expr
{

}
| LPAREN expr RPAREN
{
  $$ = $2;
}
;

%%

void yyerror(const char* msg)
{
  printf("%s",msg);
}

int main(int argc, char *argv[])
{
  //yydebug = 0;
  yyin = stdin; // get input from screen

  // Make Module
  M = new Module("Tutorial4", TheContext);  
  
  if (yyparse()==0) {
    // parse successful!
    std::error_code EC;
    raw_fd_ostream OS("main.bc",EC,sys::fs::OF_None);
    WriteBitcodeToFile(*M,OS);

    // Dump LLVM IR to the screen for debugging                                                                                                
    M->print(errs(),nullptr,false,true);
  }
  
  return 0;
}
