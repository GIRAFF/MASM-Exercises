.386
.model flat, c
.data
	three real4 3.0
	x_st real4 6.0
	x_i real4 6.0001
	fx_st real4 0.0
	fx_i real4 0.0
	buf real4 0.0
	x_ii real4 0.0
.code
foonc proc x:real4
	fld three; -:3:
	fld x    ; -:x:3:
	fdivrp   ; -:x/3:
	fld x    ; -:x:x/3:
	fptan    ; -:1:tg(x):x/3:
	fdivrp   ; -:ctg(x):x/3:
	fsubrp   ; -:ctg(x)-x/3:
	fstp buf ; -:
	ret
foonc endp

work proc accur:real4
	finit
	mov ebx, 0
	push x_st
	call foonc
	mov eax, buf
	mov fx_st, eax
	lop:
		inc ebx
		push x_i
		call foonc
		mov eax, buf
		mov fx_i, eax
		fld fx_st ; -:f(x0):
		fld fx_i  ; -:f(xi):f(x0):
		fsubrp    ; -:f(xi)-f(x0):
		fld x_st  ; -:x0:f(xi)-f(x0):
		fld x_i   ; -:xi:x0:f(xi)-f(x0):
		fsubrp    ; -:xi-x0:f(xi)-f(x0):
		fld fx_i  ; -:f(xi):xi-x0:f(xi)-f(x0):
		fmulp     ; -:f(xi)(xi-x0):f(xi)-f(x0):
		fdivrp    ; -:f(xi)(xi-x0)/(f(xi)-f(x0)):
		fld x_i   ; -:xi:f(xi)(xi-x0)/(f(xi)-f(x0)):
		fsubrp    ; -:xi-f(xi)(xi-x0)/(f(xi)-f(x0)):
		fst x_ii  ; -:xi-f(xi)(xi-x0)/(f(xi)-f(x0)):
		fld x_i   ; -:xi:xi-f(xi)(xi-x0)/(f(xi)-f(x0)):
		fsubrp    ; -:delta x:
		fabs      ; -:|delta x|:
		fld accur ; -:accur:|delta x|:
		mov eax, x_ii
		mov x_i, eax
		fcompp
		fstsw ax
		sahf
		jb lop
	fld x_i
	ret
work endp

end