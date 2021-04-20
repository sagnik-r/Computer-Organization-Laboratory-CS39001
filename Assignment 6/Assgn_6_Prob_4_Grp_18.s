#Assignment 6
#Semester A2020
#Sagnik Roy (18CS10063) Debajyoti Kar (18CS10011)
#Problem 4


.data
	prompt1: .asciiz	"Enter the multiplicand : "
	prompt2: .asciiz	"Enter the multiplier : "
	message: .asciiz	"The result is : "
	var_is_invalid:	.asciiz	"Invalid input, numbers should be 16 bit signed integer  -32768 <= n <= 32767\n"
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
		li $t0, 32768		# t0 = 2^15
		sub $t0, $t0, $a0	# t0 = t0 - a0
		ble $t0, $zero, invalidInput		# a0 >= 2^15
		
		li $t1, -32768		# t1 = -2^15
		sub $t1, $t1, $a0	# t1 = t1 - a0
		bgt $t1, $zero, invalidInput		# a0 < -2^15
		
		li $t0, 32768		# t0 = 2^15
		sub $t0, $t0, $a1	# t0 = t0 - a1
		ble $t0, $zero, invalidInput		# a1 >= 2^15
		
		li $t1, -32768		# t1 = 2^15
		sub $t1, $t1, $a1	# t1 = t1 - a1
		bgt $t1, $zero, invalidInput		# a1 < -2^15
			

		#Function call
		jal seq_mult_booth
		
		



		# Display Result
		move $t0, $v0	#Save the result in register t0

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
	
	invalidInput:
		li $v0, 4
		la $a0, var_is_invalid
		syscall

		b exitLabel	

	
	exitLabel:
		li $v0, 10
		syscall
		
	seq_mult_booth:
		
		#Initialize the result register
		sll $v0, $a1, 16	
		srl $v0, $v0, 16

		li $t2, -32767
		slt $t2, $a0, $t2	# $t2 = 1 if a0 = -32767 (minimum) else 0
		

		li $t0, 0	#Initialize count
		li $t1, 0	#Initialize value of Q_minus
		
		sll $t5, $a0, 16
		srl $t5, $t5, 16	#Store the LSB 16 bits of the multiplicand
		
		
		multiplication_loop:
			addi $t0, $t0, 1	#Increment count in each loop
			beq $t0, 17, multiplication_end	#After 16 operations, exit the loop
			
			beq $t1, $zero, Q_minus_is_zero	#If Q_minus is 0
			
			andi $t3, $v0, 1	#Last bit of multiplier
			bne $t3, $zero, shift_right		#Case: 11
			
			#Case: 01
			#A = A + M
			srl $t4, $v0, 16
			add $t4, $t4, $t5
			sll $t4, $t4, 16
			sll $v0, $v0, 16
			srl $v0, $v0, 16
			or $v0, $v0, $t4
			j shift_right		#Arithmetic right shift 
			
			Q_minus_is_zero:
				andi $t3, $v0, 1	#Last bit of multiplier
				beq $t3, $zero, shift_right		#Case: 00
				
				#Case: 10
				#A = A - M
				srl $t4, $v0, 16
				sub $t4, $t4, $t5
				sll $t4, $t4, 16
				sll $v0, $v0, 16
				srl $v0, $v0, 16
				or $v0, $v0, $t4
				
			shift_right:
				andi $t3, $v0, 1	#Last bit of multiplier
				move $t1, $t3		#Q_minus = Last bit of multiplier
				sra $v0, $v0, 1	#Arithmetic right shift
				j multiplication_loop
			
		
		multiplication_end:
		
			beq $t2, $zero, return
			sub $v0, $zero, $v0	
		
		return:
			jr $ra		#Return with result in register v0

