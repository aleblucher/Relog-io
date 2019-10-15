
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria is
   generic (
          dataWidth: natural := 8;
          addrWidth: natural := 3
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoria is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
        -- Inicializa os endereços:
		  
tmp(0) := "0000000000000011"; --SETE  0 0
tmp(1) := "0000001010001000"; --IO    1 2 1     [1]
tmp(2) := "0000000001001100"; --COUNT 1 1
tmp(3) := "0000001010001001"; --SUBC  1 1
tmp(4) := "0000000000001010"; --JMPZ  1
tmp(5) := "0000000000001101"; --JMP   1


tmp(6) := "0000000000000111"; --NOP

tmp(7) := "0000001011010000"; --IO    2 3 1     [1]
tmp(8) := "0000000001010100"; --COUNT 2 1
--tmp(3) := "0000001010 010 001"; --SUBC  2 0
--tmp(9) := "0000000000000010"; --JMPZ  0
tmp(9) := "0000000000001101"; --JMP   1







        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;