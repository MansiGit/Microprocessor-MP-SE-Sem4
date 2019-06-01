%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endm

%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endm

%macro fopen 1
mov rax,2
mov rdi,%1
mov rsi,2
mov rdx,666
syscall
%endm

%macro fclose 1
mov rax,3
mov rdi,%1
syscall
%endm

%macro fread 3
mov rax,0
mov rdi,%1
mov rsi,%2
mov rdx,%3
syscall
%endm

%macro fwrite 3
mov rax,1
mov rdi,%1
mov rsi,%2
mov rdx,%3
syscall
%endm
