.macro end
    li      $v0, 10
    syscall
.end_macro

.macro getInt(%des)
    li      $v0, 5
    syscall
    move    %des, $v0
.end_macro

.macro printInt(%src)
    move    $a0, %src
    li      $v0, 1
    syscall
.end_macro

.macro push(%src)
    addi    $sp, $sp, -4
    sw      %src, 0($sp)
.end_macro

.macro pop(%des)
    lw      %des, 0($sp)
    addi    $sp, $sp, 4
.end_macro

.macro getIndex(%ans, %n, %m)
	sll %ans %n 3
	add %ans %ans %m
	sll %ans %ans 2
.end_macro

.macro getBook(%ans, %x)
	move %ans %x
	sll %ans %ans 2
.end_macro

.data:

	G: .space 256
	book: .space 32

.text:

main:
	getInt($s0)  #s0=n
	getInt($s1)  #s1=m
	li $t0 0     #i=0
	
if_start:

	slt $t1 $t0 $s1
	beq $t1 $0 if_end
	getInt($s2)  #s2=x
	getInt($s3)  #s3=y
	
	subi $s2 $s2 1  #s2=x-1
	subi $s3 $s3 1  #s3=y-1
	li $t1 1
	getIndex($s4, $s2, $s3)
	sw $t1 G($s4)  #G[x-1][y-1]=1
	getIndex($s4, $s3, $s2)
	sw $t1 G($s4)  #G[y-1][x-1]=1

	addi $t0 $t0 1 #i++
	j if_start
	nop
	
if_end:

	li $v0 0
	move $a0 $0  #a0=x
	jal dfs  #dfs(0)
	nop
	
	printInt($v0)
	end
	
dfs:

	push($ra)
	push($t0)
	push($t1)
	
	move $t0 $a0  #t0=x
	
	getBook($t1,$t0)
	li $t2 1
	sw $t2 book($t1) #book[x]=1
	
	li $t3 1  #flag=1
	li $t4 0  #i=0
	
for1_start:

	slt $t1 $t4 $s0
	beq $t1 $0 for1_end
	
	getBook($t1,$t4)
	lw $t2 book($t1)
	and $t3 $t3 $t2
	
	addi $t4 $t4 1
	j for1_start
	
for1_end:
	
	getIndex($t2,$t0,$0)
	lw $t1 G($t2)
	and $t1 $t3 $t1  #t1=ans
	li $t2 1
	beq $t1 $t2 goto1
	nop
	j end1
	nop
	
goto1:
	
	li $v0 1
	pop($t1)
	pop($t0)
	pop($ra)
	jr $ra  #return

end1:
	
	li $t1 0  #i=0
	
for2_start:

	slt $t2 $t1 $s0
	beq $t2 $0 for2_end
	
	getBook($t2,$t1)
	lw $t3 book($t2)
	li $t5 1
	slt $t4 $t3 $t5
	getIndex($t5, $t0, $t1)
	lw $t2 G($t5)
	and $t2 $t2 $t4
	li $t3 1
	beq $t2 $t3 goto2
	nop
	j end2
	nop
	
goto2:

	move $a0 $t1
	jal dfs

end2:
	
	addi $t1 $t1 1
	j for2_start
	
for2_end:

	getBook($t1,$t0)
	sw $0 book($t1)
	
	pop($t1)
	pop($t0)
	pop($ra)
	jr $ra
