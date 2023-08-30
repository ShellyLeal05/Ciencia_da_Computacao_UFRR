section .data
    msg1 db "Digite o primeiro número: ", 0
    msg2 db "Digite o segundo número: ", 0
    msg3 db "Resultado: ", 0
    num1 dq 0
    num2 dq 0
    resultado dq 0

section .text
    global _start

    ; Função para imprimir uma string
    print_string:
        mov rax, 1                  ; syscall write
        mov rdi, 1                  ; file descriptor (stdout)
        mov rdx, rbx                ; comprimento da string
        syscall
        ret

    ; Função para ler um número
    read_number:
        mov rax, 0                  ; syscall read
        mov rdi, 0                  ; file descriptor (stdin)
        mov rsi, rbx                ; buffer para armazenar a entrada
        mov rdx, 20                 ; tamanho máximo da entrada
        syscall
        ret

_start:
    ; Exibe a mensagem para digitar o primeiro número
    mov rbx, msg1
    call print_string

    ; Lê o primeiro número
    mov rbx, num1
    call read_number

    ; Exibe a mensagem para digitar o segundo número
    mov rbx, msg2
    call print_string

    ; Lê o segundo número
    mov rbx, num2
    call read_number
    
    ; Soma os números
    mov rax, [num1]
    mov rbx, [num2]
    add rax, rbx
    mov [resultado], rax

    ; Exibe o resultado
    mov rbx, msg3
    call print_string
    mov rax, [resultado]
    call print_number

    ; Termina o programa
    mov rax, 60         ; syscall exit
    xor rdi, rdi        ; status de saída
    syscall

    ; Função para imprimir um número
    print_number:
        mov rsi, rsp                ; Use RSI como ponteiro para o buffer
        mov rcx, 0                  ; Contador de dígitos
    reverse_loop:
        rol rax, 4                  ; Shift right by 4 bits
        mov al, ah                  ; Pega os 4 bits menos significativos
        and al, 0xF                 ; Mascara para obter um dígito
        add al, '0'                 ; Converte para o caractere ASCII
        mov [rsi], al               ; Armazena o caractere no buffer
        inc rsi                     ; Move o ponteiro do buffer
        inc rcx                     ; Incrementa o contador de dígitos
        test rax, rax               ; Verifica se todos os dígitos foram processados
        jnz reverse_loop            ; Repete se ainda houver dígitos
        mov [rsi], byte 0           ; Termina a string
        dec rsi                     ; Aponta para o último caractere
        ; Inverte a string no buffer
        mov rdi, rsp                ; Ponteiro para o início da string
        add rdi, rcx                ; Ponteiro para o último caractere
    reverse_copy_loop:
        mov al, [rdi]               ; Carrega o caractere reverso
        mov [rsi], al               ; Copia para a posição correta
        dec rdi                     ; Move para o caractere anterior
        inc rsi                     ; Move para a próxima posição
        test al, al                 ; Verifica o final da string reversa
        jnz reverse_copy_loop       ; Repete se ainda não for o final
        ret
