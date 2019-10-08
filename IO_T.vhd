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
		button:	in std_logic;
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6 : OUT STD_LOGIC_VECTOR(6 downto 0)
	);

end IO_T;

--------------------------------------------------------

architecture behv of IO_T is
SIGNAL hr: std_logic_vector(13 DOWNTO 0);
SIGNAL min, min_dec: std_logic_vector(6 DOWNTO 0); --for debunggin only 
SIGNAL saida_clk: std_logic;
SIGNAL HEXXX: STD_LOGIC_VECTOR(6 downto 0);
begin	
	
	

-- define a temparary signal to store the result

	TEMPO_SEG: ENTITY work.divisorGenerico PORT MAP (clk => clk, saida_clk => saida_clk);

	
	HEX_X : ENTITY work.conversorHex7Seg PORT MAP(dadoHex => data(3 downto 0), saida7seg => HEXXX);
	
	process (ALL)
	begin
		case IO_ADDR is --conversor pra numero
			
			
			when "000" =>-- time IO
				result <= "00000000" & saida_clk;
				
				
				
			when "001" =>-- button
				result <= (others => button);
				
				
				
			when "011" =>-- MIN SEG o decimal
				HEX0 <= "1111111";
	
				
				
				
			when "010" =>-- MIN SEG o nao decimal			
				HEX1 <= "1111111";
				
			when "100" =>-- HR SEG
				HEX2 <= "1111111";
			when "101" =>-- HR SEG
				HEX3 <= "1100111";
			when others =>
				HEX3 <= "1111111";
		end case;
	
	
	
		
		
		HEX0 <= hr(13 downto 7);
		HEX1 <= hr(6 downto 0);
		HEX2 <= min;
		HEX3 <= min_dec;
		displays_7seg <= hr & min_dec & min;
		
		
		
		

	end process;

 
		

	
	
 
    -- the 3rd bit should be carry
	 
	 --- case pra selecionar o IO com IO_ADDR 
	 --- cada case pega um dos enderecos do io localizado 
   

end behv;

--------------------------------------------------------
