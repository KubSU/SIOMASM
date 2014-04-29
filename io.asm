outstr	macro string
	push	edx
	push	string
	pop	edx
	call	_outstr
	pop	edx
endm

outint	macro	num
	push	eax
	push	num
	pop	eax
	call	_outint
	pop	eax
endm

inint	macro
	call	_inint
endm

newline	macro
	printc	"\n"
endm