.text

main:

	li $v0, 5
	syscall    #read year
	
	move $a0, $v0  #year
	li $a1, 400
	div $a0, $a1
	mfhi $a2   #%400
	
	beq $a2, $0, out1
	nop
	
	li $a1, 4
	div $a0, $a1
	mfhi $a2
	
	bne $a2, $0, out0
	nop
	
	li $a1, 100
	div $a0, $a1
	mfhi $a2
	
	beq $a2, $0, out0
	nop
	
	j out1
	
	li $v0, 10
	syscall
	
out1:
	li $a0, 1
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
out0:
	li $a0, 0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall