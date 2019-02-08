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



.data # Initiates and stores variables / int's in RAM.

     prompt: .asciiz "Enter the length of one of the trangle legs: "
     prompt_2: .asciiz "Enter the number of triangles to print: "


.text # Calls variables during stack in form of functions and arguments.

      #Prompt to enter 
      li $v0, 4
      la $a0, prompt
      syscall

      #Collect response for number of sides
      li $v0, 5
      syscall
      
      #Store resulting data value in $t0
      move $t0, $v0
      
      #Prompt_2 to enter 
      li $v0, 4
      la $a0, prompt_2
      syscall

      #Collect response for number triangles
      li $v0, 5
      syscall
      
      #Store resulting data value in $t1
      move $t1, $v0


      # Print combination of inputs and character variables based on user feedback


