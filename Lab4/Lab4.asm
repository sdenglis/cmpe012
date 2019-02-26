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
# Convert ASCII hex -> hex -> binary -> signed integer.
# Subtract ASCII conversion value.
# Use division and modulo values to convert hex into binary.
# Use running sums to convert binary into signed integer.
# Convert ASCII binary -> binary -> signed integer.
# Subtract ASCII conversion value.
# Use running sums to convert binary into signed integer.
# Perform addition operation and store sum into $s0.
# Convert resultant value and manipulate into a base(4) signed integer.
# Convert signed integer -> base(4)
# Print final signed magnitude to display with no leading 0's.

.data	
	# Maximum size of input is 8 bits for binary value + 2-bit 0b preface.
	feedback:    .asciiz "You entered the numbers:\n"

	# New line character
	newLine:     .asciiz "\n"
	space:       .asciiz " "
.text
   main:
	# Displays feedback prompt.
	li $v0, 4
	la $a0, feedback
	syscall
	
	# Print user input.
	lw $a0, 4($a1)
	li $v0, 4
	
	lw $s1, 4($a1)
	syscall

	# Prints a space character.
	li $v0, 4
	la $a0, space
	syscall
	
	# Print second user input.
	lw $a0, 0($a1)
	li $v0, 4
	
	lw $s2, 0($a1)
	syscall
	
   string_sorter:

	li $t9, 0x00000078    # Store condition for hexadecimal check (x).
	li $t8, 0x00000062    # Store condition for binary check (b).
	li $t7, 0x00000030    # Stores condition for decimal check (=/= 0).
	
	lb $t1, 0x01($s1)     # Stores the second byte of $s1 into $t1.
	lb $t2, 0x01($s2)     # Stores the second byte of $s2 into $t2.
	lb $t3, 0x00($s1)     # Stores the first byte of $s1 into $t3.
	lb $t4, 0x00($s2)     # Stores the first byte of $s2 into $t4.
	
	
	
	bne $t3, $t7, dec_condition # Check if $s1 =/= decimal
	bne $t4, $t7, dec_condition # Check if $s2 =/= decimal
	
   dec_condition:
	beq $t1, $t9, hex_condition # Check if x($s1) = x
	beq $t2, $t9, hex_condition # Check if x($s2) = x
	
   hex_condition:
	beq $t1, $t8, bin_condition # Check if b($s1) = b
	beq $t2, $t8, bin_condition # Check if b($s2) = b
	
   bin_condition:
   
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
