; Кулаченко Николай 21 группа 2014г
; работа с файлом
.486
.model flat, stdcall
option casemap :none

 ; директивы компоновщику для подключения inc-файлов и библиотек
 include \masm32\include\io.asm
 include \masm32\include\windows.inc
 include \masm32\include\user32.inc
 include \masm32\include\kernel32.inc
 include \masm32\macros\macros.asm
 include \masm32\macros\windows.asm

 includelib \masm32\lib\user32.lib
 includelib \masm32\lib\kernel32.lib

.data
  text    db "Hello, file!", 0     ; текст
  fLen    dd 0                     ; длина файла
  handler dd ?                     ; Handler для работы с файлом
  BUF     dd ?                     ; буфер
  br      dd ?                     ; вспомогательный сегмент

.code

start:

  ; создание файла с заданным именем и параметрами
  invoke CreateFile, chr$("test.txt"), GENERIC_WRITE, FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL  
  
  ; получаем Handler файла
  mov handler, eax

  ; длина строки с текстом
  invoke lstrlen, offset text         
  
  ; запись в файл текста
  invoke WriteFile, handler, offset text, eax, offset br,0   

  ; закрытие
  invoke CloseHandle, handler 
  
  ; открытие для чтения
  invoke CreateFile, chr$("test.txt"), GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL 

  mov handler, eax

  ; получение размера
  invoke GetFileSize, handler, NULL

  mov fLen, eax

  ; выделение памяти
  invoke VirtualAlloc, NULL, fLen, MEM_COMMIT, PAGE_READWRITE  

  mov BUF, eax

  ; чтение из файла в BUF длины fLen
  invoke ReadFile, handler, BUF, fLen, offset br, NULL 

  ; закрытие файла
  invoke CloseHandle, handler
  
  ; вывод текста из буфера
  invoke MessageBox, 0, BUF, chr$("FILE"), 0  
  
  invoke ExitProcess,0

  end start