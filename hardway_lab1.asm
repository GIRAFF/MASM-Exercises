.386
.MODEL FLAT, STDCALL
	OPTION CASEMAP: NONE
	EXTERN CharToOemA@8: PROC
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
.CODE
m_BufToIntOct MACRO len, buff, dest
	LOCAL CONVERT, FAIL, LEND
	; checking if the num has enough digits
	CMP len, 4
	JL FAIL
	MOV ESI, OFFSET buff
	XOR BX, BX
	XOR EAX, EAX
CONVERT:
	MOV BL, [ESI]
	SUB BL, '0'
	CMP BL, 8
	JNB FAIL  ;JAE~JGE for unsigned
	MUL 8
	ADD AX, BX
	INC ESI
	; if the string is over
	CMP [ESI], 0
	JE LEND
JMP CONVERT
FAIL:
	PUSH 1
	CALL ExitProcess@4
LEND:
	MOV dest, EAX
ENDM

m_NumToHexString MACRO num, buffaddr
	LOCAL CONV, LTEN, ADDCHAR
	MOV EAX, num 
CONV:
	DIV 10h:DWORD
	CMP EDX, 10
	JL LTEN
	SUB EDX, 10
	ADD EDX, 'A'
	JMP ADDCHAR
LTEN:
	ADD EDX, '0'
ADDCHAR:
	MOV [buffaddr], EDX
	INC buffaddr
	CMP EAX, 0
JA CONV
ENDM

m_MakeExprString MACRO buffaddr, first, second, res
	MOV EBX, buffaddr
	m_NumToHexString first, buffaddr
	MOV buffaddr, MINUS
	ADD buffaddr, 3
	m_NumToHexString second, buffaddr
	MOV buffaddr, sEQ
	ADD buffaddr, 3
	m_NumToHexString res, buffaddr
	MOV buffaddr, EBX
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
	m_BufToIntOct LENS, BUF, FIRST

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
	m_BufToIntOct LENS, BUF, SND

	MOV EAX, FIRST
	SUB EAX, SND
	MOV FIN, EAX

	; TODO use macro to make it one string
	m_MakeExprString OFFSET BUF, FIRST, SND, FIN
	MOV EAX, OFFSET BUF
	PUSH EAX
	PUSH EAX
	CALL CharToOemA@8

	; print the result
	PUSH OFFSET BUF
	PUSH lstrlenA@4
	PUSH 0
	PUSH OFFSET LENS
	PUSH EAX
	PUSH OFFSET BUF
	PUSH DOUT
	CALL WriteConsoleA@20

EXIT:
	PUSH ECODE
	CALL ExitProcess@4
MAIN ENDP

END MAIN
