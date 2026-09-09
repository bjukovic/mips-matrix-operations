# MIPS Matrix Operations

A **group project developed for the Computer Architecture course in Spring 2025**, implementing fundamental matrix operations using **MIPS Assembly language**.

The project demonstrates how mathematical operations on two-dimensional data structures can be implemented at a low level using processor registers, memory addressing, control flow, procedures, loops, and system calls.

The program provides an interactive, menu-driven interface where users can enter matrices, display them, and perform **matrix addition, subtraction, and multiplication**. It also validates matrix dimensions and provides error handling when an operation cannot be performed.

---

## Table of Contents

* [Overview](#overview)
* [Features](#features)
* [Matrix Operations](#matrix-operations)
* [Program Architecture](#program-architecture)
* [Memory Organization](#memory-organization)
* [Matrix Addressing](#matrix-addressing)
* [MIPS Instructions Used](#mips-instructions-used)
* [Register Usage](#register-usage)
* [Program Flow](#program-flow)
* [Example](#example)
* [Getting Started](#getting-started)
* [Project Structure](#project-structure)
* [Limitations](#limitations)
* [Possible Improvements](#possible-improvements)
* [Learning Objectives](#learning-objectives)
* [Academic Context](#academic-context)
* [Team](#team)

---

## Overview

Matrix operations are commonly implemented using high-level programming languages and specialized libraries. This project takes a lower-level approach by implementing the operations directly in **MIPS Assembly**.

The implementation focuses on several fundamental computer architecture concepts:

* Direct manipulation of processor registers
* Memory addressing and data storage
* Control flow and branching
* Procedure calls
* Nested loops
* Representation of two-dimensional arrays in linear memory
* System calls for user interaction
* Low-level implementation of mathematical algorithms

By implementing these operations manually, the project provides insight into how high-level mathematical operations can be translated into individual processor instructions.

The program supports matrices of up to **10 × 10 elements**.

---

## Features

The program includes:

* Interactive menu-driven interface
* Input of matrix dimensions
* Input of individual matrix elements
* Display of matrices
* Matrix addition
* Matrix subtraction
* Matrix multiplication
* Dimension compatibility checks
* Error handling for invalid operations
* Fixed matrix storage of up to **10 × 10 elements**
* Memory-based matrix representation
* MIPS system calls for input and output

---

## Matrix Operations

### Matrix Addition

Two matrices can be added only when they have the same dimensions.

For matrices `A` and `B`:

```text
C[i][j] = A[i][j] + B[i][j]
```

The program first verifies that:

```text
rows(A) = rows(B)
columns(A) = columns(B)
```

If the dimensions do not match, the program displays an error message and returns to the main menu.

---

### Matrix Subtraction

Matrix subtraction follows the same dimension requirements as addition.

For matrices `A` and `B`:

```text
C[i][j] = A[i][j] - B[i][j]
```

The matrices must have identical numbers of rows and columns.

---

### Matrix Multiplication

Matrix multiplication is implemented using three nested loops.

For matrix `A` with dimensions:

```text
m × n
```

and matrix `B` with dimensions:

```text
n × p
```

the resulting matrix `C` has dimensions:

```text
m × p
```

The multiplication is performed using:

```text
C[i][j] = Σ A[i][k] × B[k][j]
```

Before performing the operation, the program checks the multiplication requirement:

```text
columns(A) = rows(B)
```

The implementation then uses three counters to iterate through the rows of matrix `A`, columns of matrix `B`, and corresponding elements used to calculate each result.

---

## Program Architecture

The program follows a menu-driven structure.

```text
                    ┌───────────────┐
                    │     Start     │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │  Display Menu │
                    └───────┬───────┘
                            │
              ┌─────────────┼─────────────┐
              │             │             │
              ▼             ▼             ▼
        Input Matrices    Display      Operations
                            │             │
                            │       ┌─────┼─────┐
                            │       │     │     │
                            │       ▼     ▼     ▼
                            │     Add  Subtract Multiply
                            │       │     │     │
                            └───────┴─────┴─────┘
                                      │
                                      ▼
                              Display Result
                                      │
                                      ▼
                                Return to Menu
                                      │
                                      ▼
                                    Exit
```

The main program transfers control to the menu, where the user selects the desired operation.

Each major operation is implemented through separate procedures responsible for input, validation, calculation, and output.

---

## Memory Organization

The program uses the MIPS `.data` segment to store:

* Matrix data
* Matrix dimensions
* Output matrix
* User-interface messages
* Error messages

Each matrix is allocated using:

```asm
.space 400
```

The maximum matrix size is:

```text
10 × 10 = 100 elements
```

Each element is a 32-bit integer:

```text
32 bits = 4 bytes
```

Therefore, the required memory for one maximum-size matrix is:

```text
100 × 4 = 400 bytes
```

This is why 400 bytes are reserved for each matrix.

Matrix dimensions are stored using `.word`, while text messages are stored using `.asciiz`.

---

## Matrix Addressing

A matrix is conceptually two-dimensional, but memory is linear. Therefore, each matrix element must be converted into a memory address.

For an element at row `row` and column `col`, the element index is calculated as:

```text
element_index = row × number_of_columns + col
```

Because each matrix element occupies 4 bytes, the byte offset is:

```text
offset = (row × number_of_columns + col) × 4
```

The final memory address is then calculated as:

```text
address = base_address + offset
```

This addressing technique is used throughout the program when reading and writing matrix elements.

It demonstrates how a high-level two-dimensional array can be represented and accessed using low-level memory operations.

---

## MIPS Instructions Used

### Data Declaration

| Directive  | Purpose                         |
| ---------- | ------------------------------- |
| `.space N` | Reserves `N` bytes of memory    |
| `.word`    | Stores a 32-bit integer         |
| `.asciiz`  | Stores a null-terminated string |

### Arithmetic and Logical Operations

| Instruction | Purpose                                   |
| ----------- | ----------------------------------------- |
| `add`       | Adds two register values                  |
| `sub`       | Subtracts one register value from another |
| `mul`       | Multiplies two values                     |

### Memory Access

| Instruction | Purpose                         |
| ----------- | ------------------------------- |
| `lw`        | Loads a 32-bit word from memory |
| `sw`        | Stores a 32-bit word in memory  |
| `la`        | Loads the address of a label    |

### Control Flow

| Instruction | Purpose                                           |
| ----------- | ------------------------------------------------- |
| `j`         | Performs an unconditional jump                    |
| `beq`       | Branches if two registers are equal               |
| `bne`       | Branches if two registers are not equal           |
| `jal`       | Jumps to a procedure and saves the return address |
| `jr`        | Jumps to an address stored in a register          |

### System Calls

| System Call  | Purpose                           |
| ------------ | --------------------------------- |
| `li $v0, 1`  | Prepare to print an integer       |
| `li $v0, 4`  | Prepare to print a string         |
| `li $v0, 5`  | Prepare to read an integer        |
| `li $v0, 10` | Terminate the program             |
| `syscall`    | Executes the selected system call |

---

## Register Usage

The project uses MIPS registers for storing dimensions, addresses, counters, intermediate values, and system-call parameters.

| Registers | Usage                                   |
| --------- | --------------------------------------- |
| `$s0-$s7` | Saved variables                         |
| `$t0-$t9` | Temporary values and loop counters      |
| `$a0-$a3` | Procedure arguments                     |
| `$v0-$v1` | Return values and system-call selection |
| `$ra`     | Return address                          |

The temporary registers are particularly important for controlling nested loops and calculating matrix memory addresses.

---

## Program Flow

The general execution flow is:

1. Start the program.
2. Display the main menu.
3. Read the user's selection.
4. Input the required matrices.
5. Validate matrix dimensions.
6. Perform the selected matrix operation.
7. Store the result in the output matrix.
8. Display the resulting matrix.
9. Return to the main menu.
10. Exit when the user selects the termination option.

---

## Example

Consider the following matrices:

```text
A =  1  2
     3  4

B =  5  6
     7  8
```

### Addition

```text
A + B =  6   8
         10  12
```

### Subtraction

```text
A - B =  -4  -4
         -4  -4
```

### Multiplication

```text
A × B =  19  22
         43  50
```

These calculations are performed directly through the MIPS Assembly implementation rather than using high-level matrix libraries.

---

## Getting Started

### Requirements

A MIPS Assembly simulator capable of supporting the instructions and system calls used by the program is required.

The project can be used with a compatible MIPS simulator such as:

* **MARS**
* **QtSPIM**

### Running the Program

1. Open the MIPS Assembly source file in the simulator.
2. Assemble the program.
3. Run the program.
4. Select an operation from the menu.
5. Enter the matrix dimensions.
6. Enter the matrix elements.
7. View the calculated result.

---

## Project Structure

A recommended repository structure is:

```text
mips-matrix-operations/
│
├── matrix_operations.asm
│
├── screenshots/
│   ├── menu.png
│   ├── matrix-input.png
│   ├── addition.png
│   ├── subtraction.png
│   └── multiplication.png
│
├── docs/
│   └── Project_Report.pdf
│
└── README.md
```

The exact file names and structure may vary depending on the files included in the project repository.

---

## Limitations

The current implementation has several limitations:

* Matrix dimensions are limited to a maximum of **10 × 10**.
* Matrix elements are represented as 32-bit integers.
* Matrix memory is statically allocated.
* The program uses a text-based interface.
* Input and output depend on simulator-supported system calls.
* The implementation does not currently support floating-point matrix values.

---

## Possible Improvements

Future versions of the project could include:

* Dynamic matrix sizes
* More robust input validation
* Floating-point matrix support
* Additional matrix operations
* Scalar multiplication
* Matrix transposition
* Determinant calculation
* Inverse matrix calculation
* Improved user interface
* Performance comparison between different implementations
* Additional assembly-level optimizations

---

## Learning Objectives

Through this project, the team gained practical experience with:

* MIPS Assembly programming
* Computer architecture concepts
* Processor registers
* Memory organization
* Memory addressing
* Array and matrix representation
* Branching and control flow
* Nested loops
* Procedure calls
* System calls
* Low-level mathematical computation
* Error handling
* Translating algorithms into assembly instructions

---

## Academic Context

This project was developed as a **group project for the Computer Architecture course during Spring 2025**.

The main objective was to apply concepts related to processor architecture and assembly language by implementing matrix operations at a low level.

The project demonstrates the connection between mathematical algorithms and their underlying implementation through processor instructions, registers, and memory.

**Course:** Computer Architecture
**Semester:** Spring 2025
**Project Type:** Group Project
**Programming Language:** MIPS Assembly

---

## Team

This project was completed collaboratively as part of the **Computer Architecture** course.

The implementation, testing, documentation, and analysis were carried out as a group.

---

## License

This project was developed for **educational and academic purposes** as part of a university course project.
