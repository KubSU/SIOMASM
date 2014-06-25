; Кулаченко Николай 21 группа 2014г
; по клику мышки отрисовывает расширяющийся круг
  .386
    .model flat, stdcall  ;Плоская модель.

    option casemap :none  ;Директива говоpит MASM сделать метки 
                          ;чувствительными к pегистpу.
                          ;Необходимо для безошибочного подключения 
                          ;windows.inc-файла.

    ;Директивы компоновщику для подключения inc-файлов и библиотек.	
    include \masm32\include\io.asm
    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
    include \masm32\include\gdi32.inc
    include \masm32\include\windows.inc
    include \masm32\include\comdlg32.inc

    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\gdi32.lib
    includelib \masm32\lib\comdlg32.lib

    ;===============================
    ; Объявление локальных макросов
    ;===============================
        szText MACRO Name, Text:VARARG
          LOCAL lbl
            jmp lbl
              Name db Text,0
            lbl:
          ENDM

        m2m MACRO M1, M2
          push M2
          pop  M1
        ENDM

        return MACRO arg
          mov eax, arg
          ret
        ENDM

    ;=========================================
    ; Объявление прототипов локальных функций 
    ;=========================================
        WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD
        WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
        TopXY PROTO   :DWORD,:DWORD

    .data
      ;Название нашего окна
        szDisplayName db "!! Draw circles !!",0	
      ;Дескриптор коммандной строки
        CommandLine   dd ?
      ;Дескриптор окна
        hWnd          dd ?
      ;Дескриптор приложения
        hInstance     dd ?
      ;Дескриптор главного меню
        hMenu         dd ?
      ;Дескрипторы используемых карандашей и кистей   
        hPen          dd ?
        hBrush        dd ?
      ;Структура для хранения координат вершин прямоугольника клиентской области
        cRect         RECT <?>
      ;Координаты мышки
        PosX          dd ?
        PosY          dd ?
      ; Для рисования круга
        R             dd 20
        Ri            dd ?
        x1            dd ?
        x2            dd ?
        y1            dd ?
        y2            dd ?
      ;Текущие размеры экрана
        XM            dd ?
        YM            dd ?
      ; Текст
        msg1          db "Круги по нажатию левой кнопки мыши"
      ; Массив используемых нами цветов
        Color         dd 000000h  ;clBlack
                      dd 000080h  ;clMaroon
                      dd 008000h  ;clGreen
                      dd 008080h  ;clOlive
                      dd 800000h  ;clNavy
                      dd 800080h  ;clPurple
                      dd 808000h  ;clTeal
                      dd 808080h  ;clGray
                      dd 0C0C0C0h ;clSilver
                      dd 0000FFh  ;clRed
                      dd 00FF00h  ;clLime
                      dd 00FFFFh  ;clYellow
                      dd 0FF0000h ;clBlue
                      dd 0FF00FFh ;clFuchsia
                      dd 0FFFF00h ;clAqua
                      dd 0C0C0C0h ;clLtGray
                      dd 808080h  ;clDkGray
                      dd 0FFFFFFh ;clWhite
      ; Вспомогательные переменные     
        Four          dd 4        ; для умножения на 4
        hBrushColor   dd 000000h  ; для сл. цвета кисти
        hPenColor     dd 000000h  ; для сл. цвета карандаша
        bgColor       dd ?        ; сохраним номер цвета фона

    .code

start:
    invoke GetModuleHandle, NULL	;Получить дескриптор приложения
    mov hInstance, eax
    invoke GetCommandLine		      ;Получить дескриптор коммандной строки
    mov CommandLine, eax
    invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
    invoke ExitProcess, eax		    ;Выход из программы (завершить процесс).

WinMain proc hInst     :DWORD,
             hPrevInst :DWORD,
             CmdLine   :DWORD,
             CmdShow   :DWORD

    ;===============================
    ; Вводим "локальные" переменные
    ;===============================
        LOCAL wc   :WNDCLASSEX
        LOCAL msg  :MSG
        LOCAL Wwd  :DWORD
        LOCAL Wht  :DWORD
        LOCAL Wtx  :DWORD
        LOCAL Wty  :DWORD

    szText szClassName,"Class1"	;Имя класса

    ;================================================
    ; Заполняем WNDCLASSEX структуру нужными данными
    ;================================================
        mov wc.cbSize,         sizeof WNDCLASSEX
        mov wc.style,          CS_HREDRAW + CS_VREDRAW + CS_SAVEBITS + CS_OWNDC
        mov wc.lpfnWndProc,    offset WndProc
        mov wc.cbClsExtra,     NULL
        mov wc.cbWndExtra,     NULL
        m2m wc.hInstance,      hInst

  ;Декскриптор кисти фона (NULL-фон рисоваться не будет)
  
  
    ; подключаем рандом  (randomize)
	invoke GetCurrentProcessId
	invoke nseed, eax
  
    
    ; получаем рандомный номер в массиве цвета
    call GetRandColor       ; в eax
    mov bgColor, eax        ; сохраним цвет фона
    mov ebx, bgColor
    
    invoke CreateSolidBrush, Color[ebx]  
    mov wc.hbrBackground,  eax

    mov wc.lpszMenuName,   NULL
    mov wc.lpszClassName,  offset szClassName
  ;Читаем стандартную иконку
    invoke LoadIcon, 7F00h, 0
    mov wc.hIcon,          eax
  ;Читаем курсор с идентификатором 1000 из ресурсов приложения
    invoke LoadCursor, hInst, 3e8h
    mov wc.hCursor,        eax
    mov wc.hIconSm,        0

    invoke RegisterClassEx, ADDR wc	;Регистрируем класс "Class1"

  ;Получаем информацию о размерах экрана и по заданным длине 
  ;и ширине окна находим центральное расположение окна
    mov Wwd, 800
    mov Wht, 600
    invoke GetSystemMetrics, SM_CXSCREEN
    mov XM, eax
    invoke TopXY, Wwd, eax
    mov Wtx, eax
    invoke GetSystemMetrics, SM_CYSCREEN
    mov YM, eax
    invoke TopXY, Wht, eax
    mov Wty, eax

  ;Создаем окно зарегестрированного класса
  invoke CreateWindowEx, 0,
                        ADDR szClassName,
                        ADDR szDisplayName,
                        WS_OVERLAPPED + WS_CAPTION + WS_SYSMENU + \
                        WS_MINIMIZEBOX + WS_MAXIMIZEBOX + WS_THICKFRAME,
                        Wtx,Wty,Wwd,Wht,
                        NULL,NULL,
                        hInst,NULL
  mov hWnd, eax

  invoke LoadMenu, hInst, 2	  ;Читаем меню с идентификатором 2
  mov hMenu, eax
  invoke SetMenu, hWnd, eax	  ;Привязываем его к нашему окну

  ;Показываем созданное окно
  invoke ShowWindow, hWnd, SW_SHOWNORMAL
  ;Перерисовываем содержимое окна
  invoke UpdateWindow, hWnd

  ;==========================
  ; Цикл обработки сообщений
  ;==========================
      StartLoop:
        invoke GetMessage, ADDR msg, NULL, 0, 0
        cmp eax, 0
        je ExitLoop
        invoke DispatchMessage,  ADDR msg
        jmp StartLoop
      ExitLoop:

  return msg.wParam
WinMain endp


; Для изм. координат круга:
; x1 += eax, y1 += eax
; x2 -= eax, y2 -= eax
GetXY proc
    push PosX
    pop x1
    add x1, eax
        
    push PosX
    pop x2
    sub x2, eax

    push PosY
    pop y1
    add y1, eax

    push PosY
    pop y2
    sub y2, eax
    
    ret
GetXY endp


; eax = random(17) * 4 - случайный номер цвета в массиве Color[]
GetRandColor proc
	
	invoke nrandom, 17 				; eax = random(17)
	
	mov edx, 0
	mul Four                        ; eax = eax * 4
	
    ret

GetRandColor endp


;Функция обработки сообщений главного окна
WndProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD

    ;===============================
    ; Вводим "локальные" переменные
    ;===============================
	LOCAL hDC  :DWORD
	LOCAL Ps   :PAINTSTRUCT

    ; LMB_UP
    .if uMsg == WM_LBUTTONUP

        ; Получаем координаты мышки и записываем их в PosX, PosY
        mov ecx, 0h

        mov cx, WORD PTR [lParam]
        mov PosX, ecx
        mov cx, WORD PTR [lParam+2h]
        mov PosY, ecx
        
        ; Получаем рандомный номер в массиве цветов для кисти
        call GetRandColor
        mov hBrushColor, eax
        
        ; Получаем рандомный номер в массиве цветов для карандаша
        call GetRandColor
        mov hPenColor, eax
                
        ; Запускаем таймер
        mov Ri, 1
        invoke SetTimer, hWnd, 1, 50, NULL

        return 0

    ; TIMER
    .elseif uMsg == WM_TIMER

        ; изменяем радиус круга 1..R
        mov eax, R
        .if Ri < eax
          inc Ri
          mov eax, Ri
          call GetXY            ; получаем координаты текущего круга
                                ; x1, y1, x2, y2 завис. от радиуса
        .endif

        invoke InvalidateRect, hWnd, NULL, 1

        return 0

    ; PAINT
    .elseif uMsg == WM_PAINT
        ; рисуем в BeginPaint'е
        invoke BeginPaint, hWnd, ADDR Ps
          mov hDC, eax 

          mov ebx, hBrushColor                  ; hBrushColor - случайный номер для цвета кисти

          ;Создаем кисть
          invoke CreateSolidBrush, Color[ebx]
          mov hBrush, eax
          invoke SelectObject, hDC, eax

          mov ebx, hPenColor                    ; hPenColor - случайный номер для цвета карандаша

          ;Создаем карандаш
          invoke CreatePen, PS_SOLID, 4, Color[ebx]
          mov hPen, eax
          invoke SelectObject, hDC, eax

          ;Цвет для вывода строки
          mov ebx, bgColor
          invoke SetBkColor, hDC, Color[ebx]
          ;invoke SetTextColor, hDC, Color[4] - цвет текста 
          


          invoke DrawText, hDC, ADDR msg1, sizeof msg1, ADDR cRect,
                                 DT_VCENTER or DT_CENTER or DT_NOPREFIX


          ;Собственно, рисуем круг!
          invoke Ellipse, hDC, x1, y1, x2, y2


          ;Освобождаем контекст и удаляем кисть
          invoke DeleteObject, hBrush
          invoke DeleteObject, hPen

        invoke EndPaint,hWnd,ADDR Ps
        return 0

    ; SIZE
    .elseif uMsg == WM_SIZE

        ;Получаем информацию о текущих размерах клиентской области окна
        invoke GetClientRect, hWin, ADDR cRect

        return 0

    ; DESTROY
    .elseif uMsg == WM_DESTROY
      ;Удаляем созданные объекты
        invoke DeleteObject, hPen
        invoke DeleteObject, hBrush
        invoke PostQuitMessage, NULL

        return 0
    .endif

    invoke DefWindowProc, hWin, uMsg, wParam, lParam
    ret
WndProc endp

;Функция для центрирования окна
TopXY proc wDim:DWORD, sDim:DWORD
    shr sDim, 1		;Делим характеристику экрана на 2
    shr wDim, 1		;Делим характеристику окна на 2
    mov eax, wDim	;Копируем характеристику окна в eax
    sub sDim, eax	;Вычитаем половину характеристики окна из половины
		              ;характеристики экрана
    return sDim
TopXY endp

end start