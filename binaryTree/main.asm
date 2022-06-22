  global main
extern malloc
main:
	call typeanumbermsg
    call typeanumber
    call convert
    cmp eax, 23049          ; input = indeks
    je koniec
	call first
		loop:
		call typeanumbermsg
        call typeanumber
        call convert
        cmp eax, 23049          ; input = indeks
        je koniec
		call bst
		
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
    mov edx, 10              ; dlugosc inputu uzytkownika
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


first:
	mov [firstElement], eax
	mov dword[firstElement+4],0
	mov dword[firstElement+8],0
	ret

bst:
	mov ebx, firstElement
	call bst2
	ret
bst2:
	pusha

	mov ecx, [ebx]
	cmp eax, ecx
	jl left
	jge right
	
	bstRet:
	popa
	ret
left:
	pusha
	mov ecx, [ebx+4]
	cmp ecx,0	
	je wstawBst;if equal
	mov ebx, [ebx+4]
	call bst2
	asdfg:
	
	
	popa
	jmp bstRet

right:
	pusha
	mov ecx, [ebx+8]
	cmp ecx,0	
	je wstawBstRight;if equal
	mov ebx, [ebx+8]
	call bst2
	asdfgRight:
	
	popa
	jmp bstRet


wstawBst:
	push ebx
	call newElement
	pop ebx
	mov dword[ebx+4],eax
	jmp asdfg
	
wstawBstRight:
	push ebx
	call newElement
	pop ebx
	mov dword[ebx+8],eax
	jmp asdfgRight

newElement:
	push ebx
	push eax
	push 12
	call malloc
	pop edx
	pop ecx
	
	mov [eax],ecx
	mov dword[eax+4],0
	mov dword[eax+8],0
	pop ebx
	ret
	
section .data
    errorPrint db 'Found a letter!',0xa,0x0,0x0 ; string, 0xa to koniec linii
    dlerrorlen equ $ - errorPrint                  ; dlugosc     db-> define byte    dw-> define word    dd -> define double word

    podajLiczbe db 'Type number:',0xa,0x0,0x0  ; string, 0xa to koniec linii
    dlmsglen equ $ - podajLiczbe           ; dlugosc
 
section .bss
    liczbaString resb 4   ; rezerwacja 10B na input
	firstElement resb 12  ; rezerwacja 10B na pierwszy element