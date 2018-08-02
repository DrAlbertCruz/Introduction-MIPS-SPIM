# filename: main.s
# purpose:  test output facilities in print.s and input facilities in read.s

#  spim> re "main.s"
#  spim> re "printf.s"
#  spim> re "read.s"
#  spim> run
#  spim> exit 

.text
.globl  main
.ent  main

main:
  la  $a0,format1  # Load address of format string #1 into $a0
  jal printf       # call printf

                   # test single %d 
  la  $a0,format2  # load address of format string #2 into $a0
  li  $a1, 10      # test %d format - load 10 into $a1
  jal printf       # call printf

                   # test three %d format strings
  la  $a0,format3  # load address of format string #3 into $a0
  li  $a1, 2       # load integer 2 as first arg 
  li  $a2, 3       # load integer 3 as second arg
  li  $a3, 5       # load integer 5 as third arg
  jal printf       # call printf

                   # test %s
  la  $a0,format4  # load address of format string #4 into $a0
  la  $a1,a_string # load address of arbitrary string 
  jal printf       # call printf

                   # test %c
  la  $a0,format5  # load address of format string #5 into $a0
  lb  $a1,a_char   # load arbitrary byte to $a1 
  jal printf       # call printf


  jal read         # run the read procedure

  li  $v0,10       # 10 is exit system call
  syscall    

.end  main



.data
format1: 
  .asciiz "Hello world.\n"        # asciiz adds trailing null byte to string
format2: 
  .asciiz "Register $a1 holds: %d\n"  
format3: 
  .asciiz "%d plus %d is %d\n"
a_string:
  .asciiz "I am a string"
format4: 
  .asciiz "The string is: %s\n"
a_char:
  .byte 'a' 
format5: 
  .asciiz "The char is: %c\n"
