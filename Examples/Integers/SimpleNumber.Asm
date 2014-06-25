; Кулаченко Николай 21 группа 2014г
; ввести число и определить простое ли оно
.686
include /masm32/include/io.asm


.data
	msgInputN	db 'Введите N: ', 0
	msgYes		db 'Число простое', 0
	msgNo		db 'Число непростое', 0

	N 		dd ?
	f 		dd 1
.code

;======== макрос проверки простого числа ========
Smpl macro Num
local L1
	mov ecx, Num
	dec ecx
L1:
	.if ecx > 1 && f > 0
		mov eax, Num
		mov edx, 0
	
		div ecx
		.if edx == 0
			mov f, 0
		.endif

		dec ecx
		jmp L1
	.endif
endm
;================================================

;========== обычный пример процедуры ============
outSmpl proc
	Smpl N 						; зовем наш макрос
	.if f > 0
		outstr offset msgYes 	; N - простое => 'Yes'
	.else
		outstr offset msgNo 	; N - непростое => 'No'
	.endif
	ret
outSmpl endp
;================================================


start:
	
	outstr offset msgInputN
	inint N

	call outSmpl
	
	inint eax

exit


end start