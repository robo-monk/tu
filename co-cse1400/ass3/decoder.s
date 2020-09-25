.text
	value: .asciz "the value is %s"
	string: .asciz "%s"
	charn: .asciz "%c\n"
	char: .asciz "%c"
	digit: .asciz "%ld\n"
	hexa: .asciz "%lX"


/*.include "abc_sorted.s"*/
.include "helloWorld.s"

.global main

# params: clean_block
# ret: next address of block 
grab_nextadr:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
	#grab value
	movq %rdi, %rax	
	shr $32, %rax			# chop off value and times off the end of the block 16 bits to crop + 16 0 to crop from previous instruction
	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

# params: clean_block
# ret: times to print
grab_times:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
	# grab times
	movq %rdi, %rax			# move chopped block to new register, because the proccess will be destructive
	shl $32, %rax			# chop off value and times off the end of the block
	shr $56, %rax			# chop off value and times off the end of the block
	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

# params: clean_block
# ret: value to print
grab_value:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
	# grab value 
	movq %rdi, %rax			# move chopped block to ret register
	shl $40, %rax			# chop off value and times off the end of the block
	shr $56, %rax			# chop off value and times off the end of the block
	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

# params: message, block_andress
# ret: a clean block 
get_clean_block:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
	
	movq $8, %rax
	mulq %rsi
	addq %rax, %rdi			# go to the correct block
	movq (%rdi), %rax		# block to ret register
	shl $16, %rax			# chop the uknown-uneccessary bits
	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

# tests
test:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq %rdi, %rbx			# move to calle saved arg
	# testing the subroutines
	/*movq %rbx, %rdi*/
	call grab_value
	movq %rax, %rsi
	movq $0, %rax
	movq $charn, %rdi
	call printf			# print the value

	movq %rbx, %rdi
	call grab_times
	movq %rax, %rsi
	movq $0, %rax
	movq $digit, %rdi
	call printf			# print the times

	movq %rbx, %rdi
	call grab_nextadr
	movq %rax, %rsi
	movq $0, %rax
	movq $digit, %rdi
	call printf			# print the address

	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

#   params: the address of the message to read
#   ret: no
decode:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq %rdi, %rbx
	movq $0, %r12	

	decode_block:
		movq %r12, %rsi
		movq %rbx, %rdi
		call get_clean_block
		movq %rax, %r13 		# move clean block to rcx
		
		movq %r13, %rdi
		call grab_times
		movq %rax, %r14

		print_val:
			decq %r14
			movq %r13, %rdi
			call grab_value
			movq %rax, %rsi
			movq $0, %rax
			movq $char, %rdi
			call printf			# print the value

			cmpq $0, %r14
			jne print_val 

		movq %r13, %rdi
		call grab_nextadr
		movq %rax, %r12

		cmpq $0, %rax
		jne decode_block 

	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi		# first parameter: address of the message
	call	decode			# call decode

	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program

