.686
include /masm32/include/io.asm

.data


.code

start:

mov 	eax, 0
mov 	ebx, 0
mov	ecx, 0
mov	edx, 0
mov	esi, 0
mov	edi, 0

inint eax
inint ebx
inint ecx
inint edx
inint esi
inint edi


outch '='
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