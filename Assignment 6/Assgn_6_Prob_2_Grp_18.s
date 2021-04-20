#Assignment 6
#Semester A2020
#Sagnik Roy (18CS10063) Debajyoti Kar (18CS10011)
#Problem 2


.data
	var_input_number:	.asciiz	"Enter integer to check if prime: "
	var_is_prime:	.asciiz	"Input is a prime number\n"
	var_is_not_prime:	.asciiz	"Input is not a prime number\n"
	var_is_invalid:	.asciiz	"Invalid input number should be greater than 1\n"

.text
.globl main
	main:
		#prompt user for input
		li $v0, 4
		la $a0, var_input_number
		syscall

		li $v0, 5
		syscall

		move $t0, $v0

		li $t1, 2 #initial value	 

		# Sanity Check: Exclude number less than equal to 1 and handle 2 trivially
		
		ble $t0, 1, invalidInput	# input <= 1	
		beq $t0, 2, isPrime

		#loop to check for primes

		loopPrime:
			beq $t0, $t1, isPrime
			div $t0, $t1
			mfhi $t2	 #get remainder of division
			beq $t2, 0, isNotPrime
			addi $t1, $t1, 1

			b loopPrime
	
	#Input is Prime	
	isPrime:
		li $v0, 4
		la $a0, var_is_prime
		syscall

		b exitLabel
	
	#Input is not Prime	
	isNotPrime:
		li $v0, 4
		la $a0, var_is_not_prime
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
