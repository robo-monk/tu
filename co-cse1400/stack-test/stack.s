.text
v: .asciz "value is: %d \n"

.global main

main:

test:
	movq $1, %rax
	pushq $8
	pushq $4
	pushq $7
	movq $5, %rdi
	addq $8, %rsp
	pushq %rbp
	movq %rsp, %rbp

	pushq %rdi
	mulq -8(%rbp)
	addq 16(%rbp), %rax

	movq %rbp, %rsp
	popq %rbp

	movq %rax, %rsi
	movq $0, %rax
	movq $v, %rdi
	call printf
	jmp end
sub:
	pushq %rbp		# push the base pointer
	movq %rsp, %rbp		# copy stack pointer value to base pointer

	pushq $620
	pushq $420
	pushq $220
	
	addq $16, %rsp

	movq $0, %rax
	movq $v, %rdi
	popq %rsi
	call printf
	

	movq $0, %rax
	movq $v, %rdi
	popq %rsi
	call printf

	movq %rbp, %rsp
	popq %rbp

	movq $0, %rax
	movq $v, %rdi
	movq %rbp, %rsi
	call printf
end:
	movq $0, %rdi
	call exit
