;从端口获取 当前月份数 并显示
assume cs:code
code segment 
start:
 mov al,8 ;月份位于 8 单元处
 out 70h,al ;位置70h端口，8单元处
 in al,71h ;读入
 mov ah,al
 mov cl,4
 
 shr ah,cl ;月份十位
 and al,00001111b ;月份个位
 
 ;转为字符
 add ah,30h
 add al,30h
 
 mov bx,0b800h
 mov es,bx
 
 mov bx,160*12+40*2
 mov byte ptr es:[bx],ah ;往显存写入月份十位数
 mov byte ptr es:[bx+2],ah ;往显存写入月份个位数
 
 mov ax,4c00h
 int 21h
 
code ends
end start
 