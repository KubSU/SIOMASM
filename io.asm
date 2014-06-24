.xlist
option casemap :none
include \masm32\include\masm32rt.inc
includelib \masm32\lib\iolib.lib

_outstr PROTO
_outint	PROTO 
_inint	PROTO
_inch	PROTO
system	PROTO c :dword

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

outch	macro	char
	push 	edx
	push	ecx
	push	eax
	printf("%c", char)
	pop	eax
	pop	ecx
	pop	edx
endm

inch	macro	x
	LOCAL	regax?
	same	<x>,<ah,AH,Ah,aH>,regax?
	IF	regax?
		XCHG	AH,AL
		CALL	_inch
		XCHG	AH,AL
	ELSE
		same	<x>,<al,AL,Al,aL>,regax?
		IF	regax?
			CALL	_inch
		ELSE
			PUSH	AX
			CALL	_inch
			MOV	x,AL
			POP	AX
		ENDIF
	ENDIF
endm

outint	macro	num, digits := <0>
	push	eax
	push	ecx
	push	edx
	push	num
	pop	eax
	push	digits
	pop	ecx
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
	push	ecx
	push	edx
	printc	"\n"
	pop	edx
	pop	ecx
	pop	eax
endm
.list