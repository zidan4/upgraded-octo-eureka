
section .data
    prompt db "Enter amount in USD: ", 0
    usd_to_eur dq 0.85   ; Exchange rate (USD to EUR)
    usd_to_gbp dq 0.75   ; Exchange rate (USD to GBP)
    newline db 10, 0
    eur_label db "EUR: ", 0
    gbp_label db "GBP: ", 0
    buffer db "00000", 0  ; Buffer for output conversion

section .bss
    amount resq 1  ; User input amount (8 bytes)

section .text
    global _start
    extern printf, scanf

_start:
    ; Print prompt
    mov rdi, prompt
    call print_string

    ; Read user input
    mov rsi, amount
    mov rdi, scanf_format
    call scanf

    ; Convert USD to EUR
    fld qword [amount]     ; Load amount into FPU stack
    fmul qword [usd_to_eur] ; Multiply by EUR exchange rate
    call print_result       ; Print result as EUR

    ; Convert USD to GBP
    fld qword [amount]     ; Load amount again
    fmul qword [usd_to_gbp] ; Multiply by GBP exchange rate
    call print_result       ; Print result as GBP

    ; Exit program
    mov rax, 60   ; syscall: exit
    xor rdi, rdi  ; status: 0
    syscall

print_result:
    call float_to_string   ; Convert floating-point to string
    call print_string      ; Print converted value
    call print_newline
    ret

print_string:
    mov rsi, rdi          ; Load string into RSI
    mov rdx, 100          ; Assume max length 100
    mov rax, 1            ; syscall: write
    mov rdi, 1            ; stdout
    syscall
    ret

print_newline:
    mov rdi, newline
    call print_string
    ret

scanf_format:
    db "%lf", 0
