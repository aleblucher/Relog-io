library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

---------------------------------------------------

entity ALU is

port(	A:	in std_logic_vector(1 downto 0);
	B:	in std_logic_vector(1 downto 0);
	Sel:	in std_logic_vector(1 downto 0);
	Res:	out std_logic_vector(1 downto 0)  
);

end ALU;

---------------------------------------------------

architecture behv of ALU is
begin					   

    process(A,B,Sel)
    begin
    
	-- use case statement to achieve 
	-- different operations of ALU

	case Sel is
	    when "00" =>
		Res <= A + B;
	    when "01" =>						
	        Res <= A + (not B) + 1;
            when "10" =>
		Res <= A and B;
	    when "11" =>	 
		Res <= A or B;
	    when others =>	 
		Res <= "XX";
        end case;

    end process;

end behv;

----------------------------------------------------
