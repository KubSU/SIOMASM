; Кулаченко Николай 21 группа 2014г
; рандомно заполнить массив и заменить минимальный элемент максимальным
.686
include /masm32/include/io.asm


.data
	msgInputN	db 'Введите N: ', 0
	msgBefore 	db 'До: ', 0
	msgAfter 	db 'После: ', 0
	Arr 	dd 100 dup(?)
	N 		dd ?
.code


;==== процедура вывода массива на экран ====
_outArray proc
pusha
	mov esi, 0
	mov ecx, 0
	.while ecx < N
		outint Arr[esi]
		outch ' '

		add esi, 4
		inc cx
	.endw
popa
	ret
_outArray endp
;=============================================



start:
	; подключаем random  (randomize)
	invoke GetCurrentProcessId
	invoke nseed, eax


	; вводим N
	outstr offset msgInputN
	inint N


	; заполняем массив рандом. числами
	mov esi, 0
	mov ecx, 0
	.while ecx < N
		pusha 								; помним, что invoke сбивает регистры
		invoke nrandom, 100 				; eax = random(100)
		mov Arr[esi], eax
		popa

		add esi, 4
		inc ecx
	.endw


	; выводим массив
	newline
	outstr offset msgBefore
	newline
	call _outArray

	; ищем max
	mov	eax, Arr
	mov	ecx, 0
	mov	esi, 0

	.while ecx < N
		.if Arr[esi] > eax
			mov	eax, Arr[si]
		.endif
		add	esi, 4
		inc	ecx
	.endw


	; ищем min
	mov	ebx, Arr
	mov	ecx, 0
	mov	esi, 0

	.while ecx < N
		.if Arr[esi] < ebx
			mov	ebx, Arr[si]
		.endif
		add	esi, 4
		inc	ecx
	.endw


	;=====   min <- max   ======
	; eax = max
	; ebx = min
	mov esi, 0
	mov ecx, 0
	.while ecx < N
		.if Arr[esi] == ebx
			mov Arr[esi], eax
		.endif
		add esi, 4
		inc cx
	.endw


	; таки снова выводим массив
	newline
	outstr offset msgAfter
	newline
	call _outArray
	
	inint eax

exit

end start