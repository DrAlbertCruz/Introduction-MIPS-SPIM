# printf.s  
# purpose:  MIPS assembly implementation of a C-like printf procedure 
# supports %s, %d, and %c formats up to 3 formats in one call to printf
# all arguments passed in registers (args past 3 are ignored)

# Register Usage: 
#    $a0,$s0 - pointer to format string 
#    $a1,$s1 - format arg1 (optional) 
#    $a2,$s2 - format arg2 (optional) 
#    $a3,$s3 - format arg3 (optional) 
#    $s4  - count of format strings processed so far
#    $s5  - holds the format string (%s,%d,%c,%) 
#    $s6  - pointer to printf buffer
#

.text 
.globl printf

printf:
   subu  $sp, $sp, 36       # setup stack frame
   sw    $ra, 32($sp)       # save local environment
   sw    $fp, 28($sp) 
   sw    $s0, 24($sp) 
   sw    $s1, 20($sp) 
   sw    $s2, 16($sp) 
   sw    $s3, 12($sp) 
   sw    $s4, 8($sp) 
   sw    $s5, 4($sp)
   sw    $s6, 0($sp)  
   addu  $fp, $sp, 36 
                            # grab the args and move into $s0..$s3 registers
   move $s0, $a0            # fmt string
   move $s1, $a1            # arg1 (optional)
   move $s2, $a2            # arg2 (optional)
   move $s3, $a3            # arg3 (optional)

   li   $s4, 0              # set argument counter to zero
   la   $s6, printf_buf     # set s6 to base of printf buffer


main_loop:                   # process chars in fmt string
   lb   $s5, 0($s0)          # get next format flag
   addu $s0, $s0, 1          # increment $s0 to point to next char
   beq  $s5, '%', printf_fmt # branch to printf_fmt if next char equals '%'
   beq  $0, $s5, printf_end  # branch to end if next char equals zero 


printf_putc: 
   sb   $s5, 0($s6)          # if here we can store the char(byte) in buffer 
   sb   $0, 1($s6)           # store a null byte in the buffer
   move $a0, $s6             # prepare to make printf_str(4) syscall  
   li   $v0, 4               # load integer 4 into $v0 reg              
   syscall                   # make the call

   b    main_loop            # branch to continue the main loop

printf_fmt: 
   lb   $s5, 0($s0)           # load the byte to see what fmt char we have 
   addu $s0, $s0, 1           # increment $s0 pointer 

   beq  $s4, 3,  main_loop    # if $s4 equals 3 branch to main_loop 
   beq  $s5,'d', printf_int   # decimal integer 
   beq  $s5,'s', printf_str   # string 
   beq  $s5,'c', printf_char  # ASCII char 
   beq  $s5,'%', printf_perc  # percent 
   b    main_loop             # if we made it here just continue 


printf_shift_args:            # code to shift to next fmt argument
   move  $s1, $s2             # assign $s2 to $s1 
   move  $s2, $s3             # assign $s3 to $s2 
   add   $s4, $s4, 1          # increment arg count
   b     main_loop            # branch to main_loop

printf_int:                   # print decimal integer
   move  $a0, $s1             # move $s1 into $v0 for print_int syscall
   li    $v0, 1               # load syscall no. 1 into $v0
   syscall                    # execute syscall 1
   b     printf_shift_args    # branch to printf_shift_args to process next arg

printf_str:
   move  $a0, $s1             # move buffer address $s1 to $a0 for print_str(4) 
   li    $v0, 4               # setup syscall - load 4 into $v0 
   syscall
   b    printf_shift_args     # branch to shift_arg loop

printf_char:                  # print ASCII character 
   sb    $s1, 0($s6)          # store byte from $s1 to buffer $s6
   sb    $0,  1($s6)          # store null byte in buffer $s6
   move  $a0, $s6             # prepare for print_str(1) syscall
   li    $v0, 4               # load 1 into $v0
   syscall                    # execute syscall 1
   b     printf_shift_args    # branch to printf_shift_args to process next arg

printf_perc: 
   li   $s5, '%'              # handle %%
   sb   $s5, 0($s6)           # fill buffer with byte %
   sb   $0, 1($s6)            # add null byte to buffer 
   move $a0, $s6              # prepare for print_str(4) syscall
   li   $v0, 4              
   syscall                    # execute the call
   b    main_loop             # branch to main_loop


printf_end:               # callee needs to clean up after itself
   lw   $ra, 32($sp)      # load word at address $sp+32 into return address reg 
   lw   $fp, 28($sp)      # load word at address $sp+28 into frame pointer reg 
   lw   $s0, 24($sp)      # save values at addresses $sp+24 ... $sp+0 
   lw   $s1, 20($sp)      
   lw   $s1, 16($sp)      
   lw   $s1, 12($sp)      
   lw   $s1,  8($sp)      
   lw   $s1,  4($sp)      
   lw   $s1,  0($sp)      
   addu $sp, $sp, 36     # release the stack frame
   jr   $ra              # jump to the return address


.data 

printf_buf:     .space 2

# end of print.s
