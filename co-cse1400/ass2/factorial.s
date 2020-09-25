# Assigment 2 - Computer Organisation - Filippos Taprantzis - 5110963

.text
hello: .asciz "\n Welcome to FACCtorial 🚀 \n - by Filippos Taprantzis ( 5110963 ) \n"
n_prompt: .asciz "Please enter a non-negative number:  \n > " 
digit_input: .asciz "%d" # input format string for digits
goodbye: .asciz "\n The result is: %d\n Thanks for using FACCtorial! \n" 

.global main

main:
	# greet user
	movq $0, %rax		# no vectors for last argument for printf
	movq $hello, %rdi	
	call printf		# print the greeting for the user

	# call get_input to grab a number from the user
	movq $n_prompt, %rdi	
	call get_input		# call the inout subroutine to collect user input

	# calling factorial
	movq %rax, %rdi		# writing returned value of get_input as first param (n) for factorial
	call factorial
	
	# say goodbye to user
	movq $goodbye, %rdi 	# param1
	movq %rax, %rsi		# return value of factorial as param2	
	movq $0, %rax 		# no vector registers for printf
	call printf

end:
	movq $0, %rdi		# load program exit code
	call exit		# exit the program


get_input: #(prompt)
	
	# prologue
	pushq %rbp 		# push the basepointer
	movq %rsp, %rbp		# copy stack pointing value to base pointer
	
	# prompt user to input a base
	movq $0, %rax 		# no vector registers for scanf
	call printf 		# print prompt asking user to input a base
	
	# grab the user input 
	subq $8, %rsp 		# reserve space on the stack
	movq $digit_input, %rdi # set param1 to the formated string ( digit )
	leaq -8(%rbp), %rsi	# set param2 to the reserved space
	movq $0, %rax		# no vectors as param
	call scanf

	# returning 2 values
	movq -8(%rbp), %rax 	# return input in rax register
	
	# epilogue - cleaning up
	movq %rbp, %rsp
	popq %rbp
	ret

factorial: #(n)

	# prologue
	pushq %rbp 		# push the basepointer
	movq %rsp, %rbp		# copy stack pointing value to base pointer

	# base case
	cmpq $1, %rdi
	jle base 		# jump to fac_end & ret 1 if n <= 0
	
	pushq %rdi		# push n to the stack
	decq %rdi		# dec n  by 1
	call factorial		# call factorial recursively
	popq %rcx		# pop n to a caller-saved register
	mul %rcx		# rax = fac(n-1)  * n 

	# epilogue - cleaning up
	movq %rbp, %rsp
	popq %rbp
	ret

	base:
		movq $1, %rax	# base case
		# epilogue - cleaning up
		movq %rbp, %rsp
		popq %rbp
		ret

