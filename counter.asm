section .data                           
    sirm db "Enter the string: ",10
    sirml equ $-sirm
    vocalem db "Vowels: "
    vocaleml equ $-vocalem
    cifrem db "Digits: "
    cifreml equ $-cifrem
    othersm db "Others: "
    othersml equ $-othersm
    
section .bss
    string resb 101 ;Maximum string size of 100.
    vowels resb 4
    digits resb 4
    others resb 4
    temp resb 1
   
section .text
global _start

_start:

;Manually adding the endline character.
mov byte [vowels+3], 0ah
mov byte [digits+3], 0ah
mov byte [others+3], 0ah

mov ecx, sirm
mov edx, sirml
mov eax, 4
mov ebx, 1
int 0x80


mov ecx, string
mov edx, 101
mov eax, 3
mov ebx, 0
int 0x80

;Clearing the registers
xor eax, eax
xor ecx, ecx
xor edx, edx
xor ebx, ebx

;Counts the number of vowels in the strings, until it reaches the end
;of it. If it didn't find one, it increments the others variable using
;bl for current count and cl for last loop count, comparing them to know
;if there was any change.
parcurgevoc:
mov al, byte [string+edx]
mov [temp], bl
cmp al, 10
je endparcurgevoc
cmp al, 'a'
jne a
inc bl
a:
cmp al, 'A'
jne A
inc bl
A:
cmp al, 'e'
jne e
inc bl
e:
cmp al, 'E'
jne E
inc bl
E:
cmp al, 'i'
jne i
inc bl
i:
cmp al, 'I'
jne I
inc bl
I:
cmp al, 'o'
jne o
inc bl
o:
cmp al, 'O'
jne O
inc bl
O:
cmp al, 'u'
jne u
inc bl
u:cmp al, 'U'
jne U
inc bl
U:
inc edx
mov cl, [temp]
cmp bl, cl
jg parcurgevoc
mov cl, [others]
inc cl
mov [others], cl
jmp parcurgevoc
endparcurgevoc:

;Hex to decimal conversion, using 3 bytes and not one since it also does
;processing for the display.
mov al, bl
mov ebx, 10
xor dl, dl
div ebx
add dl, '0'
mov [vowels+2], dl
xor dl, dl
div ebx
add dl, '0'
mov [vowels+1], dl
add al, '0'
mov [vowels], al
    

xor edx, edx
xor ecx, ecx
xor ebx, ebx
xor eax, eax

;Counts the number of digits, and subtracts them from the others variable.
;This way, all 3 can be counted with only 2 loops.
parcurgenr:
mov al, byte [string+edx]
cmp al, 10
je endparcurgenr
cmp al, '0'
jl notnr
cmp al, '9'
jg notnr
inc bl
mov cl, [others]
dec cl
mov [others], cl
notnr:
inc edx
jmp parcurgenr
endparcurgenr:

mov al, bl
mov ebx, 10
xor dl, dl
div ebx
add dl, '0'
mov [digits+2], dl
xor dl, dl
div ebx
add dl, '0'
mov [digits+1], dl
add al, '0'
mov [digits], al
    
mov al, [others]
mov ebx, 10
xor dl, dl
div ebx
add dl, '0'
mov [others+2], dl
xor dl, dl
div ebx
add dl, '0'
mov [others+1], dl
add al, '0'
mov [others], al

mov ecx, vocalem
mov edx, vocaleml
mov eax, 4
mov ebx, 1
int 0x80

mov ecx, vowels
mov edx, 4
mov eax, 4
mov ebx, 1
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, 0ah
mov edx, 1
int 0x80

mov ecx, cifrem
mov edx, cifreml
mov eax, 4
mov ebx, 1
int 0x80

mov ecx, digits
mov edx, 4
mov eax, 4
mov ebx, 1
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, 0ah
mov edx, 1
int 0x80

mov ecx, othersm
mov edx, othersml
mov eax, 4
mov ebx, 1
int 0x80

mov ecx, others
mov edx, 4
mov eax, 4
mov ebx, 1
int 0x80

mov eax, 1
mov ebx, 0
int 0x80