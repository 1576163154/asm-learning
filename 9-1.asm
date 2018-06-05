assume cs:code
data segment
data ends
db 01h
dw offset start
code segment
 start:
 mov ax,data
 mov ds,ax
 mov bx,0
 jmp word ptr ds:[bx+1];这里从 ds:[bx+1]处取两个字节，
;那么第一个字节是多少修无所谓了
code ends
end start
    