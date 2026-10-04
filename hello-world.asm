; ------------------------------------------------------------------------------
; Write a program that prints "Hello, World!\n"
; It may not use `.STRINGZ`, `.FILL`, `puts`, `out`, or `lea`
; ------------------------------------------------------------------------------

.ORIG x3000

    jsr A
    putsp ; <- r7
    halt

    ; H  e  l  l  o  ,     W  o  r  l  d  !  \n
    ; 48 65 6C 6C 6F 2C 20 57 6F 72 6C 64 21 0A

    ldr r2, r5, #8   ; eH   <- r7 + 2
    ldr r6, r1, #-20 ; ll
    ld  r6, B        ; ,o   B == x6F
    and r3, r4, #0   ; W 
    str r1, r1, #-17 ; ro
    ldr r2, r1, #-20 ; dl
    brnp A           ; \n!  A == x21

.BLKW x21
A
add r0, r7, #2
ret
.BLKW x48
B

.END
