#########################
#Lab 5: Subroutines 
#CMPE 012 Winter 2019
#
#English, Samuel 
#sdenglis
#########################
.data
	inputString:       .space 400  # reserved amount of character for each array, arbitrary
	inputKey:          .space 400
	resultingString:   .space 400
	operationArray:    .space 400  
	
	invalidInput:      .asciiz     "Invalid input: please input E, D, or X."
	outputPrompt:      .asciiz     "Here is the encrypted and decrypted string\n"
        askAgain:	   .asciiz     "\nDo you want to (E)ncrypt, (D)ecrypt, or e(X)it? "
	Encrypted:         .asciiz     "<Encrypted> "
	Decrypted:         .asciiz     "<Decrypted> "
	newLine:           .asciiz     "\n"

.text

restart_prompt: nop
	la	$a0, askAgain
	li	$a1, 0
	li $v0, 4                      # prints prompt loaded into $a0
	syscall                        # execute command
	j hover
	
give_prompt: nop
#-------------------------------------------------------------------- 
# arguments:  $a0 - address of string prompt to be printed to user 
#             $a1 - prompt number (0, 1, or 2) 
#
# prompt 0: Do you want to (E)ncrypt, (D)ecrypt, or e(X)it? 
# prompt 1: What is the key? 
# prompt 2: What is the string? 
#
# return:     $v0 - address of the user input string 
#-------------------------------------------------------------------- 

	li $v0, 4                      # prints prompt loaded into $a0
	syscall                        # execute command
	
hover: nop
   bne     $a1, 0, skipFirst
	li $v0, 8                      # prepares for user input
	la $a0, operationArray         # stores value into operation array
	li $a1, 400                    # limit on number of characters
	syscall
	
   la   $v0,    operationArray         # move operation array address to $v0
 
 	move 	$s0, $v0	       # $s0 contains address of E,D or X
	
	lb	$t0, ($s0)	       # check for validity of user input
	addi    $s0,  $s0, 1
	lb      $t1, ($s0)             # load next character 
	subi    $s0,  $s0, 1           # restore $s0 value 
	bne     $t1  10, elseInput     # if next closest character is not a new line, consider it invalid
	beq  	$t0, 88, validInput    # X is valid input!
	beq  	$t0, 68, validInput    # D is valid input!
	beq  	$t0, 69, validInput    # E is valid input!
elseInput: nop
	la 	$a0, invalidInput      # else, invalid input.
	li 	$v0, 4                 # print invalid feedback
	syscall 
	
	la      $a0, newLine           # prints a new line to conform with formatting
	li      $v0, 4
	syscall

	j restart_prompt               # hard reset to obtain new, valid input
validInput: nop
	jr $ra                         # jump back to caller address

skipFirst: nop
   bne     $a1, 1, skipSecond
	li $v0, 8                      # prepares for user input
	la $a0, inputKey               # stores value into array
	li $a1, 400                    # limit on number of characters
	syscall
 
   la   $v0, inputKey                  # move inputKey array address to $v0
 
	jr $ra                         # jump back to caller address

skipSecond: nop
# no need for final condition, $a1 has limited range (0-2)
	li $v0, 8                      # prepares for user input
	la $a0, inputString            # stores value into array
	li $a1, 400                    # limit on number of characters
	syscall
 
   la   $v0, inputString               # move inputString array address to $v0
 
	jr $ra                         # jump back to caller address



cipher: nop
#--------------------------------------------------------------------
# Calls compute_checksum and encrypt or decrypt depending on if the user input E or 
# D. The numerical key from compute_checksum is passed into either encrypt or decrypt
# 
# arguments:  $n/a, everything is stored on stack
# 
# return:     $v0 - address of resulting encrypted/decrypted string 
#--------------------------------------------------------------------

	subu $sp,  $sp, 4              # save previous caller address before jumping to nested subroutine
	sw   $ra, ($sp)                # push $ra to the stack
	subu $sp,  $sp, 4            
	sw   $a1, ($sp)              
	subu $sp,  $sp, 4            
	sw   $a2, ($sp)              
	subu $sp,  $sp, 4            
	sw   $s2, ($sp)              
	
	jal  compute_checksum          # jump to compute_checksum function, store value in $v0
	
	lw   $s2, ($sp)                # pop stack, obtain previously saved $s2 value
	addu $sp,  $sp, 4              # increment stack pointer by 4
	lw   $a2, ($sp)              
	addu $sp,  $sp, 4            
	lw   $a1, ($sp)              
	addu $sp,  $sp, 4            
	lw   $ra, ($sp)             
	addu $sp,  $sp, 4            

	lb   $t0, ($a0)	               # load first character of operationArray for condition check
	
   bne       $t0,  68, skipDecrypt     # branch to next case if $t0 does not contain 'D'
	subu $sp,  $sp, 4              # save previous caller address before jumping to nested subroutine
	sw   $ra, ($sp)                # push $ra to the stack
	subu $sp,  $sp, 4            
	sw   $a1, ($sp)              
	subu $sp,  $sp, 4            
	sw   $a2, ($sp)              
	subu $sp,  $sp, 4           
	sw   $s2, ($sp)              
	
	jal  decrypt                   # jump to decrypt function
	
	lw   $s2, ($sp)                # pop stack, obtain previously saved $s2 value
	addu $sp,  $sp, 4              # increment stack pointer by 4
	lw   $a2, ($sp)              
	addu $sp,  $sp, 4            
	lw   $a1, ($sp)              
	addu $sp,  $sp, 4            
	lw   $ra, ($sp)              
	addu $sp,  $sp, 4            
	
	j endCipher                    # skip encrypt block of code
	
skipDecrypt: nop
# no need for branch statement since only two possible outcomes (Decrypt, Encrypt)
	subu $sp,  $sp, 4              # save previous caller address before jumping to nested subroutine
	sw   $ra, ($sp)                # push $ra to the stack
	subu $sp,  $sp, 4            
	sw   $a1, ($sp)              
	subu $sp,  $sp, 4            
	sw   $a2, ($sp)              
	subu $sp,  $sp, 4            
	sw   $s2, ($sp)              
	
	jal  encrypt                   # jump to encrypt function
	
	lw   $s2, ($sp)                # pop stack, obtain previously saved $s2 value
	addu $sp,  $sp, 4              # increment stack pointer by 4
	lw   $a2, ($sp)              
	addu $sp,  $sp, 4            
	lw   $a1, ($sp)              
	addu $sp,  $sp, 4            
	lw   $ra, ($sp)              
	addu $sp,  $sp, 4            
	
endCipher: nop
   la      $v0, resultingString
	jr $ra



compute_checksum: nop
#-------------------------------------------------------------------- 
# Computes the checksum by xor’ing each character in the key together. Then, 
# use mod 26 in order to return a value between 0 and 25.
#
# arguments:  $a1 - address of key string
#
# return:     $v0 - numerical checksum result (value should be between 0 - 25)
#--------------------------------------------------------------------

	li   $t9,  0                   # initialize running XOR value
XORloop: nop
	lb   $t8, ($a1)                # load character from key string
   beq       $t8, 0x0A,    exitXOR     # branch when string reaches new line
	xor  $t9,  $t9, $t8            # XOR running sum with the loaded character
	
	addi $a1,  $a1, 1              # increment address pointer until we reach null terminator
	j XORloop                      # repeat
exitXOR: nop
	divu $t9,  $t9, 26             # divide running XOR by 26
	mfhi $v0                       # store remainder (mod) value into $v0
	
	li   $t9, 0                    # clear up register space
	li   $t8, 0                    # clear up register space
	
	jr $ra                         # return to cipher caller address



encrypt: nop
#-------------------------------------------------------------------- 
# Uses a Caesar cipher to encrypt a character using the key returned from 
# compute_checksum. This function should call check_ascii.
#
# arguments:  $a2 - character to encrypt 
#             $a1 - checksum result
#
# return:     $array, fully encrypted input string
#-------------------------------------------------------------------- 

   la        $t7,  resultingString
	move $a1,  $v0                 # sets $a1 to the checksum result generated in XOR function
encryptLoop:
	lb   $a2, ($s2)                # stores character to encrypt into $a2
   beq       $a2, 0,    exitEncrypt    # exit loop when we reach a null terminator
	
	subu $sp,  $sp, 4              # save previous caller address before jumping to nested subroutine
	sw   $ra, ($sp)                # push $ra to the stack
	
	jal check_ascii                # sort ascii characters and convert accordingly
	
	lw   $ra, ($sp)                # pop stack, obtain previously saved $ra value
	addu $sp,  $sp, 4              # increment stack pointer by 4
	
	sb   $a2, ($t7)                # store shifted character into final array structure
	addi $s2, $s2, 1               # add to address pointer for inputString
	addi $t7, $t7, 1               # increment resultingString address for each loop iteration
	j encryptLoop                  # repeat

exitEncrypt: nop
	li $t7, 0                      # clear register space
	jr $ra                         # return to cipher command address



decrypt: nop
#-------------------------------------------------------------------- 
# Uses a Caesar cipher to decrypt a character using the key returned from 
# compute_checksum. This function should call check_ascii
#
# arguments:  $a2 - character to decrypt 
#             $a1 - checksum result
#
# return:     $array, fully decrypted input string
#-------------------------------------------------------------------- 

   la        $t7,  resultingString
	move $a1,  $v0                 # sets $a1 to the checksum result generated in XOR function
decryptLoop:
	lb   $a2, ($s2)                # stores character to encrypt into $a2
   beq       $a2, 0,    exitDecrypt    # exit loop when we reach a null terminator
	
	subu $sp,  $sp, 4              # save previous caller address before jumping to nested subroutine
	sw   $ra, ($sp)                # push $ra to the stack
	
	jal checkUpper2                # sort ascii characters and convert accordingly
	
	lw   $ra, ($sp)                # pop stack, obtain previously saved $ra value
	addu $sp,  $sp, 4              # increment stack pointer by 4
	
	sb   $a2, ($t7)                # store shifted character into final array structure
	addi $s2, $s2, 1               # add to address pointer for inputString
	addi $t7, $t7, 1               # increment resultingString address for each loop iteration
	j decryptLoop                  # repeat

exitDecrypt: nop
	li $t7, 0                      # clear register space
	jr $ra                         # return to cipher command address



check_ascii: nop
#-------------------------------------------------------------------- 
# Converts loaded ASCII character to a newly-shifted value.
# Split into two sections, one where the base value is A/a for encryption,
# and Z/z for decryption, with values added v. subtraction accordingly.
#
# arguments:  $a2 - character to transform
#
# return:     $a2 - new, shifted ASCII value
#-------------------------------------------------------------------- 

checkUpper: nop                        # check for upper-case value
   bge       $a2, 65,   upper          # check if loaded character is above 'A'
	j elseASCII                    # else, non-letter character
upper: nop
   ble       $a2, 90,   upperTrue      # check if loaded character is below 'Z'
	j checkLower                   # else, check if lower-case value

upperTrue: nop                         # function for upper-case value
	sub  $t9, $a2, 65              # subtract ascii character from base ascii value
	add  $t9, $t9, $a1             # adds temporary value to XOR shift amount
	abs  $t9, $t9                  # ensures that we divide by a positive
	divu $t9, $t9, 26              # divide temp value by 26
	mfhi $t8                       # store mod value into $t8
	addi $a2, $t8, 65              # add mod value to base ascii value, store back into $a2
	j elseASCII                    # end process and continue

checkLower: nop                        # check for lower-case value
   bge       $a2, 97,   lower          # check if loaded character is above 'a'
	j elseASCII                    # else, non-letter character
lower: nop
   ble       $a2, 122,  lowerTrue      # check if loaded character is below 'z'
	j elseASCII                    # else, non-letter character

lowerTrue: nop                         # function for lower-case value
	sub  $t9, $a2, 97              # subtract ascii character from base ascii value
	add  $t9, $t9, $a1             # adds temporary value to XOR shift amount
	abs  $t9, $t9                  # ensures that we divide by a positive
	divu $t9, $t9, 26              # divide temp value by 26
	mfhi $t8                       # store mod value into $t8
	addi $a2, $t8, 97              # add mod value to base ascii value, store back into $a2
	j elseASCII                    # end process and continue

elseASCII: nop                         # else, treat as non-letter value
	li   $t9, 0                    # clear up register space
	li   $t8, 0
	li   $t5, 0
	jr   $ra                       # return to caller address

checkUpper2: nop                       # check for upper-case value
   bge       $a2, 65,   upper2         # check if loaded character is above 'A'
	j elseASCII2                   # else, non-letter character
upper2: nop
   ble       $a2, 90,   upperTrue2     # check if loaded character is below 'Z'
	j checkLower2                  # else, check if lower-case value

upperTrue2: nop                        # function for upper-case value
	li   $t5, 90 
	sub  $t9, $t5, $a2             # subtract ascii character from base ascii value
	add  $t9, $t9, $a1             # adds temporary value to XOR shift amount
	abs  $t9, $t9                  # ensures that we divide by a positive
	divu $t9, $t9, 26              # divide temp value by 26
	mfhi $t8                       # store mod value into $t8
	sub  $a2, $t5, $t8             # add mod value to base ascii value, store back into $a2
	j elseASCII2                   # end process and continue

checkLower2: nop                       # check for lower-case value
   bge       $a2, 97,   lower2         # check if loaded character is above 'a'
	j elseASCII2                   # else, non-letter character
lower2: nop
   ble       $a2, 122,  lowerTrue2     # check if loaded character is below 'z'
	j elseASCII2                   # else, non-letter character

lowerTrue2: nop                        # function for lower-case value
	li   $t5, 122
	sub  $t9, $t5, $a2             # subtract ascii character from base ascii value
	add  $t9, $t9, $a1             # adds temporary value to XOR shift amount
	abs  $t9, $t9                  # ensures that we divide by a positive
	divu $t9, $t9, 26              # divide temp value by 26
	mfhi $t8                       # store mod value into $t8
	sub  $a2, $t5, $t8             # add mod value to base ascii value, store back into $a2
	j elseASCII2                   # end process and continue

elseASCII2: nop                        # else, treat as non-letter value
	li   $t9, 0                    # clear up register space
	li   $t8, 0
	jr   $ra                       # return to caller address



print_strings: nop
#-------------------------------------------------------------------- 
# Determines if user input is the encrypted or decrypted string in order
# to print accordingly. Prints encrypted string and decrypted string.
#
# arguments:  $s2 - address of user input string to be printed
#             $s3 - address of resulting encrypted/decrypted string to be printed
#             $s0 - address of E or D character 
#
# return:     prints to console 
#-------------------------------------------------------------------- 

	la   $a0, newLine              # print new line after input prompts
	li   $v0,  4
	syscall
	
	la   $a0, outputPrompt         # print precursor to <> strings
	li   $v0,  4
	syscall


	lb   $t0, ($s0)	               # load X, D, E character
   beq       $t0,  68, DecryptedCase   # check if program decrypted string
   beq       $t0,  69, EncryptedCase   # check if program encrypted string

DecryptedCase: nop
	la   $a0,  Encrypted           # <Encrypted> 
	li   $v0,  4                   # prints prompt loaded into $a0
	syscall                        # execute command
	
	la   $a0, ($s2)                # <Decrypted> string
	li   $v0,  4                   # prints prompt loaded into $a0
	syscall                        # execute command
	
	la   $a0,  Decrypted           # <Decrypted> 
	li   $v0,  4                   # prints prompt loaded into $a0
	syscall                        # execute command
	
	la   $a0, ($s3)                # <Encrypted> string
	li   $v0,  4                   # prints prompt loaded into $a0
	syscall                        # execute command
	j  exitPrint                   # skip next case 
		
EncryptedCase: nop
	la   $a0,  Encrypted           # <Encrypted> 
	li   $v0,  4                   # prints prompt loaded into $a0
	syscall                        # execute command
	
	la   $a0, ($s3)                # <Encrypted> string
	li   $v0,  4                   # prints prompt loaded into $a0
	syscall                        # execute command
	
	la   $a0,  Decrypted           # <Decrypted> 
	li   $v0,  4                   # prints prompt loaded into $a0
	syscall                        # execute command

	la   $a0, ($s2)                # <Decrypted> string
	li   $v0,  4                   # prints prompt loaded into $a0
	syscall                        # execute command
	
exitPrint: nop
# clears all of the arrays in preparation of next branch iteration
	la   $t9,  inputString
	la   $t8,  inputKey
	la   $t7,  resultingString
	la   $t6,  operationArray
	
clearArrayRES: nop
# loop blocks takes array and sets each char to 0, stopping when the loaded char is 0x00
	lb   $t5, ($t7)
	beq  $t5,  0x00, clearArrayINP
	li   $t5,  0
	sb   $t5, ($t7)
	addi $t7,  $t7, 1
	j clearArrayRES
	
	clearArrayINP: nop
	lb   $t5, ($t9)
	beq  $t5,  0x00, EXITFINAL
	li   $t5,  0
	sb   $t5, ($t9)
	addi $t9,  $t9, 1
	j clearArrayINP
	
EXITFINAL: nop
	jr $ra                         # return to caller address
