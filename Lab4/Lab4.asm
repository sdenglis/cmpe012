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
# $t0: Temporary Register (usage varies depending on loop conditional).
# $t1: Temporary Register.
# $t2: Temporary Register.
# $t3: Temporary Register.
# $t4: Temporary Register.
# $t5: Temporary Register.
# $t6: Temporary Register (Usually used for loop counter).
# $t7: Temporary Register.
# $t8: Temporary Register.
# $t9: Temporary Register.
# $sp: Stack pointer used to push and pop items off the stack.
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
	output:      .asciiz "The sum in base 4 is:\n"

	# New line character
	newLine:     .asciiz "\n"
	# Space character
	space:       .asciiz " "
	# Null character
	null:        .asciiz ""
	# Negative sign
	negSign:     .asciiz "-"
	
	# Maximum size of input is 8 bits for binary value + 2-bit 0b preface.
	int_array:   .word 2      # or .space 8
	ascii_array: .space 8
	
	
	
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
	lb $t2, 1($a0)        # Stores the second byte of $a1 into $t2.
	li $v0, 4             # Print ASCII syscall
	syscall
	
	# Prints a new line character.
	li $v0, 4
	la $a0, newLine
	syscall
	
	# Prints a new line character.
	li $v0, 4
	la $a0, newLine
	syscall
	
	# Prints a new line character.
	li $v0, 4
	la $a0, output
	syscall
	
	
	
   stringSorter: nop
	
   hexCondition: nop
	beq $t1, 0x00000078, hexConvert1   # Check if x($s1) = x
	j hexConvert2
	
   hexConvert1: nop
   	li    $t9, 0	                   # initialize registers
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   
   	lw    $a0, 0($a1)
   
      hexASCII: nop
   	                                   # Subtract ASCII value
   	beq   $t6, 2, exitHex              # Counter register for 8 iterations
 
	lb    $t8, 0x02($a0)               # Load contents of $a0 offset by 2
   	bgt   $t8, 0x0000003A, letterCase  # If $t8 > number values, then evaluate based on letter criteria.
   	j     numberCase
   letterCase: nop
   	subi  $t8, $t8, 55               
	sb    $t8, int_array($t7)
   	
   	addi  $t7, $t7, 1	           # increment int_array address
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t6, $t6, 1                  # increment counter
   	
   	j     hexASCII                     # Jump to repeat loop
   numberCase: nop
   	subi  $t8, $t8, 0x30               # Subtract number value for ASCII
	sb    $t8, int_array($t7)     	   # Store converted value into int_array
	
	addi  $t7, $t7, 1	           # increment int_array address
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t6, $t6, 1                  # increment counter
   	
   	j     hexASCII                     # Jump to repeat loop
   	
   exitHex: nop
	li    $t9, 0
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   
   exitHEX: nop
   	beq   $t6, 2, forwards            # Counter register for 8 bytes
       
        lb    $t8, int_array($t7)         # i = lb($t0)
   	mul   $t9, $t9, 16                # RS = 16*RS
   	add   $t9, $t9, $t8               # RS = RS + i
   	addi  $t8, $t8, 1                 # $t0 + 1
   	
   	addi  $t7, $t7, 1		  # Add to int_array pointer
   	addi  $t6, $t6, 1                 # Add to counter
   	
   	j     exitHEX                     # Jump to repeat loop
	
   forwards: nop
   	sll   $t9, $t9, 24                # Shift left by 24 bits
   	sra   $s1, $t9, 24                # Sign extend $t9 and store resultant into $s1
   
   hexConvert2: nop
   	beq $t2, 0x00000078, HEXConvert2  # Check if x($s2) = x
	j onwards
	
   HEXConvert2: nop
   	li    $t9, 0	                  # initialize registers
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   
   	lw    $a0, 4($a1)
   
   hexASCII2: nop
   	# Subtract ASCII value
   	beq   $t6, 2, exitHex2             # Counter register for 8 iterations
 
	lb    $t8, 0x02($a0)               # Load contents of $a0 offset by 2
   	bgt   $t8, 0x0000003A, letterCase2 # If $t8 > number values, then evaluate based on letter criteria.
   	j     numberCase2
   letterCase2: nop
   	subi  $t8, $t8, 55               
	sb    $t8, int_array($t7)
   	
   	addi  $t7, $t7, 1	           # increment int_array address
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t6, $t6, 1                  # increment counter
   	
   	j     hexASCII2                    # Jump to repeat loop
   numberCase2: nop
   	subi  $t8, $t8, 0x30               # Subtract number value for ASCII
	sb    $t8, int_array($t7)      	   # Store converted value into int_array
	
	addi  $t7, $t7, 1	           # increment int_array address
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t6, $t6, 1                  # increment counter
   	
   	j     hexASCII2                    # Jump to repeat loop
   	
   exitHex2: nop
	li    $t9, 0
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   
   exitHEX2: nop
   	beq   $t6, 2, forwards2         # Counter register for 8 bytes
       
        lb    $t8, int_array($t7)       # i = lb($t0)
   	mul   $t9, $t9, 16              # RS = 16*RS
   	add   $t9, $t9, $t8             # RS = RS + i
   	addi  $t8, $t8, 1               # $t0 + 1
   	
   	addi  $t7, $t7, 1		# Add to int_array pointer
   	addi  $t6, $t6, 1               # Add to counter
   	
   	j     exitHEX2                  # Jump to repeat loop
	
   forwards2: nop
   	sll   $t9, $t9, 24              # Shift left by 24 bits
   	sra   $s2, $t9, 24              # Sign extend $t9 and store resultant into $s2

   onwards:
   
   
   
   binCondition: nop
	beq   $t1, 0x00000062, binConvert1   # Check if b($s1) = b
	j nextCase
   binConvert1: nop
	                                     # Reset registers to clear up space
   	li    $t9, 0
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   
   	lw    $a0, 0($a1)
   	
   binASCII: nop
   	# Subtract ASCII value
   	beq   $t6, 8, exitBin                # Counter register for 8 iterations
   	
	
	lb    $t8, 0x02($a0)                 # Load contents of $a0 offset by 2
   	subi  $t8, $t8, 0x30                 # Subtract number value for ASCII
	sb    $t8, int_array($t7)     	     # Store converted value into int_array
	
	addi  $t7, $t7, 1	             # increment int_array address
   	addi  $a0, $a0, 1	             # increment ASCII pointer
   	addi  $t6, $t6, 1                    # increment counter
   	
   	j     binASCII                       # Jump to repeat loop
   	
   exitBin: nop
	li    $t9, 0
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   	
   exitBIN: nop
   	beq   $t6, 8, continue              # Counter register for 8 bytes
       
        lb    $t8, int_array($t7)           # i = lb($t0)
   	mul   $t9, $t9, 2                   # RS = 2*RS
   	add   $t9, $t9, $t8                 # RS = RS + i
   	addi  $t8, $t8, 1                   # $t0 + 1
   	
   	addi  $t7, $t7, 1		    # Add to int_array pointer
   	addi  $t6, $t6, 1                   # Add to counter
   	
   	j     exitBIN                       # Jump to repeat loop
	                                    # Running Sum should equal the contents of register $t9
	
   continue: nop
   	sll   $t9, $t9, 24                  # Shift left by 24 bits
   	sra   $s1, $t9, 24                  # Sign extend $t9 and store resultant into $s1
   
   
   
   nextCase: nop
	beq   $t2, 0x00000062, binConvert2  # Check if b($s2) = b
	j     exitSorter
   binConvert2: nop
   	                                    # Reset registers to clear up space
   	li    $t9, 0
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   
   	lw    $a0, 4($a1)
   	
   binASCII2: nop
   	                                    # Subtract ASCII value
   	                                    # 0 ASCII - 0x30 = 0 Decimal
   	beq   $t6, 8, exitBin2              # Counter register for 8 iterations
	
	lb    $t8, 0x02($a0)                # Load contents of $a0 offset by 2
   	subi  $t8, $t8, 0x30                # Subtract number value for ASCII
	sb    $t8, int_array($t7)           # Store converted value into int_array
	
	addi  $t7, $t7, 1	            # increment int_array address
   	addi  $a0, $a0, 1	            # increment ASCII pointer
   	addi  $t6, $t6, 1                   # increment counter
   	
   	j     binASCII2                     # Jump to repeat loop
   	
   exitBin2: nop
	li    $t9, 0
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   	
   exitBIN2: nop
   	beq   $t6, 8, continue2         # Counter register for 8 bytes
       
        lb    $t8, int_array($t7)       # i = lb($t0)
   	mul   $t9, $t9, 2               # RS = 2*RS
   	add   $t9, $t9, $t8             # RS = RS + i
   	addi  $t8, $t8, 1               # $t0 + 1
   	
   	addi  $t7, $t7, 1               # Add to int_array pointer
   	addi  $t6, $t6, 1               # Add to counter
   	
   	j     exitBIN2                  # Jump to repeat loop
	                                # Running Sum should equal the contents of register $t9
	
   continue2: nop
   	sll   $t9, $t9, 24              # Shift left by 24 bits
   	sra   $s2, $t9, 24              # Sign extend $t9 and store resultant into $s2
   	
   exitSorter: nop
   	li    $t9, 0
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   
   	add   $s0, $s1, $s2
   	move  $t9, $s0
   	
   remainderLoop: nop
   	beq   $t9, 0, exitRemainder
   	div   $t9, $t9, 4

   	mfhi  $t8          # Remainer stored to stack
   	
   	blt $t8, 0, absolute
   	j skip
   absolute: nop
   	sub $t8, $zero, $t8
   skip: nop
   	
   	sw    $t8, 0($sp)
   	mflo  $t9          # Quotient carries to next iteration
   	addi  $sp, $sp, 4
   	addi  $t6, $t6, 1
   	j remainderLoop
   	
   exitRemainder: nop
   	beq   $t6, -1, ASCIIexit
   	lw    $a0, -4($sp)

   	sw    $a0, ascii_array($t7)
   	addi  $sp, $sp, -4
   	subi  $t6, $t6, 1
   	addi  $t7, $t7, 4
   	addi  $t5, $t5, 1
	
	j exitRemainder
   ASCIIexit: nop
   	li $a0, 0
   	li $t7, 0
   	li $t3, 0
   	li $t4, 1
   	   	
   	blt $s0, 0, negative
   	j ASCIIPRINT
   negative:
   	li $v0, 4
	la $a0, negSign
	syscall
   	
   	li $a0, 0
   	li $t7, 0
   	li $t3, 0
   	li $t4, 1
   	
   ASCIIPRINT: nop
	
	lw    $t3, ascii_array($t7)
   	addi  $t3, $t3, 0x30
   	beq   $t4, $t5, finalPrint
	sb    $t3, ascii_array($a0)    # Store converted value into int_array
	
	addi  $t7, $t7, 4	       # increment int_array address
   	addi  $a0, $a0, 1	       # increment ASCII pointer
   	addi  $t4, $t4, 1              # increment counter
   	
   	j     ASCIIPRINT               # Jump to repeat loop
   	
   finalPrint: nop
   
	la $a0 ascii_array
   	li $v0, 4
	syscall
	
   	li $v0, 4
   	la $a0 newLine
	syscall
   	
   	
   endProgram: nop
        # Tell the program to terminate main command.
	li $v0, 10
	syscall
