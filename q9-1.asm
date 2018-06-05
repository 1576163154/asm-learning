assume cs:codesg
codesg segment
 start:
  mov ax,bx ;2字节
  mov si,offset start
  mov di,offset s0
  mov ax,cs:[si]
  mov cs:[di],ax
 s0:
  nop ;nop 预留一字节
  nop
  
codesg ends
end start