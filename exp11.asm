assume cs:codesg
data segment
 db "Beginner's All-purpose symbolic instruction Code.",0
data ends

codesg segment
start:
 mov ax,data
 mov ds,ax
 mov si,0
 
 mov bh,0
 call letterc
 
 mov ax,4c00h
 int 21h
 
 
 letterc:
  mov bl,ds:[si]
  cmp bl,30h ;若为 ‘0’那么结束转换
  je ok
  
  cmp bl,97
  jb next
  cmp bl,122
   ja next
   
  sub byte ptr ds:[si],32 
   
 next: 
  inc si 
  jmp letterc
  
 ok:
  ret
codesg ends
end start