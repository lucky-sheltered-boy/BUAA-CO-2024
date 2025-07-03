.data
	array: .space 4008
	array_x: .space 4008
	array_y: .space 4008
	space: .asciiz " "
	enter: .asciiz "\n"
	
.text
	li $s1, 4
	li $v0, 5
	syscall
	move $a0, $v0 
	addi $a0, $a0, 1 #$a0=n+1
	
	li $v0, 5
	syscall
	move $a1, $v0
	addi $a1, $a1, 1  #$a1=m+1
	
	li $t0, 1      #$t0=i
	
for_i_start:
	slt $t2, $t0, $a0
	beq $t2, $0, for_i_end  #i<n
	li $t1, 1      #$t1=j
	
	for_j_start:
		slt $t2, $t1, $a1   #j<m
		beq $t2, $0, for_j_end
		
		li $v0, 5
		syscall
		move $t2, $v0 #$t2=input
		
		beq $t2, $0, end #$t2!=0
		
		la $t3, array
		add $t3, $t3, $s1
		sw $t2, 0($t3)
		la $t3, array_x
		add $t3, $t3, $s1
		sw $t0, 0($t3)
		la $t3, array_y
		add $t3, $t3, $s1
		sw $t1, 0($t3) #store information
		
		addi $s1, $s1, 4 #$s1+=4
		
	end:
		addi $t1, $t1, 1
		j for_j_start
		
	for_j_end:
		addi $t0, $t0, 1
		j for_i_start
	
for_i_end:
	subi $s1, $s1, 4
	
while_s1_start:
	beq $s1, $0, while_s1_end
	
	la $t3, array_x
	add $t3, $t3, $s1
	lw $a0, 0($t3)
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall
	la $t3, array_y
	add $t3, $t3, $s1
	lw $a0, 0($t3)
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall
	la $t3, array
	add $t3, $t3, $s1
	lw $a0, 0($t3)
	li $v0, 1
	syscall
	la $a0, enter
	li $v0, 4
	syscall
	
	subi $s1, $s1, 4
	j while_s1_start
	
while_s1_end:
	li $v0, 10
	syscall
	
	