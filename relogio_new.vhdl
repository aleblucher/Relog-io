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
    SIGNAL sel_pc, sel_ula, enable_bank, enable_buffer : std_logic;
    SIGNAL op_ula: std_logic_vector(2 DOWNTO 0);

    begin
	 
	 MUX_ULA : ENTITY work.MUX PORT MAP (I0 => out_bank, I1 => imediato, sel => sel_pc, q => in_ulaa);
	 
	 ULA : ENTITY work.ula GENERIC MAP (largura => 9) PORT MAP(A => in_ulaa, B => in_ulab, opcode => op_ula, out_ula => out_ula);
	 ROM: ENTITY work.rom GENERIC MAP (dataWidth => 15, addrWidht => 20) PORT MAP (Endereco => out_pc , Dado=>);
	 
	 
	 CASE IMEDIATO:
	 --testa os bagulho
	 
		 REG_SEG : ENTITY work.registrador GENERIC MAP (largura => 8)PORT MAP(data => out_ula, clk => CLK, enable => enable_bank, q => out_bank);
		 REG_MIN : ENTITY work.registrador GENERIC MAP (largura => 8)PORT MAP(data => out_ula, clk => CLK, enable => enable_bank, q => out_bank);
		 REG_HORA : ENTITY work.registrador GENERIC MAP (largura => 8)PORT MAP(data => out_ula, clk => CLK, enable => enable_bank, q => out_bank);
		 
		 REG_TEMPO : ENTITY work.registrador GENERIC MAP (largura => 8)PORT MAP(data => out_ula, clk => CLK, enable => enable_bank, q => out_bank);
	 
	 MUX_PC : ENTITY work.mux PORT MAP (I0 => out_adder, I1 => imediato, sel => sel_pc, o => in_pc);
	 
	 ADDER : ENTITY work.adder PORT MAP (A => '1', B => out_pc, o => out_adder); 
	 
	 
	 
	 
    
	 
	 END;
    