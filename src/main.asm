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
.loop:
	lodsb ; loads next character in al
	or al, al; checks if the character is not null
	jz .done ; jumps if the zero flag is set
	
	; calls bios interrupt
	mov ah, 0x0e
	mov bh, 0
	int 0x10
	jmp .loop
.done:
	pop ax
	pop si
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

	hlt
.halt:
	jmp .halt

msg_hello: db "hey wold", ENDL, 0


times 510-($-$$) db 0
dw 0AA55h
