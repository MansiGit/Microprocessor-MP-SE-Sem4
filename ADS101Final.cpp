%include "macro.nasm"

section .data
	msg db 10,13,'File contents are: ',10,13
	len equ $-msg
	err db 10,13,'Not a command',10,13
	err_len equ $-err
	msgc db 10,13,'File copied'
	len2 equ $-msgc
	msgd db 10,13,'File deleted',10,13
	len3 equ $-msgd
	er db 10,13,'Cannot open file'
	er_len equ $-er
	
	TYPE db 'TYPE'
	DELETE db 'DELETE'
	COPY db 'COPY'
	
section .bss
filename1 resb 50
filename2 resb 50
buff resb 4096
bufflength equ $-buff
fhandle1 resq 1
fhandle2 resq 1
abufflength resq 1

global _start:
section .text
_start:
	pop rcx
	pop rsi
	pop rsi
	mov rdi,TYPE
	mov cl,04
up:	mov al,[rsi]
	mov bl,[rdi]
	cmp al,bl
	je label1
	mov rdi,DELETE
	mov bl,[rdi]
	mov cl,06
	cmp al,bl
	je label3
	mov rdi,COPY
	mov bl,[rdi]
	mov cl,04
	cmp al,bl
	je label2
	jmp dn
	
label1: mov al,[rsi]
	mov bl,[rdi]
	cmp al,bl
	jne dn
	inc rsi
	inc rdi
	dec cl
	jnz label1
	print msg,len
	
	pop rsi
	mov rdx,[rsi]
	mov [filename1],rdx
	mov byte[filename1+rax],0
	;xor rax,rax
	fopen filename1
	cmp rax,-1h
	je error
	mov [fhandle1],rax
	xor rax,rax
	fread [fhandle1],buff,bufflength
	dec rax
	mov [abufflength],rax
	print buff,abufflength
	fclose [fhandle1]
	jmp dn1
	
label2: mov al,[rsi]
	mov bl,[rdi]
	cmp al,bl
	jne dn
	inc rsi
	inc rdi
	dec cl
	jnz label2
	print msgc,len2
	
	pop rsi
	mov rdx,[rsi]
	mov [filename1],rdx
	mov byte[filename1+rax],0
	pop rsi
	mov rdx,[rsi]
	mov [filename2],rdx
	mov byte[filename2+rax],0
	
	fopen filename1
	cmp rax,-1h
	je error
	mov [fhandle1],rax
	xor rax,rax
	
	fopen filename2
	cmp rax,-1h
	je error
	mov [fhandle2],rax
	xor rax,rax
	fread [fhandle1],buff,bufflength
	dec rax
	mov [abufflength],rax
	
	fwrite [fhandle2],buff,abufflength
	fclose [fhandle1]
	fclose [fhandle2]
	jmp dn1
	
label3: mov al,[rsi]
	mov bl,[rdi]
	cmp al,bl
	jne dn
	inc rsi
	inc rdi
	dec cl
	jnz label3
	;print msgd,len3
	
	pop rsi
	mov rdx,[rsi]
	mov [filename1],rdx
	mov byte[filename1+rax],0
	fopen filename1
	cmp rax,-1h
	mov [fhandle1],rax
	xor rax,rax
	;fread [fhandle1],buff,bufflength
	mov rax,filename1
	syscall
	cmp rax,-1h
	je del
del: 	print msgd,len3
	jmp dn1
error:  print er,er_len
dn:	print err,err_len
dn1:	mov rax,60
	mov rdi,0
	syscall
;------------------------------------------------	
manu@ubuntu:~/MP$ nasm -f elf64 -g -F stabs DOS.nasm
manu@ubuntu:~/MP$ ld -o DOS DOS.o
manu@ubuntu:~/MP$ ./DOS TYPE abc.txt

File contents are: 
"Welcome!!!"
Computer Engineering
Pune Vidyarthi Grihas College of Engineering and Technology,Pune
Mansi Borole

manu@ubuntu:~/MP$ ./DOS COPY abc.txt abx.txt

File copied

manu@ubuntu:~/MP$ ./DOS TYPE abx.txt

File contents are: 
"Welcome!!!"
Computer Engineering
Pune Vidyarthi Grihas College of Engineering and Technology,Pune
Mansi Borole
manu@ubuntu:~/MP$ ./DOS DELETE abc.txt

File deleted
manu@ubuntu:~/MP$ ./DOS TYPE abc.txt

File contents are: 
"Welcome!!!"
Computer Engineering
Pune Vidyarthi Grihas College of Engineering and Technology,Pune
Mansi Borole

