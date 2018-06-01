;将字符串
assume ds:data,cs:code
data segment 
 db 'welcome to masm!'
 db '................'
data ends

code segment
 start:
  mov ax,data
  mov ds,ax
  
  mov bx,0
  mov cx,16 ;循环次数
  l1:
     mov al,ds:[bx]
	 
	 mov ds:[bx+16],al
	 inc bx
  loop l1
  

 
  
  mov ax,4c00h
  int 21h
  
 code ends
 end start