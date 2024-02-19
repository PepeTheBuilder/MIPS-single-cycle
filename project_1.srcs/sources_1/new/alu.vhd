library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- VERIFICAT IN SIMULARE
entity ALU is 
	Port( 
          ALUop : in STD_LOGIC_VECTOR(2 downto 0);
          input1 : in STD_LOGIC_VECTOR(15 downto 0);
          input2 : in STD_LOGIC_VECTOR(15 downto 0);
          sa : in std_logic_vector(0 downto 0);
          output : out STD_LOGIC_VECTOR(15 downto 0);
          zero: out STD_LOGIC
		);
end ALU;

architecture main_arh of ALU is
begin
-- aici baga muxu
--fuction code meaning: "000"- ADD, "001"-SUB,"010"-AND ,"011"-OR  ,"100"-XOR,"101"-SLL,"110"-SRL, "111"-SLT;
process( ALUop,input1,input2,sa) is
begin


    if input1-input2=x"0000" then 
            zero<='1';
        else 
            zero<='0';
    end if;
	
	
    case (ALUop) is
    when "000" => output<=input1+input2;  
    when "001" => output<=input1-input2;
    when "010" => output<=input1 and input2;
    when "011" => output<=input1 or input2;
    when "100" => output<=input1 xor input2;
    when "101" => output <= shl(input1, sa); -- Shift left logical by sa
    when "110" => output <= shr(input1, sa); -- Shift right logical by sa
    when others =>  if conv_integer(input1) > conv_integer(input2) then
                        output <= input2;
                          else 
                        output <= input1;
                     end if;
    end case;

end process;

end main_arh;