;处理 0 号 中断
assume cs:code
code segment
start:
 mov ax,cs
 mov ds,ax
 mov si,offset do0
 mov ax,0
 mov es,ax
 mov di,200h
 
 ;将cs:do0 到 cs:do0end 间的指令 复制到0:200 处
 
 mov cx,offset do0end - offset do0
 cld
 rep movsb
 
 ;将 0 号中断处理程序入口地址设置为0:200
 mov ax,0
 mov es,ax
 mov word ptr es:[0*4],200h
 mov word ptr es:[0*4+2],0
 
 mov ax,4c00h
 int 21h
 
do0:
 jmp short do0Start
 db "divide error!"
 do0Start:
  mov ax,cs
  mov ds,ax
  mov si,202h
  
  mov ax,0b800h
  mov es,ax
  mov di,12*160+36*2
  
  mov cx,13
  l:
   mov al,ds:[si]
   mov es:[di],al
   inc si
   add di,2
   loop l
   
   mov ax,4c00h
   int 21h
  do0end:
   nop
   
code ends
end start
