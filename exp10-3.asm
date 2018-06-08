;将二进制数据转为字符串数据在屏幕显示
;65536 to '655360'
assume cs:code
data segment
 db '000000',0;以‘0’结尾便于判断
data ends

stack segment 
dw 0,0,0,0,0,0;用于存放余数,;末尾会被用来存放 ip
stack ends
code segment 
start:
 mov ax,data
 mov ds,ax

 mov ax,stack
 mov sp,12

 

 mov si,0
 
 ;将65536进行转换
 mov ax,65535
 call dtoc
 
 ;在这里赋值，之前的调用会修改一些寄存器
 mov dh,8 ;第8行
 mov dl,3 ;第3列
 mov ch,0
 mov cl,2 ;绿色 0000 0010b
 mov si,0
 call show_str
 
 mov ax,4c00h
 int 21h
 
 dtoc:
  ;65536 在16/8下 会溢出
  ;进行被除数32位，除数16位的除法
  
  l2:
  mov dx,0
  mov bx,10
  div bx
  mov cx,ax 
  
  
  
  push dx ;将余数压入栈中,单次push需两字节
  jcxz l3
  
  jmp l2
  
  ;从栈中依次弹出6 5 5 3 5 将其加上 30h 转为相应的'6' '5' ...
  ;并转移到 data segment
  l3:
   
   pop ax ;弹出也相应修改为弹出两个字节
   
  
   add al,30h ;转为 ' ' 形式
   
   
   
   ;填充 data segment
   mov ds:[si],al
   inc si
   
   mov cx,sp ;获取当前栈顶指针
   sub cx,10
   jcxz l4
   
   
   jmp l3
 
  l4:
  ;最后再往ds 字符最后添加 '0'
  mov al,30h
  
  mov ds:[si],al
  
  ret
 
 
 
 
 

 
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
   l1:
    mov cl,ds:[si]
	mov ch,0
	mov al,cl
	sub cx,30h
    jcxz ok ;若是 ‘0’ 这返回
	mov es:[bx],al ;将字符 移动到es:bx 处
	;开始修改样式，这里只是简单改为绿色
	mov es:[bx+1],dl
	add bx,2
	add si,1
	jmp short l1
  
  
 
 ok:
  ret

  
code ends
end start