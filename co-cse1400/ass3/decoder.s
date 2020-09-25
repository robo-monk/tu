.text
	value: .asciz "the value is %s"
	string: .asciz "%s"
	digit: .asciz "%ld\n"
	hexa: .asciz "%lX"


.include "abc_sorted.s"

.global main

# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte unknown                                         *
#   - 4 byte index                                           *
#   - 1 byte amount                                          *
#   - 1 byte character                                       *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************
decode:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
	# your code goes here

	addq $8, %rdi

	movq (%rdi), %rbx

	/*movq %rbx, %rsi*/
	/*movq $digit, %rdi*/
	/*movq $0, %rax*/
	/*call printf			# print the input byte block*/

	shl $16, %rbx			# chop the uknown-uneccessary bits

	/*movq %rbx, %rsi*/
	/*movq $0, %rax*/
	/*movq $digit, %rdi*/
	/*call printf			# print the chopped byte block*/

	# grab next address
	movq %rbx, %rcx			# move chopped block to new register, because the proccess will be destructive
	shr $32, %rcx			# chop off value and times off the end of the block 16 bits to crop + 16 0 to crop from previous instruction
	pushq %rcx			# push address value into the stack

	# grab times
	movq %rbx, %rcx			# move chopped block to new register, because the proccess will be destructive
	shl $32, %rcx			# chop off value and times off the end of the block
	shr $56, %rcx			# chop off value and times off the end of the block
	pushq %rcx			# push address value into the stack

	# grab value 
	movq %rbx, %rcx			# move chopped block to new register, because the proccess will be destructive
	shl $40, %rcx			# chop off value and times off the end of the block
	shr $56, %rcx			# chop off value and times off the end of the block
	pushq %rcx			# push address value into the stack


	# testing the values grabbed

	movq $0, %rax
	movq $digit, %rdi
	popq %rsi
	call printf			# print the value

	movq $0, %rax
	movq $digit, %rdi
	popq %rsi
	call printf			# print the times

	movq $0, %rax
	movq $digit, %rdi
	popq %rsi
	call printf			# print the address

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

