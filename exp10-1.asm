;在屏幕上显示特定样式的字符串
assume cs:code
data segment
 db 'Welcome to masm!',0;以‘0’结尾便于判断
data ends

code segment 
start:
 mov ax,data
 mov ds,ax


 mov dh,8 ;第8行
 mov dl,3 ;第3列
 mov cl,2 ;绿色 0000 0010b

 mov si,0
 

 
 call show_str
 
 mov ax,4c00h
 int 21h
 
 
 ;dos 默认显示第一页，而第一页其实地址为 B800:0 
 ;每行占 160个字节
 ;那么要显示的起始地址可以算出
 ;起始地址 = B8000h + (行数 -1)*160 + (列数 - 1)*2
 show_str:
   mov ax,0b800H
   mov es,ax
   
   ;计算偏移地址，不在计算起始地址
   ;用bx保存偏移
   mov ah,0
   mov al,160
   dec dh
   mul dh   ;计算 (行数 -1)*160 
   mov bx,ax
   
   mov ah,0
   mov al,2
   dec dl
   mul dl
   add bx,ax
   ;取得样式暂存
   mov dl,cl
   
   ;从es:[bx]处取数据,放于cx中
   l:
    mov cl,ds:[si]
	mov ch,0
    jcxz ok ;若是 ‘0’ 这返回
	mov es:[bx],cl ;将字符 移动到es:bx 处
	;开始修改样式，这里只是简单改为绿色
	mov es:[bx+1],dl
	add bx,2
	add si,1
	jmp short l
  
  
 
 ok:
  ret

  
code ends
end start
