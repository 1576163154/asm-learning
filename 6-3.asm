;利用栈来反向存储一组数据
assume cs:codesg
codesg segment
dw 0123h,0456h,0789,0abch,0defh,0fedh,0cbah,0987h ;指令开始前 8 个16位真整数
dw 0,0,0,0,0,0,0,0 ;用于作栈

start:
mov ax,cs
mov ss,ax ;设置 段栈 指针
mov sp,20h ;设置栈顶 指针

mov bx,0 ;循环索引
mov cx,8 ;循环次数

;入栈
l1:
push cs:[bx]
add bx,2
loop l1

mov bx,0
mov cx,8

;出栈
l2:
pop cs:[bx]
add bx,2
loop l2

mov ax,4c00h
int 21h

codesg ends
end start