    .global main
    .func main
    
    main:
    BL _scanf
    MOV R4, R0
    BL _scanf
    MOV R5, R0
    BL _count_partitions
    MOV R1, R0
    MOV R2, R4
    MOV R3, R5
    BL _printf
    
    
    
    
    _count_partitions:
    PUSH {LR}
    
    CMP R4, #0
    MOVEQ R0, #1
    POPEQ {PC}
    
    CMP R4, #0
    MOVLT R0, #0
    POPLT {PC}
    
    CMP R5, #0
    MOVEQ R0, #0
    POPEQ {PC}
    
    PUSH {R4}
    PUSH {R5}
    SUB R0, R4, R5
    BL _count_partitions
     
    SUB R1, R5, #1
    MOV R5, R1
    MOV R0, R4
    BL _count_partitions
    
    ADD R0, R0, R5
    POP {R4}
    POP {R5}
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
    
    
    _printf:
    MOV R4, LR              
    LDR R0, =printf_str 
    @MOV R1, R1
    BL printf              
    MOV PC, R4
    
    
    
    
    .data
    format_str:     .asciz    "%d"
    printf_str:     .asciz    "There are %d partitions of %d using integers up to %d"
