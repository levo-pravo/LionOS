org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

start:
	jmp main


; Prints a string to the screen
; Parameters:
; 	ds:si points to string
puts:
	; save register that will be modified
	push si
	push ax
	mov ah, 0x0e ; int 0x10 needs this
.loop:
	lodsb ; loads next character in al
	; equals to:
	; mov al, [si]
	; inc si
	or al, al; checks if the character is not null
	jz .done ; jumps if the zero flag is set
	; calls interrupt
	int 0x10
	jmp .loop
.done:
	pop ax
	pop si
	ret

; Reads one line
reads:
	push ax
	push si
	mov si, one_line
	mov word [one_line], 0 
.loop:
	mov ah, 0 ; reads one character
	int 0x16 ; ^^^^^^^^^^^^^^^^^^^^
	cmp al, 0x30 ; is "0" ?
	je .done
	mov [si], al ; adds the character to the line
	inc si
	mov ah, 0x0e ; puts one character
	int 0x10 ; ^^^^^^^^^^^^^^^^^^^^^^
	jmp .loop
.done:
	mov ah, 0x0e
	mov al, 0x0D 
	int 0x10
	mov al, 0x0A 
	int 0x10
	pop si
	pop ax
	ret

main:
	; setup data segments
	mov ax, 0
	mov es, ax
	mov es, ax
	
	; setup stack
	mov ss, ax
	mov sp, 0x7C00 ; stack pointer goes backwards, 1000 - 999 - 998...
	
	; print message
	mov si, msg_hello
	call puts
	mov si, msg_os
	call puts

	call reads

	hlt
.halt:
	jmp .halt

msg_hello: db "hey wold", ENDL, 0
msg_os: db "hi you in front of pc it is me LionOS", ENDL, 0
one_line: db "hi", 0

times 510-($-$$) db 0
dw 0xAA55
