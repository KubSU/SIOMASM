.686

include /masm32/include/io.asm

.data
i	dd	0
j	dd 	0
n	dd	0

m1	dd	100 dup(0)
m2	dd	100 dup(0)
m3	dd	100	dup(0)

msgInput db	"Type matrix dimension N<10 $> ",0

.code
start:

outstr	offset	msgInput
inint32	n

;seeding random generator
invoke GetCurrentProcessId
invoke nseed, eax

;initialize matrices
mov		ecx, 0

.while ecx < n
	mov	j, 0
	mov	ecx, 0
	.while ecx < n
		;index
		call	countIndex
		;fill with random value
		invoke nrandom, 100
		mov	m1[ebx], eax
		invoke	nrandom, 100
		mov	m2[ebx], eax
		inc j
		mov	ecx, j
	.endw
	inc	i
	mov	ecx, i
.endw

newline
mov	esi, offset m1
call outm
outch '+'
newline
mov	esi, offset m2
call outm
outch '='
newline

; multiple matrices
mov	ecx, 0
mov	i, 0
mov	j, 0
.while ecx < n
	mov	ecx, 0
	mov	j, 0
	.while ecx < n
		call	countIndex
		mov	eax, m1[ebx]
		add	eax, m2[ebx]
		mov	m3[ebx], eax
		inc	j
		mov	ecx, j
	.endw
	inc	i
	mov	ecx, i
.endw

mov	esi, offset m3
call outm
newline
inkey
exit

countIndex	proc
	mov	eax, i
	mul	n
	add	eax, j
	mov	ebx, 4
	mul	ebx
	mov	ebx, eax
	ret
countIndex endp

outm	proc

mov	ecx, 0
mov	i, 0
mov	j, 0
.while ecx < n
	mov	ecx, 0
	mov	j, 0
	.while ecx < n
		call	countIndex
		mov		edi, esi
		add		edi, ebx
		outint32 [edi], 4
		inc	j
		mov	ecx, j
	.endw
	newline
	inc	i
	mov	ecx, i
.endw
ret
outm	endp

end start