# Relog-io

OPCODE | USAGE                                                     | DESRIPTION
---    | ---                                                       | ---
000    | IO    [MODE<1>]        [IO_ADDRESS<3>]   [REG_ADDRESS<3>] |
001    | SUBC  [ADDRESS_REG<3>] [IMEDIATE<9>]                      |
010    | JMPZ  [ADDRESS<9>]                                        |
011    | SETE  [ADDRESS_REG<3>] [IMEDIATE<9>]                      |
100    | COUNT [ADDRESS_REG<3>]                                    |
101    | JMP   [ADDRESS<9>]                                        |
111    | NOP                                                          |




## Code example V0.3

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
SUBC 2 9
JMPZ MINPROC_DEC

MINPROC_DEC:
COUNT 3
IO 1 3 3
SUBC 3 9
JMPZ HRPROC

HRPROC:
COUNT 4
IO 1 4 4
SUBC 4 12
JMPZ HRPROC_DEC

HRPROC_DEC:
COUNT 6
IO 1 6 6
SUBC 6 1
JMPZ HRPROC



```

```
0000000000000000
0010000000000010
0100000000010000
1000010000000000
0010010001111000
0101110000000000
1000100000000000
0001010010000000
0010100000010010
0101011000000000
1001010000000000
0001101101000000
0011010000010010
0101111000000000
1001000000000000
0001100100000000
0011000000011000
0101001100000000
1001100000000000
0001110110000000
0011100000000010
0101111000000000
```



#### CheatSheet

------

##### Mode IO
- 0 READ MODE
- 1 WRITE MODE

##### IO ADDRESS
- 0 TIME IO
- 1 BUTTON 1 IO
- 2 MIN-DEC SEGMENTS IO
- 3 MIN SEGMENTS IO
- 4 HR-DEC SEGMENTS IO
- 5 HR SEGMENTS IO
- 6 AM-PM

##### IO ADDRESS
- 0 TIME IO FLAG
- 1 SECOND REGISTER
- 2 MIN REGISTER
- 3 MIN-DEC REGISTER
- 4 HR REGISTER
- 5 HR-DEC REGISTER

