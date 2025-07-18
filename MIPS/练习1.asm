.macro scanf(%t)
	li $v0 5
	syscall
	move %t $v0
.end_macro

.macro printf(%t)
	move $a0 %t
	li $v0 1
	syscall
.end_macro

.text
main:
	scanf($s0)  #s0=n

for_start:
	slt $t0 $t1 $s0  #i<n
	beq $t0 $0 for_end
	
	scanf($t0)
	add $s1 $s1 $t0
	
	if_start:
		slt $t0 $s2 $s1
		beq $t0 $0 if_end
		
		move $s2 $s1
		
	if_end:
	
	addi $t1 $t1 1
	j for_start
	
for_end:	
	printf($s2)