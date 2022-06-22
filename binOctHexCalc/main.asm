  global main
 
main:
    call typeanumbermsg
    mov byte [wynik+32],0xa
	loop:
        call typeanumber
        call convert
		
		cmp eax, 23049          ; input = indeks
        je koniec
		
		call binary
		call octan
		call hex
    jmp loop
   
koniec:
    mov eax,1               ; wyjdz
    mov ebx,100             ; kod konczacy
    int 0x80                ; przerwanie
 
typeanumbermsg:
    mov edx,dlmsglen        ; ile charow
    mov ecx,podajLiczbe     ; gdzie pierwszy znak
    mov ebx,1              
    mov eax,4               
    int 0x80                ; wypisz
    ret                     
 
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
        imul eax, 10            ; mnoze przez 10 imul -> signedInt mul -> unsignedInt
        add eax, ecx            ; eax przechowuje wynik
    jmp convertLoop             ; loop dopoki koniec
 
    done:
        cmp ecx, 10             ; czy znak konczoncy
        jne errormessage        ; jesli nie to mamy litere
        ret
binary:
	push EAX;
	mov ECX, 32;
	mov EBX, 2;
	loop32:
		mov EDX, 0;
		div EBX;
		add EDX, '0';
		mov [wynik+ECX-1], DL
	loop loop32;
	call typeresultbin;
	pop EAX;
	ret
	
octan:
	push EAX;
	mov ECX, 32;
	mov EBX, 8;
	loop32o:
		mov EDX, 0;
		div EBX;
		add EDX, '0';
		mov [wynik+ECX-1], DL
	loop loop32o;
	call typeresultbin;
	pop EAX;
	ret

hex:
	push EAX;				;zachowujemy liczbe na inne dzielenia
	mov ECX, 32;			;tworzymy licznik, aby robil nam 32 znaki
	mov EBX, 16;			;ustalamy dzielnik
	loop64o:
		mov EDX, 0;			;zerujemy EDX, bo tam bedzie wynik
		div EBX;			;dzielimy EAX przez EBX
		add EDX, '0';		;przesuwamy tablice ascii az do cyferek
		cmp DL, 58			;sprawdzamy czy reszta jest wieksza badz rowna do 10
		JGE a7				;jezeli wieksza badz rowna, dodaj 7 (przesuniecie ascii)
		retHex:					;punkt powrotu z a7
		mov [wynik+ECX-1], DL	;wrzucami wynik na odpowiednie miejsce w tablicy
	loop loop64o				;nazywa 64 aby nie powodowac konfliktu nazwy
	call typeresultbin;			;wypisywanie
	pop EAX;					;przywracanie eax, bo zgubilismy po drodze
	ret
	
a7:
	add DL, 7
	jmp retHex

typeresultbin:
	;mov byte [wynik],'a'
    mov edx,34        ; ile charow
    mov ecx,wynik     ; gdzie pierwszy znak
    mov ebx,1              
    mov eax,4               
    int 0x80                ; wypisz
    ;call typeanumbermsg
	ret  
 
section .data
    errorPrint db 'Found a letter!',0xa,0x0,0x0 ; string, 0xa to koniec linii
    dlerrorlen equ $ - errorPrint                  ; dlugosc     db-> define byte    dw-> define word    dd -> define double word

    podajLiczbe db 'Type number:',0xa,0x0,0x0  ; string, 0xa to koniec linii
    dlmsglen equ $ - podajLiczbe           ; dlugosc
 
section .bss
    liczbaString resb 10   ; rezerwacja 10b na input
	wynik resb 132