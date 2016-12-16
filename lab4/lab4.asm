.386
.model flat, stdcall
option casemap: none
extern WriteConsoleA@20: PROC
extern GetStdHandle@4: PROC
.data
	term db 0
	ten dd 10
	dout dd ?
	lens dd ?
	buf db ?
	ba dd ?
	bb dd ?
.code

print macro num
local conv, addchar, prnt
	mov ba, eax
	mov bb, ebx
	mov eax, num 
	xor ebx, ebx
	push ' '
	inc ebx
conv:
	cdq
	div ten
	add edx, '0'
addchar:
	push edx
	inc ebx
	cmp eax, 0
jg conv
prnt:
	pop eax
	mov buf, al
	push 0
	push offset lens
	push 1
	push offset buf
	push dout
	call WriteConsoleA@20
	dec ebx
	cmp ebx, 0
	jg prnt
	
	mov eax, ba
	mov ebx, bb
ENDM

count macro ofst
local fin, clop, move, fall
	xor edx, edx
	clop:
		mov cl, [ofst+ebx]
		cmp cl, 10
		je fin
		cmp cl, 0
		je fall
		cmp cl, ' '
		jne move
		inc edx
	move:
		inc ebx
		jmp clop
	fall:
		mov term, 1
	fin:
		inc edx
		inc ebx
		print edx
endm

work proc text:dword
	push -11
	call GetStdHandle@4
	mov dout, eax

	xor ebx, ebx
	mov eax, text
	lop:
		count eax
		mov ch, term
		cmp ch, 1
	jne lop
ret 4
work endp

end