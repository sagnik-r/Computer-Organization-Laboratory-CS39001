#Assignment 7
#Semester A2020
#Sagnik Roy (18CS10063) Debajyoti Kar (18CS10011)
#Problem 3


.data
	array:	.word	0:9			# array of 9 integers
	input_prompt:	.asciiz "Insert 9 integers : \n"
	output: 	.asciiz "The entered integrs are : \n"
	prompt_key:	.asciiz "Enter the element to search in array : "
	found:	.asciiz "Element found at key : "
	not_found:	.asciiz	"Element not present in array"
	space: 		.asciiz " "
	newline: 	.asciiz "\n"

.text

main:
	la $a0, input_prompt
	li $v0, 4
	syscall

	li $t0, 0		# t0 is loop counter variable
	li $t1, 9		# t1 is array size
	la $t2, array	# t2 is base address of array

	for:
		bge $t0, $t1, end_for	# All inputs entered
		mul $t3, $t0, 4			# t3 is offset
		add $t4, $t2, $t3		# t4 is address where value is to be enetered 

		li $v0, 5				# take input 
		syscall

		sw $v0, ($t4)
		add $t0, $t0, 1			# Update loop counter variable
		b for

	end_for:


	la $a0, array			# Load base address of array to $a0
	li $a1, 9				# Load size of array to $a1
	jal InsertionSort		# call insertion sort procedure

	

	la $a0, output
	li $v0, 4
	syscall

	li $t0, 0		# t0 is loop counter variable
	li $t1, 9		# t1 is array size
	la $t2, array	# t2 is base address of array

	for_2:			# printing the integers in sorted order
		bge $t0, $t1, LoopEnd	# All elements printed
		mul $t3, $t0, 4			# t3 is offset
		add $t4, $t2, $t3		# t4 is address whose value is to be printed 

		lw $a0, 0($t4)			# Load the element from array to $a0
		li $v0, 1				# Integer Display
		syscall

		la $a0, space			# printing space after each integer
		li $v0, 4
		syscall
		
		add $t0, $t0, 1			# Update loop counter variable
		b for_2

	LoopEnd:

	li $v0, 4					# new Line after printing all integers
	la $a0, newline
	syscall


	la $a0, prompt_key			# prompt user to enter the search key
	li $v0, 4
	syscall

	li $v0, 5					# take input 
	syscall
	
	la $a0, array			# load base address of array to $a0
	li $a1, 0				# low index of binary search
	li $a2, 8				# hi index of binary search
	move $a3, $v0			# load the search key to $a3

	
	jal BinarySearch		# call the binary search routine
	
	beq $v0, -1, NotFound   # if $v0 = -1 -> element is not present in array
	move $t0, $v0			# load the value of $v0 to $t0

	la $a0, found           # Display message: Found element
	li $v0, 4
	syscall

	move $a0, $t0			# Display index at which element was found
	li $v0, 1	
	syscall

	j exitLabel

	NotFound:
		la $a0, not_found   # Element not found message 
		li $v0, 4
		syscall

		j exitLabel

	exitLabel:				# System exit
		la $a0, newline
		li $v0, 4
		syscall

		li $v0, 10
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
        
        jr $ra                 # return to caller

BinarySearch:
	
	add $t0, $a1, $a2                   # $t0 = start + end
    sra $s1, $t0, 1                     # $s1 = $t0 / 2

    # save $ra in the stack
    addi $sp, $sp, -4
    sw $ra, 0($sp)			            # saving $ra to stack

    sll $t3, $s1, 2 
    # base case
    blt $a2, $a1, returnNegative1       # if (end < start) 

    add $t3, $a0, $t3
    lw  $t1, 0($t3)                     # $t1 = arr[middle]
    move  $t2, $a3                      # $t2 = val
    beq $t1, $t2, returnMiddle          # if (arr[middle] == val)

    blt $t2, $t1, returnFirstPart       # if (val < arr[middle])

    bgt $t2, $t1, returnLastPart        # if (val > arr[middle])  

    returnNegative1:
       li $v0, -1
       j Exit       
    returnMiddle:
       move $v0, $s1                    # return middle
       j Exit   

    returnFirstPart:
           move $t3, $s1                # temp = middle     
           addi $t3, $t3, -1            # temp --
           move $a2, $t3                # end = temp
           jal BinarySearch
       j Exit

    returnLastPart:                             
       move $t3, $s1                    # temp = middle
       addi $t3, $t3, 1                 # temp++
       move $a1, $t3                    # start = temp
       jal BinarySearch
       j Exit   

	Exit:   
	    lw $ra, 0($sp)			# restore $ra from stack
	    addi $sp, $sp, 4		# restore stack pointer
	    jr $ra 					# Return to callee
