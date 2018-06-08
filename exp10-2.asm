;计算 1000000/10 F4240h/A
;解决除法溢出问题

assume cs:code
data segment
dw 0 ;用于存放0000000f/0a 的商
data ends

code segment
start:
 mov ax,data
 mov ds,ax
 

 mov ax,4240h ;被除数低16位
 mov dx,000fh ;被除数高16位
 mov cx,0ah   ;除数
 
 call divdw
 
 mov ax,4c00h
 int 21h
 
 divdw:
  mov bx,ax ;暂存 4240h
  ;计算 0000000fh / 0a
  mov ax,dx
  mov dx,0
  div cx
  ;ax 存商，dx 存余
  mov data:[0],ax ;
  
  ;计算 (00004240h + dx * 65536) / 0ah
  mov ax,bx
  div cx
  
  mov cx,dx ;最终余数存于 cx
  mov dx,data:[0];商的高16位
  ;ax 此时存的是商的低16位
  
  
    
code ends
end start