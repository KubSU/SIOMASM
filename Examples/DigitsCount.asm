.686
include /masm32/include/io.asm

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
newline

exit
end start