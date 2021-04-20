#Assignment 6
#Semester A2020
#Sagnik Roy (18CS10063) Debajyoti Kar (18CS10011)
#Problem 1


.data
	prompt1: .asciiz	"Enter the first number : "
	prompt2: .asciiz	"Enter the second number : "
	message: .asciiz	"The GCD is : "
	var_is_invalid:	.asciiz	"Invalid input, numbers should be positive\n"
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
		
		move $t0, $v0	# $t0 - Num1 

		#prompt for second input
		li $v0, 4
		la $a0, prompt2
		syscall

		li $v0, 5
		syscall
		
		move $a1, $v0	# $a1 - Num 2
		move $a0, $t0	# $a0 - Num 1
		

		#Sanity Checking
		
		ble $a1, 0, invalidInput	# input1 <= 0
		ble $a0, 0, invalidInput	# input2 <= 0

		#Function CAll

		jal gcd

		move $t0, $v0

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

	gcd:
		beq $a0, $a1, gcd_exit
		slt $t0, $a1, $a0	# if a1 < a0, t0 = 1
		bne $t0, $zero, L1	# if t0 == 1 (a1 < a0), go L1 
		sub $a1, $a1, $a0	# a1 = a1 - a0
		j gcd

	L1:
		sub $a0, $a0, $a1	# a0 = a0 - a1
		j gcd

	gcd_exit:
		add $v0, $a0, $zero	# when a0 = a1, ans = a0
		jr $ra				#Return with result in register v0