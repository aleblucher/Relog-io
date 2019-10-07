library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--------------------------------------------------------

entity IO_T is
	generic(
			  dataWidth : natural := 9;
			  addrWidth : natural := 3
		 );
	port(	
		clk: in std_logic;
		enable: in std_logic;
		
		mode:	in std_logic;
		IO_ADDR:	in std_logic_vector(addrWidth-1 downto 0);
		data: in std_logic_vector(dataWidth-1 downto 0);
		result:	out std_logic_vector(dataWidth-1 downto 0);
		displays_7seg: out std_logic_vector(28-1 downto 0);
		button:	in std_logic
	);

end IO_T;

--------------------------------------------------------

architecture behv of IO_T is
SIGNAL hr: std_logic_vector(13 DOWNTO 0);
SIGNAL min, min_dec: std_logic_vector(6 DOWNTO 0); --for debunggin only 
SIGNAL saida_clk: std_logic;
begin	
	
	

-- define a temparary signal to store the result

	TEMPO_SEG: ENTITY work.divisorGenerico PORT MAP (clk => clk, saida_clk => saida_clk);


	process (enable)
	begin
			case IO_ADDR is --conversor pra numero
			
			
			when "000" =>-- time IO
				result <= "00000000" & saida_clk;
				
				
				
			when "001" =>-- button
				result <= (others => button);
				
				
				
			when "011" =>-- MIN SEG o decimal
				case (data(3 downto 0)) is
					when x"0" =>
						min_dec <= "1111110";
					when x"1" =>
						min_dec <= "0011000";
					when x"2" =>
						min_dec <= "0110111";
					when x"3" =>
						min_dec <= "0111101";
					when x"4" =>
						min_dec <= "1011001";
					when x"5" =>
						min_dec <= "1101101";
					when x"6" =>
						min_dec <= "1101111";
					when x"7" =>
						min_dec <= "0011110";
					when x"8" =>
						min_dec <= "1111111";
					when x"9" =>
						min_dec <= "1111101";
					when others =>
				end case;
				
				
				
			when "010" =>-- MIN SEG o nao decimal			
				case (data(3 downto 0)) is
					when x"0" =>
						min <= "1111110";
					when x"1" =>
						min <= "0011000";
					when x"2" =>
						min <= "0110111";
					when x"3" =>
						min <= "0111101";
					when x"4" =>
						min <= "1011001";
					when x"5" =>
						min <= "1101101";
					when x"6" =>
						min <= "1101111";
					when x"7" =>
						min <= "0011110";
					when x"8" =>
						min <= "1111111";
					when x"9" =>
						min <= "1111101";
					when others =>
				end case;
				
			when "100" =>-- HR SEG
				case (data(3 downto 0)) is
					when x"0" =>
						hr <= "00000001111110";
					when x"1" =>
						hr <= "00000000011000";
					when x"2" =>
						hr <= "00000000110111";
					when x"3" =>
						hr <= "00000000111101";
					when x"4" =>
						hr <= "00000001011001";
					when x"5" =>
						hr <= "00000001101101";
					when x"6" =>
						hr <= "00000001101111";
					when x"7" =>
						hr <= "00000000011110";
					when x"8" =>
						hr <= "00000001111111";
					when x"9" =>
						hr <= "00000001111101";
					when x"a" =>
						hr <= "00110001111110";
					when x"b" =>
						hr <= "00110000011000";
					when x"c" =>
						hr <= "00110000110111";
					when others =>
				end case;
			when others =>
		end case;
	
	
	
		
		
		
		displays_7seg <= hr & min_dec & min;
		
		
		
		

	end process;

 
		

	
	
 
    -- the 3rd bit should be carry
	 
	 --- case pra selecionar o IO com IO_ADDR 
	 --- cada case pega um dos enderecos do io localizado 
   

end behv;

--------------------------------------------------------
