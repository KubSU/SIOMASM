.686
option casemap :none
include \masm32\include\masm32rt.inc

ltoa PROTO  :DWORD, :DWORD
StrLen PROTO :DWORD
atol PROTO :DWORD
strcpy	PROTO c	:dword, :dword

.data

iolib_buffer	db 	1024 dup (?)

.code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_outstr	proc
	invoke CharToOem, edx, addr iolib_buffer
	print	addr iolib_buffer
	ret
_outstr endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_outint	proc
	push	ecx
	invoke	ltoa, eax, ADDR iolib_buffer
	invoke	StrLen, addr iolib_buffer
	pop	ecx
	
	.if ecx > eax
		sub	ecx, eax
		.while ecx > 0
			push	ecx
			print	" "
			pop	ecx
			dec ecx
		.endw
	.endif
	print	addr iolib_buffer
	
	ret
_outint endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_inint	proc
	push	ecx
	push	edx
	invoke	atol, input()
	pop	edx
	pop	ecx
	ret
_inint endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_inch	proc
	push	ecx
	push	edx
	push	eax
	invoke	strcpy, addr iolib_buffer, input()
	pop	eax
	mov	al, iolib_buffer[0]
	pop	edx
	pop	ecx
	ret
_inch	endp

end