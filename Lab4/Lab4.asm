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
# $ra: Return to caller when fitting procedures into code.
# $s0: Stores summation of $s1 & $s2 values.
# $s1: Holds 32-bit 2SC of first value.
# $s2: Holds 32-bit 2SC of second value.
# $t0: Temporary Register (usage varies depending on loop conditional).
# $t1: Temporary Register is used.
# $t2: Temporary Register is used.
# $t3: Temporary Register is used.
# $t4: Temporary Register is used.
# $t5: Temporary Register is used.
# $t6: Temporary Register (usually used for loop counter).
# $t7: Temporary Register (int_array address pointer).
# $t8: Temporary Register is used.
# $t9: Temporary Register is used.
# $sp: Stack pointer used to push and pop items off the stack.
# $v0: Syscall Register, used for syscalls.
# $a0: Arguments register (used mostly for ASCII pointer address).
##########################################################################
# PSEUDO CODE:
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
	
	# Maximum size of input
	int_array:   .word 2               # or .space 8, stores integer values.
	ascii_array: .space 8              # Used to transfer and store ASCII values.
	
	
	
.text
   main: nop
	# Prints feedback prompt.
	li $v0, 4
	la $a0, feedback
	syscall
	
	# Display user input.
	lw $a0, 0($a1)
	lb $t1, 0x01($a0)
	lb $t3, 0($a0)
	li $v0, 4                          # Print ASCII syscall
	syscall

	# Prints a space character.
	li $v0, 4
	la $a0, space
	syscall
	
	# Display second user input.
	lw $a0, 4($a1)
	lb $t2, 1($a0)   
	lb $t4, 0($a0)                     # Stores the second portion of $a0 into $t2
	li $v0, 4                          # Print ASCII syscall
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
	
	
	
   decCondition: nop
	blt   $t1, 0x00000040, decConvert1
	j     nextDec
	
   decConvert1: nop
   	li    $t9, 0
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t0, 0
   	lw    $a0, 0($a1)
	beq   $t3, 0x0000002D, negDEC
	j     decASCII
	
   negDEC: nop
   	lb    $t8, 0x01($a0)   
   	beq   $t8, 0x00, exitDec
   	subi  $t8, $t8, 0x30               # Subtract number value for ASCII
	sb    $t8, int_array($t7)     	   # Store converted value into int_array
	
	addi  $t7, $t7, 1	           # increment int_array address
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t0, $t0, 1
   	
   	j     negDEC                       # Jump to repeat loop
   decASCII: nop
   	lb    $t8, 0x00($a0)   
   	beq   $t8, 0x00, exitDec
   	subi  $t8, $t8, 0x30               # Subtract number value for ASCII
	sb    $t8, int_array($t7)     	   # Store converted value into int_array
	
	addi  $t7, $t7, 1	           # increment int_array address
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t0, $t0, 1
   	
   	j     decASCII                     # Jump to repeat loop
   exitDec: nop
	li    $t9, 0                       # Reload registers.
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
   	
   exitDEC: nop
   	beq   $t6, $t0, contDec            # Counter register for 8 bytes
        
        lb    $t8, int_array($t7)          # i = lb($t0)
   	mul   $t9, $t9, 10                 # RS = 10*RS
   	add   $t9, $t9, $t8                # RS = RS + i
   	addi  $t8, $t8, 1                  # $t0 + 1
   	
   	addi  $t7, $t7, 1		   # Add to int_array pointer
   	addi  $t6, $t6, 1                  # Add to counter
   	
   	j     exitDEC                      # Jump to repeat loop
	                                   # Running Sum should equal the contents of register $t9
   contDec: nop
   	beq   $t3, 0x0000002D, negINV
   	j     elseShift
   	
   negINV: nop
   	nor   $t9, $t9, $t9
   	addi  $t9, $t9, 1
   
   elseShift: nop
   	sll   $t9, $t9, 24                 # Shift left by 24 bits
   	sra   $s1, $t9, 24                 # Sign extend $t9 and store resultant into $s1
	li    $t0, 1
	
   nextDec: nop
  	li    $t9, 0
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
   	lw    $a0, 0($a1)
	blt   $t2, 0x00000040, decConvert2
	j     nextDec2
	
   decConvert2: nop
   	beq   $t0, 1, DECIMAL
   	j     NOTDECIMAL
   	
   DECIMAL: nop
   	li    $t9, 0                       # Reload registers.
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t0, 0
   beq        $t4, 0x0000002D, NEGDEC2
	j     DECASCII2
	
   NEGDEC2: nop
   	lb    $t8, -3($a0)   
   	beq   $t8, 0x00, exitDec2
   	subi  $t8, $t8, 0x30               # Subtract number value for ASCII
	sb    $t8, int_array($t7)     	   # Store converted value into int_array
	
	addi  $t7, $t7, 1	           # increment int_array address
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t0, $t0, 1
   	
   	j     NEGDEC2                      # Jump to repeat loop
   
   DECASCII2: nop
   	lb    $t8, -3($a0)   
   	beq   $t8, 0x00, exitDec2
   	subi  $t8, $t8, 0x30               # Subtract number value for ASCII
	sb    $t8, int_array($t7)     	   # Store converted value into int_array
	
	addi  $t7, $t7, 1	           # increment int_array address
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t0, $t0, 1
   	
   	j     DECASCII2                    # Jump to repeat loop
  
    NOTDECIMAL: nop
   	li    $t9, 0                       # Reload registers.
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t0, 0
	beq   $t4, 0x0000002D, negDEC2
	j     decASCII2
  
    negDEC2: nop
   	lb    $t8, -3($a0)   
   	beq   $t8, 0x00, exitDec2
   	subi  $t8, $t8, 0x30               # Subtract number value for ASCII
	sb    $t8, int_array($t7)     	   # Store converted value into int_array
	
	addi  $t7, $t7, 1	           # increment int_array address
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t0, $t0, 1
   	
   	j     negDEC2                      # Jump to repeat loop
   
   decASCII2: nop
   	lb    $t8, -3($a0)   
   	beq   $t8, 0x00, exitDec2
   	subi  $t8, $t8, 0x30               # Subtract number value for ASCII
	sb    $t8, int_array($t7)     	   # Store converted value into int_array
	
	addi  $t7, $t7, 1	           # increment int_array address
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t0, $t0, 1
   	addi  $t6, $t6, 1
   	
   	j     decASCII2                    # Jump to repeat loop
   	
   exitDec2: nop
   	li    $t9, 0                       # Reload registers.
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
   	
   exitDEC2: nop
   	beq   $t6, $t0, contDec2           # Counter register for 8 bytes
       
        lb    $t8, int_array($t7)          # i = lb($t0)
   	mul   $t9, $t9, 10                 # RS = 10*RS
   	add   $t9, $t9, $t8                # RS = RS + i
   	addi  $t8, $t8, 1                  # $t0 + 1
   	
   	addi  $t7, $t7, 1		   # Add to int_array pointer
   	addi  $t6, $t6, 1                  # Add to counter
   	
   	j     exitDEC2                     # Jump to repeat loop

   contDec2: nop
   	beq   $t4, 0x0000002D, negINV2
   	j     elseShift2
   	
   negINV2: nop
   	nor   $t9, $t9, $t9
   	addi  $t9, $t9, 1
   
   elseShift2: nop
   	sll   $t9, $t9, 24                 # Shift left by 24 bits
   	sra   $s2, $t9, 24                 # Sign extend $t9 and store resultant into $s1
	
   nextDec2: nop
	
   stringSorter: nop
	
   hexCondition: nop
	beq   $t1, 0x00000078, hexConvert1 # Check if 0x01($a0) = x
	j     hexConvert2
	
   hexConvert1: nop
   	li    $t9, 0	                   # Initialize registers
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   	lw    $a0, 0($a1)                  # Prepare $a0 with full user input
   
   hexASCII: nop
   	beq   $t6, 2, exitHex              # Counter register for 2 iterations (for hex)
	lb    $t8, 0x02($a0)               # Load contents of $a0 offset by 2 (to exclude the 0x prefix)
   	bgt   $t8, 0x0000003A, letterCase  # If $t8 > number values, then evaluate based on letter criteria.
   	j     numberCase                   # Else, go to number criteria.
   letterCase: nop
   	subi  $t8, $t8, 55                 # Subtract by A-F ASCII conversion value.
	sb    $t8, int_array($t7)          # Store result into int_array
   	
   	addi  $t7, $t7, 1	           # increment int_array address pointer
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t6, $t6, 1                  # increment counter
   	
   	j     hexASCII                     # Jump to repeat loop
   numberCase: nop
   	subi  $t8, $t8, 0x30               # Subtract number value for 0-9 ASCII conversion
	sb    $t8, int_array($t7)     	   # Store converted value into int_array
	
	addi  $t7, $t7, 1	           # increment int_array address pointer
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t6, $t6, 1                  # increment counter
   	
   	j     hexASCII                     # Jump to repeat loop
   	
   exitHex: nop
	li    $t9, 0                       # Reset registers to free space
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   
   exitHEX: nop
   	beq   $t6, 2, forwards             # Counter register for 2 iterations
        
        lb    $t8, int_array($t7)          # i = lb($t0)
   	mul   $t9, $t9, 16                 # RS = 16*RS
   	add   $t9, $t9, $t8                # RS = RS + i
   	addi  $t8, $t8, 1                  # $t0 + 1
   	
   	addi  $t7, $t7, 1		   # Add to int_array pointer address
   	addi  $t6, $t6, 1                  # Add to loop counter
   	
   	j     exitHEX                      # Jump to repeat loop
	
   forwards: nop
   	sll   $t9, $t9, 24                 # Shift left by 24 bits
   	sra   $s1, $t9, 24                 # Sign extend $t9 and store resultant into $s1
   
   hexConvert2: nop
   	beq   $t2, 0x00000078, HEXConvert2 # Check if 0x05($a0) = x
	j     onwards                      # Else, continue with program
	
   HEXConvert2: nop
   	li    $t9, 0	                   # initialize registers
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   	lw    $a0, 4($a1)
   
   hexASCII2: nop
   	beq   $t6, 2, exitHex2             # Counter register for 2 iterations
 
	lb    $t8, 0x02($a0)               # Load contents of $a0 offset by 2
   	bgt   $t8, 0x0000003A, letterCase2 # If $t8 > number values, then evaluate based on A-F ASCII criteria.
   	j     numberCase2                  # Else evaluate based on 0-9 ASCII criteria.
   letterCase2: nop
   	subi  $t8, $t8, 55                 # Subtract ASCII A-F value
	sb    $t8, int_array($t7)          # Store result into int_array
   	
   	addi  $t7, $t7, 1	           # increment int_array address pointer
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
	li    $t9, 0                       # Reload registers, free space.
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   
   exitHEX2: nop
   	beq   $t6, 2, forwards2            # Counter register for 2 iterations
       
        lb    $t8, int_array($t7)          # i = lb($t0)
   	mul   $t9, $t9, 16                 # RS = 16*RS
   	add   $t9, $t9, $t8                # RS = RS + i
   	addi  $t8, $t8, 1                  # $t0 + 1
   	
   	addi  $t7, $t7, 1	   	   # Add to int_array pointer address
   	addi  $t6, $t6, 1                  # Add to counter register
   	
   	j     exitHEX2                     # Jump to repeat loop
	
   forwards2: nop
   	sll   $t9, $t9, 24                 # Shift left by 24 bits
   	sra   $s2, $t9, 24                 # Sign extend $t9 and store resultant into $s2

   onwards:
   
   binCondition: nop
	beq   $t1, 0x00000062, binConvert1 # Check if 0x01($a0) = b
	j     nextCase
	
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
   	beq   $t6, 8, exitBin              # Counter register for 8 iterations
   	
	
	lb    $t8, 0x02($a0)               # Load contents of $a0 offset by 2
   	subi  $t8, $t8, 0x30               # Subtract number value for ASCII
	sb    $t8, int_array($t7)     	   # Store converted value into int_array
	
	addi  $t7, $t7, 1	           # increment int_array address
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t6, $t6, 1                  # increment counter
   	
   	j     binASCII                     # Jump to repeat loop
   	
   exitBin: nop
	li    $t9, 0                       # Reload registers.
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   	
   exitBIN: nop
   	beq   $t6, 8, continue             # Counter register for 8 bytes
       
        lb    $t8, int_array($t7)          # i = lb($t0)
   	mul   $t9, $t9, 2                  # RS = 2*RS
   	add   $t9, $t9, $t8                # RS = RS + i
   	addi  $t8, $t8, 1                  # $t0 + 1
   	
   	addi  $t7, $t7, 1		   # Add to int_array pointer
   	addi  $t6, $t6, 1                  # Add to counter
   	
   	j     exitBIN                      # Jump to repeat loop
	                                   # Running Sum should equal the contents of register $t9
   continue: nop
   	sll   $t9, $t9, 24                 # Shift left by 24 bits
   	sra   $s1, $t9, 24                 # Sign extend $t9 and store resultant into $s1
   
   nextCase: nop
	beq   $t2, 0x00000062, binConvert2 # Check if 0x05($a0) = b
	j     exitSorter                   # Else, continue past this block of code.
   binConvert2: nop
   	li    $t9, 0                       # Reset registers to clear up space
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   	lw    $a0, 4($a1)
   	
   binASCII2: nop
   	beq   $t6, 8, exitBin2             # Counter register for 8 iterations
	
	lb    $t8, 0x02($a0)               # Load contents of $a0 offset by 2
   	subi  $t8, $t8, 0x30               # Subtract number value for ASCII
	sb    $t8, int_array($t7)          # Store converted value into int_array
	
	addi  $t7, $t7, 1	           # increment int_array address
   	addi  $a0, $a0, 1	           # increment ASCII pointer
   	addi  $t6, $t6, 1                  # increment counter
   	
   	j     binASCII2                    # Jump to repeat loop
   	
   exitBin2: nop
	li    $t9, 0                       # Reset, clear space.
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   	
   exitBIN2: nop
   	beq   $t6, 8, continue2            # Counter register for 8 iterations
       
        lb    $t8, int_array($t7)          # i = lb($t0)
   	mul   $t9, $t9, 2                  # RS = 2*RS
   	add   $t9, $t9, $t8                # RS = RS + i
   	addi  $t8, $t8, 1                  # $t0 + 1
   	
   	addi  $t7, $t7, 1                  # Add to int_array pointer
   	addi  $t6, $t6, 1                  # Add to counter
   	
   	j     exitBIN2                     # Jump to repeat loop
	                                   # Running Sum should equal the contents of register $t9
   continue2: nop
   	sll   $t9, $t9, 24                 # Shift left by 24 bits
   	sra   $s2, $t9, 24                 # Sign extend $t9 and store resultant into $s2
   	
   exitSorter: nop
   	li    $t9, 0                       # Space!
	li    $t8, 0
	li    $t7, 0
	li    $t6, 0
	li    $t5, 0
	li    $t4, 0
	li    $t3, 0
	li    $t0, 0
   
   	add   $s0, $s1, $s2                # Add together the 32bit 2sc binary and store sum in $s0.
   	move  $t9, $s0                     # Set $t9 to $s0 contents.
   	
   remainderLoop: nop
   	beq   $t9, 0, exitRemainder        # End when we reach 0 and can no longer divide.
   	div   $t9, $t9, 4                  # Divide the sum by 4(base 4).

   	mfhi  $t8                          # Remainder stored to $t8
   	
   	blt   $t8, 0, absolute             # Remove negative, we will account for it later.
   	j     skip                         # Else positive, continue running.
   absolute: nop
   	sub   $t8, $zero, $t8              # Absolute value command
   skip: nop
   	
   	sw    $t8, 0($sp)                  # Remainder is saved to stack
   	mflo  $t9                          # Quotient carries to next iteration
   	addi  $sp, $sp, 4                  # Increase the stack pointer
   	addi  $t6, $t6, 1                  # Increase arbitrary counter for subsequent loops
   	addi  $t0, $t0, 1                  # Yet another arbitrary counter for subsequent loops
   	j     remainderLoop                # Loop back to top
   	
   exitRemainder: nop
   	beq   $t6, 0, ASCIIexit         
   	lw    $a0, -4($sp)                 # Pop values off the stack and into $a0
   	addi  $a0, $a0, 0x30               # Convert the integer value to ASCII representation
   	sw    $a0, ascii_array($t7)        # Store answer into ascii_array
   	addi  $sp, $sp, -4                 # Decrease the stack pointer
   	subi  $t6, $t6, 1                  # Decrease the arbitrary loop counter
   	addi  $t7, $t7, 4                  # Increase the ascii_array pointer
	
	j     exitRemainder
   ASCIIexit: nop
   	li    $a0, 0                       # Initialize registers, yet again.
   	li    $t7, 0
   	li    $t3, 0
   	li    $t4, 0
   	li    $t5, 0
   	li    $t6, 0
   	li    $t8, 0
   	li    $t9, 0

   	   	
   	blt   $s0, 0, negative             # Check if $s0 is negative
   	j     ASCIIPRINT                   # Else positive, skip following section:
   negative: nop
   	li    $v0, 4
	la    $a0, negSign                 # Print negative sign
	syscall
   	
	li    $a0, 0                       # Clear registers, once again!
   	li    $t7, 0
   	li    $t3, 0
   	li    $t4, 0
   	li    $t5, 0
   	li    $t6, 0
   	li    $t8, 0
   	li    $t9, 0

   	
   ASCIIPRINT: nop                      
   
   	ble   $s0,-64, ham                 # Branch condition to fix printing of extra bit (I ran out of lable names, I know) for negatives.
   	bge   $s0, 64, cheese              # Branch condition to fix printing of extra bit for positives.
   	j     ASCIIPRINT2
   	
   ham: nop
      	li    $t4, -1                      # Initialize counter loop to strictly one less iteration
   ham2: nop
   	lw    $t3, ascii_array($t7)        # Load stores ASCII values from ascii_array
   	beq   $t4, $t0, finalPrint         # Check condition to exit loop
	sb    $t3, ascii_array($a0)        # store ASCII values into $a0 via. ascii_array
	
	addi  $t7, $t7, 4	           # increment loaded ascii_array address
   	addi  $a0, $a0, 1	           # increment stored ASCII pointer
   	addi  $t4, $t4, 1                  # increment counter
   	
   	j     ham2                         # Jump to repeat loop
   
   
   cheese: nop
      	li    $t4, -1                      # Initialize counter loop to strictly one less iteration
   cheese2:
   	lw    $t3, ascii_array($t7)        # Load stores ASCII values from ascii_array
   	beq   $t4, $t0, finalPrint         # Check condition to exit loop
	sb    $t3, ascii_array($a0)        # store ASCII values into $a0 via. ascii_array
	
	addi  $t7, $t7, 4	           # increment loaded ascii_array address
   	addi  $a0, $a0, 1	           # increment stored ASCII pointer
   	addi  $t4, $t4, 1                  # increment counter
   	
   	j     cheese2                      # Jump to repeat loop
   	
   	
   ASCIIPRINT2: nop
	
	lw    $t3, ascii_array($t7)        # Else, value is treated as normal.
   	beq   $t3, 0x00, finalPrint        # Branch and exit loop when null terminator is reached
	sb    $t3, ascii_array($a0)        # Store final ASCII string into ascii_array($a0)
	
	addi  $t7, $t7, 4	           # increment input int_array address
   	addi  $a0, $a0, 1	           # increment stored ASCII pointer
   	addi  $t4, $t4, 1                  # increment counter
   	
   	j     ASCIIPRINT2                  # Jump to repeat loop
   	
   finalPrint: nop
   
	la    $a0 ascii_array              # Print ascii_array
   	li    $v0, 4
	syscall
	
   	li    $v0, 4                       # Print a final new line.
   	la    $a0 newLine
	syscall
   	
   	
   endProgram: nop
        # Tell the program to terminate main command.
	li    $v0, 10
	syscall
