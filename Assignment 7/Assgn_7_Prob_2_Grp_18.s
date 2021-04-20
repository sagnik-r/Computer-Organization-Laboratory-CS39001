#Assignment 7
#Semester A2020
#Sagnik Roy (18CS10063) Debajyoti Kar (18CS10011)
#Problem 2


.data
	array:	.word	0:8				# array of 8 integers
	input_prompt:	.asciiz "Insert 8 integers : \n"
	output: 	.asciiz "The entered integrs in ascending order are : \n"
	space: 		.asciiz " "
	newline: 	.asciiz "\n"

.text

main:
	la $a0, input_prompt
	li $v0, 4
	syscall

	li $t0, 0		# t0 is loop counter variable
	li $t1, 8		# t1 is array size
	la $t2, array	# t2 is base address of array

	for:
		bge $t0, $t1, end_for	# All inputs entered
		mul $t3, $t0, 4			# t3 is offset
		add $t4, $t2, $t3		# t4 is address where value is to be enetered 

		li $v0, 5				# take input 
		syscall

		sw $v0, ($t4)			# store the input in the array
		add $t0, $t0, 1			# update the loop counter
		b for 					# branch to for loop

	end_for:


	la $a0, array				# store base address in $a0
	li $a1, 8					# size of array in $a1
	jal InsertionSort			# call insertion sort routine



	la $a0, output				# display message
	li $v0, 4
	syscall

	li $t0, 0		# t0 is loop counter variable
	li $t1, 8		# t1 is array size
	la $t2, array	# t2 is base address of array

	for_2:			# Printing the integers in sorted order
		bge $t0, $t1, exitLabel	# All elements printed
		mul $t3, $t0, 4			# t3 is offset
		add $t4, $t2, $t3		# t4 is address whose value is to be printed 

		lw $a0, 0($t4)
		li $v0, 1				#Integer Display
		syscall

		la $a0, space			# space after each integer
		li $v0, 4				
		syscall
		
		add $t0, $t0, 1			# Update loop counter
		b for_2

	exitLabel:
		la $a0, newline			# new line after printing all integers
		li $v0, 4
		syscall

		li $v0, 10				# System exit
		syscall

	InsertionSort:
        li $t0, 1
		# while i < N
        j checkOuter        	# test before 1st iteration
		outerLoop:              # body of loop here
	    	sll $t4, $t0, 2     # t0 is index, t4 is offset(t0 * 4)
	        add $t4, $a0, $t4   # address of a[i]
	
	        lw $t3, 0($t4)		# x ← A[i]
	
	        addi $t1, $t0, -1	# j ← i - 1
			# while j >= 0 and A[j] > x
	        j checkInner        # test before 1st iteration
		innerLoop:             # body of loop here
			# A[j+1] ← A[j]
	        sll  $t4, $t1, 2        # $t4 is the offset, $t1 is index
	        add $t4, $a0, $t4       # address of A[j]
            lw $t2, 0($t4)          # get value of A[j]
	        addi $t4, $t4, 4        # offset of A[j+1]
	        sw $t2, 0($t4)          # assign to A[j+1]
	
	        addi $t1, $t1, -1		# j ← j - 1
			# end while
		checkInner: 				# construct condition, j >= 0 and A[j] > x
	        blt $t1, $zero exitInnerLoop # convert to: if j < 0 break from loop #####
	        sll  $t4, $t1, 2        # $t4 is offset, $t1 is index
	        add $t4, $a0, $t4       # address of A[j]
	        lw $t2, 0($t4)          # get value of A[j]
	        bgt $t2, $t3, innerLoop  # break from loop already if false
		exitInnerLoop:                         # branch here to short-circuit and
			# A[j+1] ← x
	        add  $t4, $t1, 1        # scale index j+1 to offset
	        sll  $t4, $t4, 2        # scale index j to offset
	        add $t4, $a0, $t4       # address of a[j+1]
	        sw $t3, 0($t4)          # A[j+1] becomes x
			# i ← i + 1
	        addi $t0, $t0, 1
			# end while
		checkOuter: 
			blt $t0,$a1, outerLoop  # i < N 
	        
	        jr $ra                  # return to caller
