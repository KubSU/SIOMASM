outstr	macro string
	push	edx
	push	eax
	push	ecx
	push	string
	pop	edx
	call	_outstr
	pop	ecx
	pop	eax
	pop	edx
endm

outint	macro	num
	push	eax
	push	ecx
	push	edx
	push	num
	pop	eax
	call	_outint
	pop	edx
	pop	ecx
	pop	eax
endm

same	macro	name,variants,ans

	ans=0
	IRP	v,<variants>
	IFIDN	<name>,<v>
	ans=1
	EXITM
	ENDIF
	ENDM

endm

inint	macro	x
	LOCAL	regeax?
	push	ecx
	push	edx
	same	<x>,<eax,eAX,eAx,eaX,Eax,EAX,EAx,EaX>,regeax?
	IF	regeax?
	CALL	_inint
	ELSE
	PUSH	EAX
	CALL	_inint
	MOV	x, EAX
	POP	EAX
	ENDIF
	pop	edx
	pop	ecx
endm

newline	macro
	push	eax
	push	ecx
	push	edx
	printc	"\n"
	pop	edx
	pop	ecx
	pop	eax
endm