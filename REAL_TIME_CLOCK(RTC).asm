.model tiny
.code
        org 100h                
	start:  
		jmp init
		saveint dd ?
		temp dw 0
        tempax dw ?
        tempbx dw ?
        tempcx dw ?
        tempdx dw ?
        tempsi dw ?
        tempdi dw ?
        tempds dw ?
        tempes dw ?

	mark:
		;Store the registers temporarily
        mov cs:tempax,ax	
        mov cs:tempbx,bx
        mov cs:tempcx,cx
        mov cs:tempdx,dx
        mov cs:tempsi,si
        mov cs:tempdi,di
        mov cs:tempds,ds
        mov cs:tempes,es

		;Read time 
		mov ah,02h              	
        int 1ah									; returns ch=hh, cl=mm, dh=ss in BCD
		inc cs:temp								;for beep
        mov ax,0b800h           				;BASE ADDRESS OF PAGE-0 OF VIDEO RAM
        mov es,ax
        mov di,3984             				;OFFSET IN VIDEO RAM WHERE WE WANT TO DISPLAY HH:MM:SS

		;--------------------------DISPLAYING HH--------------------------
        mov bl,02               				;NUMBER OF DIGITS TO DISPLAY
	l1:
	    rol ch,1               					
        rol ch,1               
		rol ch,1               
		rol ch,1               
		mov ch,CH
        and al,0FH
		add al,30h		
		mov ah,17h             					;ATTRIBUTE BYTE (BL R G B I R G B) 00010111
		mov es:[di],ax
		inc di
		inc di
		dec bl
        jnz l1

		;--------------------------DISPLAYING BLINKING ':'--------------------------
        mov al,':'
        mov ah,94h								;ATTRIBUTE BYTE (BL R G B I R G B) 10011000
        mov es:[di],ax
        inc di
        inc di

		;--------------------------DISPLAYING MM--------------------------
        mov bl,02               	;NUMBER OF DIGITS TO DISPLAY
	l2:    
		rol cl,1               	
		rol cl,1               
		rol cl,1               
		rol cl,1               
		mov al,cl
		and al,0fh
		add al,30h
		mov ah,17h              				;ATTRIBUTE BYTE (BL R G B I R G B) 00010111
		mov es:[di],ax
		inc di
		inc di
		dec bl
        jnz l2

		;--------------------------DISPLAYING BLINKING ':'--------------------------
        mov al,':'
        mov ah,94h								;ATTRIBUTE BYTE (BL R G B I R G B) 10011000
        mov es:[di],ax
        inc di
        inc di

		;--------------------------DISPLAYING SS--------------------------
        mov bl,02               	
	l3: 
	
		rol dh,1              	
		rol dh,1               
		rol dh,1 
		rol dh,1                             
		mov al,dh
		and al,0Fh
		add al,30h
		mov ah,17h              				;ATTRIBUTE BYTE (BL R G B I R G B) 00010111
		mov es:[di],ax
		inc di
		inc di
		dec bl
        jnz l3
        
	cmp cs:temp,91								;for 5sec 18.2*5=91
	jne nobeep
	  
		mov cs:temp,00h
       	mov ax, 1193        			; Frequency number (in decimal)divided 1,193,180 by desired tone here we used 1000Hz
        out 42h, al         			; Output low byte.
        mov al, ah          			; Output high byte.
        out 42h, al        
        in al, 61h         			; Turn on note (get value from port 61h).
        or al, 00000011b   			; Set bits PB1 and PB0.
        out 61h, al         			; Send new value.
        mov bx, 25          			; Pause for duration of note.
	pause1:
        mov cx, 65535
	pause2:
		dec cx
		jne pause2
		dec bx
		jne pause1
		in al, 61h         ; Turn off note (get value from port 61h).
		and al, 11111100b   ; Reset bits 1 and 0.
		out 61h, al  

	nobeep:	
		mov ax,cs:tempax
		mov bx,cs:tempbx
		mov cx,cs:tempcx
		mov dx,cs:tempdx
		mov si,cs:tempsi
		mov di,cs:tempdi
		mov ds,cs:tempds
		mov es,cs:tempes
        jmp cs:saveint

init:   
		cli
		;raed the original vector address entry and store it in data area
        mov ah,35h              
        mov al,08h              
        int 21h                 

        mov word ptr saveint,bx
        mov word ptr saveint+2,es

		;Set the vector address to our interrupt service routine
        mov ah,25h              
        mov al,08h              
        lea dx,mark          
        int 21h

		;Terminate and make it resident
        mov ah,31H              
        lea dx,init             
        sti                                             ;set intrrupt flag
        int 21h                                         ;Terminate and Stay resident 
end start
