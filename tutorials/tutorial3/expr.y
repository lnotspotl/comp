%{
#include <cstdio>
#include <list>
#include <map>
#include <iostream>
#include <string>
#include <memory>
#include <stdexcept>

#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Value.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/IRBuilder.h>

#include <llvm/Bitcode/BitcodeReader.h>
#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/Support/SystemUtils.h>
#include <llvm/Support/ToolOutputFile.h>
#include <llvm/Support/FileSystem.h>

using namespace llvm;

static LLVMContext TheContext;
static IRBuilder<> Builder(TheContext);

Value *regs[8] = {NULL};


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
  Value *val;
}
// Put this after %union and %token directives

%type <val> expr
%token <reg> REG ARGUMENT
%token <imm> IMMEDIATE
%token ASSIGN SEMI PLUS MINUS LPAREN RPAREN LBRACKET RBRACKET RETURN

%type expr

%left  PLUS MINUS

%%

program:   REG ASSIGN expr SEMI
{
  regs[$1] = $3;
}
| program REG ASSIGN expr SEMI
{
  regs[$2] = $4;
}
| program RETURN REG SEMI
{
  debug_print("RETURN %d\n", $3);
  Builder.CreateRet(regs[$3]);
  return 0; // exit parser
}
;
expr: IMMEDIATE
{
  $$ = Builder.getInt32($1);
}
| REG
{ 
  $$ = regs[$1];
}
| ARGUMENT
{
  $$ = regs[$1];
}
| expr PLUS expr
{
  $$ = Builder.CreateAdd($1, $3);
}
| expr MINUS expr
{
  $$ = Builder.CreateSub($1, $3);
}
| LPAREN expr RPAREN
{
  $$ = $2;
}
| MINUS expr
{
  $$ = Builder.CreateNeg($2);
}
| LBRACKET expr RBRACKET
{
  $$ = Builder.CreateLoad(Builder.getInt32Ty(),$2);
}
;

%%

void yyerror(const char* msg)
{
  printf("%s",msg);
}

int main() {

  Module *M = new Module("Tutorial3", TheContext);
  Type *i32 = Builder.getInt32Ty();
  std::vector<Type*> args = {i32,i32,i32,i32};

  // Create void function type with no arguments
  FunctionType *FunType = FunctionType::get(Builder.getInt32Ty(),args,false);

  // Create a main function
  Function *Function = Function::Create(FunType, GlobalValue::ExternalLinkage, "myfunction",M);

  //Add a basic block to main to hold instructions
  BasicBlock *BB = BasicBlock::Create(TheContext, "entry", Function);
  // Ask builder to place new instructions at end of the
  // basic block
  Builder.SetInsertPoint(BB);

  yydebug = 0;
  yyin = stdin;
  // yyparse() triggers parsing of the input
  if (yyparse()==0) {
    // all is good
    std::error_code EC;
    raw_fd_ostream OS("main.bc",EC,sys::fs::OF_None);
    WriteBitcodeToFile(*M,OS);

    // Dump LLVM IR to the screen for debugging                                                                                                
    M->print(errs(),nullptr,false,true);
  } else {
    printf("There was a problem! Read error messages above.\n");
  }
  return 0;
}
