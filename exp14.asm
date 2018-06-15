;从CMOS RAM中获取时间日期，并显示
assume cs:code  
 
data segment  
   db '00/00/00 00:00:00','$'  
   db 9,8,7,4,2,0  
data ends  

stack segment
 dw 0
stack ends
code segment  
start:  
    mov ax,data  
    mov ds,ax  
	
	mov ax,stack
	mov ss,ax
	mov sp,1
	
    mov di,0  
    mov si,18 ;data中第二组数据  
  
    mov cx,6  
s:  
    push cx ;暂存cx
    mov al,[si]  
    out 70h,al  
    in al,71h  
    mov ah,al  
    mov cl,4  
    shr ah,cl  
    and al,00001111b  
  
    add ah,30h  
    add al,30h  
  
    mov [di],ah  
    mov [di+1],al  
  
    inc si  
    add di,3  
	pop cx
    loop s  
  


    mov ah,2  
    mov bh,0  
    mov dh,12  
    mov dl,15  
    int 10h  
  
    mov ax,data  
    mov ds,ax  
    mov dx,0  
    mov ah,9  
    int 21h  
  
    mov ax,4c00h  
    int 21h  
  
code ends  
end start 
