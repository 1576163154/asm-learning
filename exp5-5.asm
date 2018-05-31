;使用多个段
assume cs:code
a segment 
 db 1,2,3,4,5,6,7,8
a ends

b segment 
 db 1,2,3,4,5,6,7,8
b ends

c segment 
 db 0,0,0,0,0,0,0,0
c ends

code segment
start:

;任意用3个段来存储这三段数据，只是为了便于取
mov ax,c
mov ss,ax
mov sp,8

mov ax,a
mov ds,ax

mov ax,b
mov es,ax

mov bx,0
mov cx,8

l1:
mov dl,ds:[bx]
add dl,es:[bx]
mov ss:[bx],dl
inc bx
loop l1

mov ax,b
mov ds,ax


mov ax,4c00h
int 21h

code ends


end start