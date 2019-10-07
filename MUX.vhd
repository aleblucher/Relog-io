
library ieee;
use ieee.std_logic_1164.all;

entity MUX is
    generic (
        -- Total de bits das entradas e saidas
        larguraDados    : natural  :=   9
    );
    port (
        IN_A    : in  std_logic_vector(larguraDados-1 downto 0);
        IN_B    : in  std_logic_vector(larguraDados-1 downto 0);
        sel   : in  std_logic;

        mux_out   : out std_logic_vector(larguraDados-1 downto 0)
    );
end entity;

architecture comportamento of MUX is
begin
  -- Para sintetizar lógica combinacional usando um processo,
  --  todas as entradas do modulo devem aparecer na lista de sensibilidade.
    process(IN_A, IN_B, sel) is
    begin
     -- If é uma instrução sequencial que não pode ser usada
     --  na seção de instruções concorrentes da arquitetura.
        if(sel='0') then
            mux_out <= IN_A;
        else
            mux_out <= IN_B;
        end if;
    end process;
end architecture;