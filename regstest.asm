.686
.model flat, stdcall
option casemap :none

.xlist
include io.asm		; macro
include iolib.asm	; it should be replaced by includelib iolib.obj
.list

.data


.code

start:

mov 	eax, 1
mov 	ebx, 2
mov		ecx, 3
mov		edx, 4
mov		esi, 5
mov		edi, 6

outint eax
newline
outint ebx
newline
outint ecx
newline
outint edx
newline
outint esi
newline
outint edi
newline



outint eax
newline
outint ebx
newline
outint ecx
newline
outint edx
newline
outint esi
newline
outint edi
newline


exit
end start