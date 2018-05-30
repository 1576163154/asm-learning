assume cs:code
code segment
mov ax,[0]
mov ax,ds:[0]
 
mov ax,4c00h
  int 21h
  code ends
  end