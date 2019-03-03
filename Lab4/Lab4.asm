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
# REGISTER USAGE:
#
# $ra: Return to caller when fitting procedures into code.
# $s0: Stores summation of $s1 & $s2 values.
# $s1: Holds 32-bit 2SC of first value.
# $s2: Holds 32-bit 2SC of second value.
# $t0: Temporary Register.
# $t1: Temporary Register.
# $v0: Syscall Register.
# $a0: Arguments register.
#
##########################################################################
# PSEUDO CODE:
#
# Obtain user input for first string of ASCII characters.
# Obtain user input for second string of ASCII characters.
# Print input feedback with prompt.
# Convert each string into 32-bit two's compliment numbers.
# Convert ASCII -> hex -> signed decimal.
   # Subtract ASCII conversion value.
   # Use running sums to convert binary into signed integer.
# Convert ASCII -> binary -> signed decimal.
   # Subtract ASCII conversion value.
   # Use running sums to convert binary into signed integer.
# Perform addition operation and store sum into $s0.
# Convert resultant value and manipulate into a base(4) signed integer.
# Print final signed magnitude to display with no leading 0's.
#
##########################################################################



.data	
	feedback:    .asciiz "You entered the numbers:\n"

	# New line character
	newLine:     .asciiz "\n"
	# Space character
	space:       .asciiz " "
	# Null character
	null:        .asciiz ""
	
	# Maximum size of input is 8 bits for binary value + 2-bit 0b preface.
	testArray:   .space 8
	
.text
   main: nop
	# Prints feedback prompt.
	li $v0, 4
	la $a0, feedback
	syscall
	
	# Display user input.
	lw $a0, 0($a1)
	lb $t1, 0x01($a0)     # Stores the second byte of $a1 into $t1.
	li $v0, 4             # Print ASCII syscall
	syscall

	# Prints a space character.
	li $v0, 4
	la $a0, space
	syscall
	
	# Display second user input.
	lw $a0, 4($a1)
	lb $t2, 1($a0)     # Stores the second byte of $a1 into $t2.
	li $v0, 4           # Print ASCII syscall
	syscall
	
   stringSorter: nop
   
   	#beq   $t9, 8, exitLoad
   	#lw $a0, 0($a1)
	#lb $s1, 0x02($a0)
	#addi  $a1, $a1, 1
   #	addi  $t9, $t9, 1
   	
   	exitLoad:
	
   hexCondition: nop
	beq $t1, 0x00000078, hexConvert1 # Check if x($s1) = x
	beq $t2, 0x00000078, hexConvert2 # Check if x($s2) = x
	
   hexConvert1: nop
   hexConvert2: nop
   	# Subtract ASCII value
   	# 0 ASCII - 48 = 0 Decimal (0-9)
   	# A ASCII - 55 = 10 Decimal (A-F)
   	
   	# while (n=/= null char)
   	# i = lb($t0)
   	# RS = 16*RS
   	# RS = RS + i
   	# $t0 + 1
   	# jump top loop
   	
   	# Shift left upto MSB
   	# Shift right arithmetic to sign extend MSB
   	# Convert to signed decimal

   	
   binCondition: nop
	beq   $t1, 0x00000062, binConvert1 # Check if b($s1) = b
	beq   $t2, 0x00000062, binConvert2 # Check if b($s2) = b
	j     continue                     # Else not true, continue running program
	
	# Reset registers to clear up space
	li    $t9, 0
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0

   binConvert1: nop
   binConvert2: nop
   	# Subtract ASCII value
   	# 0 ASCII - 48 = 0 Decimal
   	beq   $t9, 8, exitBin           # Counter register for 8 bytes
   	
   	lw $a0, 0($a1)
	lb $s1, 0x02($a0)

   	subi  $s1, $s1, -48             # Subtract number value for ASCII -> decimal in $t8
	addi  $a0, $a0, 1
   	addi  $t9, $t9, 1
   	
   	j     binConvert2               # Jump to repeat loop
   	
   exitBin: nop
   	li    $t9, 0
   	la    $s2, 0($s1)
   exitBin2: nop
   	beq   $t9, 8, continue          # Counter register for 8 bytes
        lb    $t8, 2($s2)               # i = lb($t0)
   	mul   $t7, $t7, 2               # RS = 2*RS
   	add   $t7, $t7, $t8             # RS = RS + i
   	addi  $s2, $s2, 1               # $t0 + 1
   	addi  $t9, $t9, 1               # Add to counter
   	
   	j     exitBin2                   # Jump to repeat loop
  
   continue: nop
   	sll $t7, $t7, 24                # Shift left by 24 bits
   	sra $s2, $t7, 24                # Sign extend $t6 and store resultant into $s2
   	
   endProgram: nop
	# Tell the program to terminate main command.
	li $v0, 10
	syscall
	
	
##########################################################################
# PROCEDURE LABELS

	# Prints a new line character.
	printLine: nop
	li $v0, 4
	la $a0, newLine
	syscall
	jr $ra
	
	# Prints a space character.
	printSpace: nop
	li $v0, 4
	la $a0, space
	syscall
	jr $ra
