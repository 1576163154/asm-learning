;将字符串
assume ds:data,cs:code,ss:stack
stack segment
dw 0,0,0,0,0,0,0,0
stack ends

data segment 
 db '1. display      '
 db '2. brows        '
 db '3. replace      '
 db '4. modify       '
data ends

code segment
 start:
  mov ax,data
  mov ds,ax
  
  mov ax,stack
  mov ss,ax
  mov sp,16
  
  mov bx,0
  mov cx,4
  
  l1:
  push cx
  mov si,3
  mov cx,4 ;4列
  
  l2:
  mov al,[bx+si]
  and al,11011111B
  mov [bx+si],al
  inc si
  loop l2
  
  add bx,16 ;变更为下一行
  pop cx
  
  loop l1
  
 
  

 
  
  mov ax,4c00h
  int 21h
  
 code ends
 end start