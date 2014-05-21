.686
.model flat, stdcall
option casemap :none

.xlist
include io.asm		; macro
include iolib.asm	; it should be replaced by includelib iolib.obj
.list

.data

lpstrMessage db "Hello, World", 13,10,0
lpstrMsgInput db "Type number> ",0

.code

start:
; clear screen macro
; cls

outstr	offset	lpstrMsgInput
inint	eax
outstr	offset lpstrMessage
sub	eax, 5
outint	eax, 3
newline

mov	ebx, 0
mov	eax, 1

.while eax
	outint	eax
	outch ';'
	outint ebx
	newline
	
	inc	ebx
	mov	eax, ebx
	mov	edx, 0
	mov 	ecx, 3
	div	ecx
	mov 	eax, edx
.endw



exit
end start