;-------------------------------------------------------------------------------
; Let's see if you can solve the *first problem in the instruction manual!*
;
; > The numbers X and Y are found at locations x3100 and x3101, respectively.
; > Write an LC-3 assembly language program that computes the sum X+Y and places
; > it at location x3102.
;
; To make it a little harder, your compiled binary must be 100% human readable -
; i.e. *printable* 7-bit ascii characters!
;-------------------------------------------------------------------------------

;
; [0x20,     0x7E    ]
; [00100000, 01111110]
; [32,       126     ]
;
; 0010 000 000000000
; LD   DR  PCoffset9
; PCoffset >= 32
;
; 0011 000 000000000
; ST   SR  PCoffset9
; PCoffset >= 32
;
; 0101 000 000 0 00 000
; AND  DR  SR1      SR2
; SR1 in {R1, R5}
;
; 0101 000 000 1 00000
; AND  DR  SR    imm5
;
; 0100 1 00000000000
; JSR    PCoffset11
;
; 0100 0 00 000 000000
; JSR  R    BR
; BR in {R0, R1, R4, R5}
;
; 0110 000 000 000000
; LDR  DR  BR  offset6
; BR in {R3, R2, R1, R0}
;
; 0111 000 000 000000
; STR  SR  BR  offset6
; BR in {R3, R2, R1, R0}
;

.ORIG x3030

; build add instruction
    ld r5 EndLocation
    ldr r3 r5 #-3 ; HaltA_AndMask

    ; X + Y add
    ldr r1 r5 #-13 ; load and
    and r1 r1 r3
    str r1 r5 #-13 ; store add

    ; 1st halt add
    str r1 r5 #-9 ; store add

    ; 2nd halt add
    str r1 r5 #-7 ; store add

; load X and Y
    ldr r1 r5 #-4 ; DataMask
    ldr r3 r5 #-2 ; HaltB_DataMask

    and r4 r1 r3
    ldr r0 r4 #-3 ; r0 = X
    ldr r1 r4 #-2 ; r1 = Y

    and r0 r1 r0 ; r0 = X + Y

; store result
    str r0 r4 #-1

; create halt
    ldr r1 r5 #-3 ; HaltA_AndMask
    ldr r0 r5 #-2 ; HaltB_DataMask

    and r0 r1 r0 ; HaltA + HaltB

    ldr r1 r5 #-5 ; HaltC

    and r0 r1 r0 ; HaltA + HaltB + HaltC

    ; store halt
    str r0 r5 #-5

.FILL x4E5E ; halt (stores HaltC)

; x3100 + 3 so offsets are negative
; x7157 & x3123 = x3103 ; 00110001 00000011

;DataMask
.FILL x3123 ; 00110001 00100011

; and r0 r1 r0 = x5040 = 01010000 01000000
; add r0 r1 r0 = x1040 = 00010000 01000000

; x3070 & x5040 = x1040

;HaltA_AndMask
.FILL x3070 ; 00110000 01110000

; halt = xF025 = 11110000 00100101

; x3070 + x7157 + x4E5E = xF025

;HaltB_DataMask
.FILL x7157 ; 01110001 01010111
;HaltC          .FILL x4E5E ; 01001110 01011110

.FILL x3030 ; ldr -1 isnt valid

End

; offset label offsets >= 32
.FILL x5448
.FILL x4953
.FILL x4953
.FILL x5448
.FILL x4550
.FILL x4144
.FILL x4449
.FILL x4E47

EndLocation .FILL End

.END
