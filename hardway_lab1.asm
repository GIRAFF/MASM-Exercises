.386
.MODEL FLAT, STDCALL
	OPTION CASEMAP: NONE
	EXTERN CharToOemA@8: PROC
	EXTERN WriteConsoleA@20: PROC
	EXTERN ReadConsoleA@20: PROC
	EXTERN GetStdHandle@4: PROC
	EXTERN lstrlenA@4: PROC
	EXTERN ExitProcess@4: PROC
.DATA
	; string data
	MSG1 DB "Введите число: ",0
	MSG2 DB "Введите ещё число: ",0
	MINUS DB " - "
	sEQ DB " = "
	; descriptors
	DIN DD ?
	DOUT DD ?
	; buffers
	BUF DB 200 dup (?)
	INTBUF DD ?
	; vars
	LENS DD ?  ; len of string
	FIRST DD ? ; first operand
	SND DD ?   ; second operand
	FIN DD ?   ; result
	ECODE DD 0 ; exit code
	THREE DD 3 ; three
	EIGHT DD 8 ; eight?
	HEX DD 10h ; SIXTEEN??!?!
.CODE
m_BufToIntOct MACRO buff, dest
	LOCAL CONVERT, FAIL, LEND
	; checking if the num has enough digits
	PUSH OFFSET buff
	CALL lstrlenA@4
	MOV ESI, OFFSET buff
	XOR BX, BX
	XOR EAX, EAX
CONVERT:
	MOV BL, [ESI]
	SUB BL, '0'
	CMP BL, 8
	JNB LEND ; cause I don't give a hell...
	MUL EIGHT
	ADD AX, BX
	INC ESI
JMP CONVERT
LEND:
	MOV dest, EAX
ENDM

m_NumToHexPrint MACRO num;, buffaddr
	LOCAL CONV, LTEN, ADDCHAR
	MOV EAX, num 
	XOR EBX, EBX
CONV:
	CDQ
	DIV HEX
	CMP EDX, 10
	JL LTEN
	SUB EDX, 10
	ADD EDX, 'A'
	JMP ADDCHAR
LTEN:
	ADD EDX, '0'
ADDCHAR:
	PUSH EDX
	INC EBX
	CMP EAX, 0
JG CONV
PRINT:
	POP EAX
	MOV BUF, AL
	PUSH 0
	PUSH OFFSET LENS
	PUSH 1
	PUSH OFFSET BUF
	PUSH DOUT
	CALL WriteConsoleA@20
	DEC EBX
	CMP EBX, 0
	JG PRINT
ENDM

MAIN PROC
	; MSG1 & MSG2 to OEM
	MOV EAX, OFFSET MSG1
	PUSH EAX
	PUSH EAX
	CALL CharToOemA@8

	MOV EAX, OFFSET MSG2
	PUSH EAX
	PUSH EAX
	CALL CharToOemA@8

	; get in-/output descs to EAX
	PUSH -10
	CALL GetStdHandle@4
	MOV DIN, EAX
	PUSH -11
	CALL GetStdHandle@4
	MOV DOUT, EAX

	; 'please, put the first one'
	PUSH OFFSET MSG1
	CALL lstrlenA@4
	PUSH 0
	PUSH OFFSET LENS
	PUSH EAX
	PUSH OFFSET MSG1
	PUSH DOUT
	CALL WriteConsoleA@20

	PUSH 0
	PUSH OFFSET LENS
	PUSH 200
	PUSH OFFSET BUF
	PUSH DIN
	CALL ReadConsoleA@20
	; put the num from BUF to int memcell
	m_BufToIntOct BUF, FIRST

	; 'please, put the second one'
	PUSH OFFSET MSG2
	CALL lstrlenA@4
	PUSH 0
	PUSH OFFSET LENS
	PUSH EAX
	PUSH OFFSET MSG2
	PUSH DOUT
	CALL WriteConsoleA@20

	PUSH 0
	PUSH OFFSET LENS
	PUSH 200
	PUSH OFFSET BUF
	PUSH DIN
	CALL ReadConsoleA@20
	; put the num from BUF to int memcell
	m_BufToIntOct BUF, SND

	MOV EAX, FIRST
	SUB EAX, SND
	MOV FIN, EAX
	; print result
	m_NumToHexPrint FIN;, OFFSET BUF
EXIT:
	PUSH ECODE
	CALL ExitProcess@4
MAIN ENDP

END MAIN
