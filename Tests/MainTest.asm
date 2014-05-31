.686
include /masm32/include/io.asm

.data

lpstrMessage db "Hello, World", 13,10,0
lpstrMsgInput db "Type number> ",0
msgArr	db 	"====Array===",0
num	dd	5
arr	dd	10 dup(?)

.code

start:

outstr	offset	lpstrMsgInput
inint	eax
outstr	offset lpstrMessage
sub	eax, 5
outint	eax, 3
newline
outint	num
newline

outstr	offset 	msgArr
newline

mov	ebx, 0
mov	eax, 2
.while ebx < 10
	mov	arr[ebx], eax
	outint	arr[ebx]
	newline
	inc	ebx
	mul	ebx
.endw



exit
end start