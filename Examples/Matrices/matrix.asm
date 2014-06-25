.686
include \masm32\include\io.asm

.data

msgInput	db	"Type dimension of matrix N $> ",0
i	dd	0
j	dd 	0
n	dd	0

.code

start:
;looks great if n > 20
	outstr	offset msgInput
	inint32 eax
	mov	n, eax
	mul	n
	mov	ecx, eax
	mov	eax, n
	
	.while ecx > 0
		.if j >= eax
			mov	j, 0
			inc	i
			newline
		.endif
		
		mov	ebx, n
		sub	ebx, j
		mov	edx, j
		
		.if ebx > i && i < edx
			outint8 0, 2
		.else
			outint8 1, 2
		.endif
		
		dec	ecx
		inc	j
	.endw
	newline

inkey
exit
end start