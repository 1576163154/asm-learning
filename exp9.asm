assume cs:cseg,ds:data
data segment
    db 'welcome to masm!'
data ends
cseg segment
start:
    mov ax,data
    mov ds,ax
    mov ax,0B800H
    mov es,ax
    mov bx,0f00h
    mov si,0
    mov cx,16
s:mov al,[si]
    mov es:[bx],al
    mov al,02h
    mov es:[bx+1],al
    add bx,2
    inc si
    loop s

    
;系统调用
    mov ax,4c00H
    INT 21H
cseg ends

end start