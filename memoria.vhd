
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
        -- Inicializa os endereços: w/ code version 0.3
		  tmp(0) := "1000010000000000";
		  tmp(1) := "1010000000000000";
--tmp(0) := "0000000000000000";
--tmp(1) := "0010000000000010";
--tmp(2) := "0100000000010000";
--tmp(3) := "1000010000000000";
--tmp(4) := "0010010001111000";
--tmp(5) := "0101110000000000";
--tmp(6) := "1000100000000000";
--tmp(7) := "0001010010000000";
--tmp(8) := "0010100000010010";
--tmp(9) := "0101011000000000";
--tmp(10) := "1001010000000000";
--tmp(11) := "0001101101000000";
--tmp(12) := "0011010000010010";
--tmp(13) := "0101111000000000";
--tmp(14) := "1001000000000000";
--tmp(15) := "0001100100000000";
--tmp(16) := "0011000000011000";
--tmp(17) := "0101001100000000";
--tmp(18) := "1001100000000000";
--tmp(19) := "0001110110000000";
--tmp(20) := "0011100000000010";
--tmp(21) := "0101111000000000";

        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;