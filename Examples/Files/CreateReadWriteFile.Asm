; ��������� ������� 21 ������ 2014�
; ������ � ������
.486
.model flat, stdcall
option casemap :none

 ; ��������� ������������ ��� ����������� inc-������ � ���������
 include \masm32\include\io.asm
 include \masm32\include\windows.inc
 include \masm32\include\user32.inc
 include \masm32\include\kernel32.inc
 include \masm32\macros\macros.asm
 include \masm32\macros\windows.asm

 includelib \masm32\lib\user32.lib
 includelib \masm32\lib\kernel32.lib

.data
  text    db "Hello, file!", 0     ; �����
  fLen    dd 0                     ; ����� �����
  handler dd ?                     ; Handler ��� ������ � ������
  BUF     dd ?                     ; �����
  br      dd ?                     ; ��������������� �������

.code

start:

  ; �������� ����� � �������� ������ � �����������
  invoke CreateFile, chr$("test.txt"), GENERIC_WRITE, FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL  
  
  ; �������� Handler �����
  mov handler, eax

  ; ����� ������ � �������
  invoke lstrlen, offset text         
  
  ; ������ � ���� ������
  invoke WriteFile, handler, offset text, eax, offset br,0   

  ; ��������
  invoke CloseHandle, handler 
  
  ; �������� ��� ������
  invoke CreateFile, chr$("test.txt"), GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL 

  mov handler, eax

  ; ��������� �������
  invoke GetFileSize, handler, NULL

  mov fLen, eax

  ; ��������� ������
  invoke VirtualAlloc, NULL, fLen, MEM_COMMIT, PAGE_READWRITE  

  mov BUF, eax

  ; ������ �� ����� � BUF ����� fLen
  invoke ReadFile, handler, BUF, fLen, offset br, NULL 

  ; �������� �����
  invoke CloseHandle, handler
  
  ; ����� ������ �� ������
  invoke MessageBox, 0, BUF, chr$("FILE"), 0  
  
  invoke ExitProcess,0

  end start