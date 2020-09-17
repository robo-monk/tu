# Assigment 2 - Computer Organisation

.text
hello: .asciz "\n Welcome to FACCtorial 🚀 \n - by Filippos Taprantzis ( 5110963 ) \n"
n_prompt: .asciz "\n Please enter the n:  \n > " 
digit_input: .asciz "%d" # input format string for digits
goodbye: .asciz "\n The result is: %d\n Thanks for using FACCtorial! \n" 

.global main

main:
	# prologue
	movq %rsp, %rbp		# init base pointer
	
	# greet user
	movq $0, %rax		# no vectors for last argument for printf
	movq $hello, %rdi	
	call printf		# print the greeting for the user

	# calling get2inputs to grab 2 inputs from the user
	movq $n_prompt, %rdi	
	call get_input		# call the inout subroutine to collect user input
	
	# calling factorial
	movq %rax, %r8		# writing returned value of get_input as first param for factorial
	movq $0, %r9		# 0 as second param of factorial ( 0 carry )
	call factorial
end:
	movq $0, %rdi		# load program exit code
	call exit		# exit the program

get_input:
	# prompts a message stored in %RDI
	# and asks user for an digital input

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
	
	# epilogue
	movq %rbp, %rsp
	popq %rbp
	ret

factorial_end:
	# print goodby message with result

	movq %r9, %rsi
	movq $goodbye, %rdi 	# param1
				# param2 is the result ( already in %rsi) 
	movq $0, %rax 		# no vector registers for printf
	call printf
	
	# epilogue	
	call end
factorial_start:
	movq %r8, %r9

factorial:
	# accepts 2 params, n in r8 & carry in r9 
	
	# prologue
	cmpq $0, %r9		
	je factorial_start

	cmpq $1, %r8
	jle factorial_end	# base case return r9
	
	decq %r8
	movq %r8, %rax		# writing returned value of get_input as first param for factorial
	mulq %r9		# 0 as second param of factorial ( 0 carry )
	movq %rax, %r9
	jmp factorial
	ret

