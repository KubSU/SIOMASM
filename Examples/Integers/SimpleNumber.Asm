; ��������� ������� 21 ������ 2014�
; ������ ����� � ���������� ������� �� ���
.686
include /masm32/include/io.asm


.data
	msgInputN	db '������� N: ', 0
	msgYes		db '����� �������', 0
	msgNo		db '����� ���������', 0

	N 		dd ?
	f 		dd 1
.code

;======== ������ �������� �������� ����� ========
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

;========== ������� ������ ��������� ============
outSmpl proc
	Smpl N 						; ����� ��� ������
	.if f > 0
		outstr offset msgYes 	; N - ������� => 'Yes'
	.else
		outstr offset msgNo 	; N - ��������� => 'No'
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