HEX

E804000 CONSTANT BSC1                   \ Base address of BSC1 register
BSC1 CONSTANT CONTROL                   \ Control register address
4 BSC1 + CONSTANT STATUS                \ Status register address
8 BSC1 + CONSTANT DATA_LENGTH           \ Data Length register address
0C BSC1 + CONSTANT SLAVE_ADDRESS        \ Slave Address register address
10 BSC1 + CONSTANT DATA_FIFO            \ Data FIFO register address

\ Safely set to 1 register bits
: SET_REGISTER ( value register_address -- )
    DUP                \ value register_address register_address
    @                  \ value register_address register_value
    ROT                \ register_address register_value value
    OR                 \ register_address new_register_value
    SWAP               \ new_register_value register_address
    !
;

\ Sets GPIO2 and GPIO3 to ALT0
: CONFIG_I2C_GPIO
    2 4 SET_GPFSEL          \ Sets FSEL2 to 100
    3 4 SET_GPFSEL          \ Sets FSEL3 to 100 
;

\ Resets the Status Register setting:
\ bit 1 (Transfer Done) to 1,
\ bit 8 (Ack Error) to 1,
\ bit 9 (Clock Stretch Timeout) to 1
: RESET_STATUS 
    302 STATUS SET_REGISTER
;

\ Resets FIFO setting bit 4 (FIFO Clear) to 1
: RESET_FIFO
    10 CONTROL SET_REGISTER
;

\ Sets the number of bytes of data to transmit or receive to 1
: SET_DATA_LENGTH
    1 DATA_LENGTH !
;

\ Sets the slave address 
: SET_SLAVE 
    27 SLAVE_ADDRESS !
;

\ Stores data in Data FIFO register
: STORE_FIFO ( data -- )
    DATA_FIFO !
;

\ Starts a new transfer setting 
\ bit 0 (Read Transfer) to 0
\ bit 7 (Start Transfer) to 1 
\ bit 15 (I2C enable) to 1 
: START_TRANSFER
    CONTROL @ 1 BIC CONTROL !        \ clear bit 0
    8080 CONTROL SET_REGISTER        \ set bit 7 and bit 15
;

\ Sends 8 bit using i2c
: SEND
    RESET_STATUS 
    RESET_FIFO
    SET_DATA_LENGTH
    SET_SLAVE
    STORE_FIFO
    START_TRANSFER
;