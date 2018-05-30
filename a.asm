assume cs:aa
aa segment 

mov ax,2h
add ax,ax
add ax,ax

mov ax,4c00h
int 21h
aa ends
end