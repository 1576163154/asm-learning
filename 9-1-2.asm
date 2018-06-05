assume cs:code
data segment
 dd 12345678H
data ends

code segment
 start:
 mov ax,data
 mov ds,ax
 mov bx,0
 mov ax,offset start 
 mov [bx],ax
 mov [bx+2],cs
 jmp dword ptr ds:[0];从ds:0处取4个字节，
;前2个作为ip
;后两个作为 cs
code ends
end start
