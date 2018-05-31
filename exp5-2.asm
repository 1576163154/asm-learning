;使用多个段
assume cs:code,ds:data,ss:stack
data segment
dw 0123h,0456h
data ends

stack segment
dw 1,1;初始化为 1 便于在查看内存分布
stack ends

code segment
start:
mov ax,stack
mov ss,ax ;设置 段栈 指针
mov sp,10h ;设置栈顶 指针偏移

mov ax,data
mov ds,ax

push ds:[0]
push ds:[2]

pop ds:[2]
pop ds:[0]

mov ax,4c00h
int 21h

code ends
end start