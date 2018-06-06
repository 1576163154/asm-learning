assume cs:codesg
codesg segment
 mov ax,4c00h
 int 21h
 start:
 mov ax,0
  s:
   nop
   nop
   mov di,offset s
   mov si,offset s2
   mov ax,cs:[si]
   mov cs:[di],ax
  s0: 
   jmp short s;机器码EBF0 即将当前ip 向之前偏移 10 字节 到达 s:处
  s1:
   mov ax,0
   int 21h
   mov ax,0
  s2:
   jmp short s1;机器码EBF6 即将当前ip 向之前偏移 10 字节 到达 cs开头 mov ax 4c00h处
   nop
codesg ends
end start
 