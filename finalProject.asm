.data
name: .asciiz "Eric Tercasio\n"
.align 2
fibArray: .word 
res: .space 400
numCount: .word 15
numCount2: .word 16
septor: .asciiz " , "
endOfList: .asciiz " end of list \n"
.align 2

.text

.globl  main
.macro PrintArray($arg1, $arg2)
	la	$a0,$arg1
	lw	$a1,$arg2
	jal	printTheList
.end_macro

main:

	jal	fibSequence
	PrintArray(fibArray, numCount2)
	


	li $v0, 10 		# syscall code 10 is for exit.
	syscall 	
fibSequence:
	la	$t0, fibArray
	lw	$s0, numCount
	add	$t1, $t1, 0
	add	$t2, $t2, 1
fibLoopStart:
	sw	$t1, fibArray
	sw	$t2, fibArray + 4
fibLoop2:
	bgt	$s1, $s0, endOfFib
	lw	$t1, fibArray($t3)
	add	$t3, $t3, 4
	lw	$t2, fibArray($t3)
	add	$t4, $t1, $t2
	add	$t3, $t3, 4
	sw	$t4, fibArray($t3)
	sub	$t3, $t3, 4
	add	$s1, $s1, 1
	
	j	fibLoop2

endOfFib:
	jr	$ra



printTheList:	# (&listOfNumber[],numCount)    print the array list
# use $t1 for &listOfNumber[]  address of listOfNumber
#     $t2 for numbCount
# push and save registers into the stack here
#
# 
	move 	$t2,$a1		# capture or move $a1 to $t2
	move 	$t1,$a0		# move the address of listOfNumber to $t1
chkmore:
	blez	$t2,printListend
	lw	$t3,0($t1)
	li	$v0,1		# system call for print_int
	add	$a0,$0,$t3
	syscall
	addi	$t1,$t1,4
	subi	$t2,$t2,1
	beqz 	$t2,printListend
	li	$v0,4
	la	$a0,septor
	syscall

	j	chkmore
printListend:
	li	$v0,4
	la	$a0,endOfList
	syscall 

	jr	$ra