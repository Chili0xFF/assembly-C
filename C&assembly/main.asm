section .text
extern printf
global test
global test2
global test3
global test4

test:
	pusha 
	mov ecx, index 				
	mov edx, indexLength 
	mov ebx, 1
	mov eax, 4					;wypisywanie indexu sys_write
	int 0x80
	popa
	ret

test2:
	push ebp
	mov ebp,esp
	pusha				
	mov eax, 23049				;wypisywanie indexu do C
	mov [ebp-4],eax
	popa
    pop ebp
	ret
	
test3:
	push ebp
	mov ebp,esp
	pusha
	mov eax, [ebp+8]		;do eax wrzucamy input
	cmp eax,2			
	je wypisz1				;if 2, pierwsza. if 1||0 , nie pierwsza, wieksze do sprawdzenia
	jl wypisz0
	jg sprawdz
	endOfFile:
	popa
	pop ebp
	ret
	
test4:
	push ebp
	mov ebp,esp
	pusha
		mov ecx, [ebp+12]		;przyjmujemy rozmiar
		
		cmp ecx,0				;jezeli tablica ma rozmiar 0, to nic nie rob
		jne parzyste
		endOfFileParz:			
	popa
	pop ebp
	ret

parzyste:
	loopParzyste:
		mov ebx,[ebp+12]		;rozmiar potrzebny do wyliczania przesuniecia
		
		sub ebx,ecx				;liczymy o ile znakow musimy sie przesunac
		
					
		mov eax, ebx
		mov edx, 4				;przeliczamy na przesuniecie byte
		mul edx
		mov ebx, eax
		
		mov eax, [ebp+8]		;odbieramy tablice
								
		mov eax, [eax+ebx]		;wyciagamy odpowiednia liczbe z tablicy
		push ebx				;zapisujemy sobie przesuniecie, w razie jakby byla parzysta
		
		mov edx,0	
		mov ebx,2				;dzielimy nasza liczbe eax na 2
		div ebx
		
		pop ebx	
		
		cmp edx,1				;if 1 -> nieParzysta, 0 -> parzysta
		je podmien0
		retParzyste:
	loop loopParzyste
	jmp endOfFileParz
	
podmien0:
	mov eax, [ebp+8]
	mov dword [eax+ebx],0		;podmieniamy liczbę w tablicy eax na pozycji ebx, na 0
	jmp retParzyste

sprawdz:
	mov edx,0
	push eax
	mov ebx, 2
	div ebx
	mov ebx, eax  ;ustawiamy max na approx polowe naszej liczby, bo nie wiem jak zrobic sqrt
	pop eax		  ;przywracamy liczbe
	mov ecx, ebx
	sub ecx, 2	  ;ebx-ecx=dzielnik loop->zmniejszamy ecx, czyi zwiekszamy dzielnik
	loopPierwsza:
		;eax-> nasza liczbe, edx->pusty, ebx->max, ecx->aktualny licznik
		push eax
		mov edx,0
		push ebx			;zapisujemy "maksymalny dzielnik"
		sub ebx, ecx		;wyliczamy aktualny dzielnik
		
		div ebx
		cmp edx,0
		pop ebx
		pop eax
		je wypisz0
	loop loopPierwsza
	jmp wypisz1

wypisz1:
	mov eax, 1
	mov [ebp-4],eax
	jmp endOfFile
	
;clearStack:
	;pop ebx
	;pop eax
	;jmp wypisz0
wypisz0:
	mov eax, 0
	mov [ebp-4],eax
	jmp endOfFile

section .data
	index db '23049',0xa, 0x0
	indexLength equ $ - index
section .bss
	buf resb 1  ; 1-byte buffer		