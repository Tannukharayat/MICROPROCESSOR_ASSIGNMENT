;working
.model small

.stack 100

.data
msg db 10,13,'this is cos wave$'
x dd 0.0
xad dd 5.0
one80 dd 180.0
thirty dd 30.0
fifty dd 50.0
;row db 00
;col db 00
;xcursor dd 00
ycursor dt 00
count dw 360
x1 dw 0


.code
.386
main: mov ax,@data
mov ds,ax                                                                                                                                                                                                                                                                                                                                                                       

mov ah,00               ;set video mode
mov al,6
int 10h

up1:finit

fldpi
fdiv one80
fmul x
fcos
fld thirty
fmul 
fld fifty
fsub st,st(1)   ;=100-60 sin((pi/180))*x


fbstp ycursor
;lea esi,ycursor
mov si,offset ycursor
mov ah,0ch              ;write graphics pixel
mov al,01h
mov bh,0h
mov cx,x1
mov dx,[si]
int 10h

inc x1                 
fld x                  
fadd xad               
fst x                  
dec count              
jnz up1                


mov ah,09h                      ; display message
lea dx,msg
int 21h

;mount c dire 
;c:
;tasm filename.asm
;tlink filename
;filename    

mov ah,4ch
int 21h
end main

