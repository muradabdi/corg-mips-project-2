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

	wrong:

	pass:
	