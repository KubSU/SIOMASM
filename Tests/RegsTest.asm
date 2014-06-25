.686
include /masm32/include/io.asm

.data
char	db	0

.code

start:

mov 	eax, 0
mov 	ebx, 0
mov	ecx, 0
mov	edx, 0
mov	esi, 0
mov	edi, 0

inint32 eax
inint32 ebx
inint32 ecx
inint32 edx
inint32 esi
inint32 edi
inch	char

outch '='
newline

outint32 eax
newline
outint32 ebx
newline
outint32 ecx
newline
outint32 edx
newline
outint32 esi
newline
outint32 edi
newline
outch	char
newline
mov	eax, 0
mov	al, char
outint32	eax
newline

exit
end start