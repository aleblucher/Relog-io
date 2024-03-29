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
		--clk: 						in std_logic;
		reset: 					in std_logic;
		sw_controll:			in std_logic_vector(5 downto 0);
		fpga_led_pio  : out std_logic_vector(7-1 downto 0);
		led: out std_logic;
		
		CLOCK_50 : IN STD_LOGIC;
        -- BOTOES
        KEY: IN STD_LOGIC_VECTOR(quantidadeBotoes-1 DOWNTO 0);
        -- CHAVES
        SW : IN STD_LOGIC_VECTOR(quantidadeChaves-1 downto 0);
        
        -- LEDS
        LEDR : OUT STD_LOGIC_VECTOR(quantidadeLedsRed-1 downto 0);
        LEDG : OUT STD_LOGIC_VECTOR(quantidadeLedsGreen-1 downto 0);
        -- DISPLAYS 7 SEG
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : OUT STD_LOGIC_VECTOR(6 downto 0):= (others => '1')
		  
		  
		
    );

end entity;

ARCHITECTURE arch OF relogio is
    SIGNAL out_ROM : std_logic_vector(15 DOWNTO 0);
    SIGNAL imediato,
	 in_pc,
	 out_pc, out_adder, out_addergen,
	 out_bank0,
	 out_bank1,
	 out_bank2,
	 out_bank3,
	 out_bank4,
	 out_bank5,
	 out_bank6,
	 out_bank7,
	 out_bank8,
	 out_bank,
	 in_ulaa,  in_ulab,
	 out_ula, in_bank,
	 out_io, in_io,
	 out_subadder
	 : std_logic_vector(8 DOWNTO 0); --can be less???
    SIGNAL sel_pc, sel_ula, enable_buffer, mode, flag_z, reset_reg, carry, enable_pc, enable_io, saida_clk: std_logic;
    SIGNAL op_ula, io_address, reg_address: std_logic_vector(2 DOWNTO 0);
	 SIGNAL imediate, OUTROMIMEDIATLEMIDDLE: std_logic_vector(8 DOWNTO 0); --for debunggin only 
	 SIGNAL display_7seg: std_logic_vector((7*4)-1 downto 0);
	 SIGNAL CLK : std_logic; 
	 SIGNAL OP_ULAEZFLAG: std_logic_vector(3 DOWNTO 0);
	 SIGNAL enable_bank: std_logic_vector(6 DOWNTO 0);
	 SIGNAL OPULAEMODE: std_logic_vector(3 DOWNTO 0);
    begin
	 
	 
	 
	 
	 OP_ULAEZFLAG <= op_ula & flag_z;
	 
	 OPULAEMODE <= op_ula & mode;
	 
	 
	 OUTROMIMEDIATLEMIDDLE <= "000" & out_ROM(8 downto 3);
	 
	 
	 
	 -- ===================== DECODER START ================================ TODO: separated file	
	 op_ula <= out_ROM(2 downto 0);
	 
	 CLK <= CLOCK_50 when sw(16)='0' else
				 SW(17);
	 
		 
	with OP_ULAEZFLAG select
	sel_pc <= '1' when "0101",
				'1' when "1011",
				'1' when "1010",
				'0' when others;
				
	with op_ula select
	enable_io <= '1' when "000",
				'0' when others;
				
				
	LEDR(8 downto 0) <= out_pc;
	
	
	out_bank <= out_bank0 when REG_ADDRESS = "000" else
					out_bank1 when REG_ADDRESS = "001" else
					out_bank2 when REG_ADDRESS = "010" else
					out_bank3 when REG_ADDRESS = "011" else
					out_bank4 when REG_ADDRESS = "100" else
					out_bank5 when REG_ADDRESS = "101" else
					out_bank6 when REG_ADDRESS = "110" else
					out_bank7;
					
	enable_bank <= "0000001" when REG_ADDRESS = "000" else
						"0000010" when REG_ADDRESS = "001" else
						"0000100" when REG_ADDRESS = "010" else
						"0001000" when REG_ADDRESS = "011" else
						"0010000" when REG_ADDRESS = "100" else
						"0100000" when REG_ADDRESS = "101" else
						"1000000" when REG_ADDRESS = "110" else
						"0000000";
						
			
						
						
	mode <= out_ROM(3) when op_ula = "000" else
				'0';
	
	io_address <= out_ROM(6 downto 4) when op_ula = "000" else
				"000";
				
	reg_address <= out_ROM(9 downto 7) when op_ula = "000" else
						out_ROM(9 downto 7) when op_ula = "001" else 
						out_ROM(5 downto 3) when op_ula = "010" else 
						out_ROM(5 downto 3) when op_ula = "011" else
						out_ROM(5 downto 3) when op_ula = "100" else
						"000";
				
--	imediate <= out_ROM(14 downto 6) when op_ula = "101" else
--					out_ROM(14 downto 6) when op_ula = "100" else
--					"000000000";
				
--	in_bank <= out_addergen when op_ula = "100" else
--					out_ROM(14 downto 6) when op_ula = "011" else
--					"000000000";
				
	with OPULAEMODE & flag_z select
	in_bank <= out_io when "0001X",
				out_subadder when "001X1",
				out_addergen when "100XX",
				out_ROM(14 downto 6) when "011XX",
				"000000000" when others;
				
	with OP_ULAEZFLAG select
	in_bank <= out_subadder when "0011",
				"000000000" when others;
				
	with OP_ULAEZFLAG select
		imediate <= out_ROM(14 downto 6) when "0101",
						OUTROMIMEDIATLEMIDDLE when "0010",
						OUTROMIMEDIATLEMIDDLE when "0011",
						out_ROM(14 downto 6) when "1010",
						out_ROM(14 downto 6) when "1011",
						out_ROM(14 downto 6) when "1000",
						out_ROM(14 downto 6) when "1001",
						"000000000" when others;
				
				
				
	with OPULAEMODE select
	in_io <= out_bank when "0001",
				"000000000" when others;
				
	LEDG(0) <= mode;
	LEDG(2) <= sel_pc;
			
				
				
--	imediate(8 downto 3) <= out_ROM(8 downto 3) when op_ula="001" else
--									"000000";
				
	
				
				
	
	 
--	 process (clk)
--	 begin --isso deve ser o CPU ???
--		 case op_ula is
----			when "000" => --IO [MODE] [IO_ADDR] [REG_ADDR]
----				mode <= out_ROM(3);
----				io_address <= out_ROM(6 downto 4);
----				reg_address <= out_ROM(9 downto 7);
----				case mode is
----					when '0' =>
----						in_bank <= out_io;
----					when '1' =>
----						in_io <= out_bank;
----				end case;
--			when "001" => --SUBC [REG_ADDR] [IMEDIATE] if result is zero set zero flag and reset
--			--	reg_address <= out_ROM(9 downto 7);
--			--	imediate(8 downto 3) <= out_ROM(8 downto 3); --ADRRESS location to jump
--				if (flag_z) then
--				--	in_bank <= out_subadder;
--				end if;
--			when "010" => --JUMPZ [REG_ADDR] [IMEDIATE] if result is zero set zero flag and reset
--				flag_z <= flag_z; --the zero flag used in jumps
--		--		reg_address <= out_ROM(5 downto 3);
--				if (flag_z = '1') then
--			--		imediate <= out_ROM(14 downto 6);
--				end if;
--			when "011" =>
--				--useless ? needed (start value?)
--				-- enable item ??
--			--	reg_address <= out_ROM(5 downto 3);
--			--	in_bank <= out_ROM(14 downto 6);
--			when "100" => -- COUNT [REG_ADDRESS] [NUMERO<9>] add 1 to count adress
--		--		reg_address <= out_ROM(5 downto 3);
--			--	imediate <= out_ROM(14 downto 6);
--			--	in_bank <= out_addergen;
--			when "101" => --jmp [ADDRESS] 
--			--	imediate <= out_ROM(14 downto 6); --ADRRESS location to jump
--				-- enable item ??
--			when others =>
--				-- other dont matter
--		end case;
--		
--		
--		
--		
--		
--		
----		case reg_address is
----			when "000" =>
----				enable_bank(0) <= '1';
----				out_bank <= out_bank1;
----			when "001" =>
----				enable_bank(1) <= '1';
----				out_bank <= out_bank2;
----			when "010" =>
----				enable_bank(2) <= '1';
----				out_bank <= out_bank3;
----			when "011" =>
----				enable_bank(3) <= '1';
----				out_bank <= out_bank4;
----			when "100" =>
----				enable_bank(4) <= '1';
----				out_bank <= out_bank5;
----			when "101" =>
----				enable_bank(5) <= '1';
----				out_bank <= out_bank6;
----			when "110" =>
----				enable_bank(6) <= '1';
----				out_bank <= out_bank7;
----			when "111" =>
----				enable_bank(7) <= '1';
----				out_bank <= out_bank8;
----			when others =>
----				enable_bank <= (others => '0');
--		
----		end case;
--		
--		-- ===================== DECODER END ================================
--		
--	end process;
	
--	
	IO : ENTITY work.IO_T PORT MAP(clk => clk, 
		enable => enable_io,
		mode => mode,
		IO_ADDR => io_address,
		data => out_bank,
		result => out_io,
		displays_7seg => display_7seg,
		button => sw_controll(0),
		HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2, HEX3 => HEX3, HEX4 => HEX4, HEX5 => HEX5, HEX6 => HEX6,
		SW => SW
	);
	
--	IO_TEST : ENTITY work.IO_T PORT MAP(clk => clk, 
--		enable => '1',
--		mode => '1',
--		IO_ADDR => "011",
--		data => "000000101",
--		result => out_io,
--		displays_7seg => display_7seg,
--		button => sw_controll(0),
--		HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2, HEX3 => HEX3, HEX4 => HEX4, HEX5 => HEX5, HEX6 => HEX6,
--		SW => SW
--	);
	
	

	
--	ULA : ENTITY work.ula GENERIC MAP (largura => 10) PORT MAP(A => in_ulaa, B => in_ulab, opcode => op_ula, out_ula => out_ula);
	ROM: ENTITY work.memoria GENERIC MAP (dataWidth => 16, addrWidth => 9) PORT MAP (Endereco => out_pc , Dado=>out_ROM); --todo parse dado for input
	  
	 
	 
	
	MUX_PC : ENTITY work.mux2 PORT MAP (IN_A => out_adder, IN_B => imediate, sel => sel_pc, mux_out => in_pc);
	 
	 
	--- =============================== ULA =====================================
	ADDER : ENTITY work.ADDER GENERIC MAP (n => 9) PORT MAP (A => "000000001", B => out_pc, sum => out_adder, carry => carry); --define generic default for data n & larguraDados
	ADDERGEN : ENTITY work.ADDER GENERIC MAP (n => 9) PORT MAP (A => imediate, B => out_bank, sum => out_addergen, carry => carry); --define generic default for data n & larguraDados
	
	SUBADDER : ENTITY work.SUBADDER GENERIC MAP (n => 9) PORT MAP (A => out_bank, B => imediate, sum => out_subadder, zf => flag_z); --define generic default for data n & larguraDados
	 
	 
	 
	 --- ====================================== "BANCO" DE REGISTRADORES =======================================
	 
	 
	 LEDR(17 downto 9) <= out_bank1;
	 
	
	REG_SEG : ENTITY work.registradorGenerico GENERIC MAP (larguraDados => 9)PORT MAP(data => in_bank, clk => CLK, enable => enable_bank(1), q => out_bank1, RST => reset_reg);
			
   REG_MIN : ENTITY work.registradorGenerico GENERIC MAP (larguraDados => 9)PORT MAP(data => in_bank, clk => CLK, enable => enable_bank(2), q => out_bank2, RST => reset_reg);
	REG_MIN_DEC : ENTITY work.registradorGenerico GENERIC MAP (larguraDados => 9)PORT MAP(data => in_bank, clk => CLK, enable => enable_bank(3), q => out_bank3, RST => reset_reg);
	REG_HORA : ENTITY work.registradorGenerico GENERIC MAP (larguraDados => 9)PORT MAP(data => in_bank, clk => CLK, enable => enable_bank(4), q => out_bank4, RST => reset_reg);
	REG_HORA_DEC : ENTITY work.registradorGenerico GENERIC MAP (larguraDados => 9)PORT MAP(data => in_bank, clk => CLK, enable => enable_bank(5), q => out_bank5, RST => reset_reg);

	REG_AM_PM: ENTITY work.registradorGenerico GENERIC MAP (larguraDados => 9)PORT MAP(data => in_bank, clk => CLK, enable => enable_bank(6), q => out_bank6, RST => reset_reg);
	
	--ADD_HR: ENTITY work.registradorGenerico GENERIC MAP (larguraDados => 9)PORT MAP(data => in_bank, clk => CLK, enable => enable_bank(7), q => out_bank7, RST => reset_reg);

	REG_TEMPO : ENTITY work.registradorGenerico GENERIC MAP (larguraDados => 9)PORT MAP(data => in_bank, clk => CLK, enable => enable_bank(0), q => out_bank0, RST => reset_reg);
	
	
	PC : ENTITY work.registradorGenerico GENERIC MAP (larguraDados => 9)PORT MAP(data => in_pc, clk => CLK, enable => '1', q => out_pc, RST => '0');
	
	END;
    