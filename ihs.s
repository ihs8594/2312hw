.global main
.func main
   
main: 
    BL _prompt
    BL _scanf
    MOV R10, R0             @ store return val of scanf(n) into R10
    MOV R0, #0              @ initialze index variable i 
    BL _generate

_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return
    
_generate:
    CMP R0, #20             @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    LDR R1, =a              @ get address of a
    LDR R2, =b 
    
    LSL R3, R0, #2          @ multiply index*4 to get array offset
    ADD R3, R1, R3          @ R2 now has the element address
    ADD R7, R10, R0          @ R7 has n+i
    STR R7, [R3]            @ store n+i to a[i]
    
    LSL R5, R0, #2 
    ADD R5, R2, R5
    STR R7, [R5]
    
    ADD R0, R0, #1
    
    LSL R4, R0, #2          @multiply previous index(i)*4 to get i+1 array offset
    ADD R4, R1, R4          @R3 now has i+1 element address
    ADD R8, R7, #1           @R8 has (n+i+1)
    STR R8, [R4]            @store -(n+i+1) to a[i+1]
    
    LSL R6, R0, #2 
    ADD R6, R2, R6
    STR R8, [R6]
    ADD R0, R0, #1          @ increment index by 2
    B _generate            @ branch to next loop iteration

writedone:
    MOV R0, #0              @ initialze index variable
    BL _ArrayLoop 

_ArrayLoop: 
    CMP R0, #20 
    BEQ ArrayDone
    LDR R1, =b 
    LSL R2, R0, #2 
    ADD R2, R1, R2 
    BL _sort
    
_iterate:   
    ADD R0, R0, #1 
    BL _ArrayLoop

ArrayDone: 
    MOV R0, #0 
    BL _readloop

_sort: 
    ADD R3, R0, #1 
    CMP R3, #20 
    BEQ _iterate 
    LSL R5, R3, #2 
    ADD R5, R1, R5 
    LDR R6, [R2] 
    LDR R7, [R5] 
    CMP R6, R7 
    LDRGT R8, [R2] 
    STRGT R7, [R2] 
    STRGT R8, [R5] 
    ADD R3, R3, #1 
    B _sort 
    
_readloop:
    CMP R0, #20            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =a           @ get address of array_a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    
    LDR R3, =b 
    LSL R4, R0, #2 
    ADD R4, R3, R4 
    LDR R3, [R4]
    
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    PUSH {R3} 
    PUSH {R4} 
    MOV R3, R3
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R4} 
    POP {R3}
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   _readloop            @ branch to next loop iteration
readdone:
    B _exit                 @ exit if done

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall


.data

.balign 4
a:        .skip       80
b:        .skip       80
format_str:     .asciz      "%d"
prompt_str:     .asciz      "Type a number and press enter: "
printf_str:     .asciz      "array_a[%d] = %d, array_b = %d\n "
exit_str:       .ascii      "Terminating program.\n"
