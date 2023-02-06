 : JF-HERE HERE ;
 : JF-CREATE CREATE ;
 : JF-FIND FIND ;
 : JF-WORD WORD ;
 : HERE JF-HERE @ ;
 : ALLOT HERE + JF-HERE ! ;
 : ['] ' LIT , ;
 IMMEDIATE : ' JF-WORD JF-FIND >CFA ;
 : CELL+ 4 + ;
 : ALIGNED 3 + 3 INVERT AND ;
 : ALIGN JF-HERE @ ALIGNED JF-HERE ! ;
 : CREATE JF-WORD JF-CREATE DOCREATE , ;
 : (DODOES-INT) ALIGN JF-HERE @ LATEST @ >CFA ! DODOES> ['] LIT , LATEST @ >DFA , ;
 : (DODOES-COMP) (DODOES-INT) ['] LIT , , ['] FIP! , ;
 : DOES>COMP ['] LIT , HERE 3 CELLS + , ['] (DODOES-COMP) , ['] EXIT , ;
 : DOES>INT (DODOES-INT) LATEST @ HIDDEN ] ;
 : DOES> STATE @ 0= IF DOES>INT ELSE DOES>COMP THEN ;
 IMMEDIATE HEX FE200000 CONSTANT PERI_BASE 1 CONSTANT OUTPUT 0 CONSTANT INPUT : DELAY BEGIN 1 - DUP 0 = UNTIL DROP ;
 : FSEL>ADDRESS A / 4 * PERI_BASE + ;
 : FSEL>VALUE FSEL>ADDRESS @ ;
 : MASK SWAP A MOD 3 * LSHIFT ;
 : BIC INVERT AND ;
 : BIC_MASK 7 MASK ;
 : MSB 4 RSHIFT ;
 : LSB 0F AND ;
 : R@ R> R> TUCK >R >R ;
 : SET_GPFSEL OVER BIC_MASK ROT ROT SWAP DUP ROT MASK SWAP DUP FSEL>VALUE >R ROT R> SWAP BIC ROT OR SWAP FSEL>ADDRESS ! ;
 : SET_CLR_MASK DUP 20 < IF 1 SWAP LSHIFT ELSE DUP 1F > IF 1 SWAP 20 MOD LSHIFT THEN THEN ;
 : ON DUP SET_CLR_MASK SWAP DUP 20 < IF DROP 1C PERI_BASE + ! ELSE DUP 1F > IF DROP 20 PERI_BASE + ! THEN THEN ;
 : OFF DUP SET_CLR_MASK SWAP DUP 20 < IF DROP 28 PERI_BASE + ! ELSE DUP 1F > IF DROP 2C PERI_BASE + ! THEN THEN ;
 : READ DUP 20 < IF 34 PERI_BASE + @ SWAP RSHIFT 1 AND ELSE DUP 1F > IF 38 PERI_BASE + @ SWAP RSHIFT 1 AND THEN THEN ;
HEX FE804000 CONSTANT BSC1 BSC1 CONSTANT CONTROL 4 BSC1 + CONSTANT STATUS 8 BSC1 + CONSTANT DATA_LENGTH 0C BSC1 + CONSTANT SLAVE_ADDRESS 10 BSC1 + CONSTANT DATA_FIFO : CONFIG_I2C_GPIO 2 4 SET_GPFSEL 3 4 SET_GPFSEL ;
 : RESET_STATUS STATUS @ 302 OR STATUS ! ;
 : RESET_FIFO CONTROL @ 10 OR CONTROL ! ;
 : SET_DATA_LENGTH DATA_LENGTH @ 1 OR DATA_LENGTH ! ;
 : SET_SLAVE SLAVE_ADDRESS @ 7F BIC 27 OR SLAVE_ADDRESS ! ;
 : STORE_FIFO DATA_FIFO @ FF BIC OR DATA_FIFO ! ;
 : START_TRANSFER CONTROL @ 1 BIC 8080 OR CONTROL ! ;
 : SEND RESET_STATUS RESET_FIFO SET_DATA_LENGTH SET_SLAVE STORE_FIFO START_TRANSFER ;
 HEX 02 CONSTANT FUNCTION_SET 01 CONSTANT CLEAR : DOOR 20 52 4F 4F 44 5 ;
 : CLOSED 20 44 45 53 4F 4C 43 7 ;
 : OPEN 20 4E 45 50 4F 5 ;
 : SEND_NIBBLE SWAP 4 LSHIFT OR SEND 1000 DELAY ;
 : SEND_COMMAND DUP MSB SWAP LSB SWAP DUP 0C SEND_NIBBLE 08 SEND_NIBBLE DUP 0C SEND_NIBBLE 08 SEND_NIBBLE ;
 : SEND_DATA DUP MSB SWAP LSB SWAP DUP 0D SEND_NIBBLE 09 SEND_NIBBLE DUP 0D SEND_NIBBLE 09 SEND_NIBBLE ;
 : INITIALIZE_LCD CONFIG_I2C_GPIO FUNCTION_SET SEND_COMMAND ;
 : SEND_WORD >R BEGIN R> 1 - >R SEND_DATA R@ 0 = UNTIL R> DROP ;
 HEX 1A CONSTANT RED_LED 10 CONSTANT GREEN_LED 6 CONSTANT BUZZER 19 CONSTANT BUTTON 1B CONSTANT HALL_SENSOR : INITIALIZE_PERIPHERALS RED_LED OUTPUT SET_GPFSEL GREEN_LED OUTPUT SET_GPFSEL BUZZER OUTPUT SET_GPFSEL BUTTON INPUT SET_GPFSEL HALL_SENSOR INPUT SET_GPFSEL ;
 : BUTTON_STATUS BUTTON READ ;
 : HALL_SENSOR_STATUS HALL_SENSOR READ ;
 : BUZZER_STATUS BUZZER READ ;
HEX : RUN INITIALIZE_LCD CLEAR SEND_COMMAND INITIALIZE_PERIPHERALS GREEN_LED ON BEGIN HALL_SENSOR_STATUS 1 = BUZZER_STATUS 0 = AND IF GREEN_LED OFF RED_LED ON BUZZER ON CLEAR SEND_COMMAND DOOR OPEN SEND_WORD SEND_WORD THEN BUTTON_STATUS 1 = HALL_SENSOR_STATUS 0 = AND IF RED_LED OFF GREEN_LED ON BUZZER OFF CLEAR SEND_COMMAND DOOR CLOSED SEND_WORD SEND_WORD THEN 0 UNTIL ;
