library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------

entity ADDER is

generic(n: natural :=2);
port(	A:	in std_logic_vector(n-1 downto 0);
	B:	in std_logic_vector(n-1 downto 0);
	carry:	out std_logic;
	sum:	out std_logic_vector(n-1 downto 0)
);

end ADDER;

--------------------------------------------------------

architecture behv of ADDER is

-- define a temparary signal to store the result

SIGNAL A_SIGNAL, B_SIGNAL, RESULT_SIGNAL: unsigned((n-1) downto 0);
SIGNAL zz: std_logic;
 
begin					  
 
	A_SIGNAL <= unsigned(a);
	B_SIGNAL <= unsigned(b);
	
	RESULT_SIGNAL <= B_SIGNAL + A_SIGNAL;
    -- the 3rd bit should be carry
   
    sum <= std_logic_vector(RESULT_SIGNAL);

end behv;

--------------------------------------------------------
