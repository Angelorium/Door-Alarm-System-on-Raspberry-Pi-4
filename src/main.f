HEX

\ Executes the program
: RUN ( -- )
    INITIALIZE_LCD
    CLEAR SEND_COMMAND
    INITIALIZE_PERIPHERALS
    GREEN_LED ON 
    
    BEGIN 
        HALL_SENSOR_STATUS 1 = BUZZER_STATUS 0 = AND IF 
            GREEN_LED OFF 
            RED_LED ON 
            BUZZER ON
            CLEAR SEND_COMMAND
            DOOR OPEN SEND_WORD SEND_WORD
        THEN
        BUTTON_STATUS 1 = HALL_SENSOR_STATUS 0 = AND IF 
            RED_LED OFF 
            GREEN_LED ON 
            BUZZER OFF
            CLEAR SEND_COMMAND
            DOOR CLOSED SEND_WORD SEND_WORD 
        THEN
    0 UNTIL
;
