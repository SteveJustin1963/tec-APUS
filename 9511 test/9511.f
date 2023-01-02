: pushData ( n -- )
   DATA_PORT c@ swap
   DATA_PORT c!
;

: popData ( -- n )
   DATA_PORT c@
   DATA_PORT c@
;

: awaitResult ( -- )
   BEGIN
      STATUS_PORT c@ AND BUSY
   UNTIL
   0=
;

: start ( -- )
   1 DE! 1 HL!
   pushData
   DE HL!
   pushData
   SADD COMMAND_PORT c!
   awaitResult
   popData
   RESULT !
;

$800 start 
