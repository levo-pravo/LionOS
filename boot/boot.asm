org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start
	; use equ for constants

mov si, msg_hello
call puts
mov si, msg_flpp
call puts

cli
lgdt [GDT_Descriptor]
; now we change the last bit of cr0 to1
mov eax, cr0
or eax, 1 ; this
mov cr0, eax
jmp CODE_SEG:start_protected_mode

msg_hello: db "Good morning, sir!", ENDL, 0
msg_flpp: db "Running from floppy disk...", ENDL, 0

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

GDT_Start:
	null_descriptor:
		dd 0 ; four times 00000000
		dd 0 ; four times 00000000
	code_descriptor:
		dw 0xffff
		dw 0 ; 16 bits +
		db 0 ; 8 bits = 24
		db 0b10011010 ; present, privilege, type, Type flags
		db 0b11001111 ; Other flags + limit (last 4 bits - f)
		db 0 ; last 8 bits of base
	data_descriptor:
		dw 0xffff
		dw 0 ; 16 bits +
		db 0 ; 8 bits = 24
		db 0b10010010 ; present, privilege, type, Type flags
		db 0b11001111 ; Other flags + limit (last 4 bits - f)
		db 0 ; last 8 bits of base
	GDT_End:

GDT_Descriptor:
	dw GDT_End - GDT_Start - 1 ; size
	dd GDT_Start ; start

[bits 32]
start_protected_mode:
	mov al, "A"
	mov ah, 0x0f
	mov [0xb8000], ax

times 510-($-$$) db 0
dw 0xAA55
