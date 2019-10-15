LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity relogio is
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
		reset: 					in std_logic;
		sw_controll:			in std_logic_vector(5 downto 0);

		
		CLOCK_50 : IN STD_LOGIC;
        -- BOTOES
        KEY: IN STD_LOGIC_VECTOR(quantidadeBotoes-1 DOWNTO 0);
        -- CHAVES
        SW : IN STD_LOGIC_VECTOR(quantidadeChaves-1 downto 0);
        
        -- LEDS
        LEDR : OUT STD_LOGIC_VECTOR(quantidadeLedsRed-1 downto 0);
        LEDG : OUT STD_LOGIC_VECTOR(quantidadeLedsGreen-1 downto 0);
        -- DISPLAYS 7 SEG
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : OUT STD_LOGIC_VECTOR(6 downto 0)
		  
		  
		
    );

end entity;

ARCHITECTURE arch OF relogio is
    SIGNAL out_ROM : std_logic_vector(15 DOWNTO 0);
	 SIGNAL in_pc,
	 out_pc, out_adder, out_addergen,
	 out_bank,
	 in_bank,
	 out_io, in_io,
	 out_subadder
	 : std_logic_vector(8 DOWNTO 0);
    SIGNAL sel_pc, sel_ula, enable_buffer, mode, reset_reg, carry, enable_pc, enable_io, saida_clk, habilita_escrita: std_logic;
	 SIGNAL flag_z: std_logic := '0';
    SIGNAL op_ula, io_address, reg_address: std_logic_vector(2 DOWNTO 0);
	 SIGNAL imediate: std_logic_vector(8 DOWNTO 0); --for debunggin only 
	 SIGNAL display_7seg: std_logic_vector((7*4)-1 downto 0);
	 SIGNAL CLK : std_logic; 
	 SIGNAL enable_sub  : std_logic;
	 SIGNAL OP_ULAEZFLAG: std_logic_vector(3 DOWNTO 0);
    begin
	 

	
	
	 
	CLK <=	CLOCK_50 when sw(17)='0' else
				KEY(0);
	 
	 
	--OP_ULAEZFLAG <= op_ula & flag_z;
	 
	 
	 
	 -- ===================== DECODER START ================================ TODO: separated file	
	--op_ula <= out_ROM(2 downto 0);
	 
		 



				
	DECODER: ENTITY work.decoder PORT MAP(
		CLK => CLK,
		out_ROM => out_ROM,
		out_addergen => out_addergen,
		out_bank => out_bank,
		in_bank => in_bank,
		out_io => out_io, in_io => in_io,
		out_subadder =>out_subadder,
		sel_pc => sel_pc, mode => mode,
		flag_z => flag_z,
		enable_pc => enable_pc, enable_io => enable_io, habilita_escrita => habilita_escrita,
		op_ula => op_ula, io_address => io_address, reg_address => reg_address,
		imediate => imediate,
		enable_sub => enable_sub
    );
	
	IO :ENTITY work.IO_T PORT MAP(clk => clk, 
		enable => enable_io,
		mode => mode,
		IO_ADDR => io_address,
		data => out_bank,
		result => out_io,
		button => sw_controll(0), ---raplace with actual button
		HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2, HEX3 => HEX3, HEX4 => HEX4, HEX5 => HEX5, HEX6 => HEX6, HEX7 => HEX7,
		SW => SW
	);
	
--	IO_TEST : ENTITY work.IO_T PORT MAP(clk => clk, 
--		enable => '1',
--		mode => '1',
--		IO_ADDR => "011",
--		data => "000000010",
--		result => out_io,
--		displays_7seg => display_7seg,
--		button => sw_controll(0),
--		HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2, HEX3 => HEX3, HEX4 => HEX4, HEX5 => HEX5, HEX6 => HEX6,
--		SW => SW
--	);

	ROM: ENTITY work.memoria GENERIC MAP (dataWidth => 16, addrWidth => 9) PORT MAP (Endereco => out_pc , Dado=>out_ROM); --todo parse dado for input
	
	MUX_PC : ENTITY work.mux2 PORT MAP (IN_A => out_adder, IN_B => imediate, sel => sel_pc, mux_out => in_pc);
	 
	--- =============================== ULA =====================================
	ADDER_1 : ENTITY work.ADDER GENERIC MAP (n => 9) PORT MAP (A => "000000001", B => out_pc, sum => out_adder, carry => carry); --define generic default for data n & larguraDados
	ADDER_GENERIC : ENTITY work.ADDER GENERIC MAP (n => 9) PORT MAP (A => imediate, B => out_bank, sum => out_addergen, carry => carry); --define generic default for data n & larguraDados
	
	SUBADDER: ENTITY work.SUBADDER GENERIC MAP (DATA_WIDTH => 9) PORT MAP (A => out_bank, B => imediate, result => out_subadder, zf => flag_z, enable_sub => enable_sub); --define generic default for data n & larguraDados
	 
	 --- ====================================== "BANCO" DE REGISTRADORES =======================================
	
	BR: ENTITY work.bancoRegistradores port map(        
		clk => clk,
			endereco =>  REG_ADDRESS,
			dadoEscrita => in_bank,
        escreve => habilita_escrita,
        saida => out_bank
    );
	 
	PC : ENTITY work.registradorGenerico GENERIC MAP (larguraDados => 9)PORT MAP(data => in_pc, clk => CLK, enable => '1', q => out_pc, RST => '0');
	
	 

	
	
		 

	
	--LEDG(4) <= sel_pc;
	 LEDG(5) <= habilita_escrita;
	
	 LEDG(7) <= flag_z;
	
	  LEDR(11 downto 9) <= io_address;
	--LEDR(4 downto 0) <= imediate(4 downto 0);
	
		LEDG(2 downto 0) <= op_ula;
	

	
	LEDR(8 downto 0) <= out_pc;
	
	
	

END;
    