; Кулаченко Николай 21 группа 2014г
; рандомно заполнить матрицу, найти минимальный элемент и обнулить строку-столбец, где он расположен
.686
include /masm32/include/io.asm


.data
	msgInputN	db 'Введите N: ', 0
	msgBefore 	db 'До: ', 0
	msgAfter 	db 'После: ', 0
	msgMinEl 	db 'Min = ', 0
	Arr 	dd 100 dup( 100 dup (?) )
	N 		dd ?
	i 		dd ?
	j 		dd ?

.code


;========= процедура вывода матрицы на экран ==========
_outMatrix proc
pusha
	mov esi, 0
	mov ecx, 0
	.while ecx < N
		push ecx

		mov ebx, 0
		mov ecx, 0
		.while ecx < N
			outint Arr[esi][ebx], 3 			; выводим элемент с отступом
			
			add ebx, 4
			inc ecx
		.endw

		newline
		pop ecx

		; too lazy to multiply by 4
		add esi, N
		add esi, N
		add esi, N
		add esi, N

		inc ecx
	.endw
popa
	ret
_outMatrix endp
;=======================================================


;====== процедура обнуляет i столбец и j строку =========
_nulMatrix proc
pusha
	mov esi, i
	mov ebx, 0
	mov ecx, 0
	.while ecx < N
		mov esi, i
		mov Arr[esi][ebx], 0

		add ebx, 4
		inc ecx
	.endw

	mov ebx, j
	mov esi, 0
	mov ecx, 0
	.while ecx < N
		mov ebx, j
		mov Arr[esi][ebx], 0

		; toooo lazy
		add esi, N
		add esi, N
		add esi, N
		add esi, N

		inc ecx
	.endw

popa
	ret
_nulMatrix endp
;==========================================================





start:
	; подключаем рандом  (randomize)
	invoke GetCurrentProcessId
	invoke nseed, eax


	; вводим N
	outstr offset msgInputN
	inint N


	; заполняем матрицу рандом. числами
	mov esi, 0
	mov ecx, 0
	.while ecx < N
		push ecx

		mov ebx, 0
		mov ecx, 0
		.while ecx < N
			pusha 								; помним, что invoke сбивает регистры
			invoke nrandom, 100 				; eax = random(100)
			mov Arr[esi][ebx], eax
			popa		
			
			add ebx, 4
			inc ecx
		.endw

		pop ecx

		; призываем на помощь копипасту
		add esi, N
		add esi, N
		add esi, N
		add esi, N

		inc ecx
	.endw


	; выводим матрицу
	newline
	outstr offset msgBefore
	newline
	call _outMatrix


	; ищем min,
	; а точнее [i,j] - координаты
	mov eax, Arr
	mov esi, 0
	mov ecx, 0
	.while ecx < N
		push ecx

		mov ebx, 0
		mov ecx, 0
		.while ecx < N
			.if Arr[esi][ebx] < eax
				mov i, esi
				mov j, ebx
				mov eax, Arr[esi][ebx]
			.endif		
			
			add ebx, 4
			inc ecx
		.endw

		pop ecx

		; да поможет нам копипаста!
		add esi, N
		add esi, N
		add esi, N
		add esi, N

		inc ecx
	.endw


	; выводим min
	newline
	outstr offset msgMinEl
	outint eax
	newline

	; обнуляем строку-столбец
	call _nulMatrix

	; выводим матрицу
	newline
	outstr offset msgAfter
	newline
	call _outMatrix
	
	inint eax

exit

end start