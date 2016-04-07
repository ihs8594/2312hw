    .global main
    .func main
   
main:
    BL  _prompt             @ branch to prompt procedure with return
    BL  _scanf              @ branch to scanf procedure with return
    MOV R1, R0              @ move return value R0 to argument register R1
    BL  _printf
    BL  _opprompt
    BL  _getop
    MOV R3, R0
    BL  _prompt
    BL  _scanf
    MOV R2, R0
    BL  _printf             @ branch to print procedure with return
    BL  _add
    MOV R1, R0
    BL  _printf
    B   _exit               @ branch to exit procedure with no return
   
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
    
_opprompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =operation_str  @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
       
_printf:
    MOV R4, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    MOV PC, R4              @ return
    
    
_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return
 
_getop:
    MOV R7, #3              
    MOV R0, #0             
    MOV R2, #1             
    LDR R1, =op_char     
    SWI 0                  
    LDR R0, [R1]            
    AND R0, #0xFF           
    MOV PC, LR 

_add:
    ADD R0, R1, R2
    MOV	PC, LR
    
_subtract:
    SUB R0, R1, R2    
    MOV PC, LR
    
_multiply:
    MUL R0, R1, R2     
    MOV PC, LR
    
_max:
    CMP R1, R2
    MOVLT R0, R3      
    MOVGT R0, R1
    MOV PC, LR


.data
format_str:     .asciz      "%d"
prompt_str:     .asciz      "Type a number and press enter: "
printf_str:     .asciz      "The number entered was: %d\n"
operation_str:  .asciz      "Choose an operation {+,-,*,M}: "
op_char:        .ascii      " "
exit_str:       .ascii      "Terminating program.\n"
