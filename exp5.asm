;使用多个段
assume cs:code,ds:data,ss:stack
data segment
dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h ;指令开始前 8 个16位真整数
data ends

stack segment
dw 0,0,0,0,0,0,0,0 ;用于作栈
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