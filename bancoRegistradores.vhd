library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Baseado no apendice C (Register Files) do COD (Patterson & Hennessy).

entity bancoRegistradores is
    generic
    (
        larguraDados        : natural := 9;
        larguraEndBancoRegs : natural := 3   --Resulta em 2^5=32 posicoes
    );
-- Leitura de 2 registradores e escrita em 1 registrador simultaneamente.
    port
    (
        clk        : in std_logic;
--
        endereco       : in std_logic_vector((larguraEndBancoRegs-1) downto 0);

--
        dadoEscrita    : in std_logic_vector((larguraDados-1) downto 0);
--
        escreve        : in std_logic := '0';
        saida          : out std_logic_vector((larguraDados -1) downto 0)
    );
end entity;

architecture comportamento of bancoRegistradores is

    subtype palavra_t is std_logic_vector((larguraDados-1) downto 0);
    type memoria_t is array(2**larguraEndBancoRegs-1 downto 0) of palavra_t;

    -- Declaracao dos registradores:
    shared variable registrador : memoria_t;

begin
    process(clk) is
    begin
        if (rising_edge(clk)) then
            if (escreve = '1') then
                registrador(to_integer(unsigned(endereco))) := dadoEscrita;
            end if;
        end if;
    end process;
    saida <= registrador(to_integer(unsigned(endereco)));
end architecture;