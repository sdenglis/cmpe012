##########################################################################
# Created by:  English, Samuel
#              sdenglis
#              18 February 2019
# Assignment:  Lab 4: ASCII conversion
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Winter 2019
# Description: This program converts user ASCII string input into a base(4) integer
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################
# REGISTER USAGE
# $ra: Return to caller when fitting procedures into code.
# $s0: Stores summation of $s1 & $s2 values.
# $s1: Holds 32-bit 2SC of first value.
# $s2: Holds 32-bit 2SC of second value.
# $t0: Temporary Register.
# $t1: Temporary Register.
# $v0: Syscall Register.
# $a0: Arguments register.

# PSEUDO CODE
# Obtain user input for first string of ASCII characters.
# Obtain user input for second string of ASCII characters.
# Print input feedback with prompt.
# Convert each string into 32-bit two's compliment numbers.
# Perform addition operation and store sum into $s0.
# Convert resultant value and manipulate into a base(4) signed integer.
# Print final signed magnitude to display with no leading 0's.

.data
	feedback:    .asciiz "You entered the numbers:\n"
	# Maximum size of input is 8 bits for binary value + 2-bit 0b preface.
	userInput_1: .space 10
	userInput_2: .space 10
	# New line character
	newLine:     .asciiz "\n"
	space:       .asciiz " "
.text
	main:
	# Obtain user input in form of text (1).
	li $v0, 8
	la $a0, userInput_1
	# Maximum allowed input size.
	li $a1, 10
	syscall
	
	# Prints a new line.
	li $v0, 4
	la $a0, newLine
	syscall

	# Obtain user input in form of text (2).
	li $v0, 8
	la $a0, userInput_2
	# Maximum allowed input size.
	li $a1, 10
	syscall
	
	# Prints a new line.
	li $v0, 4
	la $a0, newLine
	syscall
	
	# Displays feedback prompt.
	li $v0, 4
	la $a0, feedback
	syscall
	
	# Displays userInput_1.
	li $v0, 4
	la $a0, userInput_1
	syscall
	
	# Prints a space character.
	li $v0, 4
	la $a0, space
	syscall
	
	# Displays userInput_2.
	li $v0, 4
	la $a0, userInput_2
	syscall
	
	# Tell the program to terminate main command.
	li $v0, 10
	syscall
	
	
##########################################################################
# PROCEDURE LABELS

	# Prints a new line character.
	printLine:
	li $v0, 4
	la $a0, newLine
	syscall
	jr $ra
	
	# Prints a space character.
	printSpace:
	li $v0, 4
	la $a0, space
	syscall
	jr $ra
