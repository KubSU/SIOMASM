.686
.model flat, stdcall
option casemap :none

.xlist
include io.asm		; macro
include iolib.asm	; it should be replaced by includelib iolib.obj
.list

.data

lpstrMsgInput db "Type number> ",0
lpstrMsgOutput db "Digits count: ",0

.code

start:

	outstr	offset lpstrMsgInput
	inint	eax

	mov	ecx, 0
	mov	ebx, 10

	.while eax
		mov	edx, 0
		div	ebx
		inc 	ecx
	.endw

	outstr	offset lpstrMsgOutput
	outint 	ecx


exit
end start