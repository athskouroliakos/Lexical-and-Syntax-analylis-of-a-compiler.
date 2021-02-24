/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    T_EOF = 0,
    T_FUNCTION = 258,
    T_SUBROUTINE = 259,
    T_END = 260,
    T_INTEGER = 261,
    T_REAL = 262,
    T_LOGICAL = 263,
    T_CHARACTER = 264,
    T_RECORD = 265,
    T_ENDREC = 266,
    T_DATA = 267,
    T_CONTINUE = 268,
    T_GOTO = 269,
    T_CALL = 270,
    T_READ = 271,
    T_WRITE = 272,
    T_IF = 273,
    T_THEN = 274,
    T_ELSE = 275,
    T_ENDIF = 276,
    T_DO = 277,
    T_ENDDO = 278,
    T_STOP = 279,
    T_RETURN = 280,
    T_ID = 281,
    T_ICONST = 282,
    T_RCONST = 283,
    T_LCONST = 284,
    T_CCONST = 285,
    T_SCONST = 286,
    T_OROP = 287,
    T_ANDOP = 288,
    T_NOTOP = 289,
    T_RELOP = 290,
    T_ADDOP = 291,
    T_MULOP = 292,
    T_DIVOP = 293,
    T_POWEROP = 294,
    T_LPAREN = 295,
    T_RPAREN = 296,
    T_COMMA = 297,
    T_ASSIGN = 298,
    T_COLON = 299,
    T_EQUOP = 300
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 18 "parser.y" /* yacc.c:1909  */

    int intval;
    float floatval;
    char charval;
    char* strval;
    _Bool boolval;

#line 109 "parser.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
