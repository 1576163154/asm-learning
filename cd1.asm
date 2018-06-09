;课程设计一
;在之前 实验7 的基础上，再将那些存好的数据显示出来


assume cs:code

data segment
db '1975','1976','1977','1978'
db '1979','1980','1981','1982'
db '1983','1984','1985','1986'
db '1987','1988','1989','1990'
db '1991','1992','1993','1994'
db '1995'

dd 16,22,382
dd 1356,2390,8000,16000
dd 24486,50065,97479,140417
dd 197514,345980,590827,803530
dd 1183000,1843000,2759000,3753000
dd 4649000,5937000

dw 3,7,9,13
dw 28,38,130,220,476,778,1001,1442
dw 2258,2793,4037,5635,8226,11542,14430,15257
dw 17800

data ends

table segment
db 21 dup ('year summ ne ?? ')
db '5937000 ' ;用于暂存，临时转换的字符串 偏移地址位 21*16 = 
table ends



;ss 用于存放局部变量
;之后用于记录外层循环cx，实现双层循环
stack segment
dw 0,0,0 ;用于记录年份，收入，员工数量偏移
dw 0,0 ;外层循环,内层循环(弃用）
dw 0,0 ;es段行数偏移，ds段行数偏移
dw 0,0,0;除法结果，商低16位，商高16位，余数

dw 0,0,0,0,0,0,0  ;末尾7个用于存储除法余数
dw 0,0 ;call dtoc ip以及 call divdw ip
stack ends

code segment
start:


mov ax,data
mov ds,ax

mov ax,table
mov es,ax

mov ax,stack
mov ss,ax
mov sp,38

mov cx,21 ;循环21次
mov bx,0

;mov ss:[0],ax
;mov ss:[2],ax
;mov ss:[4],ax

l1:
;添加 年份
mov si,ss:[0]
mov ax,ds:[si];先取前两个字节
mov es:[bx],ax

mov ax,ds:[si+2];再取后两个字节
mov es:[bx+2],ax

add word ptr ss:[0],4

;添加收入,加上偏移44h
mov si,ss:[2]
mov ax,ds:[54h+si];先取前两个字节(低16位
mov es:[5+bx],ax

mov ax,ds:[54h+si+2];再取后两个字节(高16位
mov es:[5+bx+2],ax

add word ptr ss:[2],4

;添加员工数量
mov si,ss:[4]
mov ax,ds:[0A8h+si];只需取两个字节
mov es:[10+bx],ax

add word ptr ss:[4],2

;计算平均收入，并添加
;被除数32位，除数16位
 ;小端法，地位在前
 mov dx,es:[5+bx+2] ;被除数的高16位存于 dx
 mov ax,es:[5+bx] ;被除数的低16位存入 ax
 ;进行除法运算
 div word ptr es:[10+bx]
 

 
 mov es:[13+bx],ax ;将商放入第三个数据内存单元（商也就是平均收入
  
 



add bx,16 ;改变行数
loop l1

;清空stack segment内容
mov ax,0
mov ss:[0],ax
mov ss:[2],ax
mov ss:[4],ax

;分为两步
;①转换为便于显示的十进制字符串形式
;②写入显存


mov ax,0b800H
mov ds,ax

mov cx,21
mov ss:[6],cx ;外层循环次数

mov ss:[10],0 ;es 段 行数偏移
mov ss:[12],0 ;ds 段 行数偏移

;两层循环 外层21次,内层4次
l2:
 mov ss:[6],cx ;暂存外层cx

  ;年份直接写入显存，依次取收入，员工数，平均收入进行处理
  mov ax,ss:[12]
  mov bx,ss:[10]
  ;设定行数，列数
  mov dh,al ;第 行
  mov dl,1 ;第1列
  mov ch,0
  mov cl,2 ;绿色 0000 0010b
  mov si,bx ;字符偏移
  
  call show_str_modify
  mov bx,ss:[10]
  ;————————————————————————处理收入
  mov ax,es:[5+bx] ;低16位
  mov dx,es:[5+bx+2] ;高16位
  mov di,10 ;除数
  
  mov si,bx ;字符偏移
  add si,5
 
  call dtoc ;先转换为字符串
  mov bx,ss:[10]
  mov ax,ss:[12]
  
   ;设定行数，列数
  mov dh,al ;第 行
  mov dl,7 ;第7列
  mov ch,0
  mov cl,2 ;绿色 0000 0010b
  
  mov si,bx ;字符偏移
  add si,5
  call show_str
  mov bx,ss:[10]
  ;————————————————————————————处理员工数
  mov ax,es:[10+bx] ;低16位
  mov dx,0
  mov di,10 ;除数

  mov si,bx ;字符偏移
  add si,10
  
  call dtoc
  mov bx,ss:[10]
  mov ax,ss:[12]
   ;设定行数，列数
  mov dh,al ;第 行
  mov dl,16 ;第16列
  mov ch,0
  mov cl,2 ;绿色 0000 0010b
  
  mov si,bx ;字符偏移
  add si,10
  call show_str
  mov bx,ss:[10]
  ;————————————————————————————处理平均收入
  mov ax,es:[13+bx] ;低16位
  mov dx,0
  mov di,10 ;除数
  
  mov si,bx ;字符偏移
  add si,13
  call dtoc
  mov bx,ss:[10]
  mov ax,ss:[12]
   ;设定行数，列数
  mov dh,al ;第 行
  mov dl,23 ;第23列
  mov ch,0
  mov cl,2 ;绿色 0000 0010b
  
  mov si,bx ;字符偏移
  add si,13

  
  call show_str
  
  mov cx,ss:[6]
  add word ptr ss:[10],16 ;转到下一行
  add word ptr ss:[12],1
 loop l2

 mov ax,4c00h
 int 21h
 
  divdw:
  mov bx,ax ;暂存 4240h
  ;计算 0000000fh / 0a
  mov ax,dx
  mov dx,0
  div di
  
  mov ss:[16],ax ;存入商的高16位
  
  ;计算 (00004240h + dx * 65536) / 0ah
  mov ax,bx
  div di
  
  mov ss:[18],dx ;存入余数
  mov ss:[14],ax ;存入商的低16位
  ret
 
 
 
  ;dos 默认显示第一页，而第一页其实地址为 B800:0 
 ;每行占 160个字节
 ;那么要显示的起始地址可以算出
 ;起始地址 = B8000h + (行数 -1)*160 + (列数 - 1)*2
 show_str:
   
   
   ;计算偏移地址，不在计算起始地址
   ;用bx保存偏移
   mov ah,0
   mov al,160
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
   mov si,336
   l4:
    
    mov cl,es:[si]
	mov ch,0
	mov al,cl
	sub cx,20h ;便于区分 130 这里修改为 空格结尾
    jcxz ok ;若是 ‘0’ 这返回
	mov ds:[bx],al ;将字符 移动到ds:bx 处
	;开始修改样式，这里只是简单改为绿色
	mov ds:[bx+1],dl
	add bx,2
	add si,1
	jmp short l4
  
  
 
 ok:
  ret
  
  
   dtoc:
 
  mov si,336
  l5:
  
  
  call divdw ;进行不会溢出的除法求余数
  
 
  mov ax,ss:[18]
  push ax ;将余数压入栈中,单次push需两字节
  
  ;检验商是否为0
  mov ax,ss:[14]
  mov bx,ss:[16]
  
  ;先看高16位，若为0 继续看低16位
  add ax,bx
  mov cx,ax
  
  jcxz l6
  ;更新被除数和除数继续进行除法运算
   mov ax,ss:[14] ;低16位
   mov dx,ss:[16] ;高16位
   mov di,10 ;除数
  
  
  jmp l5
  
  ;从栈中依次弹出6 5 5 3 5 将其加上 30h 转为相应的'6' '5' ...
  ;并转移到 data segment
  l6:
   
   pop ax ;弹出也相应修改为弹出两个字节
   
  
   add al,30h ;转为 ' ' 形式
   
   
   
   ;填充 data segment
   mov es:[si],al
   inc si
   
   mov cx,sp ;获取当前栈顶指针
   sub cx,36
   jcxz l7
   
   
   jmp l6
 
  l7:
  ;最后再往ds 字符最后添加 空格
  mov al,20h
  
  mov es:[si],al
  
  ret
;只用于显示年份的 过程
show_str_modify:
  ;计算偏移地址，不在计算起始地址
   ;用bx保存偏移
   mov ah,0
   mov al,160
   
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
   mov cx,4
   l8:
    mov al,es:[si]
	
	
    
	mov ds:[bx],al ;将字符 移动到ds:bx 处
	;开始修改样式，这里只是简单改为绿色
	mov ds:[bx+1],dl
	add bx,2
	add si,1
	loop l8
	ret
  
  
 



code ends
end start