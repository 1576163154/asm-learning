assume cs:code
data segment
 db 'Welcome to mams','$'
data ends

code segment
 start:
 ;中断设置光标位置
 mov ah,2 ;第二个中断程序
 mov bh,0 ;显存第0页
 mov dh,5 ;第5行
 mov dl,12 ;第12行
 int 10h ;中断号
 
 ;在光标位置显示字符串
 mov ax,data
 mov ds,ax
 
 mov dx,0 ;ds:dx 指向字符串地址起始处
 mov ah,9 ;第9个中断程序
 int 21h
 
 ;程序返回
 mov ah,4ch
 mov al,0
 int 21
 code ends
 end start