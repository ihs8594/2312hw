    .global main
    .func main
   
main:
    BL  _prompt             
    BL  _scanf              
    MOV R1, R0              
    BL  _printf
    BL  _opprompt
    BL  _getop
    MOV R3, R0
    BL  _prompt
    BL  _scanf
    MOV R2, R0
    BL  _printf             
    
    CMP R3,#'+'      
    BLEQ _add      
    MOV R1,R0        
    CMP R3, #'-'
    BLEQ _sub
    MOV R1,R0
    CMP R3, #'*'
    BLEQ _mult
    MOV R1,R0
    CMP R3, #'M'
    BLEQ _max
    MOV R1,R0
    BL _result
    BL main
   
_exit:  
    MOV R7, #4             
    MOV R0, #1              
    MOV R2, #21            
    LDR R1, =exit_str       
    SWI 0                  
    MOV R7, #1             
    SWI 0                  

_prompt:
    MOV R7, #4       
    MOV R0, #1              
    MOV R2, #31             
    LDR R1, =prompt_str   
    SWI 0                  
    MOV PC, LR             
    
_opprompt:
    MOV R7, #4              
    MOV R0, #1              
    MOV R2, #31             
    LDR R1, =operation_str  
    SWI 0                  
    MOV PC, LR              
       
_printf:
    MOV R4, LR              
    LDR R0, =printf_str     
    BL printf              
    MOV PC, R4              

_result:
    MOV R4, LR              
    LDR R0, =result_str     
    BL printf              
    MOV PC, R4    
    
_scanf:
    PUSH {LR}                
    SUB SP, SP, #4          
    LDR R0, =format_str     
    MOV R1, SP              
    BL scanf                
    LDR R0, [SP]          
    ADD SP, SP, #4          
    POP {PC}                
 
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
    
_sub:
    SUB R0, R1, R2    
    MOV PC, LR
    
_mult:
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
result_str:     .asciz      "The result is: %d\n"
operation_str:  .asciz      "Choose an operation {+,-,*,M}: "
op_char:        .asciz      " "
exit_str:       .ascii      "Terminating program.\n"
