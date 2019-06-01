%macro input 2 
	mov rax,0 
	mov rdi,0 
	mov rsi,%1 
	mov rdx,%2 
	syscall 
%endm 
%macro exit 0 
        mov rax,60 
        mov rdi,0 
	syscall 
%endm 
%macro output 2 
	mov rax,1 
	mov rdi,1 
	mov rsi,%1 
	mov rdx,%2 
	syscall 
%endm 

section .bss	 
	 
section .data 
	 
	 msg db 0ah,'Mean = ' 
	 msg_len equ $-msg 
	 msg2 db 0ah,'Variance = ' 
	 msg2_len equ $-msg2 
	 msg3 db 0ah,'Standard Deviation = ' 
	 msg3_len equ $-msg3 
        arr dw 2,5,8 
        arr_len dw 3 
        a dw 100   
	mean dt 0.0 
	final dt 0.0 
global _start 
section .text 
_start: 
	mov rcx,0 
	mov cx,word[arr_len] 
	fldz 
	mov rsi,arr 
       up:	fiadd word[rsi]   
   	       add rsi,2 
	       loop up 
	fidiv word[arr_len] 
	fimul word[a] 
	fbstp [mean] 
	call conv 
	output msg,msg_len 
	output final,9 
	 

	mov rcx,0 
	mov cx,word[arr_len] 
	fldz 
	mov rsi,arr 
	up2: 	fbld [mean] 
		fidiv word[a] 
		fisub word[rsi] 
		fmul st0,st0 
		fadd st0,st1 
		add rsi,2 
		loop up2 
	fidiv word[arr_len]	 
	fimul word[a] 
	fbstp [mean] 
	call conv 
	output msg2,msg2_len 
	output final,9 
	fbld [mean] 
	fsqrt 
	fbstp [mean] 
	call conv 
	output msg3,msg3_len 
	output final,9 
	exit   
	        
conv :	 
	mov rsi,mean 
	add rsi,3 
	mov rcx,4 
	mov rdi,final 
	mov rdx,2	 
up1: 	rol byte[rsi],4 
 	mov rax,[rsi] 
	and rax,0fh 
	add rax,30h 
	cmp rax,39h 
	jbe e 
	add rax,7h 
	e:  mov [rdi],rax 
	    inc rdi 
	    dec rdx 
	    jnz up1 
	mov rdx,2 
	cmp rcx,2 
	jne down 
	mov byte[rdi],'.' 
	inc rdi    	 
	down:dec rsi 
	loop up1 
	ret 
	-----------------------------------------------------
manu@ubuntu:~/MP$ nasm -felf64 A11.nasm
manu@ubuntu:~/MP$ ld -o A11 A11.o
manu@ubuntu:~/MP$ ./A11

Mean = 000005.00
Variance = 000006.00
Standard Deviation = 000000.24
