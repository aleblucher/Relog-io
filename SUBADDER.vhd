library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--------------------------------------------------------

entity SUBADDER is

generic(n: natural :=2);
port(	
	
	A:	in std_logic_vector(n-1 downto 0);
	B:	in std_logic_vector(n-1 downto 0);
	zf:	out std_logic;
	sum:	out std_logic_vector(n-1 downto 0)
);

end SUBADDER;

--------------------------------------------------------

architecture behv of SUBADDER is

-- define a temparary signal to store the result

signal result: std_logic_vector(n downto 0);
 
begin					  
 
    -- the 3rd bit should be carry
   
	result <= ('0' & A)-('0' & B);
	zf <=
		'1' when result<0 else
		'0' when result>0;		

end behv;

--------------------------------------------------------