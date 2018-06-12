;DF和串传送指令的应用

assume cs:code
data segment
db 'Welcome to masm!'
db 16 dup(0)
data ends
;将‘ ’字符串复制到后面16个字节中
code segment
start:
 mov ax,data
 mov ds,ax
 mov si,0;起始偏移
 
 mov es,ax
 mov di,16;起始偏移
 mov cx,16 ;次数
 cld ;将DF 置为0 表明si ，di 每次移动1个字节 si++ ,di++
 rep movsb ;重复16次，单次复制一个字节
 
 
mov ax,4c00h
int 21h
code ends
end start