.global main
.func main
   
main: 
    BL _prompt
    BL _scanf
    MOV R4, R0           
    MOV R0, #0             
    BL _generate

             
    
_generate:
    CMP R0, #20            
    BEQ writedone       
    LDR R1, =array_a            
    LDR R2, =array_b 
    LSL R3, R0, #2     
    ADD R3, R1, R3         
    ADD R7, R4, R0         
    STR R7, [R3] 
    LSL R5, R0, #2 
    ADD R5, R2, R5
    STR R7, [R5] 
    ADD R0, R0, #1 
    LSL R4, R0, #2      
    ADD R4, R1, R4       
    ADD R8, R7, #1         
    ADD R9, R8, R8 
    SUB R8, R8, R9
    STR R8, [R4] 
    LSL R6, R0, #2 
    ADD R6, R2, R6
    STR R8, [R6]
    ADD R0, R0, #1         
    B _generate           

writedone:
    MOV R0, #0              
    B _ArrLoop

_ArrLoop: 
    LDR R1, =array_b 
    CMP R0, #20 
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
    
    CMP R3, #20 
    BLT _sortAscending 
    ADD R0, R0, #1 
    B _ArrLoop   
    
_readloop:
    CMP R0, #20            
    BEQ readdone          
    LDR R1, =array_a    
    LSL R2, R0, #2          
    ADD R2, R1, R2          
    LDR R1, [R2]  
    LDR R3, =array_b 
    LSL R4, R0, #2 
    ADD R4, R3, R4 
    LDR R3, [R4]
    PUSH {R0}              
    PUSH {R1}             
    PUSH {R2}             
    PUSH {R3} 
    PUSH {R4} 
    MOV R3, R3
    MOV R2, R1     
    MOV R1, R0        
    BL  _printf           
    POP {R4} 
    POP {R3}
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
    MOV R2, #31           
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
array_a:        .skip       80
array_b:        .skip       80
format_str:     .asciz      "%d"
prompt_str:     .asciz      "Type an positive integer: "
printf_str:     .asciz      "array_a[%d] = %d, array_b = %d\n "
exit_str:       .ascii      "Terminating program.\n"
