.code16
.text  
_init:
  . = 0x7c00
  .global _start
_start:

  #movb $'Z' , %al
  #movb $0x0e , %ah
  #movw $0 , %bx
  #int $0x10

  lgdt GlobalDescriptorTable
  mov %cr0 , %eax 
  orb $1 , %al    
	
  cli       
        mov %eax , %cr0

  mov $0x08 , %bx
  mov %bx , %fs

  movw $0xb800 , %ax
  movw %ax , %ds
  movb $65 , %al
  movb %al , 0

  mov %al , %fs:(%ebx)

GlobalDescriptorTable:

	.hword GlobalDescriptorTableEnd - GlobalDescriptorTable - 1 

	.hword GlobalDescriptorTable - _init
	.byte 0	

	.byte 0, 0

	.byte 0 

        .hword 0xFFFF
	.byte 0, 0, 0
	.byte 0x91 
	.byte 0xCF 
	.byte 0	
	
GlobalDescriptorTableEnd:

  . = _start + 510
  .byte 0x55
  .byte 0xaa
