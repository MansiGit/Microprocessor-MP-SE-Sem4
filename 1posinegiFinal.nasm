%macro inout 4
  mov rax,%1
  mov rdi,%2
  mov rsi,%3
  mov rdx,%4
  syscall
%endm

%macro exit 0
  mov rax,60
  mov rdi,0
  syscall
%endm

global _start
  
section .data
  
  msg db 0Dh,0Ah,'No. of positive numbers : '
  len equ $-msg
  msg1 db 0Dh,0Ah,'No of negative numbers : '
  len1 equ $-msg1
  msgnull db 0Dh,0Ah,''
  len3 equ $-msgnull
  len2 equ 1
  msgdis db 'The array contents are :'
  lendis equ $-msgdis
  arr dq 7231231212312312h,05231231212312312h,0A231231212312312h,7231231212312312h,05231231212312312h,0A231231212312312h,7231231212312312h,05231231212312312h,0A231231212312312h,0A231231212312312h
  
section .bss
 temp resb 1
 num_cnt resb 1
 ncnt resb 1
 pcnt resb 1
 numbyte resb 1
 incr_cnt resb 1 
 c resb 1

section .text

_start:


 mov byte[ncnt],00h
 mov byte[pcnt],00h
 
 mov rcx,rbx
 call display_array
 mov rbx,rcx


 mov rsi,arr
 mov cl,0Ah
up:
 mov rax,[rsi]
 bt rax,63
 jc neg
 inc byte[pcnt]
 jmp next
neg:
 inc byte[ncnt]

next:
 add rsi,8
 dec cl
 jnz up

cmp byte[pcnt],0Ah
jb less_than_9
add byte[pcnt],07

less_than_9:
add byte[pcnt],30h


cmp byte[ncnt],0Ah
jb less_than_9_negcnt
add byte[ncnt],07

less_than_9_negcnt:
add byte[ncnt],30h

inout 1,1,msg,len
inout 1,1,pcnt,1
inout 1,1,msg1,len1
inout 1,1,ncnt,1
inout 1,1,msgnull,len3

exit

display_array:
  inout 1,1,msgdis,lendis 
  inout 1,1,msgnull,len3
  mov byte[num_cnt],0Ah
  mov rsi,arr
  add rsi,4Fh
 next_num: 
  mov byte[incr_cnt],08h
 
 same_num:
  mov byte[c],02h
  mov al,byte[rsi]
  mov byte[temp],al
  
  nibsep:
   cmp byte[c],01h
   je norotate
   rol al,04
  norotate:
   and al,0Fh
   cmp al,0Ah
  jb dn
    
   add al,07h
   
  dn:
  
  add al,30h
  mov byte[numbyte],al
  mov rbx,rsi
  inout 1,1,numbyte,1
  mov rsi,rbx
  mov al,byte[temp]
  dec byte[c]
  jnz nibsep
 
  dec rsi                                            ;goto next byte
  dec byte[incr_cnt]
  jnz same_num
  
  mov rbx,rsi
  inout 1,1,msgnull,len3
  mov rsi,rbx
  dec byte[num_cnt]
  jnz next_num
  
  ret
