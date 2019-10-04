LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity relogio is
    PORT(
		clk: 						in std_logic;
		reset: 						in std_logic;
		sw_controll:				in std_logic_vector(5 downto 0)
    );

end entity;

ARCHITECTURE arch OF relogio is
    SIGNAL out_ROM : std_logic_vector(15 DOWNTO 0);
    SIGNAL imediato, in_pc, out_pc, out_adder, out_bank, in_ulaa,  in_ulab, out_ula,  : std_logic_vector(8 DOWNTO 0);
    SIGNAL sel_pc, sel_ula, enable_bank, enable_buffer, mode: std_logic;
    SIGNAL op_ula: std_logic_vector(2 DOWNTO 0);

    begin
	 
	 
	 
	 op_ula <= out_ROM(2 downto 0);
	 
	 
	 case op_ula is
		when "000" => --IO [MODE] [IO_ADDR] [REG_ADDR]
			mode <= out_ROM(3)
			io_address <= out_ROM(6 downto 4)
			reg_address <= out_ROM(9 downto 7)
		when "001" => --SUBC [REG_ADDR] [IMEDIATE] if result is zero set zero flag and reset
			reg_address <= out_ROM(9 downto 7)
			imediate(8 downto 3) <= out_ROM(8 downto 3) --ADRRESS location to jump
		when "010" => --SUBC [REG_ADDR] [IMEDIATE] if result is zero set zero flag and reset
			flag_z <= flag_z
			imediate <= out_ROM(15 downto 6)
			reg_address <= out_ROM(5 downto 3)
		when "011" =>
			--useless ? needed (start value?)
		when "100" => -- COUNT [REG_ADDRESS] add 1 to count adress
			reg_address <= out_ROM(5 downto 3)
			--imediate <= out_ROM(15 downto 6) ???
			--count or add ? if has a counter register COUNT [REG_ADDRESS] [REG_ADDRESS] add imediate to count adress
		when "101" => --jmp [ADDRESS] 
			imediate <= out_ROM(15 downto 6) --ADRRESS location to jump
		when others =>
			
		
			
	 
	 MUX_ULA : ENTITY work.MUX PORT MAP (I0 => out_bank, I1 => imediato, sel => sel_pc, q => in_ulaa);
	 
	 ULA : ENTITY work.ula GENERIC MAP (largura => 9) PORT MAP(A => in_ulaa, B => in_ulab, opcode => op_ula, out_ula => out_ula);
	 ROM: ENTITY work.rom GENERIC MAP (dataWidth => 15, addrWidht => 20) PORT MAP (Endereco => out_pc , Dado=>out_ROM); --todo parse dado for input
	  
	 
	 case imediato is --change to reg_address
		 WHEN "000000000" =>
		 REG_SEG : ENTITY work.registrador GENERIC MAP (largura => 8)PORT MAP(data => out_ula, clk => CLK, enable => enable_bank, q => out_bank);
		 WHEN "000000001" =>
		 REG_MIN : ENTITY work.registrador GENERIC MAP (largura => 8)PORT MAP(data => out_ula, clk => CLK, enable => enable_bank, q => out_bank);
		 WHEN "000000010" =>
		 REG_HORA : ENTITY work.registrador GENERIC MAP (largura => 8)PORT MAP(data => out_ula, clk => CLK, enable => enable_bank, q => out_bank);
		 WHEN "000000011" =>
		 REG_TEMPO : ENTITY work.registrador GENERIC MAP (largura => 8)PORT MAP(data => out_ula, clk => CLK, enable => enable_bank, q => out_bank);
	 end case;
	 
	 MUX_PC : ENTITY work.mux PORT MAP (I0 => out_adder, I1 => imediato, sel => sel_pc, o => in_pc);
	 
	 ADDER : ENTITY work.adder PORT MAP (A => '1', B => out_pc, o => out_adder); 
	 
	 
	 
	 
    
	 
	 END;
    