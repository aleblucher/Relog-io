library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity relogio is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		clk: 							in std_logic;
		reset: 						in std_logic;
		input:						in std_logic_vector((DATA_WIDTH-1) downto 0);
		output:						out std_logic_vector((DATA_WIDTH-1) downto 0);
		
	);

end entity;

architecture rtl of unsigned_adder_subtractor is
begin
	RegSec: entity work.register_8(rtl) port map(clk, sec_reset, sec_input, sec_output);
		  
	RegMin: entity work.register_8(rtl) port map(clk, min_reset, min_input, min_output);
		  
	RegHora: entity work.register_8(rtl) port map(clk, hora_reset, hora_input, hora_output);
	
	RegOperation: entity work.register_8(rtl) port map(clk, op_reset, op_input, op_output);
		  
		  
	
	process (clk, reset)
	begin
		-- Reset whenever the reset signal goes low, regardless of the clock
		if (reset = '0') then
			output<= '0';
		-- If not resetting, update the register output on the clock's rising edge
		elsif (rising_edge(clk)) then
			output <= input;
		end if;
	end process;

end rtl;

