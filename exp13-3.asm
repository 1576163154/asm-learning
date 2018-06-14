assume cs:code
code segment
 s1: db 'Good,better,best,','$'
 s2: db 'Never let it rest,','$'
 s3: db 'Till good is better,','$'
 s4: db 'And better,best.','$'
 s: dw offset s1,offset s2,offset s3,offset s4 ;分别记录其在CS：下的偏移
 row:db 2,4,6,8 ;显示函数
 
 start:
  mov ax,cs
  mov ds,ax
  
  mov bx,offset s ;地址起始偏移
  mov si,offset row;...
  
  mov cx,4 ;循环4次
  
  ;设置光标位置
  ok:mov bh,0
  mov dh,ds:[si]
  mov dl,0
  mov ah,2
  int 10h
  
  mov dx,ds:[bx]
  mov ah,9
  int 21h
  
  ;更新其实地址偏移
  add si,1
  add bx,2
  
  loop ok
  mov ax,4c00h
  int 21h
 code ends
 end start