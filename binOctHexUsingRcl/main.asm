global main
extern printf
main:
    call typeanumbermsg
    loop:
        call typeanumber
        call convert
		cmp eax, 23049          ; if input = indeks end programm
        je koniec
		call wypiszBinary
		call binary
		call wypiszOctal
		call octal
		call wypiszHex
		call hexal
    jmp loop
   
    koniec:
        mov eax,1               ; wyjdz
        mov ebx,100             ; kod konczacy
        int 0x80                ; przerwanie
 
typeanumbermsg:
    mov edx,dlmsglen        ; ile charow
    mov ecx,podajLiczbe     ; gdzie pierwszy znak
    mov ebx,1              
    mov eax,4               ; wypisz
    int 0x80                ; przerwanie
    ret                     ; wracam gdzie skonczylem
 
errormessage:
    mov edx,dlerrorlen        ; dlugosc inputu uzytkownika
    mov ecx,errorPrint      ; wskaznik na pierwszy znak
    mov ebx,1               ; ustawienie printa
    mov eax,4               ; wypisz
    int 0x80                ; przerwanie
    jmp loop                ; powrot do petli
 
typeanumber:
    mov edx, 16             ; dlugosc inputu uzytkownika
    mov ecx, liczbaString   ; wskaznik na miejsce w pamieci dla inputu
    mov ebx,0               ; ustawienie zapisu
    mov eax,3               ; wczytaj
    int 0x80                ; przerwanie
    ret                     ; zakonczenie calla
 
 
convert:
    mov edx, liczbaString       ; wskanzik na pierwszy char
    mov eax, 0                  ; wyzerowanie rejestru eax

    convertLoop:
        movzx ecx, byte [edx]   ; zapisuje chara w ecx
        inc edx  
        cmp ecx, 57             ; sprawdzam czy jest w przedziale 0-9
        ja done              
       
        cmp ecx, 48            
        jb done
       
        sub ecx, 48             ; z ascii do prawdziwego numeru
        imul eax, 10            ; mnoze przez 10
        add eax, ecx            ; eax przechowuje wynik
    jmp convertLoop             ; loop dopoki koniec
 
    done:
        cmp ecx, 10             ; czy znak konczoncy
        jne errormessage        ; jesli nie to mamy litere
        ret


binary:
	push eax
	mov ECX,32 
		loopBinary:
		
		shl eax, 1
		jc 	wypisz1
		jnc wypisz0
		return:
								;przesuwamy 1 raz, 10 razy bo loop
		loop loopBinary
	
	ror eax, 1
	pop eax
	ret
	
octal:
	push eax			;chowamy oryginalną wartosc do zmiany, aby jej nie stracic przy AND
	
	rol EAX, 2			;zajmujemy sie 2 lewymi bitami, bo nie sa podzielne przez 3
	push EAX			;chowamy wartosc przesunieta, aby po zerowaniu ja odzyskac
	AND EAX, 00000003H	;zerujemy 30 bitow po lewej
	
	call wypiszBetter	;wypisujemy dwa pierwsze bity
	
	mov ECX,10			;ustawiamy licznik na 10
		loopOctal:
		pop eax			;odzyskujemy eax po zerowaniu
		rol EAX, 3		;przesuwamy 3 bity na prawo
		push eax		;zachowujemy aby odzyskac po zerowaniu
		AND EAX, 00000007H	;zerujemy 29 bitow po lewej
		call wypiszBetter	;wypisujemy cokolwiek zostalo (max 3 bity)
		loop loopOctal		;wracamy do gory
	pop eax					;usuwamy ze stacka to resztke sprzed ostatniego zerowania
	pop eax					;odzyskujemy oryginalna wartosc eax, dla hex
	ret						;wracamy do main

hexal:
	push eax
	mov ECX,8			;ustawiamy licznik na 8
		loopHexal:
		pop eax			
		rol EAX, 4		;przesuwamy 4 bity na prawo
		push eax		;zapisujemy sobie eax, przed zerowaniem
		AND EAX, 0000000FH      ;zerujemy 28 bitow po lewej
		call wypiszBetterHex
		loop loopHexal		;wracamy do gory
	pop eax					;usuwamy ze stacka to resztke sprzed ostatniego zerowania
	ret

wypiszBetter:
	pusha				;zachowujemy wszystkie rejestry
	push eax			;ustawiamy co ma wypisac
	push number ;schemat
	call printf			;printf
	add esp,8			;naprawiamy pointer
	popa				;odzyskujemy rejestry
	ret					;wracamy do loopa

wypiszBetterHex:
	pusha				;zachowujemy wszystkie rejestry
	add eax, '0'
	
	cmp eax, 58			;sprawdzamy czy reszta jest wieksza badz rowna do 10
	JGE a7				;jezeli wieksza badz rowna, dodaj 7 (przesuniecie ascii)
	retHex:	
	
	push eax			;ustawiamy co ma wypisac
	
	push hexnumber      ;schemat
	call printf			;printf
	add esp,8			;naprawiamy pointer
	popa				;odzyskujemy rejestry
	
	ret					;wracamy do loopa

a7:
	add eax, 7
	jmp retHex

wypisz1:
	pusha
	push 1
	push number
	call printf
	add esp, 8
	popa
	jmp return
	
wypisz0:
	pusha
	push 0
	push number
	call printf
	add esp, 8
	popa
	jmp return

wypiszBinary:
	pusha
	mov edx,dlmsglen-5        ; ile charow
    mov ecx,binaryTxt     ; gdzie pierwszy znak
    mov ebx,1              
    mov eax,4               ; wypisz
    int 0x80                ; przerwanie
	popa
    ret                     ; wracam gdzie skonczylem
	
wypiszOctal:
	pusha
	mov edx,dlmsglen-6        ; ile charow
    mov ecx,octalTxt     ; gdzie pierwszy znak
    mov ebx,1              
    mov eax,4               ; wypisz
    int 0x80                ; przerwanie
	popa
    ret                     ; wracam gdzie skonczylem
wypiszHex:
	pusha
	mov edx,dlmsglen        ; ile charow
    mov ecx,hexTxt     ; gdzie pierwszy znak
    mov ebx,1              
    mov eax,4               ; wypisz
    int 0x80                ; przerwanie
	popa
    ret                     ; wracam gdzie skonczylem
section .data
    errorPrint db 'Found a letter!',0xa,0x0,0x0 ; string, 0xa to koniec linii
    dlerrorlen equ $ - errorPrint                  ; dlugosc

    podajLiczbe db 'Type number:',0xa,0x0,0x0  ; string, 0xa to koniec linii
    dlmsglen equ $ - podajLiczbe           ; dlugosc
    print_number_text db '%c', 0x0
	number db '%d',0xa,0x0
	hexnumber db '%c',0xa,0x0
	
	binaryTxt db 'Binary:',0xa,0x0,0x0
	octalTxt db 'Octal:' ,0xa,0x0,0x0
	hexTxt db 'Hexadecimal:',0xa,0x0,0x0
 
section .bss
    liczbaString resb 10   ; rezerwacja 10b na input
	
