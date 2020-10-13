.text
	value: .asciz "the value is %s"
	string: .asciz "%s"
	charn: .asciz "%c\n"
	char: .asciz "%c"
	digit: .asciz "%ld\n"
	hexa: .asciz "%lX"
	
	# ANSI
	test: .asciz "<%d> "
	fg_ansi: .asciz "\033[3%dm"
	bg_ansi: .asciz "\033[4%dm"
	
	free_ansi: .asciz "\033[%dm"
	reset_ansi: .asciz "\033[0m"

/*.include "abc_sorted.s"*/
/*.include "helloWorld.s"*/
.include "final.s"

.global main


# HELPER SUBROUTINES

# params: clean_block
# ret: next address of block 
grab_nextadr:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	#grab value
	movq %rdi, %rax			# move block to return register rax
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
	movq %rdi, %rax			
	shl $32, %rax			# chop off address
	shr $56, %rax			# shift right to compensate for the previous chopping

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
	shl $40, %rax			# chop off address + times
	shr $56, %rax			# shift right to compensate for the previous chopping

	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

reset_style:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq $0, %rax
	movq $reset_ansi, %rdi
	/*call printf*/

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

	# find the block	
	movq $8, %rax			# 8 for 8 bits
	mulq %rsi			# 8bits * relative address stored in rsi
	addq %rax, %rdi			# go to the correct block
	movq (%rdi), %rax		# contents of calculated address to rax
	# clean it
	shl $16, %rax			# chop the color bits

	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

# params: message, block_andress
# ret: block 
set_style:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	pushq	%rbx 
	pushq	%r11
	pushq	%r12
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	# find the block	
	movq $8, %rax			# 8 for 8 bits
	mulq %rsi			# 8bits * relative address stored in rsi
	addq %rax, %rdi			# go to the correct block
	movq (%rdi), %rbx		# contents of calculated address to rax

	movq %rbx, %r12
	shl $8, %r12	
	shr $56, %r12			# foreground color to r8
	
	movq %rbx, %r11
	shr $56, %r11			# background color to r9
	
	/*if fg & bg are equal, print a special character*/
	/*else, print fg and bg ansi escape codes*/
	cmpq %r11, %r12
	je print_special

	print_fg_bg:
		movq %r11, %rsi
		movq $bg_ansi, %rdi
		movq $0, %rax
		call printf

		movq %r12, %rsi
		movq $fg_ansi, %rdi
		movq $0, %rax
		call printf

		jmp style_epilogue

	print_special:
		movq %r12, %rdi		# sfx code
		call sfx_decode		# convert sfx code to ansi
		movq %rax, %rsi
		movq $0, %rax
		movq $free_ansi, %rdi
		call printf		# print ansi
	
	# epilogue
	style_epilogue:
		movq	%rbp, %rsp		# clear local variables from stack
		popq	%r12			# restore base pointer location 
		popq	%r11			# restore base pointer location 
		popq	%rbx			# restore base pointer location 
		popq	%rbp			# restore base pointer location 
		ret

	
# param: encoded sfx
# ret: ansi code
sfx_decode:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	/*reset*/
	movq $0, %rax
	cmpq $0, %rdi
	je sfx_ret

	/*stop blink*/
	movq $25, %rax
	cmpq $37, %rdi
	je sfx_ret

	/*bold*/
	movq $1, %rax
	cmpq $42, %rdi
	je sfx_ret

	/*faint*/
	movq $2, %rax
	cmpq $66, %rdi
	je sfx_ret

	/*conceal*/
	movq $8, %rax
	cmpq $105, %rdi
	je sfx_ret

	/*reveal*/
	movq $28, %rax
	cmpq $153, %rdi
	je sfx_ret

	/*blink*/
	movq $5, %rax
	cmpq $182, %rdi

	sfx_ret:	
	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret


# MAIN CODE


#   params: the address of the message to read
#   ret: no
decode:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	pushq	%rbx			# push contents of rbx
	pushq	%r12			# push contents of r12
	pushq	%r13			# push contents of r13
	pushq	%r14			# push contents of r14
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq %rdi, %rbx			# copy the input message to rbx
	movq $0, %r12			# r12 stores the address of the block to print - so 0 at first

	decode_block:
		movq %r12, %rsi			# param2 of set_color is the relative address
		movq %rbx, %rdi			# param1 is the message

		call set_style

		movq %r12, %rsi			# param2 of get_clean_block is the relative address
		movq %rbx, %rdi			# param1 is the message
		call get_clean_block
		movq %rax, %r13 		# move clean block to r13
		
		movq %r13, %rdi			# param1 of grab_times is a cleaned_block
		call grab_times
		movq %rax, %r14			# store times to print in %r14

		print_val:
			decq %r14			# dec 1 from how many time more to print
			movq %r13, %rdi			# param1 of grab_value is the cleaned block
			call grab_value
			movq %rax, %rsi			# param1 of printf is the value
			movq $0, %rax			# no vectors
			movq $char, %rdi		# param2 is an ASCII character formatting string
			call printf			# print the value

			cmpq $0, %r14			# print val it again?
			jne print_val 

		movq %r13, %rdi			# param1 of grab_nextadr is clean block	
		call grab_nextadr
		movq %rax, %r12			# store next address to r12

		cmpq $0, %r12			# if next address is not 0 do this again
		jne decode_block 

	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%r14			# restore og r14 
	popq	%r13			# restore og r13 
	popq	%r12			# restore og r12 value 
	popq	%rbx			# restore og rbx 
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

