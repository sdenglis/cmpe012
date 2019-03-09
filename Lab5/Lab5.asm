#########################
#Lab 5: Subroutines 
#CMPE 012 Winter 2019
#
#English, Samuel 
#sdenglis
#########################
.data
	inputString:       .space 100   # 100 * 4? per character
	inputKey:          .space 100
	resultingString:   .space 100
	operationArray:    .space 100   # single character reserved for E, D, X?
	
	invalidInput:      .asciiz "Invalid input: please input E, D, or X."

.text

give_prompt:
#-------------------------------------------------------------------- 
# give_prompt
#
# This function should print the string in $a0 to the user, store the user’s input in
# an array, and return the address of that array in $v0. Use the prompt number in $a1 
# to determine which array to store the user’s input in. ?Include error checking? for  
# the first prompt to see if user input E, D, or X if not print error message and ask 
# again. 
#
# arguments:  $a0 - address of string prompt to be printed to user 
#             $a1 - prompt number (0, 1, or 2) 
#
# note: prompt 0: Do you want to (E)ncrypt, (D)ecrypt, or e(X)it? 
# prompt 1: What is the key? 
# prompt 2: What is the string? 
#
# return:     $v0 - address of the user input string 
#-------------------------------------------------------------------- 

	li $v0, 4                      # prints prompt loaded into $a0
	syscall                        # execute command

bne $a1, 0, skipFirst
	li $v0, 8                      # prepares for user input
	la $a0, operationArray         # stores value into operation array
	li $a1, 100                    # limit on number of characters
	syscall
	
la      $v0, operationArray            # move operation array address to $v0
 
 	move 	$s0, $v0	       # $s0 contains address of E,D or X
	
	lb	$t0, ($s0)	       # check for validity of user input
	beq  	$t0, 88, validInput    # X is valid input!
	beq  	$t0, 68, validInput    # D is valid input!
	beq  	$t0, 69, validInput    # E is valid input!
elseInput:
	la 	$a0, invalidInput
	li 	$v0, 4
	syscall 

	j loop                         # hard reset to obtain new, valid input
validInput:
	jr $ra                         # jump back to caller address

skipFirst:
bne $a1, 1, skipSecond
	li $v0, 8                      # prepares for user input
	la $a0, inputKey               # stores value into array
	li $a1, 100                    # limit on number of characters
	syscall
 
la      $v0, inputKey                  # move inputKey array address to $v0
 
	jr $ra                         # jump back to caller address

skipSecond:
# no need for final condition, $a1 has limited range (0-2)
	li $v0, 8                      # prepares for user input
	la $a0, inputString            # stores value into array
	li $a1, 100                    # limit on number of characters
	syscall
 
la      $v0, inputString               # move inputString array address to $v0
 
	jr $ra                         # jump back to caller address


cipher:
#--------------------------------------------------------------------
# cipher 
# 
# Calls compute_checksum and encrypt or decrypt depending on if the user input E or 
# D. The numerical key from compute_checksum is passed into either encrypt or decrypt
#  
# note: this should call compute_checksum and then either encrypt or decrypt 
# 
# arguments:  $a0 - address of E or D character
#             $a1 - address of key string 
#             $a2 - address of user input string
# 
# return:     $v0 - address of resulting encrypted/decrypted string 
#--------------------------------------------------------------------


compute_checksum:
#-------------------------------------------------------------------- 
# compute_checksum
# 
# Computes the checksum by xor’ing each character in the key together. Then, 
# use mod 26 in order to return a value between 0 and 25.
#
# arguments:  $a0 - address of key string
#
# return:     $v0 - numerical checksum result (value should be between 0 - 25)
#--------------------------------------------------------------------


encrypt:
#-------------------------------------------------------------------- 
# encrypt
#
# Uses a Caesar cipher to encrypt a character using the key returned from 
# compute_checksum. This function should call check_ascii.
#
# arguments:  $a0 - character to encrypt 
#             $a1 - checksum result
#
# return:     $v0 - encrypted character 
#-------------------------------------------------------------------- 


decrypt:
#-------------------------------------------------------------------- 
# decrypt
#
# Uses a Caesar cipher to decrypt a character using the key returned from 
# compute_checksum. This function should call check_ascii
#
# arguments:  $a0 - character to decrypt 
#             $a1 - checksum result
#
# return:     $v0 - decrypted character 
#-------------------------------------------------------------------- 


check_ascii:
#-------------------------------------------------------------------- 
# check_ascii 
#
# This checks if a character is an uppercase letter, lowercase letter, or  
# not a letter at all. Returns 0, 1, or -1 for each case, respectively.
#
# arguments:  $a0 - character to chec
#
# return:     $v0 - 0 if uppercase, 1 if lowercase, -1 if not letter
#-------------------------------------------------------------------- 


print_strings:
#-------------------------------------------------------------------- 
# print_strings 
#
# Determines if user input is the encrypted or decrypted string in order
# to print accordingly. Prints encrypted string and decrypted string. See
# example output for more detail. 
#
# arguments:  $a0 - address of user input string to be printed
#             $a1 - address of resulting encrypted/decrypted string to be printed
#             $a2 - address of E or D character 
#
# return:     prints to console 
#-------------------------------------------------------------------- 











# Subroutines. functions that are called. return functions, know how to use stack to preserve return address across calls
# caesar cipher. Look at sample output. xor bits together, mod with cap of alphabet, and that'll be your shift value
# Error check if not E, D, or X, input --> invalid input!
# Running sum with XOR for checksum!
# array .space 100 in this case, I suppose
# Take input, $a1 takes number of characters willing to read
# load $a2 with address of where you want to store (an input array)
# Store return addresses to the stack and pop stack to preserve ra over function calls!!! (nested subroutines) bottom up. subtract $sp by 4
#also have to store to stack the $s registers, preserve across subroutines
#subi $sp $sp, 4
#sw $ra, ($sp)

#...

#lw $ra, ($sp)
#addi $sp, $sp, 4

#jr $ra

#get started with give_prompt for user input, not too bad
#after that, implement print_strings to see data getting output
#and then finnagle with others checkascii and computechecksum are helper functions
#then finish others!
