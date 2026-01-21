.386
.model flat, stdcall
.stack 4096
include Irvine32.inc

.data
accounts    dw 1234, 2345, 3456
pins        dw 1111, 2222, 3333
balances    dw 1000, 2000, 1500

welcomeMsg  byte "Welcome to ATM Simulator!", 0Dh,0Ah,0
menuMsg     byte "1. Check Balance",0Dh,0Ah,
                 "2. Deposit",0Dh,0Ah,
                 "3. Withdraw",0Dh,0Ah,
                 "4. Logout",0Dh,0Ah,
                 "5. Exit",0Dh,0Ah,0

enterAcc    byte "Enter Account Number: ",0
enterPIN    byte "Enter PIN: ",0
invalidMsg  byte "Invalid Account or PIN!",0Dh,0Ah,0
balanceMsg  byte "Your balance is: ",0
depositMsg  byte "Enter amount to deposit: ",0
withdrawMsg byte "Enter amount to withdraw: ",0
successMsg  byte "Transaction successful!",0Dh,0Ah,0
insufficient byte "Insufficient balance!",0Dh,0Ah,0
newline     byte 0Dh,0Ah,0

.code
main PROC
LoginLoop:
    call cls
    call Welcome

    call Login
    cmp ax, -1
    je LoginLoop

    mov bx, ax     

MenuLoop:
    call ShowMenu
    call ReadInt

    cmp eax, 1
    je CheckBalance
    cmp eax, 2
    je Deposit
    cmp eax, 3
    je Withdraw
    cmp eax, 4
    je Logout
    cmp eax, 5
    je ExitATM
    jmp MenuLoop


Welcome PROC
    mov edx, OFFSET welcomeMsg
    call WriteString
    call Crlf
    ret
Welcome ENDP

Login PROC
    mov edx, OFFSET enterAcc
    call WriteString
    call ReadInt
    mov si, eax

    mov edx, OFFSET enterPIN
    call WriteString
    call ReadInt
    mov di, eax

    mov cx, LENGTHOF accounts
    xor bx, bx

CheckLoop:
    mov ax, accounts[bx*2]
    cmp ax, si
    jne NextAcc
    mov ax, pins[bx*2]
    cmp ax, di
    jne Invalid
    mov ax, bx
    ret

NextAcc:
    inc bx
    loop CheckLoop

Invalid:
    mov edx, OFFSET invalidMsg
    call WriteString
    mov ax, -1
    ret
Login ENDP

ShowMenu PROC
    mov edx, OFFSET menuMsg
    call WriteString
    ret
ShowMenu ENDP

CheckBalance PROC
    mov ax, balances[bx*2]
    mov edx, OFFSET balanceMsg
    call WriteString
    call WriteDec
    call Crlf
    jmp MenuLoop
CheckBalance ENDP

Deposit PROC
    mov edx, OFFSET depositMsg
    call WriteString
    call ReadInt
    add balances[bx*2], eax
    mov edx, OFFSET successMsg
    call WriteString
    jmp MenuLoop
Deposit ENDP

Withdraw PROC
    mov edx, OFFSET withdrawMsg
    call WriteString
    call ReadInt

    mov cx, balances[bx*2]
    cmp cx, eax
    jl NotEnough

    sub balances[bx*2], eax
    mov edx, OFFSET successMsg
    call WriteString
    jmp MenuLoop

NotEnough:
    mov edx, OFFSET insufficient
    call WriteString
    jmp MenuLoop
Withdraw ENDP

Logout PROC
    call Crlf
    mov edx, OFFSET newline
    call WriteString
    jmp LoginLoop
Logout ENDP

ExitATM PROC
    mov edx, OFFSET newline
    call WriteString
    exit
ExitATM ENDP

main ENDP

END main
