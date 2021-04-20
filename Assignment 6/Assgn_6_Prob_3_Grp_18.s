#Assignment 6
#Semester A2020
#Sagnik Roy (18CS10063) Debajyoti Kar (18CS10011)
#Problem 3


.data
	prompt1: .asciiz	"Enter the multiplicand : "
	prompt2: .asciiz	"Enter the multiplier : "
	message: .asciiz	"The result is : "
	var_is_invalid:	.asciiz	"Invalid input, numbers should be 16 bit unsigned integer  0 <= n <= 65535\n"
	newline: .asciiz	"\n"

.text
.globl main
	main:
		#prompt user for 1st input
		li $v0, 4
		la $a0, prompt1
		syscall
		
		li $v0, 5
		syscall
		
		move $t0, $v0	# $t0 - Multiplicand 

		#prompt for second input
		li $v0, 4
		la $a0, prompt2
		syscall

		li $v0, 5
		syscall
		
		move $a1, $v0	# $a1 - Multiplier
		move $a0, $t0	# $a0 - Multiplicand
		
		#Sanity Checking

		blt $a1, 0, invalidInput	# input1 <= 0
		blt $a0, 0, invalidInput	# input2 <= 0

		lui $t1, 1
		ori $t1, $t1, 0		# t1 = 2^16
		sub $t1, $t1, $a0	# t1 = t1 - a0

		ble $t1, 0, invalidInput # a0 > 2^16 (out of range of 16 bit integer) 

		lui $t1, 1		
		ori $t1, $t1, 0		# t1 = 2^16
		sub $t1, $t1, $a1	# t1 = t1 - a1

		ble $t1, 0, invalidInput # a1 > 2^16 (out of range of 16 bit integer)

		#Function call
		jal seq_mult_unsigned
		
		move $t0, $v0	#Save the result in register t0

		# Display Result
		li $v0, 4	# Message
		la $a0, message
		syscall
		
		move $a0, $t0
		li $v0, 1	#Integer Display
		syscall
		
		li $v0, 4	#New Line
		la $a0, newline
		syscall

		b exitLabel

	#Input is invalid
	invalidInput:
		li $v0, 4
		la $a0, var_is_invalid
		syscall

		b exitLabel	


	exitLabel:
		li $v0, 10
		syscall

	seq_mult_unsigned:
		
		li $v0, 0	#Initialize the result register
		li $t0, 1	#Initialize the mask
		li $t1, 0	#Initialize the LSB of multiplier

		multiplication_loop:
			beq $a1, $zero, multiplication_end	#multiplier = 0
			and $t1, $t0, $a1	#Get the LSB
			beq $t1, 1, mult_do_add	#If LSB != 0 add multiplicand to result
			beq $t1, 0, mult_do_shift	#If LSB = 0 just do shift

			mult_do_add:
				addu $v0, $v0, $a0	#Add multiplicand to result
		
			mult_do_shift:
				sll $a0, $a0, 1		#Shift left the multiplicand
				srl $a1, $a1, 1		#Shift right the multiplier

			j multiplication_loop	#Back to loop

		multiplication_end:
			jr $ra		#Return with result in register v0
