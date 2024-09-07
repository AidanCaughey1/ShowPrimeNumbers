TITLE Project4    (Project4_caugheya.asm)

; Author: Aidan Caughey
; Last Modified:  02/21/2024
; OSU email address: caugheya@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  4              Due Date: 02/25/24
; Description: Displays a range of prime numbers using procedures

INCLUDE Irvine32.inc

; Constants
UPPER_BOUND = 200
LOWER_BOUND = 1

.data
intro_1		BYTE	"Prime Numbers Programmed by Aidan Caughey",13,10,0
intro_2		BYTE	"Enter the number of prime numbers you would like to see.",13,10,0
intro_3		BYTE	"I'll accept orders for up to 200 primes.",13,10,0
prompt_1	BYTE	"Enter the number of primes to display [1 ... 200]: ",0
error		BYTE	"No primes for you! Number out of range. Try again.",13,10,0
goodbye		BYTE	"Results certified by Aidan Caughey. Goodbye.",13,10,0
count		DWORD	0
lineCount	DWORD	0
numPrimes	DWORD	?
primeCount	DWORD	?
primes		DWORD	200 DUP(?)
isPrime		BYTE	200 DUP(1)
space		BYTE	'   ', 0

.code
main PROC
  call	introduction
  call	getUserData
  call	showPrimes
  call	farewell
  exit
main ENDP

; ---------------------------------------------------------------------------------
; Name: Introduction
;
; This procedure displays the intro and instructions for the user
;
; Preconditions: None
;
; Postconditions: None
;
; Receives: None
;
; Returns: None
; ---------------------------------------------------------------------------------
introduction PROC
  mov	EDX, Offset intro_1
  call	WriteString
  call	CrLf
  mov	EDX, Offset intro_2
  call	WriteString
  mov	EDX, Offset intro_3
  call	WriteString
  ret
introduction ENDP

; ---------------------------------------------------------------------------------
; Name: getUserData
;
; This procedure obtains user input for the number of primes to display
;
; Preconditions: None
;
; Postconditions: numPrimes contains the user input
;
; Receives: None
;
; Returns: None
; ---------------------------------------------------------------------------------
getUserData PROC
_getUserInput:
  mov	EDX, Offset prompt_1
  call	WriteString
  call	ReadInt					; Reads user input
  mov	numPrimes, EAX
  call	validate				; Calls sub-procedure to validate if user input is within bounds
  cmp	EAX, 0					; Compares the validation results
  jne	_getUserInput
  ret
getUserData ENDP

; ---------------------------------------------------------------------------------
; Name: validate
;
; This procedure checks if the user input is within bounds
;
; Preconditions: numPrimes contains a user input
;
; Postconditions: None
;
; Receives: None
;
; Returns: Returns 0 if numPrimes is within bounds, 1 if it's out of bounds
; ---------------------------------------------------------------------------------
validate PROC
  cmp	numPrimes, LOWER_BOUND
  jl	_invalidInput
  cmp	numPrimes, UPPER_BOUND
  jg	_invalidInput
  xor	EAX, EAX				; Clears EAX to 0 to indiciate it's valid
  ret							; Returns if valid

_invalidInput:
  mov	EDX, Offset error
  call	WriteString
  mov	EAX, 1					; Sets EAX to 1 to indicate invalid input
  ret
validate ENDP

; ---------------------------------------------------------------------------------
; Name: showPrimes
;
; This procedure finds and displays the prime numbers up to the nth prime
;
; Preconditions: numPrimes contains a user input
;
; Postconditions: primes contains the prime numbers and prime count will have the correct number of prime numbers found
;
; Receives: None
;
; Returns: None
; ---------------------------------------------------------------------------------
showPrimes PROC
  mov	ECX, numPrimes			
  mov	EDI, 2					; 2 is the starting number for prime numbers
  mov	EBX, 0					; Loop counter for storing primes


_displayLoop:
  call	Prime					; Jumps to sub-procedure to verify if it's prime
  cmp	al, 1					; If not equal to 1, then it's not prime
  jne	_notPrime
	
  mov	primes[EBX], EDI		; Stores prime number into the array
  inc	count
  inc	EBX

  mov	EAX, EDI				; prints the prime number
  call	WriteDec

  inc	lineCount
  cmp	lineCount, 10			; If more than 10 numbers on current line, new line
  jne	_printSpace
  call	CrLf
  mov	lineCount, 0
  jmp	_incrementAndDisplay

_printSpace:
  mov	EDX, Offset space		; Prints the spaces between prime numbers
  call	WriteString
  jmp	_incrementAndDisplay

_incrementAndDisplay:
  inc	EDI
  LOOP	_displayLoop
  jmp	_endDisplayLoop

_notPrime:
  inc	EDI						; Increments to the next number
  jmp	_displayLoop

_endDisplayLoop:
  ret							; Returns to main
showPrimes ENDP

; ---------------------------------------------------------------------------------
; Name: Prime
;
; This procedure checks if a given number is prime
;
; Preconditions: EDI contains a given number
;
; Postconditions: None
;
; Receives: None
;
; Returns: Returns 1 in al if the number is prime and 0 otherwise.
; ---------------------------------------------------------------------------------
Prime PROC
  mov	ESI, 2
  mov	EDX, 0

_divLoop:
  cmp	ESI, EDI				; Compare divisor to given number
  jge	_prime					; If greater or equal, number is prime
  mov	EAX, EDI
  mov	EDX, 0
  div	ESI						; Divides EDI by ESI
  cmp	EDX, 0
  jne	_notDivisible			; If remainder is not 0, continue
  jmp	_notPrime				; If divisible, it's not prime
	
_notDivisible:
  inc	ESI						; Increment divisor
  jmp	_divLoop				; Repeat to beginning
	
_prime:
  mov	al, 1					; Sets al to 1 to indicate prime
  ret
_notPrime:
  xor	al, al					; Clears al to indicate not prime
  ret
Prime ENDP
 
farewell PROC
  call	CrLf
  mov	EDX, Offset goodbye
  call	WriteString
  ret
farewell ENDP
END main