.686

option casemap :none

.xlist
include \masm32\include\masm32rt.inc
.data

iolib_buffer	db 	255 dup (?)

.code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_outstr		proc	far
	print	edx
	ret
_outstr endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_outint		proc 	far
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
_inint		proc	far
	invoke	atol, input()
	ret
_inint endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;