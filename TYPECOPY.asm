%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro
section .data
	menu db 10,'1. To Type'
		 db 10,'2. To copy'
		 db 10,'3. To delete'
		 db 10,'4. To Exit'
		 db 10,'Choose the command : '
	lenmenu equ $ - menu
	
	mes1 db 'Enter the file name : '
	len1 equ $ - mes1
	
	mes2 db 'Enter the 1st file name : '
	len2 equ $ - mes2
	
	mes3 db 'Enter the 2nd file name : '
	len3 equ $ - mes3
	
	mes4 db 'Enter the file name to delete : '
	len4 equ $ - mes4
	
	wrong db 10,10,'Wrong command ',10,10
	lenwrong equ $ - wrong
	
	
section .bss
	choice resb 2
	fileName resb 20
	fileName1 resb 20
	fileName2 resb 20
	handle resb 8
	handle1 resb 8
	handle2 resb 8
	buffer resb 500
	fileLen resb 20
	typetext resb 50
	textLen resb 8
	
section .text
global _start
_start:
menuDis:
	println menu,lenmenu
	
	mov rax,00h
	mov rdi,00h
	mov rsi,choice
	mov rdx,02h
	syscall
	
	mov al,[choice]
	cmp al,31h
	je type
	
	cmp al,32h
	je copy
	
	cmp al,33h
	je delete
	
	cmp al,34h
	je exit
	
	println wrong,lenwrong
	jmp menuDis

type:
	println mes1,len1
	
	mov rax,00h
	mov rdi,00h
	mov rsi,fileName
	mov rdx,20h
	syscall
	
	mov rsi,fileName
	add rsi,rax
	dec rsi
	mov al,00h
	mov [rsi],al
	
	mov rax,02h
	mov rdi,fileName
	mov rsi,02h
	mov rdx,0777o
	syscall
	
	mov [handle],rax
	
	mov rax,00h
	mov rdi,[handle]
	mov rsi,buffer
	mov rdx,500h
	syscall
	
	mov [fileLen],rax
	println b   uffer,[fileLen]
	
	mov rax,00h
	mov rdi,00h
	mov rsi,typetext
	mov rdx,50h
	syscall
	
	mov [textLen],rax
	
	mov rax,01h
	mov rdi,[handle]
	mov rsi,typetext
	mov rdx,[textLen]
	syscall
	
	mov rax,03h
	mov rdi,[handle]
	syscall
	jmp menuDis
	
copy:
	println mes2,len2
	
	mov rax,00h
	mov rdi,00h
	mov rsi,fileName1
	mov rdx,20h
	syscall
	
	mov rsi,fileName1
	add rsi,rax
	dec rsi
	mov al,00h
	mov [rsi],al
	
	println mes3,len3
	
	mov rax,00h
	mov rdi,00h
	mov rsi,fileName2
	mov rdx,20h
	syscall
	
	mov rsi,fileName2
	add rsi,rax
	dec rsi
	mov al,00h
	mov [rsi],al
	
	mov rax,02h
	mov rdi,fileName1
	mov rsi,02h
	mov rdx,0777o
	syscall
	
	mov [handle1],rax
	
	mov rax,00h
	mov rdi,[handle1]
	mov rsi,buffer
	mov rdx,500h
	syscall
	
	mov [fileLen],rax
	
	mov rax,02h
	mov rdi,fileName2
	mov rsi,42h
	mov rdx,0777o
	syscall
	
	mov [handle2],rax
	
	mov rax,01h
	mov rdi,[handle2]
	mov rsi,buffer
	mov rdx,[fileLen]
	syscall
	
	mov rax,03h
	mov rdi,[handle1]
	syscall
	
	mov rax,03h
	mov rdi,[handle2]
	syscall
	
	jmp menuDis
delete:
	println mes4,len4
	
	mov rax,00h
	mov rdi,00h
	mov rsi,fileName
	mov rdx,20h
	syscall
	
	mov rsi,fileName
	add rsi,rax
	dec rsi
	mov al,00h
	mov [rsi],al
	
	mov rax,87
	mov rdi,fileName
	syscall
	
	jmp menuDis
exit:
	mov rax,60
	syscall

