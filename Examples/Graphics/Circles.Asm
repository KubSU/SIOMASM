; ��������� ������� 21 ������ 2014�
; �� ����� ����� ������������ ������������� ����
  .386
    .model flat, stdcall  ;������� ������.

    option casemap :none  ;��������� ����p�� MASM ������� ����� 
                          ;��������������� � p�����p�.
                          ;���������� ��� ������������� ����������� 
                          ;windows.inc-�����.

    ;��������� ������������ ��� ����������� inc-������ � ���������.	
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
    ; ���������� ��������� ��������
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
    ; ���������� ���������� ��������� ������� 
    ;=========================================
        WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD
        WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
        TopXY PROTO   :DWORD,:DWORD

    .data
      ;�������� ������ ����
        szDisplayName db "!! Draw circles !!",0	
      ;���������� ���������� ������
        CommandLine   dd ?
      ;���������� ����
        hWnd          dd ?
      ;���������� ����������
        hInstance     dd ?
      ;���������� �������� ����
        hMenu         dd ?
      ;����������� ������������ ���������� � ������   
        hPen          dd ?
        hBrush        dd ?
      ;��������� ��� �������� ��������� ������ �������������� ���������� �������
        cRect         RECT <?>
      ;���������� �����
        PosX          dd ?
        PosY          dd ?
      ; ��� ��������� �����
        R             dd 20
        Ri            dd ?
        x1            dd ?
        x2            dd ?
        y1            dd ?
        y2            dd ?
      ;������� ������� ������
        XM            dd ?
        YM            dd ?
      ; �����
        msg1          db "����� �� ������� ����� ������ ����"
      ; ������ ������������ ���� ������
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
      ; ��������������� ����������     
        Four          dd 4        ; ��� ��������� �� 4
        hBrushColor   dd 000000h  ; ��� ��. ����� �����
        hPenColor     dd 000000h  ; ��� ��. ����� ���������
        bgColor       dd ?        ; �������� ����� ����� ����

    .code

start:
    invoke GetModuleHandle, NULL	;�������� ���������� ����������
    mov hInstance, eax
    invoke GetCommandLine		      ;�������� ���������� ���������� ������
    mov CommandLine, eax
    invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
    invoke ExitProcess, eax		    ;����� �� ��������� (��������� �������).

WinMain proc hInst     :DWORD,
             hPrevInst :DWORD,
             CmdLine   :DWORD,
             CmdShow   :DWORD

    ;===============================
    ; ������ "���������" ����������
    ;===============================
        LOCAL wc   :WNDCLASSEX
        LOCAL msg  :MSG
        LOCAL Wwd  :DWORD
        LOCAL Wht  :DWORD
        LOCAL Wtx  :DWORD
        LOCAL Wty  :DWORD

    szText szClassName,"Class1"	;��� ������

    ;================================================
    ; ��������� WNDCLASSEX ��������� ������� �������
    ;================================================
        mov wc.cbSize,         sizeof WNDCLASSEX
        mov wc.style,          CS_HREDRAW + CS_VREDRAW + CS_SAVEBITS + CS_OWNDC
        mov wc.lpfnWndProc,    offset WndProc
        mov wc.cbClsExtra,     NULL
        mov wc.cbWndExtra,     NULL
        m2m wc.hInstance,      hInst

  ;����������� ����� ���� (NULL-��� ���������� �� �����)
  
  
    ; ���������� ������  (randomize)
	invoke GetCurrentProcessId
	invoke nseed, eax
  
    
    ; �������� ��������� ����� � ������� �����
    call GetRandColor       ; � eax
    mov bgColor, eax        ; �������� ���� ����
    mov ebx, bgColor
    
    invoke CreateSolidBrush, Color[ebx]  
    mov wc.hbrBackground,  eax

    mov wc.lpszMenuName,   NULL
    mov wc.lpszClassName,  offset szClassName
  ;������ ����������� ������
    invoke LoadIcon, 7F00h, 0
    mov wc.hIcon,          eax
  ;������ ������ � ��������������� 1000 �� �������� ����������
    invoke LoadCursor, hInst, 3e8h
    mov wc.hCursor,        eax
    mov wc.hIconSm,        0

    invoke RegisterClassEx, ADDR wc	;������������ ����� "Class1"

  ;�������� ���������� � �������� ������ � �� �������� ����� 
  ;� ������ ���� ������� ����������� ������������ ����
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

  ;������� ���� ������������������� ������
  invoke CreateWindowEx, 0,
                        ADDR szClassName,
                        ADDR szDisplayName,
                        WS_OVERLAPPED + WS_CAPTION + WS_SYSMENU + \
                        WS_MINIMIZEBOX + WS_MAXIMIZEBOX + WS_THICKFRAME,
                        Wtx,Wty,Wwd,Wht,
                        NULL,NULL,
                        hInst,NULL
  mov hWnd, eax

  invoke LoadMenu, hInst, 2	  ;������ ���� � ��������������� 2
  mov hMenu, eax
  invoke SetMenu, hWnd, eax	  ;����������� ��� � ������ ����

  ;���������� ��������� ����
  invoke ShowWindow, hWnd, SW_SHOWNORMAL
  ;�������������� ���������� ����
  invoke UpdateWindow, hWnd

  ;==========================
  ; ���� ��������� ���������
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


; ��� ���. ��������� �����:
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


; eax = random(17) * 4 - ��������� ����� ����� � ������� Color[]
GetRandColor proc
	
	invoke nrandom, 17 				; eax = random(17)
	
	mov edx, 0
	mul Four                        ; eax = eax * 4
	
    ret

GetRandColor endp


;������� ��������� ��������� �������� ����
WndProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD

    ;===============================
    ; ������ "���������" ����������
    ;===============================
	LOCAL hDC  :DWORD
	LOCAL Ps   :PAINTSTRUCT

    ; LMB_UP
    .if uMsg == WM_LBUTTONUP

        ; �������� ���������� ����� � ���������� �� � PosX, PosY
        mov ecx, 0h

        mov cx, WORD PTR [lParam]
        mov PosX, ecx
        mov cx, WORD PTR [lParam+2h]
        mov PosY, ecx
        
        ; �������� ��������� ����� � ������� ������ ��� �����
        call GetRandColor
        mov hBrushColor, eax
        
        ; �������� ��������� ����� � ������� ������ ��� ���������
        call GetRandColor
        mov hPenColor, eax
                
        ; ��������� ������
        mov Ri, 1
        invoke SetTimer, hWnd, 1, 50, NULL

        return 0

    ; TIMER
    .elseif uMsg == WM_TIMER

        ; �������� ������ ����� 1..R
        mov eax, R
        .if Ri < eax
          inc Ri
          mov eax, Ri
          call GetXY            ; �������� ���������� �������� �����
                                ; x1, y1, x2, y2 �����. �� �������
        .endif

        invoke InvalidateRect, hWnd, NULL, 1

        return 0

    ; PAINT
    .elseif uMsg == WM_PAINT
        ; ������ � BeginPaint'�
        invoke BeginPaint, hWnd, ADDR Ps
          mov hDC, eax 

          mov ebx, hBrushColor                  ; hBrushColor - ��������� ����� ��� ����� �����

          ;������� �����
          invoke CreateSolidBrush, Color[ebx]
          mov hBrush, eax
          invoke SelectObject, hDC, eax

          mov ebx, hPenColor                    ; hPenColor - ��������� ����� ��� ����� ���������

          ;������� ��������
          invoke CreatePen, PS_SOLID, 4, Color[ebx]
          mov hPen, eax
          invoke SelectObject, hDC, eax

          ;���� ��� ������ ������
          mov ebx, bgColor
          invoke SetBkColor, hDC, Color[ebx]
          ;invoke SetTextColor, hDC, Color[4] - ���� ������ 
          


          invoke DrawText, hDC, ADDR msg1, sizeof msg1, ADDR cRect,
                                 DT_VCENTER or DT_CENTER or DT_NOPREFIX


          ;����������, ������ ����!
          invoke Ellipse, hDC, x1, y1, x2, y2


          ;����������� �������� � ������� �����
          invoke DeleteObject, hBrush
          invoke DeleteObject, hPen

        invoke EndPaint,hWnd,ADDR Ps
        return 0

    ; SIZE
    .elseif uMsg == WM_SIZE

        ;�������� ���������� � ������� �������� ���������� ������� ����
        invoke GetClientRect, hWin, ADDR cRect

        return 0

    ; DESTROY
    .elseif uMsg == WM_DESTROY
      ;������� ��������� �������
        invoke DeleteObject, hPen
        invoke DeleteObject, hBrush
        invoke PostQuitMessage, NULL

        return 0
    .endif

    invoke DefWindowProc, hWin, uMsg, wParam, lParam
    ret
WndProc endp

;������� ��� ������������� ����
TopXY proc wDim:DWORD, sDim:DWORD
    shr sDim, 1		;����� �������������� ������ �� 2
    shr wDim, 1		;����� �������������� ���� �� 2
    mov eax, wDim	;�������� �������������� ���� � eax
    sub sDim, eax	;�������� �������� �������������� ���� �� ��������
		              ;�������������� ������
    return sDim
TopXY endp

end start