.macro printbyte(%d)
	li  $a1, 0
	lb  $a0, %d($a1)
	li  $v0, 1
	syscall
.end_macro

.data
word: .word     0x12345678
space: .asciiz " "

.text
printbyte(0)
la $a0, space
li $v0, 4
syscall
printbyte(1)
la $a0, space
li $v0, 4
syscall
printbyte(2)
la $a0, space
li $v0, 4
syscall
printbyte(3)

li  $v0, 10
syscall
