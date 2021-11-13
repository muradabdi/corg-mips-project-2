# PROGRAM: CSCI 201 MIPS Programming Project 2

.data
	error: .asciiz "Not recognized"					# Error message 
	userInput: .space 1000							# Set input character limit

.text
	main:											# Start of code section
		li $v0, 8									# 8 = code to read string
		la $a0, userInput							# Load userInput address into $a0
		li $a1, 1000								# Load 1000 into $a1
		syscall

		addi $s4, $s4, 0                            # Load 0 into $s4. $s4 = counter

	loop:
		lb $t1, 0($a0)                              # Load byte at userInput address into $t1
		beqz $t1, pass_1                           	# Conditionally branch to pass_1 if $t1 is 0. End of string
		addi $a0, $a0, 1                            # Add 1 to $a0
		addi $s4, $s4, 1                            # Increment count, add 1 to $s4
		j loop                                      # Return to top of loop

	wrong:
		li $v0, 4                                   # 4 = code to print string
		la $a0, error                               # If errors, print a message not recognized
		syscall

	pass_1:

		start_spaces:								# Get number of spaces at start
            la $a0, userInput						# Load userInput address into $a0
            li $s5, 0								# Load 0 into $s5

		loop_space_1:
			lb $t1, 0($a0)							# Load byte at userInput address into $t1
			bne $t1, 0x20, pass_2					# Branch to pass_2 if $t1 does not equal space character
			addi $a0, $a0, 1						# Load sum of $a0 and 1 into $a0
            addi $s5, $s5, 1						# Load sum of $s5 and 1 into $s5
			j loop_space_1							# Return to top of loop_space_1

	