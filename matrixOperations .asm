
.data
matrixA:    .space 400       # Space for matrix A (up to 10x10)
matrixB:    .space 400       # Space for matrix B (up to 10x10)
matrixC:    .space 400       # Space for result matrix

rowsA:      .word 0          # Rows in matrix A
colsA:      .word 0          # Columns in matrix A
rowsB:      .word 0          # Rows in matrix B
colsB:      .word 0          # Columns in matrix B

# Messages
menu:       .asciiz "\nMatrix Operations Menu:\n1. Enter matrices\n2. Add matrices\n3. Subtract matrices\n4. Multiply matrices\n5. Display matrices\n6. Exit\nEnter choice: "
resultMsg:  .asciiz "\nResult Matrix:\n"
newline:    .asciiz "\n"
space:      .asciiz " "
tab:        .asciiz "\t"
errorMsg:   .asciiz "\nError: Matrix dimensions don't match!\n"
multError:  .asciiz "\nError: For multiplication, colsA must equal rowsB!\n"
enterRows:  .asciiz "\nEnter number of rows (1-10): "
enterCols:  .asciiz "Enter number of columns (1-10): "
enterVal:   .asciiz "Enter value for ["
closeBrack: .asciiz "]: "
matrixAMsg: .asciiz "\nMatrix A:\n"
matrixBMsg: .asciiz "\nMatrix B:\n"
currentDims:.asciiz "\nCurrent dimensions:\nMatrix A: "
xSymbol:    .asciiz " x "
matrixBText:.asciiz "\nMatrix B: "

.text
.globl main
main:
    j show_menu

# Matrix input function
input_matrices:
    # Input matrix A dimensions
    la $a0, enterRows
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    sw $v0, rowsA
    
    la $a0, enterCols
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    sw $v0, colsA
    
    # Input matrix A elements
    la $a0, matrixAMsg
    li $v0, 4
    syscall
    
    lw $s0, rowsA        # $s0 = rowsA
    lw $s1, colsA        # $s1 = colsA
    li $t0, 0            # row counter
    
input_loop_A_row:
    bge $t0, $s0, input_matrixB
    li $t1, 0            # col counter
    
    input_loop_A_col:
        bge $t1, $s1, end_input_A_col
        
        # Prompt for value
        la $a0, enterVal
        li $v0, 4
        syscall
        move $a0, $t0
        li $v0, 1
        syscall
        la $a0, space
        li $v0, 4
        syscall
        move $a0, $t1
        li $v0, 1
        syscall
        la $a0, closeBrack
        li $v0, 4
        syscall
        
        # Get value
        li $v0, 5        # Read integer
        syscall
        
        # Calculate address and store
        mul $t2, $t0, $s1
        add $t2, $t2, $t1
        sll $t2, $t2, 2
        la $t3, matrixA
        add $t3, $t3, $t2
        sw $v0, 0($t3)
        
        addi $t1, $t1, 1
        j input_loop_A_col
        
    end_input_A_col:
        la $a0, newline
        li $v0, 4
        syscall
        
        addi $t0, $t0, 1
        j input_loop_A_row

input_matrixB:
    # Input matrix B dimensions
    la $a0, enterRows
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    sw $v0, rowsB
    
    la $a0, enterCols
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    sw $v0, colsB
    
    # Input matrix B elements
    la $a0, matrixBMsg
    li $v0, 4
    syscall
    
    lw $s0, rowsB        # $s0 = rowsB
    lw $s1, colsB        # $s1 = colsB
    li $t0, 0            # row counter
    
input_loop_B_row:
    bge $t0, $s0, input_done
    li $t1, 0            # col counter
    
    input_loop_B_col:
        bge $t1, $s1, end_input_B_col
        
        # Prompt for value
        la $a0, enterVal
        li $v0, 4
        syscall
        move $a0, $t0
        li $v0, 1
        syscall
        la $a0, space
        li $v0, 4
        syscall
        move $a0, $t1
        li $v0, 1
        syscall
        la $a0, closeBrack
        li $v0, 4
        syscall
        
        # Get value
        li $v0, 5        # Read integer
        syscall
        
        # Calculate address and store
        mul $t2, $t0, $s1
        add $t2, $t2, $t1
        sll $t2, $t2, 2
        la $t3, matrixB
        add $t3, $t3, $t2
        sw $v0, 0($t3)
        
        addi $t1, $t1, 1
        j input_loop_B_col
        
    end_input_B_col:
        la $a0, newline
        li $v0, 4
        syscall
        
        addi $t0, $t0, 1
        j input_loop_B_row

input_done:
    # Show current dimensions
    la $a0, currentDims
    li $v0, 4
    syscall
    
    lw $a0, rowsA
    li $v0, 1
    syscall
    
    la $a0, xSymbol
    li $v0, 4
    syscall
    
    lw $a0, colsA
    li $v0, 1
    syscall
    
    la $a0, matrixBText
    li $v0, 4
    syscall
    
    lw $a0, rowsB
    li $v0, 1
    syscall
    
    la $a0, xSymbol
    li $v0, 4
    syscall
    
    lw $a0, colsB
    li $v0, 1
    syscall
    
    la $a0, newline
    li $v0, 4
    syscall
    
    j show_menu

display_matrices:
    # Display matrix A
    la $a0, matrixAMsg  # "Matrix A:"
    li $v0, 4
    syscall
    
    lw $s0, rowsA       # Load rowsA
    lw $s1, colsA       # Load colsA 
    li $t0, 0           # row counter = 0

display_A_row:
    bge $t0, $s0, display_matrixB  # if row >= rowsA, done
    li $t1, 0           # col counter = 0
    
display_A_col:
    bge $t1, $s1, end_display_A_col  # if col >= colsA, next row
    
    # Calculate address matrixA[row][col]
    mul $t2, $t0, $s1   # row * num_cols
    add $t2, $t2, $t1   # + col
    sll $t2, $t2, 2     # *4 (word size)
    la $t3, matrixA
    add $t3, $t3, $t2   # address of A[row][col]
    lw $a0, 0($t3)      # load value
    
    # Print value
    li $v0, 1
    syscall
    
    # Print space
    la $a0, space
    li $v0, 4
    syscall
    
    addi $t1, $t1, 1    # col++
    j display_A_col
    
end_display_A_col:
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    addi $t0, $t0, 1    # row++
    j display_A_row

display_matrixB:
    # Display matrix B
    la $a0, matrixBMsg  # "Matrix B:"
    li $v0, 4
    syscall
    
    lw $s0, rowsB       # Load rowsB
    lw $s1, colsB       # Load colsB
    li $t0, 0           # row counter = 0

display_B_row:
    bge $t0, $s0, display_done  # if row >= rowsB, done
    li $t1, 0           # col counter = 0
    
display_B_col:
    bge $t1, $s1, end_display_B_col  # if col >= colsB, next row
    
    # Calculate address matrixB[row][col]
    mul $t2, $t0, $s1   # row * num_cols
    add $t2, $t2, $t1   # + col
    sll $t2, $t2, 2     # *4 (word size)
    la $t3, matrixB
    add $t3, $t3, $t2   # address of B[row][col]
    lw $a0, 0($t3)      # load value
    
    # Print value
    li $v0, 1
    syscall
    
    # Print space
    la $a0, space
    li $v0, 4
    syscall
    
    addi $t1, $t1, 1    # col++
    j display_B_col
    
end_display_B_col:
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    addi $t0, $t0, 1    # row++
    j display_B_row

display_done:
    j show_menu
# Matrix operations
add_matrices:
    # Check matrix dimensions
    lw $t0, rowsA
    lw $t1, rowsB
    bne $t0, $t1, dimension_error
    lw $t0, colsA
    lw $t1, colsB
    bne $t0, $t1, dimension_error
    
    # Initialize counters
    lw $s0, rowsA
    lw $s1, colsA
    li $t0, 0                   # row counter
    
    add_loop_row:
        bge $t0, $s0, end_add    # $s0 has row count
        li $t1, 0                # column counter
        
        add_loop_col:
            bge $t1, $s1, end_add_col  # $s1 has column count
            
            # Calculate address for matrixA[row][col]
            mul $t2, $t0, $s1    # row * num_cols
            add $t2, $t2, $t1    # + col
            sll $t2, $t2, 2      # multiply by 4 (word size)
            la $t3, matrixA
            add $t3, $t3, $t2    # address of A[row][col]
            lw $t4, 0($t3)       # value of A[row][col]
            
            # Calculate address for matrixB[row][col]
            la $t3, matrixB
            add $t3, $t3, $t2    # address of B[row][col]
            lw $t5, 0($t3)       # value of B[row][col]
            
            # Add and store in matrixC
            add $t6, $t4, $t5
            la $t3, matrixC
            add $t3, $t3, $t2    # address of C[row][col]
            sw $t6, 0($t3)       # store result
            
            addi $t1, $t1, 1     # increment column counter
            j add_loop_col
            
        end_add_col:
            addi $t0, $t0, 1     # increment row counter
            j add_loop_row
            
    end_add:
        jal print_matrix
        j show_menu

subtract_matrices:
    # Check matrix dimensions
    lw $t0, rowsA
    lw $t1, rowsB
    bne $t0, $t1, dimension_error
    lw $t0, colsA
    lw $t1, colsB
    bne $t0, $t1, dimension_error
    
    # Initialize counters
    lw $s0, rowsA
    lw $s1, colsA
    li $t0, 0                   # row counter
    
    sub_loop_row:
        bge $t0, $s0, end_sub    # $s0 has row count
        li $t1, 0                # column counter
        
        sub_loop_col:
            bge $t1, $s1, end_sub_col  # $s1 has column count
            
            # Calculate address for matrixA[row][col]
            mul $t2, $t0, $s1    # row * num_cols
            add $t2, $t2, $t1    # + col
            sll $t2, $t2, 2      # multiply by 4 (word size)
            la $t3, matrixA
            add $t3, $t3, $t2    # address of A[row][col]
            lw $t4, 0($t3)       # value of A[row][col]
            
            # Calculate address for matrixB[row][col]
            la $t3, matrixB
            add $t3, $t3, $t2    # address of B[row][col]
            lw $t5, 0($t3)       # value of B[row][col]
            
            # Subtract and store in matrixC
            sub $t6, $t4, $t5
            la $t3, matrixC
            add $t3, $t3, $t2    # address of C[row][col]
            sw $t6, 0($t3)       # store result
            
            addi $t1, $t1, 1     # increment column counter
            j sub_loop_col
            
        end_sub_col:
            addi $t0, $t0, 1     # increment row counter
            j sub_loop_row
            
    end_sub:
        jal print_matrix
        j show_menu

multiply_matrices:
    # Check if colsA == rowsB
    lw $t0, colsA
    lw $t1, rowsB
    bne $t0, $t1, multiplication_error
    
    # Save original colsA
    lw $t9, colsA
    
    # Initialize counters
    lw $s0, rowsA        # $s0 = rowsA
    lw $s1, colsA        # $s1 = colsA (same as rowsB)
    lw $s2, colsB        # $s2 = colsB
    li $t0, 0            # i counter (rowsA)
    
    mul_loop_i:
        bge $t0, $s0, end_mul
        li $t1, 0        # j counter (colsB)
        
        mul_loop_j:
            bge $t1, $s2, end_mul_j
            li $t7, 0     # sum = 0
            li $t2, 0     # k counter (colsA/rowsB)
            
            mul_loop_k:
                bge $t2, $s1, end_mul_k
                
                # Calculate A[i][k]
                mul $t3, $t0, $s1
                add $t3, $t3, $t2
                sll $t3, $t3, 2
                la $t4, matrixA
                add $t4, $t4, $t3
                lw $t5, 0($t4)   # A[i][k]
                
                # Calculate B[k][j]
                mul $t3, $t2, $s2
                add $t3, $t3, $t1
                sll $t3, $t3, 2
                la $t4, matrixB
                add $t4, $t4, $t3
                lw $t6, 0($t4)   # B[k][j]
                
                # Multiply and accumulate
                mul $t8, $t5, $t6
                add $t7, $t7, $t8
                
                addi $t2, $t2, 1
                j mul_loop_k
                
            end_mul_k:
                # Calculate C[i][j] address
                mul $t3, $t0, $s2
                add $t3, $t3, $t1
                sll $t3, $t3, 2
                la $t4, matrixC
                add $t4, $t4, $t3
                sw $t7, 0($t4)
                
                addi $t1, $t1, 1
                j mul_loop_j
                
        end_mul_j:
            addi $t0, $t0, 1
            j mul_loop_i
            
    end_mul:
        # Print result with correct dimensions
        la $a0, resultMsg
        li $v0, 4
        syscall
        
        # Print using result dimensions (rowsA x colsB)
        lw $s0, rowsA    # Result rows
        lw $s1, colsB    # Result columns
        li $t0, 0        # row counter
        
        mul_print_loop_row:          # Changed label name
            bge $t0, $s0, end_mul_print
            li $t1, 0    # col counter
            
            mul_print_loop_col:      # Changed label name
                bge $t1, $s1, end_mul_print_col
                
                # Calculate address
                mul $t2, $t0, $s1
                add $t2, $t2, $t1
                sll $t2, $t2, 2
                la $t3, matrixC
                add $t3, $t3, $t2
                
                # Print element
                li $v0, 1
                lw $a0, 0($t3)
                syscall
                
                # Print space
                li $v0, 4
                la $a0, space
                syscall
                
                addi $t1, $t1, 1
                j mul_print_loop_col
                
            end_mul_print_col:
                # Print newline
                li $v0, 4
                la $a0, newline
                syscall
                
                addi $t0, $t0, 1
                j mul_print_loop_row
                
        end_mul_print:
            # Restore original colsA
            sw $t9, colsA
            j show_menu

print_matrix:
    # Print result message
    li $v0, 4
    la $a0, resultMsg
    syscall
    
    # Initialize counters
    lw $s0, rowsA
    lw $s1, colsA
    li $t0, 0            # row counter
    
    print_loop_row:
        bge $t0, $s0, end_print
        li $t1, 0        # col counter
        
        print_loop_col:
            bge $t1, $s1, end_print_col
            
            # Calculate address
            mul $t2, $t0, $s1
            add $t2, $t2, $t1
            sll $t2, $t2, 2
            la $t3, matrixC
            add $t3, $t3, $t2
            
            # Print element
            li $v0, 1
            lw $a0, 0($t3)
            syscall
            
            # Print space
            li $v0, 4
            la $a0, space
            syscall
            
            addi $t1, $t1, 1
            j print_loop_col
            
        end_print_col:
            # Print newline
            li $v0, 4
            la $a0, newline
            syscall
            
            addi $t0, $t0, 1
            j print_loop_row
            
    end_print:
        jr $ra

dimension_error:
    # Print error message
    li $v0, 4
    la $a0, errorMsg
    syscall
    j show_menu

multiplication_error:
    # Print specific multiplication error
    li $v0, 4
    la $a0, multError
    syscall
    j show_menu

show_menu:
    # Display menu
    li $v0, 4
    la $a0, menu
    syscall
    
    # Get user choice
    li $v0, 5
    syscall
    
    # Process choice
    beq $v0, 1, input_matrices
    beq $v0, 2, add_matrices
    beq $v0, 3, subtract_matrices
    beq $v0, 4, multiply_matrices
    beq $v0, 5, display_matrices
    beq $v0, 6, exit_program
    
    # Invalid choice
    j show_menu

exit_program:
    li $v0, 10
    syscall
