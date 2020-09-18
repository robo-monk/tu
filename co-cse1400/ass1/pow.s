# This is an improved version of the submitted pow.s

.text
hello: .asciz "\n Welcome to POW 🚀 \n - by Filippos Taprantzis ( 5110963 ) \n"
base_prompt: .asciz "\n Please enter a non-negative base \n > " 
expo_prompt: .asciz "\n Pleae enter the exponent \n > "
digit_input: .asciz "%d" # input format string for digits
goodbye: .asciz "\n The result is: %d\n Thanks for using POW! \n" 

.global main

main:
	# prologue
	movq %rsp, %rbp		# init base pointer
	
	# greet user
	movq $0, %rax		# no vectors for last argument for printf
	movq $hello, %rdi	
	call printf		# print the greeting for the user

	# calling get2inputs to grab 2 inputs from the user
	call get2inputs		# call the inout subroutine to collect user input
	
	# calling pow
	movq %rax, %rdi		# writing returning values of 
	movq %rbx, %rsi		# get2inputs to param slots of pow()	
	call pow

	# print goodby message with result and returning
	movq $goodbye, %rdi 	# param1
	movq %rax, %rsi		# param2 is the ret value of pow
	movq $0, %rax 		# no vector registers for printf
	call printf
	

end:
	movq $0, %rdi		# load program exit code
	call exit		# exit the program

get2inputs:
	# function that will prompt the user for 2 inputs,
	# and will store them in %rax & %rbx

	# prologue
	pushq %rbp 		# push the basepointer
	movq %rsp, %rbp		# copy stack pointing value to base pointer
	
	# prompt user to input a base
	movq $base_prompt, %rdi
	movq $0, %rax 		# no vector registers for scanf
	call printf 		# print prompt asking user to input a base
	
	# grab the user input for the base
	subq $8, %rsp 		# reserve space on the stack
	movq $digit_input, %rdi # set param1 to the formated string ( digit )
	leaq -8(%rbp), %rsi	# set param2 to the reserved space
	movq $0, %rax		# no vectors as param
	call scanf
	
	# prompt user to input an expo
	movq $0, %rax
	movq $expo_prompt, %rdi 
	call printf		# print prompt asking user for an expo

	# grab the user input for the expo
	subq $16, %rsp		# reserve more space on the stack
	movq $digit_input, %rdi # set param1 to format string
	leaq -16(%rbp), %rsi	# set param2 to the reserved space
	movq $0, %rax		# no vectors as param
	call scanf

	# returning 2 values
	movq -8(%rbp), %rax 	# param1 is base
	movq -16(%rbp), %rbx	# param2 is exponent

	movq %rbp, %rsp
	popq %rbp
	ret

pow: # base, exponent
	
	# check if base is 0
	cmpq $0, %rax 		# if base=0 return 0	
	je pow_end 		# jump to end

	# check if expo is 0
	movq $1, %rax		# result=1 if expo is 0
	cmpq $0, %rsi 		# compare exponent with rbx
	je pow_end 		# jump to end
	
	movq %rdi, %rax		# store base in rax

	pow_recur:
		cmpq $1, %rsi 		# compare if the expo is 1
		je pow_end
		mulq %rax		# base = base*base
		decq %rsi 		# decrement expo by 1
		jmp pow_recur		# loop

	pow_end:
		ret
