library ieee;
use ieee.std_logic_1164.all;

--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

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
		button:	in std_logic;
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : OUT STD_LOGIC_VECTOR(6 downto 0);
		SW : IN STD_LOGIC_VECTOR(18-1 downto 0)
	);

end IO_T;

--------------------------------------------------------

architecture behv of IO_T is
SIGNAL hr: std_logic_vector(13 DOWNTO 0);
SIGNAL min, min_dec: std_logic_vector(6 DOWNTO 0); --for debunggin only 
SIGNAL saida_clk, saida_clk1, saida_clk2, saida_clk3, saida_clk4, saida_clk5, saida_clk6, teste_io_time, bagulho, teste_bagulho, habH0, habH1, habH2, habH3, reset: std_logic;
SIGNAL HEX_11, HEX_22, HEX_33, HEX_44: STD_LOGIC_VECTOR(6 downto 0);
SIGNAL results, clk_out:	std_logic_vector(dataWidth-1 downto 0);
SIGNAL HEX00, HEX11, HEX22, HEX33, HEX44 : STD_LOGIC_VECTOR(6 downto 0);

SIGNAL IOMODE: std_logic_vector(addrWidth downto 0);
begin	
	
	

-- define a temparary signal to store the result


	-- se ler 1 manda para zero

	TEMPO_SEG3: ENTITY work.divisorGenerico GENERIC MAP (divisor=> 50000000) PORT MAP (clk => clk, saida_clk => saida_clk, reset => reset);
	
	TEMPO_SEG2: ENTITY work.divisorGenerico GENERIC MAP (divisor=> 25000000) PORT MAP (clk => clk, saida_clk => saida_clk1, reset => reset);
	TEMPO_SEG1: ENTITY work.divisorGenerico GENERIC MAP (divisor=> 12000000) PORT MAP (clk => clk, saida_clk => saida_clk2, reset => reset);
	TEMPO_SEG: ENTITY work.divisorGenerico GENERIC MAP (divisor=> 6000000) PORT MAP (clk => CLK, saida_clk => saida_clk3, reset => reset);
	TEMPO_SEG4: ENTITY work.divisorGenerico GENERIC MAP (divisor=> 3000000) PORT MAP (clk => CLK, saida_clk => saida_clk4, reset => reset);
	TEMPO_SEG5: ENTITY work.divisorGenerico GENERIC MAP (divisor=> 1500000) PORT MAP (clk => CLK, saida_clk => saida_clk5, reset => reset);
	TEMPO_SEG6: ENTITY work.divisorGenerico GENERIC MAP (divisor=> 750000) PORT MAP (clk => CLK, saida_clk => saida_clk6, reset => reset);


	
	HEX_0 : ENTITY work.conversorHex7Seg PORT MAP(dadoHex => data(3 downto 0), saida7seg => HEX_11);
	HEX_1 : ENTITY work.conversorHex7Seg PORT MAP(dadoHex => data(3 downto 0), saida7seg => HEX_22);
	HEX_2 : ENTITY work.conversorHex7Seg PORT MAP(dadoHex => data(3 downto 0), saida7seg => HEX_33);
	HEX_3 : ENTITY work.conversorHex7Seg PORT MAP(dadoHex => data(3 downto 0), saida7seg => HEX_44);
	HEX_7 : ENTITY work.conversorHex7Seg PORT MAP(dadoHex => data(3 downto 0), saida7seg => HEX7);
	IOMODE <= IO_ADDR & data(0);
	
	
	
		with SW(2 downto 0) select
			clk_out <=  "00000000" & saida_clk1 when "001",
						   "00000000" & saida_clk2 when "010",
							"00000000" & saida_clk3 when "011",
							"00000000" & saida_clk4 when "100",
							"00000000" & saida_clk5 when "101",
							"00000000" & saida_clk6 when "110",
							"00000000" & sw(3) when "111",
							"00000000" & saida_clk when others;
							
		reset <= '1' when clk_out(0) = '1' else '0';
							
			
							
		habH0 <= '1' when IO_ADDR = "010" else '0';
		habH1 <= '1' when IO_ADDR = "011" else '0';
		habH2 <= '1' when IO_ADDR = "100" else '0';
		habH3 <= '1' when IO_ADDR = "101" else '0';
		
		process (clk)
		begin
			if rising_edge(clk) then
				if habH0 then 
					HEX0 <= HEX_11;
				end if;
				
				if habH1 then 
					HEX1 <= HEX_22;
				end if;
				
				if habH2 then 
					HEX2 <= HEX_33;
				end if;
				
				if habH3 then 
					HEX3 <= HEX_44;
				end if;
				if IO_ADDR = "110" and data(0) = '1' then 
					HEX4 <= "0111111";
				elsif IO_ADDR = "110" and data(0) = '0' then
					HEX4 <= "0011111";
				end if;
				
			end if;
		end process;
		
		result <= clk_out when IO_ADDR = "000" else
					  SW(11 downto 4) & button when IO_ADDR = "001" else (others => '0');			  
		

										  
										 

		HEX6 <= "111111" & result(0);
 
    -- the 3rd bit should be carry
	 
	 --- case pra selecionar o IO com IO_ADDR 
	 --- cada case pega um dos enderecos do io localizado 
   

end behv;

--------------------------------------------------------
