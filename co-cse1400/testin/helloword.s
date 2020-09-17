.text

welcome: .asciz "\n Welcome, whats up?"
prompt: .asciz "\n Enter a positive number:\n"

input: .asciz "%ld"
output: .asciz "The result is %ld. \n\n"


.global main

main:
	movq %rsp, %rbp		#standard thing
	movq $0, %rax		#something for the prinf
	movq $welcome, %rdi
	call printf
	call inout
end:
	movq $0, %rdi
	call exit

inout:
	pushq %rbp
	movq %rsp, %rbp
	
	movq $0, %rax
	movq $prompt, %rdi
	call printf

	subq $8, %rsp
	movq $0, %rax
	movq $input, %rdi
	leaq -8(%rbp), %rsi # what is this
	call scanf

	popq %rsi
	movq %rsi, %rax
	movq $2, %rbx
	movq $0, %rdx
	divq %rbx

	cmpq $0, %rdx
	jne odd

even:
	incq %rsi

odd:
	movq $0, %rax
	movq $output, %rdi
	
	call printf
	
	movq %rbp, %rsp
	popq %rbp
	
	ret
