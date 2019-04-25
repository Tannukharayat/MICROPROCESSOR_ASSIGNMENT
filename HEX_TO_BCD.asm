%macro print 2
 mov rax,01h
 mov rdi,01h
 mov rsi,%1
 mov rdx,%2 
syscall
%endmacro

section .data
	msg db 10,'1.HEX To BCD'
		db 10,'3.EXIT'
	    db 10,'Enter choice  '
	len equ $-msg
	
	msg1 db 10,'Enter HEX no '
	len1 equ $-msg1	
	
	
	msg4 db 10,'Equivalent BCD no '
	len4 equ $-msg4

section .bss
	accept  resb 3
	display resb 1
	hex		resb 2
	choice 	resb 2
	result  resb 2
	remd    resb 2
	curr	resb 1
section .text
	global _start
_start:
menu:
	print msg,len
	mov rax,00h
	mov rdi,00h
	mov rsi,choice
	mov rdx,02h
	syscall
	mov al,[choice]					
	cmp al,031h
call hextobcd
	jmp menu
exit:
	mov rax,60
	syscall 
		
hextobcd:
	print msg1,len1
	call AcceptNo
	mov [hex+1],bl
	
	call AcceptNo
	mov [hex],bl
	;//Needed to handle enter charater
	mov rax,00h
	mov rdi,00h
	mov rsi,accept
	mov rdx,01h
 syscall
	
	print msg4,len4
	
	mov dx,00h
	mov ax,[hex]
	mov bx,10000
	div bx
	mov[remd],dx
	mov bl,al
	call displayNo1 ;New display procedure
		
	mov dx,00h
	mov ax,[remd]
	mov bx,1000
	div bx
	mov[remd],dx
	mov bl,al
	call displayNo1
	
	mov dx,00h
	mov ax,[remd]
	mov bx,100
	div bx
	mov[remd],dx
	mov bl,al
	call displayNo1
	
	mov dx,00h
	mov ax,[remd]
	mov bx,10
	div bx
	mov[remd],dx
	mov bl,al
	call displayNo1
	
	mov bx,[remd]
	call displayNo1
	ret
	
AcceptNo:
	mov rax,00h
	mov rdi,00h
	mov rsi,accept
	mov rdx,02h
 syscall

	mov al,[accept]	
 	sub al,30h
 	cmp al,09h
 	jle dontSub
 	sub al,07h

dontSub:
	shl al,04h
	mov bl,al
	mov al,[accept+1]
	sub al,30h
 	cmp al,09h
 	jle dontSubbb
 	sub al,07h
dontSubbb:
	or bl,al
	ret	  

displayNo1:
	mov al,bl
	add al,030h
	mov [curr],al
	print curr,01h
 	ret
displayNo:
	mov al,bl
	and al,0f0h
	shr al,04h
	add al,30h
	cmp al,039h
	jle dontAdd
	add al,07h 

dontAdd:
	mov [display],al
	mov al,bl
	and al,0fh
	add al,30h
	cmp al,039h
	jle dontAddd
	add al,07h 
dontAddd:
	mov [display+1],al
	print display,02h
	ret







	
	
