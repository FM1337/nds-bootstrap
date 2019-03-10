@---------------------------------------------------------------------------------
	.global _arm9_start
@---------------------------------------------------------------------------------
	.align	4
	.arm
    
#define ICACHE_SIZE	0x2000
#define DCACHE_SIZE	0x1000
#define CACHE_LINE_SIZE	32

@---------------------------------------------------------------------------------
_arm9_start:
@---------------------------------------------------------------------------------
	mov	r0, #0x04000000		@ IME = 0;
	add	r0, r0, #0x208
	strh	r0, [r0]

	mov	r0, #0x12		@ Switch to IRQ Mode
	msr	cpsr, r0
	ldr	sp, =__arm9_sp_irq		@ Set IRQ stack

	mov	r0, #0x13		@ Switch to SVC Mode
	msr	cpsr, r0
	ldr	sp, =__arm9_sp_svc		@ Set SVC stack

	mov	r0, #0x1F		@ Switch to System Mode
	msr	cpsr, r0
	ldr	sp, =__arm9_sp_usr		@ Set user stack

	ldr	r0, =__arm9_bss_start	@ Clear BSS section to 0x00
	ldr	r1, =__arm9_bss_end
	sub	r1, r1, r0
	bl	ClearMem

	mov	r0, #0			@ int argc
	mov	r1, #0			@ char *argv[]
	ldr	r3, =arm9_main
	bl	_blx_r3_stub		@ jump to user code

	@ If the user ever returns, restart
	b	_arm9_start

@---------------------------------------------------------------------------------
_blx_r3_stub:
@---------------------------------------------------------------------------------
	bx	r3


@---------------------------------------------------------------------------------
@ Clear memory to 0x00 if length != 0
@  r0 = Start Address
@  r1 = Length
@---------------------------------------------------------------------------------
ClearMem:
@---------------------------------------------------------------------------------
	mov	r2, #3			@ Round down to nearest word boundary
	add	r1, r1, r2		@ Shouldn't be needed
	bics	r1, r1, r2		@ Clear 2 LSB (and set Z)
	bxeq	lr			@ Quit if copy size is 0

	mov	r2, #0
ClrLoop:
	stmia	r0!, {r2}
	subs	r1, r1, #4
	bne	ClrLoop
	bx	lr
    
    
.global cacheFlush
.type	cacheFlush STT_FUNC
cacheFlush:
	stmfd   sp!, {r0-r11,lr}

	@disable interrupt
	ldr r8,= 0x4000208
	ldr r11,[r8]
	mov r7, #0
	str r7, [r8]

//---------------------------------------------------------------------------------
IC_InvalidateAll:
/*---------------------------------------------------------------------------------
	Clean and invalidate entire data cache
---------------------------------------------------------------------------------*/
	mcr	p15, 0, r7, c7, c5, 0

//---------------------------------------------------------------------------------
DC_FlushAll:
/*---------------------------------------------------------------------------------
	Clean and invalidate a range
---------------------------------------------------------------------------------*/
	mov	r1, #0
outer_loop:
	mov	r0, #0
inner_loop:
	orr	r2, r1, r0			@ generate segment and line address
	mcr p15, 0, r7, c7, c10, 4
	mcr	p15, 0, r2, c7, c14, 2		@ clean and flush the line
	add	r0, r0, #CACHE_LINE_SIZE
	cmp	r0, #DCACHE_SIZE/4
	bne	inner_loop
	add	r1, r1, #0x40000000
	cmp	r1, #0
	bne	outer_loop

//---------------------------------------------------------------------------------
DC_WaitWriteBufferEmpty:
//---------------------------------------------------------------------------------               
	MCR     p15, 0, R7,c7,c10, 4

	@restore interrupt
	str r11, [r8]

	ldmfd   sp!, {r0-r11,lr}
	bx      lr
	.pool

.global callmemsearch32
.type	callmemsearch32 STT_FUNC
callmemsearch32:
    stmfd   sp!, {r5-r11,lr}

	ldr		r6, memsearch32location

	bl		_blx_r6_stub_memsearch32	

	ldmfd   sp!, {r5-r11,pc}
	bx      lr
_blx_r6_stub_memsearch32:
	bx	r6	
.pool
memsearch32location:
.word   0x8

.global callmemsearch16
.type	callmemsearch16 STT_FUNC
callmemsearch16:
    stmfd   sp!, {r5-r11,lr}

	ldr		r6, memsearch16location

	bl		_blx_r6_stub_memsearch16	

	ldmfd   sp!, {r5-r11,pc}
	bx      lr
_blx_r6_stub_memsearch16:
	bx	r6	
.pool
memsearch16location:
.word   0x88

