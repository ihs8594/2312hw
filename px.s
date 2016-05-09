.global main
.func main
   
main: 
    BL _prompt          
    MOV R0, #0 
    MOV R11, #0
    MOV R8, #0
    BL _generate
    
    
_generate:
    BL _scanf
    MOV R4, R0
    
    LDR R1, =a            
    LDR R2, =b 
    LSL R3, R8, #2     
    ADD R3, R1, R3
    ADD R7, R4, #0
            
    STR R7, [R3] 
    LSL R5, R8, #2 
    ADD R5, R2, R5
    STR R7, [R5]
    ADD R11, R11, R4
    ADD R8, R8, #1
    CMP R8, #10
    BEQ writedone
    
    B _generate
   
writedone:
    MOV R0, #0              
    B _ArrLoop


_ArrLoop: 
    LDR R1, =b 
    CMP R0, #10 
    BEQ ArrDone 
    LSL R2, R0, #2 
    ADD R2, R1, R2 
    ADD R3, R0, #1 
    BL _sortAscending  
    
ArrDone: 
    MOV R0, #0 
    B _readloop

_sortAscending:  
    LSL R5, R3, #2 
    ADD R5, R1, R5 
    LDR R6, [R2] 
    LDR R7, [R5] 
   
    CMP R6, R7 
    
    LDRGT R8, [R2] 
    STRGT R7, [R2] 
    STRGT R8, [R5] 
    
    ADD R3, R3, #1 
    
    CMP R3, #10 
    BLT _sortAscending 
    ADD R0, R0, #1 
    B _ArrLoop



_readloop:
    CMP R0, #10
    MOVEQ R1, R9
    BLEQ _printfmin
    MOVEQ R1, R11
    BLEQ _printfmax
    MOVEQ R1, R11
    BLEQ _printfsum
    BEQ readdone          
    LDR R1, =a    
    LSL R2, R0, #2          
    ADD R2, R1, R2          
    LDR R1, [R2]  
    
    LDR R3, =b 
    LSL R10, R0, #2 
    ADD R10, R3, R10 
    LDR R3, [R10]
    CMP R0, #0
    MOVEQ R9, R3
    CMP R0, #9
    MOVEQ R12, R3
    PUSH {R0}              
    PUSH {R1}             
    PUSH {R2}
    MOV R2, R1     
    MOV R1, R0        
    BL  _printf 
    POP {R2}              
    POP {R1}               
    POP {R0}                
    ADD R0, R0, #1        
    B   _readloop

readdone:
    B _exit 

_printf:
    PUSH {LR}              
    LDR R0, =printf_str    
    BL printf               
    POP {PC}

_printfmin:
    PUSH {LR}              
    LDR R0, =printf_min    
    BL printf               
    POP {PC}
    
_printfmax:
    PUSH {LR}              
    LDR R0, =printf_max    
    BL printf               
    POP {PC}

_printfsum:
    PUSH {LR}              
    LDR R0, =printf_sum    
    BL printf               
    POP {PC}
    
_scanf:
    PUSH {LR}             
    SUB SP, SP, #4         
    LDR R0, =format_str    
    MOV R1, SP             
    BL scanf              
    LDR R0, [SP]         
    ADD SP, SP, #4        
    POP {PC} 
    
_prompt:
    MOV R7, #4             
    MOV R0, #1             
    MOV R2, #21           
    LDR R1, =prompt_str     
    SWI 0                
    MOV PC, LR             

_exit:  
    MOV R7, #4            
    MOV R0, #1            
    MOV R2, #21           
    LDR R1, =exit_str       
    SWI 0                   
    MOV R7, #1              
    SWI 0                   


.data

.balign 4
a:        .skip       40
b:        .skip       40
format_str:     .asciz      "%d"
prompt_str:     .asciz      "Type in 10 integers:"
printf_str:     .asciz      "array_a[%d] = %d\n "
printf_max:     .asciz      "maximum = %d\n "
printf_min:     .asciz      "minimum = %d\n "
printf_sum:     .asciz      "sum = %d\n "
exit_str:       .ascii      "Terminating program.\n"
