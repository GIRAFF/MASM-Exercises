.intel_syntax noprefix
.386
.model flat
.data
	strl dd ?
	subl dd ?
.code
_indexof proc
	push ebp
	push esi
	push edi
	mov ebp, esp

	mov ebx, [ebp]+8
	mov strl, [ebp]+12
	mov edx, [ebp]+16
	mov subl, [ebp]+20

	cld
	LOOP:
		mov esi, ebx   #source
		mov edi, edx   #destination
		mov ecx, subl  #len
		repe scasb
		cmp ecx, 0
		je FOUND

FOUND:
	# TODO return something
	mov eax, 1
	pop edi
	pop esi
	pop ebp
	ret
_indexof endp
