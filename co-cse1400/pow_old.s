.text

welcome: .asciz "\n Assembly Assignment 1 - Filipos Taprantzis ( 5110963 )"
prompt_base: .asciz "\n Input the base: "
prompt_expo: .asciz "\n Input the exponent: "
input: .asciz "%ld"
output: .asciz "The result is %ld. \n\n"
debug: .asciz "value is %ld. \n"

.global main

main:
	# prologue	
	movq %rsp, %rbp
	
	movq $0, %rax
	movq $welcome, %rdi
	call printf
	
	call inout

end:
	movq $0, %rdi
	call exit

inout:
	# prologue
	pushq %rbp
	movq %rsp, %rbp
	
	movq $0, %rax
	movq $prompt_base, %rdi
	call printf

	movq $0, %rax
	movq $input, %rdi
	leaq -8(%rbp), %rsi
	call scanf
	popq %rsi
	
	ret

pow:
	# function pows %R8 to %R9
	# returns result in %RAX
		
	cmpq $2, %r9	
	je pow_end
	
	# movq %r8, %rax
	# movq %r8, %rbx	
	
	decq %r9
	jmp pow
	
pow_end:
	movq %r8, %rax	
	ret

pow_invalid:

	# deals with malformed input for pow()
	ret
	
