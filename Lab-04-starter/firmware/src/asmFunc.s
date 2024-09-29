/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */

.global balance,transaction,eat_out,stay_in,eat_ice_cream,we_have_a_problem
.type balance,%gnu_unique_object
.type transaction,%gnu_unique_object
.type eat_out,%gnu_unique_object
.type stay_in,%gnu_unique_object
.type eat_ice_cream,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
balance:           .word     0  /* input/output value */
transaction:       .word     0  /* output value */
eat_out:           .word     0  /* output value */
stay_in:           .word     0  /* output value */
eat_ice_cream:     .word     0  /* output value */
we_have_a_problem: .word     0  /* output value */

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: the integer value returned to the C function
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    LDR r1,=balance
    LDR r2,[r1]
    ADD r0,r0,r2
.endif
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    
    /* This section is deticated to setting all outputs to 0, except balance */
     MOV r1, 0
     
     LDR r2, =transaction
     LDR r3, =eat_out
     LDR r4, =stay_in
     LDR r5, =eat_ice_cream
     LDR r6, =we_have_a_problem
    
     STR r1, [r2]
     STR r1, [r3]
     STR r1, [r4]
     STR r1, [r5]
     STR r1, [r6]
     
     /* Now we take our value from r0 and move it to 'transaction' */
     STR r0, [r2]
     
    /* This section compares the transaction amout and determines if a branch is neccessary */
    CMP r0, 1000
    BGT out_of_range
    CMP r0, -1000
    BLT out_of_range
    
    /* At this point, it is in range, so we calculate the temp balance in R12*/
    LDR r10, =balance
    LDR r11, [r10]
    ADDS r12, r0, r11
    BVS out_of_range @ if there is an overflow, use the out_of_range instructions
    
    /* Our temp balance is good to go, so let's set balance equal to temp balance. Temp
    balance is located in R12 and the address of balance is located in r10.*/
    STR r12, [r10]
    
    /* Now we check to see if the balance is positive or negative, and branch
     accordingly */
    CMP r12, 0
    BGT positive_balance_directive
    CMP r12, 0
    BLT negative_balance_directive
    B zero_balance
    
positive_balance_directive:
    LDR r10, =eat_out
    MOV r11, 1
    STR r11, [r10]
    MOV r0, r12
    B done
    
negative_balance_directive:
    LDR r10, =stay_in
    MOV r11, 1
    STR r11, [r10]
    MOV r0, r12
    B done
    
zero_balance:
    LDR r10, =eat_ice_cream
    MOV r11, 1
    STR r11, [r10]
    MOV r0, r12
    B done

out_of_range:
    /* This directive is for when the transaction vale is out of range */
    
    /* Here is updating the value stored at 'we have a problem' to 1*/
    LDR r11, =we_have_a_problem
    MOV r12, 1
    STR r12, [r11]
    
    /* Here is updating the value stored at 'transaction' to 0*/
    LDR r11, =transaction
    MOV r12, 0
    STR r12, [r11]
    
    /* Here is updating the value stored at r0 to the values stored at 'balance'*/
    LDR r11, =balance
    LDR r0, [r11]
    
    B done
   
    
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




