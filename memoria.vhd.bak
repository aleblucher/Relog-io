
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
        -- Inicializa os endereços: w/ code version 0.6
		  
--		  tmp(0) := "0000000000000000";
--		  tmp(1) := "0000000001000001";
--		  tmp(2) := "0000000000000010";
--		  tmp(3) := "0000001100010000";
--		  tmp(4) := "0000000001000001";
--		  tmp(5) := "0000000011100010";
--		  tmp(6) := "0000000001001100";
--	     tmp(7) := "0000111100001001";
--		  tmp(8) := "0000101000001001";
--	     tmp(9) := "0000000001010100";
--		  tmp(10) := "0000000100101000";
--		  tmp(11) := "0000001001010001";
--		  tmp(12) := "0000000001101010";
--	     tmp(13) := "0000000001011100";
--		  tmp(14) := "0000000110111000";
--		  tmp(15) := "0000001001011001";
--		  tmp(16) := "0000000010010010";
--		  tmp(17) := "0000000001100100";
--		  tmp(18) := "0000001001001000";
--		  tmp(19) := "0000011000100001";
--		  tmp(20) := "0000000010111010";
--		  tmp(21) := "0000000001110100";
--		  tmp(22) := "0000001101101000";
--		  tmp(23) := "0000000001110001";
--		  tmp(24) := "0000000010010010";
--		  tmp(25) := "0000000001101100";
--		  tmp(26) := "0000000010010010";
tmp(0) := "0000000000000011";
tmp(1) := "0000000001000100";
tmp(2) := "0000000000101000";
tmp(3) := "0000000000001101";
tmp(4) := "0000000000101111";

        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;