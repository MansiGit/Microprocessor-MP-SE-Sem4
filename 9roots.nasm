%macro display 1 
mov rdi,formatpf	;address of format string 
sub rsp,8 
movsd xmm0,[%1]	  ;floating point number in print formatformatpf 
mov rax,1              ;number of floating point numbers =1 
call printf 
add rsp,8  ;restore stack 
%endmacro 

extern printf 

section .data 

	
	msg2 db 'The roots of the equation are :',10,0 
	formatpf db "%lf",10,0 
	a dq 1.0 
	b dq 3.0 
	c dq 1.0 
	d dq 1.0 
	c1 dq 4.0 
	c2 dq 2.0 
	c3 dq 100.0 
section .bss 
	root1 rest 1 
	root2 rest 1 
	x1 resw 1 
	x2 resw 1 
	temp resq 1 
	sign resb 1 
	dpoint resb 2 
%macro ext 0 
	mov rax,60, 
	mov rdi,0 
	syscall 
%endm 
%macro input 2 
	mov rax,0 
	mov rdi,0 
	mov rsi,%1 
	mov rdx,%2 
	syscall 
	%endm 
%macro output 2 
	mov rax,1 
	mov rdi,1 
	mov rsi,%1 
	mov rdx,%2 
	syscall 
%endm 
global main 
section .text 
main: 
	finit 

;calculation of b^2-4ac 

	fldz 
	fld qword[b] 
	fmul st0,st0 
	fld qword[a] 
	fmul qword[c] 
	fmul qword[c1] 
	fsub st1,st0 
	fstp qword[temp] 
	fst qword[d] 
	bt qword[d],63 
	jc e 
	fsqrt 
		fst qword[d] 

;calculation of 1st root 

	fsub qword[b] 
	fdiv qword[a] 
	fdiv qword[c2] 
	fstp qword[x1] 
        call disp 
	display x1 


;2nd root 
	fldz 
	fsub qword[b] 
	fsub qword[d]	 
	fdiv qword[c2] 
	fdiv qword[a] 
	fstp qword[x1] 
	display x1 

	 
	e:ext 




disp:	 

push rbp 
mov rdi,msg2	 
mov rax,0 
call printf 
pop rbp 
ret 

------------------------------------------------
manu@ubuntu:~/mpfinals$ nasm -f elf64 -g -F stabs roots.nasm 
manu@ubuntu:~/mpfinals$ g++ -o roots roots.o 
manu@ubuntu:~/mpfinals$ ./roots 
The roots of the equation are : 
-0.381966 
-2.618034 
