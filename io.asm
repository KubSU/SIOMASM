outstr	macro string
	push	edx
	push	eax
	push	string
	pop	edx
	call	_outstr
	pop	eax
	pop	edx
endm

outint	macro	num
	push	eax
	push	num
	pop	eax
	call	_outint
	pop	eax
endm

same	MACRO	name,variants,ans

	ans=0
	IRP	v,<variants>
	IFIDN	<name>,<v>
	ans=1
	EXITM
	ENDIF
	ENDM

	ENDM

inint	macro	x
	LOCAL	regeax?
	same	<x>,<eax,eAX,eAx,eaX,Eax,EAX,EAx,EaX>,regeax?
	IF	regeax?
	CALL	_inint
	ELSE
	PUSH	EAX
	CALL	_inint
	MOV	x, EAX
	POP	EAX
	ENDIF
endm

newline	macro
	push	eax
	printc	"\n"
	pop	eax
endm