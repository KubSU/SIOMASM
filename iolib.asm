.686

.model flat, stdcall
option casemap :none

.xlist
; either include this all
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include  \masm32\include\masm32.inc
include  \masm32\include\kernel32.inc
include \masm32\macros\macros.asm
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
; or just include \masm\include\masm32rt.inc
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
	invoke	dwtoa, eax, ADDR iolib_buffer
	print	addr iolib_buffer
	ret
_outint endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_inint		proc	far
	invoke	atol, input()
	ret
_inint endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;