;用中断程序显示用 '0' 结束的字符串

;第一步 安装中段程序
;将中断程序指令，放于0:0200 起始处
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

  ;中断程序，从ds:si 起始处一次显示字符串，直至 遇到0
 intstart:
   push si
   push cx
   push dx 
 
  ;计算偏移地址，不在计算起始地址
   ;用bx保存偏移
   mov ah,0
   mov al,160
   mul dh   ;计算 (行数 -1)*160 
   mov bx,ax
   
   mov ah,0
   mov al,2
   dec dl
   mul dl
   add bx,ax
   ;取得样式暂存
   mov dl,cl
   
   mov ax,0b800h
   mov es,ax
   ;从es:[bx]处取数据,放于cx中
   
   l4:
    
    mov cl,ds:[si]
	mov ch,0
	mov al,cl
	
    jcxz ok ;若是 0 这返回
	mov es:[bx],al ;将字符 移动到ds:bx 处
	;开始修改样式，这里只是简单改为绿色
	mov es:[bx+1],dl
	add bx,2
	add si,1
	jmp short l4
  
  
 
 ok:
  pop dx
  pop cx
  pop si
  iret
 intend:nop
 code ends
 end start






;第二部 测试中断程序
assume cs:code
data segment
 db "Welcome to masm!",0
data ends

code segment
 start:
  mov dh,10
  mov dl,10
  mov cl,2
  
  mov ax,data
  mov ds,ax
  mov si,0
  
  int 7ch ;调用中断程序
  
  mov ax,4c00h
  int 21h
 code ends
 end start