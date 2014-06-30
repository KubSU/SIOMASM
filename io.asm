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

outstrln macro string
	push	edx
	push	eax
	push	ecx
	push	string
	pop	edx
	call	_outstr
	printc	"\n"
	pop	ecx
	pop	eax
	pop	edx
endm

outch	macro	char
	push 	edx
	push	ecx
	push	eax
	printc char
	pop	eax
	pop	ecx
	pop	edx
endm

newline	macro
	outch "\n"
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

outint32 macro	num, digits := <0>
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

outint16	macro	num, digits := <0>
	push	eax
	push	ebx
	mov	ebx, eax
	mov	eax, 0
	mov	ax, bx
	pop	ebx
	mov	ax, num
	outint32 eax, digits
	pop	eax
endm

outint8		macro	num, digits := <0>
	push	eax
	push	ebx
	mov	ebx, eax
	mov	eax, 0
	mov	ax, bx
	pop	ebx
	mov	al, num
	mov	ah, 0
	outint32 eax, digits
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

inint32 macro	x
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

inint16 macro	x
	LOCAL	regeax?
	same	<x>,<ax,AX,Ax,aX>,regeax?
	IF	regeax?
	push	ebx
	push	eax
	CALL	_inint
	mov	ebx, eax
	pop	eax
	mov	ax, bx
	pop	ebx
	ELSE
	PUSH	EAX
	CALL	_inint
	MOV	x, ax
	POP	EAX
	ENDIF
endm

inint8	macro	x
	LOCAL	regax?
	same	<x>,<ah,AH,Ah,aH>,regax?
	IF	regax?
		push	ebx
		push	eax
		CALL	_inint
		mov	ebx, eax
		pop	eax
		mov	ah, bl
		pop	ebx
	ELSE
		same	<x>,<al,AL,Al,aL>,regax?
		IF	regax?
			push	ebx
			push	eax
			CALL	_inint
			mov	ebx, eax
			pop	eax
			mov	al, bl
			pop	ebx
		ELSE
			PUSH	eax
			CALL	_inint
			MOV	x,AL
			POP	eax
		ENDIF
	ENDIF
endm

.list