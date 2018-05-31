;使用多个段
assume cs:code
a segment 
 dw 1,2,3,4,5,6,7,8
a ends


b segment 
 dw 0,0,0,0,0,0,0,0
b ends

code segment
start:

;设置栈段
mov ax,b
mov ss,ax
mov sp,10h

mov ax,a
mov ds,ax

mov bx,0
mov cx,8
;第一个循环先将一部分数据放入
l1:
push ds[bx]
add bx,2
loop l1




mov ax,4c00h
int 21h

code ends


end start