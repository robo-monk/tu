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
	movq %rax, %r8		# writing returning values of 
	movq %rbx, %r9		# get2inputs to param slots of pow()	
	call pow
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

pow:
	# function that will print the base raised to an exponent
	# params - base in %r8 & exponent in %r9

	# prologue
	pushq %rbp		 
	movq %rsp, %rbp	
	pop %rbp		# put rbp back to original place
	movq %r8, %rax		# store base_prompt in rax
	
	# check if base is 0
	movq $0, %rsi		# result=0 if base is 0
	cmpq $0, %r8 		# compare base with rbx
	je pow_end 		# jump to end

	# check if expo is 0
	movq $1, %rsi		# result=1 if expo is 0
	cmpq $0, %r9 		# compare exponent with rbx
	je pow_end 		# jump to end
	
	pow_recur:
		movq %rax, %rsi		# set last value as current result
		cmpq $1, %r9 		# compare if the expo is 1
		je pow_end 		# jump if not equal back to the loop
		mulq %r8		# r8 = r8*r8 & save it to %rax
		decq %r9 		# decrement expo by 1
		jmp pow_recur		# loop

	pow_end:

		# print goodby message with result and returning
		movq $goodbye, %rdi 	# param1
					# param2 is the result ( already in %rsi) 
		movq $0, %rax 		# no vector registers for printf
		call printf
		
		movq %rsi, %rax		# return the result in the rax register
		# epilogue	
		movq %rbp, %rsp
		popq %rbp
		call end
