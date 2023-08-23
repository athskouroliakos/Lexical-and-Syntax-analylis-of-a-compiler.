# Lexical-and-Syntax-analylis-of-a-compiler.



Flex-Bison-Compiler

FORT500 is structured with complex commands, unlike the classic FORTRAN, which does not have such commands. FORT500 also supports document structures, like Pascal or C, but does not support common areas or variable equivalents. The FORT500 does not have the same rigor as the classic FORTRAN, and the gap plays the same role in the format as in modern programming languages. Finally, the FORT500 allows you to define subroutines in a single - external - level, like FORTRAN, but uses the stack for subroutine calling, allowing recursion.

The lexical analyzer should:

1.Return the LM code he finds every time he is called.

2.Return the names of the IDs it encounters, or alternatively enter the IDs it encounters in the Symbol Panel (PS), returning the pointer to the PS that corresponds to the current ID.

3.Return the values of the constants it encounters. For non-numeric constants return the string of the word it recognized.

4.Handle lexical analysis errors by printing a message containing the line number and the line of the input file in which it occurred. the error. To try to continue erasing the wrong character, and if that is not possible, then shut down.

5.For the purposes of this exercise to print properly all the values it returns, in addition to any error messages. For the construction of the LA you can use either the method of direct programming of the DM that you designed, or the meta-tool flex. The coding of the LMs should be done with the symbolism given in the description of the language you are translating. For for example, use the ID symbol to encrypt IDs. In case you use flex, the information that LA returns beyond the LM code must be returned via the yylval variable.This file is generated automatically.


B. The syntactic analyzer should:

1.Recognize or reject the program based on the grammar of the language. More specifically: In order to construct a deterministic syntactic analyzer for language, grammar must not be ambiguous. For this purpose the ambiguous grammar given to you must be converted to non-ambiguous in one of two ways: (a) Transform the language into non-ambiguous, or (b) use the priority and associativity of the language operators , so that the analysis leads to a unique syntactic tree. Alternatively, for some rules, in which the conflict that arises is always resolved in one direction - as in the case of the pending else, we prefer to impose this direction on the SA.

2.Handle syntax analysis errors by printing appropriate messages that include the line number and the line of the input file in which each error occurred. In particular: To recover from an error use the panic method in conjunction with the strategy of generating error rules for the most common errors, such as the absence of dividers. After the first error to continue the analysis up to a maximum of 5 errors.

3.Enter the program IDs in the PS, if they have not been entered by the word analyzer. It should also manage the scope of the program in the PS, according to the description of the language you are translating.

4.For the purposes of this exercise to print in an appropriate way the content of the PS at the end of each scope.
