HEX

FE804000 CONSTANT BSC1                   \ Base address of BSC1 register
BSC1 CONSTANT CONTROL                   \ Control register address
4 BSC1 + CONSTANT STATUS                \ Status register address
8 BSC1 + CONSTANT DATA_LENGTH           \ Data Length register address
0C BSC1 + CONSTANT SLAVE_ADDRESS        \ Slave Address register address
10 BSC1 + CONSTANT DATA_FIFO            \ Data FIFO register address

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
    STATUS @ 302 BIC 302 OR STATUS !
;

\ Resets FIFO setting bit 4 (FIFO Clear) to 1
: RESET_FIFO
    CONTROL @ 10 BIC 10 OR CONTROL !
;

\ Sets the number of bytes of data to transmit or receive to 1
: SET_DATA_LENGTH
    DATA_LENGTH @ FFFF BIC 1 OR DATA_LENGTH !
;

\ Sets the slave address 
: SET_SLAVE 
    SLAVE_ADDRESS @ 7F BIC 27 OR SLAVE_ADDRESS !
;

\ Stores data in Data FIFO register
: STORE_FIFO ( data -- )
    DATA_FIFO @ FF BIC OR DATA_FIFO !
;

\ Starts a new transfer setting 
\ bit 0 (Read Transfer) to 0
\ bit 7 (Start Transfer) to 1 
\ bit 15 (I2C enable) to 1 
: START_TRANSFER
    CONTROL @ 8081 BIC 8080 OR CONTROL !
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


\ to Initialize 0c 08 2c 28