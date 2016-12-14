.data
name: .asciiz "Eric Tercasio\n"
.align 2
fibArray: .word 
res: .space 400
numCount: .word 15
septor: .asciiz " , "
fibTerms: .asciiz "15 terms of Fibonacci sequence:\n"
genTable: .asciiz "Generate approx Golden Ratio Table :\n"
newLine: .asciiz "\n"
period: .asciiz "."
tab: .asciiz "	"
a: .asciiz "A"
b: .asciiz "B" 
bOverA: .asciiz "B/A"
.align 2

.text

.globl  main
.macro printString(%address)
	li $v0, 4
	la $a0, %address
	syscall 
.end_macro
.macro PrintArray($arg1, $arg2)
	la	$a0,$arg1
	lw	$a1,$arg2
	jal	printTheList
.end_macro

.macro print_newline
	li $v0, 11
	li $a0, '\n'
	syscall 
.end_macro
.macro printTab
	li $v0, 4
	la $a0, tab
	syscall 
.end_macro
.macro printInt(%register)
	li $v0, 1
	add $a0, $zero, %register
	syscall
.end_macro
main:

	jal	fibSequence
	
	li	$v0,4
	la	$a0,fibTerms
	syscall
	
	print_newline
	 
	PrintArray(fibArray, numCount)
	
	print_newline
	
	print_newline
	
	li	$v0,4
	la	$a0,genTable
	syscall
	
	print_newline
	

	
	jal	goldenTable
	
	print_newline

	li $v0, 10 		
	syscall 	
fibSequence:
	la	$t0, fibArray		#loads blank array
	lw	$s0, numCount		#loads numCount
	add	$s1, $s1, 2		#Start at 3rd number for loop
	add	$t1, $t1, 0		#first number is 0
	add	$t2, $t2, 1		#Second is 1
fibLoopStart:		
	sw	$t1, fibArray		#Store 0 into first spot
	sw	$t2, fibArray + 4	#Store 1 into second
fibLoop2:
	bgt	$s1, $s0, endOfFib	#If counter greater than numCount, end
	lw	$t1, fibArray($t3)	#Load first word to add
	add	$t3, $t3, 4		#Add 4 to get to next Number
	lw	$t2, fibArray($t3)	#Load second word to add
	add	$t4, $t1, $t2		#Add words together
	add	$t3, $t3, 4		#Move up 4 in array
	sw	$t4, fibArray($t3)	#Store at that location
	sub	$t3, $t3, 4		#subtract to go back
	add	$s1, $s1, 1		#add 1 to counter
	
	j	fibLoop2

endOfFib:
	jr	$ra


goldenTable:
	add	$s0, $0, $0
	 add	$t0, $0, $0
	 add	$t1, $0, $0
	 add	$t2, $0, $0
	 add	$t3, $0, $0
	 add	$t4, $0, $0
	 add	$t4, $t4, 12
	 add	$t5, $0, $0
	 la	$s5, fibArray
	 add	$s5, $s5, $t4
	 printString(a)
	 printTab
	 printString(b)
	 printTab
	 printString(bOverA)
	 print_newline
	 print_newline
	 
	 j	goldenLoop
startOfGoldenLoop:
	add	$s5, $s5, 4		#start at 4th word
	add	$s0, $0, $0
	print_newline
	print_newline
goldenLoop:
	beq	$t5, 11, endOfGolden	#if 11 words done, end
	lw	$t0,0($s5)		#load word at location of $s5
	lw	$t1,4($s5) 		#load word at 1 word up from that
	div	$t2, $t1, $t0		#divide
	printInt($t0)
	printTab
	printInt($t1)
	printTab	
	printInt($t2)
	li	$v0,4
	la	$a0,period
	syscall
	add	$t5, $t5, 1		#move up 1 on counter
	 
printDecimal:
	beq	$s0, 5, startOfGoldenLoop	#Stop after 5th decimal place
	mfhi    $t3				#put remainder into $t3
	mul	$t3, $t3, 10			#multiply by 10
	div	$t3, $t3, $t0			#Divide remainder by divided number
	printInt($t3)
	add	$s0, $s0, 1			#add 1 to inner counter

	j	printDecimal
	
endOfGolden:
	jr	$ra	


printTheList: 
	move 	$t2,$a1		
	move 	$t1,$a0		
chkmore:
	blez	$t2,printListend
	lw	$t3,0($t1)
	li	$v0,1	
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

	jr	$ra
