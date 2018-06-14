;中断程序在屏幕中间显示80个！

;往内存 0:0200出存放中断指令
assume cs:code
code segment 
 start:
  mov ax,cs
  mov ds,ax
  mov si,offset intstart
  
  mov ax,0
  mov es,ax
  mov di,200h
  mov cx,offset intend - offset intstart ;确定指令长度
  cld ;DF 位++1 拷贝
  rep movsb ;单次拷贝一个字节 从ds:si 到 es:di
  
  ;将7c号中断的入口地址修改 0200:0
  mov ax,0
  mov es,ax
  mov word ptr es:[7ch*4],200h
  mov word ptr es:[7ch*4 + 2],0
  
  mov ax,4c00h
  int 21h
  
  
  intstart:
   push bp
   mov bp,sp
   dec cx
   jcxz ok
   add word ptr ss:[bp+2],bx;修改 ip
   ok:
    pop bp
	iret
  
  intend:nop
  
  code ends
  end start 




























;测试中断程序
assume cs:code
code segment
start:
 mov ax,0b800h
 mov es,ax
 
 mov di,160*12
 mov bx,offset l - offset lend ;单次中断后 ip 的偏移距离
 mov cx,80
 
 l:
  mov byte ptr es:[di],'!' ;往显存直接传入 '!'
  add di,2 
  int 7ch ;调用中断修改 ip 实现循环
  
 lend:nop
 
 mov ax,4c00h
 int 21h
 
 code ends
 end start