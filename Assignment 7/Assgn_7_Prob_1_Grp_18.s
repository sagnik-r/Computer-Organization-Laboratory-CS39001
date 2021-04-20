#Assignment 7
#Semester A2020
#Sagnik Roy (18CS10063) Debajyoti Kar (18CS10011)
#Problem 1


.data
    buffer: .space 100
    str1:  .asciiz "Enter string : "
    str2:  .asciiz "String converted to lower case : "

.text

main:
    la $a0, str1    # Load and print string asking for string
    li $v0, 4
    syscall

    li $v0, 8       # take in input
    la $a0, buffer  # load byte space into address
    li $a1, 100     # allot the byte space for string
    syscall
    move $s0, $a0   # save string to s0

    li $v0, 4
    li $t0, 0

    #Loop to convert to lower case
    loop:
    lb $t1, buffer($t0)    #Load byte from 't0'th position in buffer into $t1
    beq $t1, 0, exit       #If ends, exit
    blt $t1, 'A', not_upper  #If less than A, continue
    bgt $t1, 'Z', not_upper #If greater than Z, continue
    add $t1, $t1, 32  #If uppercase, then add 32
    sb $t1, buffer($t0)  #Store it back to 't0'th position in buffer

    #if not upper, then increment $t0 and continue
    not_upper: 
    addi $t0, $t0, 1
    j loop

    exit:
    la $a0, str2    # load and print "String converted to lower case : " string
    li $v0, 4
    syscall

    move $a0, $s0   # primary address = s0 address (load pointer)
    li $v0, 4       # print string
    syscall
    li $v0, 10      # end program
    syscall
