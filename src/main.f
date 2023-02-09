HEX

\ Executes the program
: RUN ( -- )
    INITIALIZE_LCD
    CLEAR SEND_COMMAND          \ Sends clear command to LCD
    INITIALIZE_PERIPHERALS      
    GREEN_LED ON                \ Turns on the green LED
    
    BEGIN   \ If the hall sensor does not detect the magnet and the alarm is off
        HALL_SENSOR_STATUS 1 = BUZZER_STATUS 0 = AND IF   
            GREEN_LED OFF       
            RED_LED ON 
            BUZZER ON
            CLEAR SEND_COMMAND
            DOOR OPEN SEND_WORD SEND_WORD    \ Sends words to LCD
        THEN    \ If the hall sensor detect the magnet, the alarm is on and the button is pressed  
        BUTTON_STATUS 1 = HALL_SENSOR_STATUS 0 = BUZZER_STATUS 1 = AND AND IF
            RED_LED OFF             
            GREEN_LED ON 
            BUZZER OFF
            CLEAR SEND_COMMAND
            DOOR CLOSED SEND_WORD SEND_WORD    \ Sends words to LCD
        THEN
    0 UNTIL
;
