# filename: read.s
# purpose:  demonstrate MIPS system services for reading and displaying
# user input

.text
.globl read 

read:

  # prompt user to input a string
  li $v0 4         # load immediate with 4 to setup syscall 4 (print_str)
  la $a0 sprompt   # load address of prompt 
  syscall          # display the prompt

  # read the string and display it
  la $a0 buffer   # load address of buffer
  li $v0 8         # setup syscall 8 (read_string)
  syscall          # address of string buffer returned in $a0
  li $v0 4         # syscall 4 (print_str)
  syscall          # display input 

  # prompt user to input an integer
  li $v0 4         # load immediate with 4 to setup syscall 4 (print_str)
  la $a0 iprompt   # load address of prompt into $a0 for print_str
  syscall          # display the prompt 

  # read the integer and display it 
  li $v0 5         # setup syscall 5 (read_int)
  syscall          # integer returned in $v0
  move $a0 $v0     # move the integer into register $a0
  li $v0 1         # setup syscall 1 (print_int)
  syscall          # make the call to display the integer 
   
  jr $ra

.data

buffer: .space 50
iprompt: .asciiz "Enter an integer [return]:\n"
sprompt: .asciiz "Enter a line of text [return]:\n"
