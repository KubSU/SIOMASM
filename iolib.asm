.686
option casemap :none
include \masm32\include\masm32rt.inc

ltoa PROTO  :DWORD, :DWORD
StrLen PROTO :DWORD
atol PROTO :DWORD
system	PROTO c :dword

.data

iolib_buffer	db 	255 dup (?)
iolib_cmd	db	"chcp 1251 > stderr",0
iolib_isCpChanged dw	0

.code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_outstr	proc
	.if iolib_isCpChanged == 0
		mov iolib_isCpChanged, 1
		push	edx
		invoke system, addr iolib_cmd
		pop	edx
	.endif
	print	edx
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

end