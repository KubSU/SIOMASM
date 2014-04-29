.686
.model flat, stdcall
option casemap :none

.xlist
include io.asm		; macro
include iolib.asm	; it should be replaced by includelib iolib.obj
.list

.data

lpstrMessage db "Hello, World",13,10,0

.code

start:
; clear screen macro
; cls
; writing to console
outstr offset lpstrMessage

mov	ebx, 0
mov	eax, 1

.while eax
	; macro for changing cursor position
	;loc	ebx, eax
	; macro for writing to console
	printc "Hello world \n"
	outint	2014
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