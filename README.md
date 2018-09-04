# Introduction-MIPS-SPIM

CMPS 3240 Computer Architecture/CMPS 2240 Assembly Language: Introduction to MIPS assembly language and the SPIM simulator

# Introduction

## Requirements

* A SPIM simulator on your machine. We will begin to learn assembly language with MIPS32 (MIPS for the rest of the manual). It is much easier to understand and get into than x86. However, the microprocessor you are using is likely an x86 processor. Because assembly instructions are low level operations to be fed to the microprocessor, MIPS instructions cannot be understood by the machine you are working on. We could either cross-compile the code, or use a simulator. We will use the later.
* Understand how to use the C-language `printf()`
* Review the operation of `main.s` and `read.s` before coming to lab
* Representation of strings in C-language

### Installing the SPIM simulator

If you are using the department server, ignore this step. SPIM is already installed on the department servers. If you want to use your own device, please consult this resource for instructions:

* http://spimsimulator.sourceforge.net/

## Objectives

* Write a MIPS program that prompts the user for two integers and displays the result. E.g.:
```mips
(spim) run
Enter a number:
5
Enter another number:
6
The result is 11.
```
* Understand `la`, `li`, `lb`, `jal` and `syscall`

## Background

The following files are required for this lab:
* `main.s` - An assembly language program which you will modify to complete this lab
* `printf.s` - A pre-made function that operates similarly to the C-language `printf()`

# Approach

Clone this repository. Once you've downloaded the files, load all three files and run the code to see what it does. To run the code, you must be in the SPIM simulator. To load the simulator, execute the following commands from the terminal:

```bash
$ spim
```

If this does not work and you're on your own machine, please see the above sections for how to install SPIM. Otherwise, you should see the SPIM prompt:

```bash
Loaded: /usr/share/spim/exceptions.s
SPIM Version 9.1.4 of September 4, 2011
Copyright 1990-2010, James R. Larus.
All Rights Reserved.
SPIM is distributed under a BSD license.
See the file README for a full copyright notice.
(spim)
```

or similar. To quit the SPIM CLI, execute `quit`, like so:

```bash
(spim) quit
```

Before proceeding make sure you're back in the SPIM simulator. To run code, you must load each `.s` file one-by-one. Assuming you're in the cloned directory:

```bash
(spim) load "printf.s"
(spim) load "main.s"
(spim) load "read.s"
```

`load` loads the source code into memory. After loading all of the source code, execute `run`:

```bash
(spim) run
```

which will attempt to execute the code labelled `main`. You should get:

```bash
(spim) run
Hello world.
Register $a1 holds: 10
2 plus 3 is 5
The string is: I am a string
The char is: a
Enter a line of text [return]:
```

and the terminal waits for a response. It will ask for a line of text, echo that, ask for a number and echo that as well. Here is an example:

```bash
Enter a line of text [return]:
hi
hi
Enter an integer [return]:
12
12(spim)
```

## Pitfalls

`load "main.s"` appends the source code in the `main.s` file into SPIM's simluated memory. It does not keep track of what was previously inserted. If you change `main.s` and then attempt to reload it into the CLI it will not smartly recognize the block of code that was previously associated with `main.s` to check it for collisions. So, if you insert `main.s`, update it later, and attempt to `load "main.s"` again it will cause two `main`s to be in existence and cause an error. For example, attempt to load `main.s` twice:

```bash
(spim) load "main.s"
(spim) load "main.s"
spim: (parser) Label is defined for the second time on line 14 of file main.s
          main:
              ^
```

This applies to all source files. When coding, if you make changes, you will have to start over and load the files one-by-one. To clear all previously loaded instructions from the simulator's memory run `reinitialize`:

```bash
(spim) reinitialize
Loaded: /usr/share/spim/exceptions.s
SPIM Version 9.1.4 of September 4, 2011
Copyright 1990-2010, James R. Larus.
All Rights Reserved.
SPIM is distributed under a BSD license.
See the file README for a full copyright notice.
(spim)
```

Actually, if even if you accidentally loaded the same file twice, you will need to `reinitialize` to fix the error.

## Study `main.s`

Close SPIM, open your favorite text editor and look at `main.s`. The top lines are comments:

```MIPS
# filename: main.s
# purpose:  test output facilities in print.s and input facilities in read.s
```

The following lines:

```MIPS
.text
.globl  main
.ent  main
```

are a preamble that lets MIPS know that the following lines of code are instructions, declares a subroutine called `main` *for linking purposes*, and labels the entry point for `main` when debugging the code. The first bit of real MIPS code is here:

```MIPS
main:
  la  $a0,format1  # Load address of format string #1 into $a0
  jal printf       # call printf
```

`main:` labels the next instruction as `main`. From above, when `run` is executed, it looks for an instruction labelled `main`, and runs that. `la` loads an address in memory into a register. A register is a series of flip-flops on the microprocessor that stores data. A microprocessor has a limited number of these. With MIPS32, these registers are generally 32-bits in size, and can hold either data or memory addresses. `la  $a0,format1` takes the pointer `format1` and loads its value into the register `$a0`. 

`jal printf` is a function call. Each line of instruction in your code is associated with an address. Your main function starts at 0 (this is simulated). The program will march through each line in your code, line by line. It runs line 0. Then it runs line 1, and so on until it hits the sequence of commands to quit. In a high-level language we would alter the control flow with if, switch, for, etc. With `jal` we explicitly tell it to skip to a specific address or block. For example, the above line of code jumps to the block of code labeled printf which you can find in the file printf.s (look at this file and note the line printf:). How are arguments passed? Note that we load values into the registers $a0, $a1, etc. before calling printf. For these lines of code, we pass it `format1`. It is defined on lines 51-52:

```MIPS
...
.data
format1: 
  .asciiz "Hello world.\n"        # asciiz adds trailing null byte to string
```

Note that this section starts with `.data` indicating that what follows should be read into memory, rather than treated as instructions. `format1:`, much like the `main:` labels the next instruction. Thus, when `la  $a0,format1` is carried out, `$a0` is loaded with the memory location of wherever in memory `format1` is located. Note that strings in C-language are an array of `char`s with a null terminator, denoted in MIPS as the type `.asciiz`. This is roughly equivalent to the following C code:

```c
printf( "Hello world\n!" );
```

except in our MIPS code, we have to explicitly create the string literal and place it into memory. Now consider lines 19-21, and line 53:

```MIPS
  la  $a0,format2  # load address of format string #2 into $a0
  li  $a1, 10      # test %d format - load 10 into $a1
  jal printf       # call printf
...
format2: 
  .asciiz "Register $a1 holds: %d\n"  
```

This is similar to the C code:

```c
printf( "Register $a1 holds: %d\n", 10 );
```

Take your time studying the operation of `main.s` and the `printf` function. Pay particular attention to the format specifiers `%d`.

## Lab check off

For full credit, you should get the program to ask for two integers add them together and display the result. For example:

```bash
Enter the first number [return]:
1
Enter the second number [return]:
1
Adding them together is 2.
(spim)
```
*Hint: Make your changes in read.s.*

## Pitfalls

Though you were given a C-style `printf`, you should not make calls to `printf` from within `read.s`. The reason for that is you arrive at `read.s` through a `jal` call from `main.s`. The address to return back into `main.s` is stored in the register `$ra`. Note that at the end of the `read` function, you `jr $ra` to get back to `main`. However, calling another function (such as `printf`) from within `read.s` will cause `$ra` to become overwritten, thus stuck will be stuck in a loop. You should stick to using `syscall` for I/O. Consult the following for more information about it:

* https://courses.missouristate.edu/KenVollmar/mars/Help/SyscallHelp.html

# Discussion

Insert responses to this in your lab report:

1. Why must you use `la` when referring to a string literal?
2. What will happen when you attempt to print a string but specify `%d` instead of `%s`?
3. What is the purpose of `.ent main`
