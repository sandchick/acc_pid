                PRESERVE8
                THUMB

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     0x20000000                ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     0                         ; NMI Handler
                DCD     0                         ; Hard Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; SVCall Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; PendSV Handler
                DCD     0                         ; SysTick Handler
                DCD     0                         ; IRQ0 Handler

                AREA    |.text|, CODE, READONLY

; Reset Handler

Reset_Handler   PROC
                GLOBAL  Reset_Handler
				ENTRY
                B	start
				ENDP


;Inset a loop algorithm there;
              AREA template, CODE, READONLY
start       PROC
            LDR R0, =0x40001000            
            MOVS R1, #1
			STR R1, [R0]
            LDR R0, =0x40001004
            STR R1, [R0]
            LDR R0, =0x40001008
            LDR R1, =0x00000888
            STR R1, [R0]
            LDR R0, =0x40001010
            LDR R1, =0x00000678
            STR R1, [R0]
            LDR R2, =0x40001004
            LDR R3, [R2]
            B start
            ENDP
            END
