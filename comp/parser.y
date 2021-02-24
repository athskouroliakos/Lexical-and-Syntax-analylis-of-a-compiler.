%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdbool.h>
    #include "hashtbl.h"
    #include "hashtbl.c"

    extern FILE *yyin;
    extern int yylex();
    extern void yyerror(const char* err);

    HASHTBL *hashtbl;
    int scope = 0;
%}

%error-verbose

%union {
    int intval;
    float floatval;
    char charval;
    char* strval;
    _Bool boolval;
}

//Keywords
%token T_FUNCTION                  "function"
%token T_SUBROUTINE                "subroutine"
%token T_END                       "end"
%token T_INTEGER                   "integer"
%token T_REAL                      "real"
%token T_LOGICAL                   "logical"
%token T_CHARACTER                 "character"
%token T_RECORD                    "record"
%token T_ENDREC                    "endrec"
%token T_DATA                      "data"
%token T_CONTINUE                  "continue"
%token T_GOTO                      "goto"
%token T_CALL                      "call"
%token T_READ                      "read"
%token T_WRITE                     "write"
%token T_IF                        "if"
%token T_THEN                      "then"
%token T_ELSE                      "else"
%token T_ENDIF                     "endif"
%token T_DO                        "do"
%token T_ENDDO                     "endo"
%token T_STOP                      "stop"
%token T_RETURN                    "return"

//Identifier
%token <strval> T_ID               "identifier"


//Basic Constants
%token <intval>      T_ICONST      "iconst"
%token <floatval> T_RCONST         "rconst"
%token <boolval> T_LCONST          "lconst"
%token <charval> T_CCONST          "cconst"
%token <strval> T_SCONST           "sconst"

//Operators
%token T_OROP                      "||"
%token T_ANDOP                     "&&"
%token T_NOTOP                     "!"
%token T_RELOP                     "> or >= or < or == or !="
%token T_ADDOP                     "+ or -"
%token T_MULOP                     "*"
%token T_DIVOP                     "/"
%token T_POWEROP                   "**"


//Other Lexical Tokens
%token T_LPAREN                    "("
%token T_RPAREN                    ")"
%token T_COMMA                     ","
%token T_ASSIGN                    "="
%token T_COLON                     ":"
%token T_EOF             0         "EOF"

//%type <strval>  program body declarations type vars undef_variable dims dim fields field  vals value_list values expressions
//%type <strval>  value repeat constant statements  labeled_statement label statement simple_statement assignment variable
//%type <strval>  expression goto_statement labels if_statement subroutine_call io_statement read_list read_item iter_space
//%type <strval>  step write_list write_item compound_statement branch_statement tail loop_statement subprograms subprogram header formal_parameters

%right T_ASSIGN
%left  T_OROP
%left  T_ANDOP
%left  T_EQUOP
%left  T_RELOP
%left  T_ADDOP
%left  T_MULOP T_DIVOP
%left  T_POWEROP
%left  T_NOTOP




%%

program:               body T_END subprograms                                                           {hashtbl_get(hashtbl, scope);scope--;}
                        ;
body:                  declarations statements
                        ;
declarations:          declarations type vars
                        | declarations T_RECORD fields T_ENDREC vars
                        | declarations T_DATA vals
                        | %empty                                                                           { }
                        ;
type:                  T_INTEGER 
                        | T_REAL 
                        |T_LOGICAL 
                        | T_CHARACTER
                        ;
vars:                  vars T_COMMA undef_variable
                        | undef_variable
                        ;
undef_variable:        T_ID T_LPAREN dims T_RPAREN                                                         {hashtbl_insert(hashtbl,$1,NULL,scope);}
                        | T_ID                                                                             {hashtbl_insert(hashtbl,$1,NULL,scope);}
                         ;
dims:                  dims T_COMMA dim
                        | dim
                        ;
dim:                   T_ICONST 
                        | T_ID                                                                             {hashtbl_insert(hashtbl,$1,NULL,scope);}
                        ;
fields:                fields field
                        | field
                        ;
field:                 type vars
                        | T_RECORD fields T_ENDREC vars
                        ;
vals:                  vals T_COMMA T_ID value_list                                                         {hashtbl_insert(hashtbl,$3,NULL,scope);}
                        | T_ID value_list                                                                   {hashtbl_insert(hashtbl,$1,NULL,scope);}
                        ;
value_list:            T_DIVOP values T_DIVOP
                        ;
values:                values T_COMMA value
                        | value
                        ;
value:                 repeat T_MULOP T_ADDOP constant
                        | repeat T_MULOP constant
                        | repeat T_MULOP T_SCONST
                        | T_ADDOP constant
                        | constant
                        | T_SCONST
                        ;
repeat:                T_ICONST 
                        | %empty                                                                             { }
                        ;
constant:              T_ICONST 
                        | T_RCONST 
                        | T_LCONST 
                        | T_CCONST
                        ;
statements:            statements labeled_statement
                        | labeled_statement
                        ;
labeled_statement:     label statement
                        | statement
                        ;
label:                 T_ICONST
                        ;
statement:             simple_statement
                        | compound_statement
                        ;
simple_statement:      assignment
                        | goto_statement
                        | if_statement
                        | subroutine_call
                        | io_statement
                        | T_CONTINUE
                        | T_RETURN
                        | T_STOP
                        ;
assignment:            variable T_ASSIGN expression
                        | variable T_ASSIGN T_SCONST
                        ;
variable:              variable T_COLON T_ID                                                                   {hashtbl_insert(hashtbl,$3,NULL,scope);}
                        | variable T_LPAREN expressions T_RPAREN
                        | T_ID                                                                                 {hashtbl_insert(hashtbl,$1,NULL,scope);}
                        ;
expressions:           expressions T_COMMA expression
                        | expression
                        ;
expression:            expression T_OROP expression
                        | expression T_ANDOP expression
                        | expression T_RELOP expression
                        | expression T_ADDOP expression
                        | expression T_MULOP expression
                        | expression T_DIVOP expression
                        | expression T_POWEROP expression
                        | T_NOTOP expression
                        | T_ADDOP expression
                        | variable
                        | constant
                        | T_LPAREN expression T_RPAREN
                        ;
goto_statement:        T_GOTO label
                        | T_GOTO T_ID T_COMMA T_LPAREN labels T_RPAREN                                              {hashtbl_insert(hashtbl,$2,NULL,scope);}
                        ;
labels:                labels T_COMMA label
                        | label
                        ;
if_statement:          T_IF T_LPAREN expression T_RPAREN label T_COMMA label T_COMMA label                          {scope++; }                     
                        | T_IF T_LPAREN expression T_RPAREN simple_statement
                        ;
subroutine_call:       T_CALL variable                                                                             
                        ;
io_statement:          T_READ read_list
                        | T_WRITE write_list
                        ;
read_list:             read_list T_COMMA read_item
                        | read_item
                        ;
read_item:             variable
                        | T_LPAREN read_list T_COMMA T_ID T_ASSIGN iter_space T_RPAREN                          {hashtbl_insert(hashtbl,$4,NULL,scope);}
                        ;
iter_space:            expression T_COMMA expression step
                        ;
step:                  T_COMMA expression
                        | %empty                                                                                { }
                        ;
write_list:            write_list T_COMMA write_item
                        | write_item
                        ;
write_item:            expression
                        | T_LPAREN write_list T_COMMA T_ID T_ASSIGN iter_space T_RPAREN                          {hashtbl_insert(hashtbl,$4,NULL,scope);}
                        | T_SCONST
                        ;
compound_statement:    branch_statement
                        | loop_statement
                        ;
branch_statement:      T_IF T_LPAREN expression T_RPAREN T_THEN body tail                                           {scope++;}
                        | error T_LPAREN expression T_RPAREN T_THEN body tail                                       { yyerror("Wrong use of if_statement"); yyerrok; }
                        |T_IF error expression T_RPAREN T_THEN body tail                                             { yyerror("Wrong use of if_statement"); yyerrok; }                                         
                        |T_IF T_LPAREN expression T_RPAREN error body tail                                                 { yyerror("Wrong use of if_statement"); yyerrok; }  
                        ;
tail:                  T_ELSE body T_ENDIF                                                                               {scope++;}
                        | T_ENDIF                                                                                       { hashtbl_get(hashtbl,scope); scope--;}
                        ;
loop_statement:        T_DO T_ID T_ASSIGN iter_space body T_ENDDO                               {scope++ ;}             {hashtbl_insert(hashtbl,$2,NULL,scope);}   { hashtbl_get(hashtbl,scope); scope--;}
                        ;
subprograms:           subprograms subprogram
                        | %empty                                                                                    { }
                        ;
subprogram:            header body T_END                                                                                { hashtbl_get(hashtbl,scope); scope--;}
                        ;
header:                type T_FUNCTION T_ID T_LPAREN formal_parameters T_RPAREN                                   {scope++;}  {hashtbl_insert(hashtbl,$3,NULL,scope);}
                        | T_SUBROUTINE T_ID T_LPAREN formal_parameters T_RPAREN                                    {hashtbl_insert(hashtbl,$2,NULL,scope);}
                        | T_SUBROUTINE T_ID                                                                         {hashtbl_insert(hashtbl,$2,NULL,scope);}
                        ;
formal_parameters:     type vars T_COMMA formal_parameters
                        | type vars
                        ;



%%

int main(int argc, char* argv[]){
     int token;

     if (!(hashtbl = hashtbl_create(10, NULL))){
        puts("Error, failed to initialize hashtable");
        exit(EXIT_FAILURE);
    }
     
     if(argc>1){
         yyin = fopen(argv[1], "r");
         if(yyin == NULL ){
             perror("[ERROR] Could not open file");
             return EXIT_FAILURE;
         }
     }

     yyparse();

     fclose(yyin);
     hashtbl_destroy(hashtbl);
     return 0; 
}