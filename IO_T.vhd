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
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6 : OUT STD_LOGIC_VECTOR(6 downto 0);
		SW : IN STD_LOGIC_VECTOR(18-1 downto 0)
	);

end IO_T;

--------------------------------------------------------

architecture behv of IO_T is
SIGNAL hr: std_logic_vector(13 DOWNTO 0);
SIGNAL min, min_dec: std_logic_vector(6 DOWNTO 0); --for debunggin only 
SIGNAL saida_clk, saida_clk1, saida_clk2, saida_clk3, teste_io_time, bagulho, teste_bagulho: std_logic;
SIGNAL HEXXX: STD_LOGIC_VECTOR(6 downto 0);
SIGNAL results:	std_logic_vector(dataWidth-1 downto 0);
SIGNAL HEX00, HEX11, HEX22, HEX33, HEX44 : STD_LOGIC_VECTOR(6 downto 0);
begin	
	
	

-- define a temparary signal to store the result

	TEMPO_SEG3: ENTITY work.divisorGenerico GENERIC MAP (divisor=> 50000000) PORT MAP (clk => clk, saida_clk => saida_clk3);
	
	TEMPO_SEG2: ENTITY work.divisorGenerico GENERIC MAP (divisor=> 25000000) PORT MAP (clk => clk, saida_clk => saida_clk2);
	TEMPO_SEG1: ENTITY work.divisorGenerico GENERIC MAP (divisor=> 12000000) PORT MAP (clk => clk, saida_clk => saida_clk1);
	TEMPO_SEG: ENTITY work.divisorGenerico GENERIC MAP (divisor=> 6000000) PORT MAP (clk => CLK, saida_clk => saida_clk);
	
	TEMPO_SEG_TICK_BAGULHO: ENTITY work.divisorGenerico(divInteiro) GENERIC MAP (divisor=> 200) PORT MAP (clk => SW(3), saida_clk => bagulho);

	
	HEX_X : ENTITY work.conversorHex7Seg PORT MAP(dadoHex => data(3 downto 0), saida7seg => HEXXX);
	
	process (clk)
	begin
	if saida_clk3 = '1' then
		teste_io_time <=not teste_io_time;
	end if;
	if bagulho='1' then
		teste_bagulho <= not teste_bagulho;
		
	end if;
	end process;
	
	process (ALL)
	begin
	
		
		case IO_ADDR is --conversor pra numero
			
			
			when "000" =>-- time IO
			
--				case SW is
--					when "000000000000000001" =>
--					
--						results <= "00000000" & saida_clk1;
--					when "000000000000000010" =>
--					
--						results <= "00000000" & saida_clk2;
--					when "000000000000000011" =>
--					
--						results <= "00000000" & saida_clk3;
--					when others =>
--					
--						results <= "00000000" & saida_clk;
--				end case;
						results <= "00000000" & sw(3);
--				
				
				
			when "001" =>-- button
				results <= "00000000" & button;
				
				
				
			when "010" =>-- MIN SEG o decimal
				HEX00 <= HEXXX;
	
				
				
				
			when "011" =>-- MIN SEG o nao decimal			
				HEX11 <= HEXXX;
				
			when "100" =>-- HR SEG decimal
				HEX22 <= HEXXX;
			when "101" =>-- HR SEG 
				HEX33 <= HEXXX;
			when "110" =>
				if data(0) then
					HEX44 <= "0111111";
				else
					HEX44 <= "0011111";
				end if;
			when others =>
		end case;
	
	
	
		
		
		
		
		displays_7seg <= hr & min_dec & min;
		
		
		
		

	end process;
		result <= results;
 
		HEX0 <= HEX00;
		HEX1 <= HEX11;
		HEX2 <= HEX22;
		HEX3 <= HEX33;
		HEX4 <= "111111" & sw(3);
		HEX5 <= "111111" & teste_io_time;
		HEX6 <= "111111" & bagulho;
		
	
	
 
    -- the 3rd bit should be carry
	 
	 --- case pra selecionar o IO com IO_ADDR 
	 --- cada case pega um dos enderecos do io localizado 
   

end behv;

--------------------------------------------------------
