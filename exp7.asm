;汇编语言--王爽 实验7
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
table ends

;用于记录年份，收入，员工数量偏移
stack segment
dw 0,0,0
stack ends

code segment
start:


mov ax,data
mov ds,ax

mov ax,table
mov es,ax

mov ax,stack
mov ss,ax

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


mov ax,4c00h
int 21h

code ends
end start