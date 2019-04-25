%macro println 2
mov rax,01h
mov rdi,01h
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .data
msg0 db 10,'How Many Ele :: '
len0 equ $-msg0

msg1 db 10,'Enter array Elements :'
len1 equ $-msg1

msg2 db 10,'Before Transfer :'
len2 equ $-msg2

msg3 db 10,'Array is ::'
len3 equ $-msg3

msg5 db 10,'After Transfer :'
len5 equ $-msg5

msg6 db 10,'Overlap Cnt :'
len6 equ $-msg6


space db '  '


section .bss
array resb 15
cnt resb 1
ovcnt resb 1
accept resb 3
display resb 2

section .text
 global _start
_start:
  
  println msg0,len0
  call acceptNo 
  mov [cnt],bl
  
  
  println msg1,len1
  mov rsi,array
  mov cl,[cnt]
acptNext:
  push rsi
  push rcx
  call acceptNo
  pop rcx 
  pop rsi
  
  mov [rsi],bl
  inc rsi
  dec cl
  jnz acptNext
  
  
  println msg2,len2
  println msg3,len3
  
  mov rsi,array
  mov cl,[cnt]
dispNext:
  mov bl,[rsi]
  push rsi
  push rcx
  call displayNo
  println space,02h
  pop rcx
  pop rsi
  inc rsi
  dec cl
  jnz dispNext
       
  
  println msg6,len6
  call acceptNo
  mov [ovcnt],bl
  
  
  
  
  mov rsi,array
  mov al,[cnt]
  mov cl,[cnt]
  add rsi,rax
  dec rsi
  
  mov rdi,array
  mov al,[cnt]
  mov cl,[cnt]
  add al,cl
  mov bl,[ovcnt]
  sub al,bl
  add rdi,rax
  dec rdi
  
  mov cl,[cnt]
moveNext:
  
  mov al,[rsi]
  mov [rdi],al
  dec rsi
  dec rdi
  dec cl
  jnz moveNext
  
   
  println msg5,len5
  println msg3,len3
  
   
  mov rsi,array
  mov cl,15
dispNext1:
  mov bl,[rsi]
  push rsi
  push rcx
  call displayNo
  println space,02h
  pop rcx
  pop rsi
  inc rsi
  dec cl
  jnz dispNext1
  
  mov rax,60
  syscall
  
  
  
acceptNo:

	mov rax,00h
	mov rdi,00h
	mov rsi,accept
	mov rdx,03h
	syscall

	mov al,[accept]
	sub al,30h
    cmp al,09h
	jle dontSub
	sub al,07h

dontSub:	
	mov cl,04h
	shl al,cl
	mov bl,al

	mov al,[accept+1]
	sub al,30h
	cmp al,09h
	jle dontSubb
	sub al,07h

dontSubb:
	or bl,al
ret

displayNo:

	mov al,bl
	and al,0f0h
	mov cl,04h
	shr al,cl
	add al,30h
	cmp al,39h
	jle dontAdd
	add al,07h

dontAdd:
	mov [display],al

	mov al,bl
	and al,0fh
	add al,30h
	cmp al,39h
	jle dontAddd
	add al,07h

dontAddd:
	mov [display+1],al

	println display,02h

ret
  
  
  
  
  
  
  

  
  
   


