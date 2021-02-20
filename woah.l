
%{
     #define FLEX_DEBUG 1
     #include "compiler.h"
     #include <stdio.h>
     #include <stdlib.h>

     char str_buf[256];
     int error_counter = 0;

     void token_print(int token_id);
     int str_to_int(char *str);
     void yyerror (const char* err);

%}

%option noyywrap


%option case-insensitive

%option yylineno

%x STRING
%x SINGLE_LINE_COMMENT

DIGIT          [0-9]
LETTER         [A-Z]
LPHANUM       {LETTER}{DIGIT}
ALPHANUM_      [a-zA-Z0-9_]
 
IDENTIFIER     _?{LETTER}{ALPHANUM_}*
ICONST         (0H[1-9][0-9]*[A-F]*)|(0B[1]*[0-1]*)|([1-9][0-9]*)|0
RCONST         ([1-9][0-9]*|0)?\.[0-9]+
CCONST		    '(([^\\])|(\\[ntfrbv]))'





%%

"FUNCTION"                  { token_print(T_FUNCTION); return T_FUNCTION; }
"SUBROUTINE"                { token_print(T_SUBROUTINE); return T_SUBROUTINE; }
"END"                       { token_print(T_END); return T_END; }
"INTEGER"                   { token_print(T_INTEGER); return T_INTEGER; }
"REAL"                      { token_print(T_REAL); return T_REAL; }
"LOGICAL"                   { token_print(T_LOGICAL); return T_LOGICAL; }
"CHARACTER"                 { token_print(T_CHARACTER); return T_CHARACTER; }
"RECORD"                    { token_print(T_RECORD); return T_RECORD; }
"ENDREC"                    { token_print(T_ENDREC); return T_ENDREC; }
"DATA"                      { token_print(T_DATA); return T_DATA; }
"CONTINUE"                  { token_print(T_CONTINUE); return T_CONTINUE; }
"GOTO"                      { token_print(T_GOTO); return T_GOTO; }
"CALL"                      { token_print(T_CALL); return T_CALL; }
"READ"                      { token_print(T_READ); return T_READ; }
"WRITE"                     { token_print(T_WRITE); return T_WRITE; }
"IF"                        { token_print(T_IF); return T_IF; }
"THEN"                      { token_print(T_THEN); return T_THEN; }
"ELSE"                      { token_print(T_ELSE); return T_ELSE; }
"ENDIF"                     { token_print(T_ENDIF); return T_ENDIF; }
"DO"                        { token_print(T_DO); return T_DO; }
"ENDDO"                     { token_print(T_ENDDO); return T_ENDDO; }
"STOP"                      { token_print(T_STOP); return T_STOP; }
"RETURN"                    { token_print(T_RETURN); return T_RETURN; }

{IDENTIFIER}                {token_print(T_ID); return T_ID;}


{ICONST}                    {token_print(T_ICONST); return T_ICONST;}
{RCONST}                    {token_print(T_RCONST); return T_RCONST;}
{CCONST}                    {token_print(T_CCONST); return T_CCONST;}




\"                          { strcpy(str_buf, ""); BEGIN(STRING);  }
<STRING>\"                  { BEGIN(INITIAL); printf("Found String: '%s'  \n", str_buf); return T_SCONST; }
<STRING>(\\\n|\\\r\n)       { }
<STRING>(\\.|[^"\\])        {if(strlen(yytext) == 2){
                                if(strcmp(yytext, "\\n") == 0 ){
                                    strcat(str_buf, "\n");
                                }else if (strcmp(yytext, "\\t") == 0){
                                    strcat(str_buf, "\t");
                                }else if (strcmp(yytext, "\\r") == 0){
                                    strcat(str_buf, "\r");
                                }else if (strcmp(yytext, "\\f") == 0){
                                    strcat(str_buf, "\f");
                                }else if (strcmp(yytext, "\\b") == 0){
                                    strcat(str_buf, "\b");
                                }else if (strcmp(yytext, "\\v") == 0){
                                    strcat(str_buf, "\v");
                                }
                                }else{
                                    strcat(str_buf, &yytext[1]);
                                }

                                                     

                             }
<STRING>(\n|\r\n)           {yyerror("New line found without \\."); }
<STRING><<EOF>>             {yyerror("End of String without closing it."); }
<STRING>.                   {yyerror("Unknown Character."); }



"$"                                         {printf("Comment found\n"); BEGIN(SINGLE_LINE_COMMENT); }
<SINGLE_LINE_COMMENT>(\n|\r\n)              { BEGIN(INITIAL); printf("Cooment ended\n"); }
<SINGLE_LINE_COMMENT>.                      { }





".TRUE."|".FALSE."                                              {token_print(T_LCONST); return T_LCONST; }
".OR."                                                          {token_print(T_OROP); return T_OROP;  }
".AND."                                                         {token_print(T_ANDOP); return T_ANDOP; }
".NOT."                                                         {token_print(T_NOTOP); return T_NOTOP; }
".GT."|".GE."|".LT."|".LE."|".EQ."|".NE."                       {token_print(T_RELOP); return T_RELOP; }
"+"|"-"             	                                        { token_print(T_ADDOP); return T_ADDOP; }
"*"                                                             { token_print(T_MULOP); return T_MULOP; }
"/"                                                             { token_print(T_DIVOP); return T_DIVOP; }
"**"                                                            { token_print(T_POWEROP); return T_POWEROP; }



"("                                                             {token_print(T_LPAREN);  return  T_LPAREN;  } 
")"                                                             {token_print(T_RPAREN);  return  T_RPAREN;  }
 ","                                                            {token_print(T_COMMA);  return   T_COMMA;  }
"="                                                             {token_print(T_ASSIGN);  return  T_ASSIGN;  }
":"                                                             {token_print(T_COLON);  return  T_COLON;  }


[ \t]                                                           {   }
[\n]                                                            {   }
\r\n                                                            {   }

<<EOF>>                                                         { token_print(T_EOF); return T_EOF; }
.                                                               {yyerror("Unrecognised Character"); }


%%



int main(int argc, char* argv[]){
     int token;
     
     if(argc>1){
         yyin = fopen(argv[1], "r");
         if(yyin == NULL ){
             perror("[ERROR] Could not open file");
             return EXIT_FAILURE;
         }
     }

     do{
         token = yylex();
     }while(token != T_EOF );

     fclose(yyin);
     yyterminate();
}

void token_print(int token_id) {
	
	if (FLEX_DEBUG == 0) return;
	

	if(token_id == T_ICONST) { 
		printf("[LINE %d] INTEGER TOKEN \'%s\' (%d). Base 10: %d\n", yylineno, yytext, token_id, str_to_int(yytext));
	} else if(token_id == T_RCONST) {
		printf("[LINE %d] FLOATING TOKEN \'%s\' (%d). Base 10: ____\n", yylineno, yytext, token_id);
	}else {
		printf("[LINE %d] TOKEN \'%s\' (%d)\n", yylineno, yytext, token_id);
	}
}

int str_to_int(char *str) {
	if(strncmp(str, "0H", 2) == 0) { 
		return (int) strtoll(&str[2], NULL, 16);
	}else if(strncmp(str, "0B", 2) == 0) { 
		return (int) strtoll(&str[2], NULL, 2);
	}
	else {
		return (int) strtoll(str, NULL, 10);
	}
} 


void yyerror(const char* err) {
	error_counter++;
	printf("[ERROR - LINE %d] %s\n", yylineno, err);

	if(error_counter == 5) {
		printf("MAXIMUM ERRORS FOUND\n");
		exit(EXIT_FAILURE);
	    }

	yyless(1); 
}