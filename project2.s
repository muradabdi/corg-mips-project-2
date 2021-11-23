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
		b exit_program                              # Unconditionally branch to exit_program

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

		pass_2:

			end_spaces:                             # Get number of spaces at end
                la $a0, userInput                   # Load userInput address into $a0
                add $a0, $s4, $a0                   # Load sum of $a0 and $s4 into $a0
                addi $a0, $a0, -2                   # Load sum of $a0 and -2 into $a0
                li $s6, 0                           # Load 0 into $s6
			
			loop_space_2:
				lb $t1, 0($a0)                      # Load byte at userInput address into $t1
				bne $t1, 0x20, pass_3               # Branch to pass_3 if $t1 does not equal space character
				addi $a0, $a0, -1                   # Load sum of $a0 and -1 into $a0
				addi $s6, $s6, 1                    # Load sum of $s6 and 1 into $s6
				j loop_space_2

			pass_3:
				la $a0, userInput                   # Load userInput address into $a0
				add $s1, $a0, $s5                   # Start address without spaces
				add $s2, $a0, $s4                   # Load sum of $a0 and $s4 into $s2
				addi $s2, $s2, -2                   # Load sum of $s2 and -2 into $s2
				sub $s2, $s2, $s6                   # End address without spaces

				sub $t0, $s2, $s1                   # Load difference of $s2 and $s1 into $t0
				bgt $t0, 3, wrong                   # Wrong if more than 4 characters (5 including newline)
			
				li $s0, 0	                        # Load 0 into $s0. $s0 = sum value
				li $t2, 0	                        # Load 0 into $t2. $t2 = counter
				li $t4, 36	                        # Load 36 into $t4. $t4 = N base
				li $t7, 0	                        # Load 0 into $t7. $t7 = temp
			
			loop_string:
				li $t3, 1	                        # Load 1 into $t3. $t3 = power (36^n)
				lb $t1, 0($s2)                      # Load byte at userInput address int
				bltu $t1, 0x30, wrong	            # Branch to wrong is $t1 is less than 0
				bgt $t1, 0x7A, wrong	            # Branch to wrong if $t1 is greater than lowercase z
				bge $t1, 0x61, calculate_power  	# Branch to calculate_power if $t1 is greater than or equal to lowercase a
				bgt $t1, 0x5A, wrong	            # Branch to wrong if $t1 is greater than uppercase Z
				bge $t1, 0x41, calculate_power  	# Branch to calculate_power if $t1 is greater than or equal to uppercase A
				bgt $t1, 0x39, wrong            	# Branch to wrong if $t1 is greater than 9
				bge $t1, 0x30, calculate_power	    # Branch to calculate_power if $t1 greater than 0	

			calculate_power:
				bne $t2, 0, load_power              # Branch to load_power if $t2 does not equal 0
				b done                              # Unconditionally branch to done
				load_power:
					mul $t3, $t3, $t4                   # Load product of $t3 and $t4 into $t3
					addi $t5, $t5, -1                   # Load sum of $t5 and -1 into $t5
					bne $t5, $zero, load_power          # Branch back to load_power if $t5 does not equal $zero

			done:
				beq $t1, 0x7A, z_N                  # Branch to z_N if $t1 equals lowercase z. z = 34
				beq $t1, 0x5A, Z_N                  # Branch to Z_N if $t1 equals uppercase Z. Z = 34
				bge $t1, 0x61, a_z                  # Branch to a_z f $t1 is greater than or equal to lowercase a
				bge $t1, 0x41, A_Z                  # Branch to A_Z f $t1 is greater than or equal to uppercase A
				addi $t6, $t1, -48                  # Load sum of $t1 and -48 into $t7
				b cal                               # Unconditionally branch to cal
			z_N:
				li $t6, 35                          # Load 35 into $t6
				b cal
			Z_N:
				li $t6, 35                          # Load 35 into $t6
				b cal
			a_z:
				addi $t6, $t1, -87                  # Load sum of $t1 and -87 into $t6
				b cal
			A_Z:
				addi $t6, $t1, -55                  # Load sum of $t1 and -55 into $t6
				b cal
			
			cal:	
				mul $t7, $t3, $t6                   # Load product of $t3 and $t6 into $t7
				add $s0, $t7, $s0                   # Load sum of $t7 and $s0 into $s0
				addi $t2, $t2, 1                    # Load sum of $t2 and 1 into $t2
				addi $s2, $s2, -1                   # Load sum of $s2 and -1 into $s2
				addi $t5, $t2, 0                    # Load sum of $t2 and 0 into $t5
				ble $s1, $s2, loop_string           # Branch to loop_string if $s1 is less than or equal to $s2

				li $v0, 1					        # 1 = code to print integer
				move $a0, $s0 				        # Move contents of $s0 to $a0
				syscall

	exit_program:
		li $v0, 10						            # 10 = code to exit
		syscall