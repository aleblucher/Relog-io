LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity decoder is
	generic (
        larguraBarramentoEnderecos  : natural := 8;
        larguraBarramentoDados      : natural := 8;
        quantidadeLedsRed           : natural := 18;
        quantidadeLedsGreen         : natural := 8;
        quantidadeChaves            : natural := 18;
        quantidadeBotoes            : natural := 4;
        quantidadeDisplays          : natural := 8
    );

    PORT(
		  flag_z, CLK : IN STD_LOGIC;
		  
		  enable_sub: OUT STD_LOGIC;
		  out_ROM : IN std_logic_vector(15 DOWNTO 0);

		  out_addergen,out_io,out_bank,out_subadder: IN std_logic_vector(8 DOWNTO 0);
		  
		  

		 
		
		  in_bank,
		  in_io
		 
		 : OUT std_logic_vector(8 DOWNTO 0);
		 
		 sel_pc, mode,  enable_pc, enable_io, habilita_escrita: OUT std_logic;
		 
		 op_ula, io_address, reg_address: OUT std_logic_vector(2 DOWNTO 0);
		 
		 imediate: OUT std_logic_vector(8 DOWNTO 0) --for debunggin only 
		
    );

end entity;


	
ARCHITECTURE arch OF decoder is


	 SIGNAL OP_ULAEZFLAG: std_logic_vector(3 DOWNTO 0);
begin
	
	OP_ULAEZFLAG <= op_ula & flag_z;
	 
	 
	 
	 -- ===================== DECODER START ================================ TODO: separated file	
	 op_ula <= out_ROM(2 downto 0);
	 

	 
		 
	with OP_ULAEZFLAG select
	sel_pc <= '1' when "0101",
				'1' when "1011",
				'1' when "1010",
				'0' when others;
				
				
	with op_ula select
	enable_io <= '1' when "000",
				'0' when others;
				
	with op_ula select		
	enable_sub <= '1' when "001",
				'0' when others;
				
		


						
	habilita_escrita <= '1' when (op_ula = "100" or op_ula =  "011" or op_ula = "001" or (op_ula = "000" and mode='0')) else '0';
				


	
	imediate <= out_ROM(14 downto 6) when (op_ula = "100" or op_ula = "001") else 
					out_ROM(11 downto 3) when (op_ula = "101" or op_ula = "010") else					
					"000000000";
	
	reg_address <= out_ROM(5 downto 3) when (op_ula = "100" or op_ula = "011" or op_ula = "010" or op_ula = "001" or op_ula = "000") else
						"XXX";
		
	io_address <= out_ROM(8 downto 6) when op_ula = "000" else
						"000";
						
	in_bank <= out_io when (op_ula = "000" and mode='0') else
				  out_addergen when op_ula = "100" else
				  out_ROM(14 downto 6) when op_ula = "011" else
				  out_subadder when op_ula = "001" else
				  "000000000";
	
	
	in_io <= out_bank when (op_ula = "000" and mode='1') else
				"000000000";
				
				
	mode <= out_ROM(9) when op_ula = "000" else
				'X';
				
		
				
END;