# Introduction-MIPS-SPIM

CMPS 3240 Computer Architecture/CMPS 2240 Assembly Language: Introduction to MIPS assembly language and the SPIM simulator

# Introduction

## Requirements

* A SPIM simulator on your machine. We will begin to learn assembly language with MIPS32 (MIPS for the rest of the manual). It is much easier to understand and get into than x86. However, the microprocessor you are using is likely an x86 processor. Because assembly instructions are low level operations to be fed to the microprocessor, MIPS instructions cannot be understood by the machine you are working on. We could either cross-compile the code, or use a simulator. We will use the later.
* Understand how to use the C-language `printf()`
* Review the operation of `read.s` before coming to lab

### Installing the SPIM simulator

If you are using the department server, ignore this step. SPIM is already installed on the department servers. If you want to use your own device, please consult this resource for instructions:

* http://spimsimulator.sourceforge.net/

## Objectives

* Write a MIPS program that makes function calls
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
(spim)
```

or similar. Your must load each `.s` file one-by-one. Assuming you're in the cloned directory:

```bash
(spim) load "printf.s"
(spim) load "main.s"
(spim) load "read.s"
(spim) run
```

If you get any errors please check for typos.

# Discussion
