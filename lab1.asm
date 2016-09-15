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
	EIGHT DD 8 ; eight?
.CODE

m_BufToIntOct MACRO buff, dest
	LOCAL CONVERT, LEND, FAIL
	MOV ESI, OFFSET BUF
	XOR BX, BX
	XOR EAX, EAX
CONVERT:
	MOV BL, [ESI]
	SUB BL, '0'
	CMP BL, 8
	JNB FAIL
	MUL EIGHT
	ADD AX, BX
	INC ESI
	CMP [ESI], 0
	JE LEND
	JMP CONVERT
FAIL:
	PUSH 1
	CALL ExitProcess@4
LEND:
	MOV dest, EAX
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
	m_BufToIntOct BUF, SND

	PUSH 0
	CALL ExitProcess@4
MAIN ENDP

END MAIN
