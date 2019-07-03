/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(divide_isr, T_DIVIDE)
TRAPHANDLER_NOEC(debug_isr, T_DEBUG)
TRAPHANDLER_NOEC(nmi_isr, T_NMI)
TRAPHANDLER_NOEC(breakpoint_isr, T_BRKPT)
TRAPHANDLER_NOEC(overflow_isr, T_OFLOW)
TRAPHANDLER_NOEC(bounds_check_isr, T_BOUND)
TRAPHANDLER_NOEC(illegal_opcode_isr, T_ILLOP)
TRAPHANDLER_NOEC(device_isr, T_DEVICE)
TRAPHANDLER(double_fault_isr, T_DBLFLT)
TRAPHANDLER(invalid_tss_isr, T_TSS)
TRAPHANDLER(segment_not_present_isr, T_SEGNP)
TRAPHANDLER(stack_isr, T_STACK)
TRAPHANDLER(general_protection_fault_isr, T_GPFLT)
TRAPHANDLER(page_fault_isr, T_PGFLT)
TRAPHANDLER(floating_point_error_isr, T_FPERR)
TRAPHANDLER(alignment_check_isr, T_ALIGN)
TRAPHANDLER(machine_check_isr, T_MCHK)
TRAPHANDLER(SIMD_floating_point_error_isr, T_SIMDERR)







/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
pushl %ds
pushl %es
pushal

movl $GD_KD, %eax
movw %ax, %ds
movw %ax, %es

push %esp
call trap