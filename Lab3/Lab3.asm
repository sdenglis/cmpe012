##########################################################################
# Created by: English, Samuel
# sdenglis
# 2 February 2019
#
# Assignment: Lab 3: MIPS Looping ASCII Art
# CMPE 012, Computer Systems and Assembly Language
# UC Santa Cruz, Winter 2019
#
# Description: This program prints ASCII-based triangles to the screen.
#
# Notes: This program is intended to be run from the MARS IDE.
##########################################################################

# REGISTER USAGE
# $t0: user input (number of sides)
# $t1: user input (number of triangles)
# $t2: i condition (arbitrary)
# $t3: j condition (arbitrary)
# $t4: n condition (number of triangles)
# $t5: BEQ Condition to check against $t3 for final main iteration
# $t6: value to compare to $t2
# $ra: used to tidy up code and reference procedures remotely within each loop.



.data   # Initiates and stores variables / int's in RAM.
	prompt:    .asciiz "Enter the length of one of the triangle legs: "
	prompt_2:  .asciiz "Enter the number of triangles to print: "
     
	newLine:   .asciiz "\n"       # New line character
	charSpace: .asciiz " "        # Space character
	charFWD:   .asciiz "/\000"    # Forward-slash character
	charBCK:   .asciiz "\\\000"   # Back-slash character



.text   # Calls variables during stack in form of functions and arguments.
     input:
	li $v0, 4       	      # Prompt user to enter 
	la $a0, prompt
	syscall

	li $v0, 5                     # Collect response for (number of sides)
	syscall
      
	move $t0, $v0                 # Store resulting data value in $t0
      
	li $v0, 4                     # Prompt_2 user to enter 
	la $a0, prompt_2
	syscall

	li $v0, 5                     # Collect response for (number triangles)
	syscall
      
	move $t1, $v0                 # Store resulting data value in $t1
	
     	jal printLine         	      # Print extra line to conform with formatting
     	
     main:
     	bge $t4, $t1, exitMain        # Simple sentinel loop statement for number of triangles
     	
     # Initialization of Variables:
     
     	addi $t2, $zero, 0            # Sets $t2 = 0 (i) for condition statement usage
     	addi $t3, $zero, 0            # Sets $t3 = 0 (j) for condition statement usage
     	addi $t5, $t1, -1             # Initialize $t5 for BEQ condition usage
     	addi $t6, $t0, -1             # Initialize $t6 for && BEQ comparison
     	
     while_1:
     	bge $t2, $t0, exit_1 	      # Checks for i < number of sides (user input), branches to exit if false
     		
##########################################################################
# Inner loop (going upwards)

	li $t3, 0                     # Calibrate $t3 to 0 for all inner loop cycles
		
     whileInner_1:
     	bge $t3, $t2, exitInner_1     # Checks for j < i, branches to continue outer loop if false
     	jal printSpace
     	addi $t3, $t3, 1              # Increments $t3 (j) by a value of 1 (j++)	
     	j whileInner_1
     		
##########################################################################
# Outer loop (going upwards)

     exitInner_1:
     	jal printBCK
     	jal printLine	
     	addi $t2, $t2, 1  	      # Increments $t2 (i) by a value of 1 (i++)
     	j while_1
     	
     exit_1:
     	addi $t2, $zero, 0            # Sets $t2 = 0 (i) for condition statement usage
     	addi $t3, $zero, 0 	      # Sets $t3 = 0 (j) for condition statement usage
     	
     while_2:
     	bge $t2, $t0, exit_2          # Checks for i < number of sides (user input), branches to exit if false
     		
##########################################################################
# Inner loop (going downwards)

	addi $t3, $t0, -1             # Calibrate $t3 to 0 for all inner loop cycles
		
     whileInner_2:
     	ble $t3, $t2, exitInner_2     # Checks for j > i, branches to continue outer loop if false
     	jal printSpace
     	addi $t3, $t3, -1             # Increments $t3 (j) by a value of 1 (j--)
     	j whileInner_2
     		
##########################################################################
# Outer loop (going downwards)

     exitInner_2:
     	jal printFWD
     	
     	beq $t4, $t5, ELSE            # Check for most recent increment for last loop iteration, allowing program to branch directly to syscall for immediate termination.	
	j L1
     ELSE: 
     	beq $t3, $t6, ELSE2           # && condition, only arrives at endProgram state when both conditions are satisfied.
     	j L1
     ELSE2:
     	j endProgram
     	
     L1:
     	jal printLine
     	
     	addi $t2, $t2, 1 	      # Increments $t2 (i) by a value of 1 (i++)
     	j while_2
     	
     exit_2:
     	addi $t4, $t4, 1              # Increment n (number of triangles loop) by a value of 1 (n++)
     	j main
     
     
     
     exitMain:
     endProgram:

     	li $v0, 10 	              # Tells the system that the program is complete.
     	syscall



##########################################################################
# Functions / stored procedures for main input

      	printLine:                    # Prints a new line
	li $v0, 4
	la $a0, newLine
	syscall
	jr $ra
	
	printSpace:                   # Prints a space
	li $v0, 4
	la $a0, charSpace
	syscall
	jr $ra
	
	printFWD:                     # Prints a forward-slash
	li $v0, 4
	la $a0, charFWD
	syscall
	jr $ra
	
	printBCK:                     # Prints a back-slash
	li $v0, 4
	la $a0, charBCK
	syscall
	jr $ra
	
	
	
