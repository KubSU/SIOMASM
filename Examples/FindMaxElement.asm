.686
.model flat, stdcall
option casemap :none

.xlist
include io.asm		; macro
include iolib.asm	; it should be replaced by includelib iolib.obj
.list

.data

	lpstrMsgInput	db "Enter array length> ",0
	lpstrMsgOutput	db "Max element: ",0

	alength 		dd ?
	array 		dd 100 dup (?)

.code

start:

	outstr	offset lpstrMsgInput
	inint	alength

	mov	ecx, alength
	mov	esi, 0

	.while	ecx
		inint	array[esi]
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
	outint 	eax
	inint	eax


exit
end start