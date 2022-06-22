section .text

extern printf

global encodeChar
global decodeChar
global encodeText
global decodeText

encodeText:
    mov dword [iterator],0
    push ebp
    mov ebp,esp
    pusha
    	mov eax, [ebp+8]	;przyjmujemy text
    	mov ebx, [ebp+12]        ;przyjmujemy klucz
        mov ecx, [ebp+16]       ;rozmiar textu
        mov edx, [ebp+20]       ;rozmiar klucza

        cmp ecx,edx
        jle wywolajChar
        ;jg dobudujKlucz

        retEncodeText:
    popa
    pop ebp
    ret

dobudujKlucz:
    ;eax -> text, za długi
    ;ebx -> klucz, za krótki
    ;ecx -> różnica
    ;edx -> rozmiar klucza
    push ecx
    push edx
    sub ecx,edx
    loopWyrownaj:


    loop loopWyrownaj

    pop edx
    pop ecx
    jmp wywolajChar

wywolajChar:
    pusha
    mov edx,ecx
    loopEncode:
        push ecx
        push edx
        sub edx,ecx

        push eax
        push ebx
        mov ecx,0
        mov cl, byte[eax+edx]
        mov eax,ecx
        mov ecx, 0
        mov cl, byte[ebx+edx]
        mov ebx,ecx

        call encodeChar

        pop ebx
        pop eax
        pop edx
        pop ecx
    loop loopEncode
    popa
    jmp retEncodeText

decodeText:
    mov dword [iterator],0
    push ebp
    mov ebp,esp
    pusha
    	mov eax, [ebp+8]	;przyjmujemy text
    	mov ebx, [ebp+12]        ;przyjmujemy klucz
        mov ecx, [ebp+16]       ;rozmiar textu
        mov edx, [ebp+20]       ;rozmiar klucza

        cmp ecx,edx
        jle wywolajCharDecode
        ;jg dobudujKlucz

        retDecodeText:
    popa
    pop ebp
    ret
    ret

wywolajCharDecode:
    pusha
        mov edx,ecx
        loopDecode:
            push ecx
            push edx
            sub edx,ecx

            push eax
            push ebx
            mov ecx,0
            mov cl, byte[eax+edx]
            mov eax,ecx
            mov ecx, 0
            mov cl, byte[ebx+edx]
            mov ebx,ecx

            call decodeChar

            pop ebx
            pop eax
            pop edx
            pop ecx
        loop loopDecode
        popa
        jmp retDecodeText
encodeChar:
	push ebp
    mov ebp,esp
    pusha

	sub eax, 'A'
	add eax,ebx

    cmp eax, 'Z'
    jg wyrownajEncode
    returnEncode:

    pusha				;zachowujemy wszystkie rejestry
	push eax			;ustawiamy co ma wypisac
	push character      ;schemat
	call printf			;printf
	add esp,8			;naprawiamy pointer
	popa				;odzyskujemy rejestry


    popa
    pop ebp
	ret
wyrownajEncode:
    sub eax,26
    jmp returnEncode

decodeChar:
    push ebp
    mov ebp,esp
    pusha

    sub ebx,'A'
    sub eax, ebx

    cmp eax, 'A'
    jl wyrownajDecode
    returnDecode:
    pusha				;zachowujemy wszystkie rejestry
    push eax			;ustawiamy co ma wypisac
    push character      ;schemat
    call printf			;printf
    add esp,8			;naprawiamy pointer
    popa				;odzyskujemy rejestry

    popa
    pop ebp
    ret
wyrownajDecode:
    add eax,26
    jmp returnDecode

wypisz:
    pusha				;zachowujemy wszystkie rejestry
    	push eax			;ustawiamy co ma wypisac
    	push character ;schemat
    	call printf			;printf
    	add esp,8			;naprawiamy pointer
    popa				;odzyskujemy rejestry
    ret
section .data
character db '%c',0xa,0x0

section .bss
iterator resb 4

    ;push byte 'A'
    	;push byte 'B'

    	;push ebp
    	;mov ebp,esp
    	;pusha

    	;mov eax, 0
    	;mov ebx, 0

    	;mov al, [EBP+4]
    	;mov bl, [EBP+5]

    	;sub al, bl
    	;add bl, al

    	;mov ecx, 0

    	;mov edx, 8
    	;mov cl, [bl]
    	;mov ebx, 1
    	;mov eax,4
    	;int 0x80

    	;popa
    	;pop ebp
    	;add esp, 2