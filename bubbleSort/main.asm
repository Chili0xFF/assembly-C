global main
extern malloc
extern printf
main:
    call typealicznikmsg
	call typeanumber
	call convertLicznik
	cmp eax, 0					;Ustawiamy do ecx ile razy ma sie wykonac loop i do ebx, max ilosc wykonan
	je koniec
	mov ecx, eax			
	mov ebx, eax
	push ecx
	push ebx
	
	mov edx, 4
	mul edx					;ilosc znakow * 4 aby zaalokowac odpowiednio znakow
	push eax
	call malloc
	add esp,4
	
	pop ebx			;bo malloc edytuje ebx:<
	pop ecx			;bo malloc edytuje ecx :<
		
		;w eax mamy adres 0
		;w ebx mamy max znakow
		;w ecx mamy licznik
		
		loopTab:		
			endOfLoop:		;w zlym miejscu go postawilem a potem mi sie nazwy nie chcialo zmieniac
		push ecx			;zapisujemy licznik
		push eax			;zapisujemy adres 0
		push ebx			;zapisujemy max
		
		mov edx, eax		;do edx dajemy adres 0 temp
		push edx
		push ecx
		
		call typeanumbermsg
        call typeanumber	;w eax dostaniemy liczbe
        call convert		
		
		pop ecx
		pop edx
		pop ebx
		push ebx
		
		call addNumber		;
		
				;odzyskujemy ewentualnie utracone dane
		

		pop ebx
		pop eax
		pop ecx
		;w ebx mamy maksimum
		;w eax mamy tab[0]
		;w ecx mamy licznik
    loop loopTab
	;w ecx mamy 0
	jmp sortujBomba
   
addNumber:		;w eax mamy cyfre, w ebx mamy max, w ecx mamy edx-aktualnyObrot, w edx mamy adres 0
	
	pusha
	sub ebx, ecx		;w ebx mamy przesuniecie
	push eax			
	mov ecx, 4			;w ecx mamy mnoznik
	mov eax, ebx		;w eax mamy przesuniecie
	push edx
	mul ecx				;w eax mamy przesuniecie o ile bitow
	pop edx
	mov ebx, eax		
	pop eax				;w 
	
	;w eax mamy liczbe, w ebx mamy przesuniecie o ile bitow, w ecx mamy śmieci, w edx mamy adres 0
	
	mov dword[edx+ebx], eax
	popa
	ret
   
sortujBomba:
	call wypiszTablice
	
	pusha
	
		mov ecx, 0
		outerLoop:
		pusha
			mov edx,0
			innerLoop:
			;ecx -> i, edx -> j, eax -> arr[], ebx -> size
			push ecx
			push ebx
			mov ecx, [eax+4*edx]
			inc edx
			mov ebx, [eax+4*edx]
			dec edx
			cmp ecx,ebx
			jg swap
			retpoint:
			
			pop ebx
			pop ecx
			inc edx
			push eax
			mov eax,ebx
			sub eax, ecx
			dec eax
			cmp edx,eax
			pop eax
			jl innerLoop
		
		popa
		inc ecx
		
		push eax
		mov eax, ebx
		dec eax
		cmp ecx,eax
		pop eax
		jl outerLoop
		
	
	popa
		
	call wypiszTablice
	jmp koniec
	
swap:
	;w [eax+4*edx] i [eax+4*edx]INC mam rzeczy do podmiany. Reszta wywalone
	
	pusha
	
	mov ecx, edx
	inc ecx
	
	mov dword ebx,[eax+4*edx]
	
	push ebx
	
	mov dword ebx,[eax+4*ecx]
	
	mov dword[eax+4*edx],ebx
	
	pop ebx
	
	mov dword[eax+4*ecx],ebx
	
	
	popa
	jmp retpoint

wypiszTablice:
		;bez sortowania:
		
	pusha
	mov edx, eax
	mov ecx, ebx
	loopWypisz:
		pusha
		sub ebx, ecx		;w ebx mamy przesuniecie
		push eax			
		mov ecx, 4			;w ecx mamy mnoznik
		mov eax, ebx		;w eax mamy przesuniecie
		push edx
		mul ecx				;w eax mamy przesuniecie o ile bitow
		pop edx
		mov ebx, eax		
		pop eax
		
		
		
		push dword[edx+ebx]
		push tablicaFormat
		call printf
		add esp,8
		
		popa
	loop loopWypisz
	
	popa
	ret
	
	
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
	
typealicznikmsg:
    mov edx,licznlen        ; ile charow
    mov ecx,podajLicznik     ; gdzie pierwszy znak
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
    jmp endOfLoop                ; powrot do petli

errormessageLicznik:
    mov edx,dlerrorlen        ; dlugosc inputu uzytkownika
    mov ecx,errorPrint      ; wskaznik na pierwszy znak
    mov ebx,1               ; ustawienie printa
    mov eax,4               ; wypisz
    int 0x80                ; przerwanie
    jmp main                ; powrot do petli
 
typeanumber:
	mov edx, 4             ; dlugosc inputu uzytkownika
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

convertLicznik:
    mov edx, liczbaString       ; wskanzik na pierwszy char
    mov eax, 0                  ; wyzerowanie rejestru eax

    convertLoopLicznik:
        movzx ecx, byte [edx]   ; zapisuje chara w ecx
        inc edx  
        cmp ecx, 57             ; sprawdzam czy jest w przedziale 0-9
        ja doneLicznik              
        
        cmp ecx, 48            
        jb doneLicznik
       
        sub ecx, 48             ; z ascii do prawdziwego numeru
        imul eax, 10            ; mnoze przez 10 imul -> signedInt mul -> unsignedInt
        add eax, ecx            ; eax przechowuje wynik
    jmp convertLoopLicznik             ; loop dopoki koniec
 
    doneLicznik:
        cmp ecx, 10             ; czy znak konczoncy
        jne errormessageLicznik        ; jesli nie to mamy litere
        ret
 
 
section .data
    errorPrint db 'Found a letter!',0xa,0x0,0x0 ; string, 0xa to koniec linii
    dlerrorlen equ $ - errorPrint                  ; dlugosc     db-> define byte    dw-> define word    dd -> define double word

    podajLiczbe db 'Type number:',0xa,0x0,0x0  ; string, 0xa to koniec linii
    dlmsglen equ $ - podajLiczbe           ; dlugosc
	
	podajLicznik db 'How many numbers?:',0xa,0x0,0x0
	licznlen equ $ - podajLicznik
	
	tablicaFormat db '%d', 0xa, 0x0

 
section .bss
    liczbaString resb 4   ; rezerwacja 10b na input
	
	
;	;w ebx mamy n
;		;w edx arr[]
;		;w ecx śmieci
;		;w eax śmieci
;		pusha
;		
;		mov ecx, ebx
;		dec ecx
;		loopBumbulOuter:
;			;w ebx mamy n
;			;w edx mamy arr[]
;			;w ecx i
;			;w eax śmieci
;			pusha
;			;do ecx musze teraz jakos wrzucic j
;			mov eax, ebx
;			sub eax, ecx
;			dec eax
;			mov ecx, eax
;			cmp ecx,0
;			je ignore
;			loopBumbulInner:
;				;w ebx mamy n
;				;w edx mamy arr[]
;				;w ecx j
;				;w eax śmieci
;				
;				
;				pusha
;				mov eax,eac
;				;eax = j
;				;ecx = j+1
;				pusha
;				mov dword ebx,[edx+4*eax]
;				mov dword eax,[edx+4*ecx]
;				cmp ebx,eax
;				popa
;				jg swap
;				retpoint:
;				popa
;			loop loopBumbulInner
;			ignore:
;			popa
;		loop loopBumbulOuter
;		
;		popa