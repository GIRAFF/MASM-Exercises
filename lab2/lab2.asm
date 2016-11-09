.386
.model flat, c
.data
.code
indexof proc strptr:dword, subptr:dword
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	mov eax, strptr
	lop:
		mov ebx, subptr
		slop:
			mov ch, [eax+edx]
			mov cl, [ebx]
			cmp ch, cl
			; if current chars are not equal
			jne noslop
			inc edx
			inc ebx
			jmp slop
		noslop:
			cmp cl, 0
			; go away if it is the end of substring
			je nolop
			inc eax
			mov bl, [eax]
			cmp bl, 0
			je no
			jmp lop
	nolop:
		sub eax, strptr
		ret
	no:
	mov eax, -1
	ret
indexof endp
end