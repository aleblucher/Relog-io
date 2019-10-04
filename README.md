# Relog-io

OPCODE | USAGE                                                     | DESRIPTION
---    | ---                                                       | ---
000    | IO    [MODE<1>]        [IO_ADDRESS<3>]   [REG_ADDRESS<3>] |
001    | SUBC  [ADDRESS_REG<3>] [IMEDIATE<9>]                      |
010    | JMPZ  [ADDRESS<9>]                                        |
011    | SETE  [ADDRESS_REG<3>] [IMEDIATE<9>]                      |
100    | COUNT [ADDRESS_REG<3>]                                    |
101    | JMP   [ADDRESS<9>]                                        |
111    |                                                           |




## Code example V0.2

```
INICIO: 
IO 0 0 0
SUBC 0 1
JMPZ INICIO
COUNT 1
SUBC 1 60
JMPZ MINPROC

MINPROC:
COUNT 2
IO 1 2 2
SUBC 2 60
JMPZ HRPROC

HRPROC
COUNT 3
IO 1 3 3
SUBC 3 60
JMP INICIO



```




#### CheatSheet

------

##### Mode IO
- 0 READ MODE
- 1 WRITE MODE

##### IO ADDRESS
- 0 TIME IO
- 1 BUTTON 1 IO
- 2 MIN SEGMENTS IO
- 2 HOUR SEGMENTS IO

##### IO ADDRESS
- 0 TIME IO FLAG
- 1 SECOND REGISTER
- 2 MIN REGISTER
- 2 HOUR REGISTER

