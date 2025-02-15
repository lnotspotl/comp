%{
#include <cstdio>
#include <list>
#include <map>
#include <iostream>
#include <string>
#include <memory>
#include <stdexcept>

#define MYDEBUG
template<typename ... Args>
void debug_print(Args ... args) {
  #ifdef MYDEBUG
  printf(args ...);
  #endif
}


extern FILE *yyin;
int yylex();
void yyerror(const char*);

extern "C" {
  int yyparse();
}

// helper code 
template<typename ... Args>
std::string format( const std::string& format, Args ... args )
{
    size_t size = snprintf( nullptr, 0, format.c_str(), args ... ) + 1; // Extra space for '\0'
    if( size <= 0 ){ throw std::runtime_error( "Error during formatting." ); }
    std::unique_ptr<char[]> buf( new char[ size ] ); 
    snprintf( buf.get(), size, format.c_str(), args ... );
    return std::string( buf.get(), buf.get() + size - 1 ); // We don't want the '\0' inside
}

int getReg() {
  static int cnt = 8;
  return cnt++;
}
 
%}

%verbose
%define parse.trace

%union {
  int reg;
  int imm;
  int arg;
}
// Put this after %union and %token directives

%type <reg> expr
%token <reg> REG
%token <imm> IMMEDIATE
%token <arg> ARGUMENT
%token ASSIGN SEMI PLUS MINUS LPAREN RPAREN LBRACKET RBRACKET RETURN

%type expr

%left  PLUS MINUS

%%

program:   REG ASSIGN expr SEMI
{
  debug_print("R%d = %d\n", $1, $3);
}
| program REG ASSIGN expr SEMI
{
  debug_print("R%d = %d\n", $2, $4);
}
| program RETURN REG SEMI
{
  debug_print("RETURN %d\n", $3);
}
;

expr: IMMEDIATE
{
  debug_print("expr: %d\n", $1);
}
| REG
{ 
  debug_print("expr: %d\n", $1);
}
| ARGUMENT
{
  debug_print("expr: %d\n", $1);
}
| expr PLUS expr
{
  debug_print("expr: %d\n", $1);
}
| expr MINUS expr
{
  debug_print("expr: %d\n", $1);
}
| LPAREN expr RPAREN
{
  debug_print("expr: %d\n", $2);
}
| MINUS expr
{
  debug_print("expr: %d\n", $2);
}
| LBRACKET expr RBRACKET
{
  debug_print("expr: %d\n", $2);
}
;

%%

void yyerror(const char* msg)
{
  printf("%s",msg);
}

int main(int argc, char *argv[])
{
  yydebug = 0;
  yyin = stdin; // get input from screen

  if (yyparse()==0) {
    // parse successful!
    
  }
  
  return 0;
}
