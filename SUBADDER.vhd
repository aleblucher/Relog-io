-- Quartus Prime VHDL Template
-- Signed Adder/Subtractor

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SUBADDER is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		a		: in std_logic_vector ((DATA_WIDTH-1) downto 0);
		b		: in std_logic_vector ((DATA_WIDTH-1) downto 0);
		enable_sub    : in std_logic;
		zf    : out std_logic;
		result	: out std_logic_vector ((DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of SUBADDER is

SIGNAL A_SIGNAL, B_SIGNAL, RESULT_SIGNAL: unsigned((DATA_WIDTH-1) downto 0);
SIGNAL zz: std_logic;

begin
	A_SIGNAL <= unsigned(a);
	B_SIGNAL <= unsigned(b);
	

	
	process(a,b, enable_sub)
	begin
	
		if (enable_sub = '1') then
			if (A_SIGNAL - B_SIGNAL = "000000000") then
				RESULT_SIGNAL <= (A_SIGNAL - B_SIGNAL);
				zz <= '1';
			else
				RESULT_SIGNAL <= A_SIGNAL;
				zz <= '0';
			end if;
		end if;
		
		

	end process;
	
	zf <= zz;
	result <= std_logic_vector(RESULT_SIGNAL);
	

end rtl;
