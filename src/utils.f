HEX

FE200000 CONSTANT PERI_BASE    \ Base address of peripherals
1 CONSTANT OUTPUT   
0 CONSTANT INPUT 

\ Creates a busy loop
: DELAY ( delay_value -- )
    BEGIN 1 - DUP 0 = UNTIL DROP 
;

\ Returns the GPFSEL address of the specified fsel number
: FSEL>ADDRESS ( fsel_number -- gpfsel_register_address ) 
    A / 4 * PERI_BASE + 
;

\ Returns the GPFSEL value of the specified fsel number
: FSEL>VALUE ( fsel_number -- gpfsel_register_value )
    FSEL>ADDRESS @
;

\ Creates bit mask to safely modify GPIO registers value
: MASK ( fsel_number value -- bit_mask)  
    SWAP A MOD 3 * LSHIFT
; 

\ Returns the new_value setting to 0 the specified bit in mask
: BIC ( value mask - new_value)
    INVERT AND
;

\ Creates bit mask to use bic (bit clear)
: BIC_MASK ( fsel_number -- bic_mask )
    7 MASK 
;

\ Gets only the first 4 MSB from a byte
: MSB ( byte -- MSB)
    4 RSHIFT 
;

\ Gets only the first 4 LSB from a byte
: LSB ( byte -- LSB)
    0F AND 
;

\ Copies the top of the return stack wihout affecting it
: R@ ( -- TORS )
    R> R> TUCK >R >R
;
 
\ Sets GPFSEL register to the specified value
: SET_GPFSEL ( fsel_number value -- )   
    OVER                                  \ ( fsel_number value fsel_number ) 
    BIC_MASK                              \ ( fsel_number value bic_mask ) 
    ROT ROT SWAP DUP ROT                  \ ( bic_mask fsel_number fsel_number value )
    MASK                                  \ ( bic_mask fsel_number bit_mask ) 
    SWAP                                  \ ( bic_mask bit_mask fsel_number ) 
    DUP                                   \ ( bic_mask bit_mask fsel_number fsel_number )
    FSEL>VALUE                            \ ( bic_mask bit_mask fsel_number original_value )
    >R ROT R> SWAP                        \ ( bit_mask fsel_number original_value bic_mask )
    BIC                                   \ ( bit_mask fsel_number bic_value ) 
    ROT                                   \ ( fsel_number bic_value bit_mask )
    OR                                    \ ( fsel_number new_value )
    SWAP                                  \ ( new_value fsel_number )
    FSEL>ADDRESS                          \ ( new_value fsel_address )
    !      
;

\ Returns the mask used to set or clear GPIO register
: SET_CLR_MASK ( gpio_pin -- mask )
    DUP 20 < IF 1 SWAP LSHIFT                     \ gpio_pin < 32
    ELSE DUP 1F > IF 1 SWAP 20 MOD LSHIFT         \ gpio_pin > 31
    THEN THEN 
;

\ Sets GPIO register 
: ON ( gpio_pin -- )
    DUP SET_CLR_MASK SWAP
    DUP 20 < IF DROP 1C PERI_BASE + !             \ gpio_pin < 32
    ELSE DUP 1F > IF DROP 20 PERI_BASE + !        \ gpio_pin > 31
    THEN THEN 
;

\ Clears GPIO register 
: OFF ( gpio_pin -- )
    DUP SET_CLR_MASK SWAP
    DUP 20 < IF DROP 28 PERI_BASE + !             \ gpio_pin < 32
    ELSE DUP 1F > IF DROP 2C PERI_BASE + !        \ gpio_pin > 31
    THEN THEN 
;

\ Returns the value of the specified pin
: READ ( gpio_pin -- value )
    DUP 20 < IF 34 PERI_BASE + @ SWAP RSHIFT 1 AND 
    ELSE DUP 1F > IF 38 PERI_BASE + @ SWAP RSHIFT 1 AND 
    THEN THEN 
;