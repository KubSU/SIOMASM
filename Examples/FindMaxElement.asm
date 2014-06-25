.686
include /masm32/include/io.asm

.data

	lpstrMsgInput	db "Enter array length> ",0
	lpstrMsgOutput	db "Max element: ",0

	alength 		dd ?
	array 		dd 100 dup (?)

.code

start:

	outstr	offset lpstrMsgInput
	inint32	alength

	mov	ecx, alength
	mov	esi, 0

	.while	ecx
		inint32	array[esi]
		add	esi, 4
		dec	ecx
	.endw

	mov	eax, array[0]
	mov	ecx, alength
	mov	esi, 0

	.while	ecx
		.if array[esi] > eax
			mov	eax, array[si]
		.endif
		add	esi, 4
		dec	ecx
	.endw

	outstr	offset lpstrMsgOutput
	outint32 eax
	newline

inkey
exit
end start