
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
		  
tmp(0) := "0000000000000000"; --IO 0 0 0  [1]
tmp(1) := "0000000001000001"; -- SUBC 0 1
tmp(2) := "0000000000000010"; -- JMPZ 0




  

tmp(3) := "0000000001001100"; --COUNT 1 1   [3]
tmp(4) := "0000111100001001"; --SUBC  1 60
--tmp(4) := "0000000100 001 001"; --SUBC  1 4
tmp(5) := "0000000001000010"; --JMPZ  8 UM SEGUNDO SE PASSOU
tmp(6) := "0000000000000101"; --JMP   0




tmp(7) := "0000000000000111"; --NOP
tmp(8) := "0000001010010000"; --IO    2 2 1 [8]
tmp(9) := "0000000001010100"; --COUNT 2 1
tmp(10) := "0000001010010001"; --SUBC  2 10
--tmp(10) := "0000000010 010 001"; --SUBC  2 4
tmp(11) := "0000000001101010"; --JMPZ  13

tmp(12) := "0000000000000101"; --JMP   0




tmp(13) := "0000001011011000"; --IO    3 3 1 [13]
tmp(14) := "0000000001011100"; --COUNT 3 1
tmp(15) := "0000111100011001"; --SUBC  3 10
tmp(13) := "0000000010010010"; --JMPZ  18
tmp(16) := "0000000000000101"; --JMP   0




        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;