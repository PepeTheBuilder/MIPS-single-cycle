library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
-- VERIFICAT IN SIMULARE
entity instruction_fetch is
    Port ( clk : in STD_LOGIC;
           jump_data : in STD_LOGIC_VECTOR (15 downto 0);
           brench_data : in STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC;
           jump : in STD_LOGIC;
           pcsrc : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           pc_next : out STD_LOGIC_VECTOR (15 downto 0));
end instruction_fetch;

architecture Behavioral of instruction_fetch is
signal counter,aux_counter,Q,aux_mux: STD_LOGIC_VECTOR(15 downto 0):=(Others=>'0');
type memorie is array (0 to 15) of std_logic_vector(15 downto 0);
--		ADD SUB AND OR XOR SLL SRL SLT -8 type R
--		BEQ J ADDI ORI ANDI lW SW -7 type I/J
--      opCode="000" rs_x3  rt_x3  rd_x3 sa_x1 function_x3  -- function of type R
--		opCode_x3 rs_x3 rt_x3 immidiate_x7					-- fuction of type I
-- 		opCode_x3 targetAddress_x13							-- fuction Jump
		
--		CODE:"xxxxxxxxxxxxxxxxx"	 TYPE-function name
--		B"000_001_000_010_0_000",  		R-add	
--		B"001_000_100_xxxxxxx",			I-addi (immidiate is signed so same thing as -subi)
--		B"000_011_010_010_0_001",		R-sub

--		B"000_011_010_100_0_010",		R-and 	- bitwise
--		B"010_100_101_xxxxxxx",			I-andi
--		B"000_101_100_100_0_011",		R-or
--		B"011_101_110_xxxxxxx",			I-ori
--		B"000_100_100_100_0_100",		R-xor


--		B"000_010_000_010_1_101",		R-sll -Shift left logical (puts 0)
--		B"000_010_000_010_1_110",		R-srl -Shift right logical (puts 0)
--		B"000_010_011_100_0_111",		R-slt -Set on less than (signed)

--		B"100_001_101_xxxxxxx"		I-LW  - Load word
--		B"101_100_101_xxxxxxx",		I-SW  - Store word
--		B"110_001_001_xxxxxxx",		I-beq -Branch on equal
--		B"111_xxxxxxxxxxxxx",  		J-j	 -jump PC <- nPC | nPC = (PC & 0xf0000000) | (target << 2);

-- opCode="000" =>fuction code meaning: "000"- ADD, "001"-SUB,"010"-AND ,"011"-OR  ,"100"-XOR,"101"-SLL,"110"-SRL, "111"-SLT;
-- opCode=>"000" -Type R, "001"-ADDI, "010"-ANDI, "011"-ORI, "100" -lW, "101"-SW, "110"-BEQ, "111"-JUMP;

signal stocare:memorie :=(
	    0=>B"000_000_001_000_0_000",  	--X"0080"	--add $1,$0,$2
	    1=>B"000_000_001_000_0_001",  	--X"0081"	--sub $1,$0,$2
		2=>B"001_000_100_0000010",	 	--X"2202"	--addi $4,$0,2	
    	3=>B"101_001_000_0000000", 		--X"AC80"   --sw $0,0($1)
    	4=>B"001_001_000_0000011",	 	--X"2183"	--addi $1,$0,3	
    	5=>B"100_001_000_0000000", 		--X"8400"   --lw $1,0($0)	
		6=>B"100_101_000_0000000", 		--X"9400"   --lw $5,0($0)
		7=>B"101_100_010_0000000", 		--X"B100"   --sw $2,0($5)
		8=>B"000_001_010_101_0_000", 	--X"0550" 	--add $5,$1,$2
		9=>B"000_000_010_001_0_001", 	--X"0110" 	--sub $1,$0,$2
		10=>B"000_000_101_010_0_010", 	--X"02A0" 	--and $2,$0,$5
		11=>B"111_0000000000000", 		--X"E008"   --j 0
		others=>x"0000");
begin
    --PC
    process(clk, en) 
	begin
        if (en='1') then 
	       if rising_edge(clk) then
	       Q<= counter;
		  end if;
		end if;
    end process;

    process(Q)
    begin
        instruction<=stocare(conv_integer(Q));
        aux_counter<=Q+'1'; 
        pc_next <= aux_counter;
    end process;

    --mux 1 (langa AlU)
    process(pcsrc,brench_data,aux_counter) 
    begin
       case pcsrc is
            when '0'=> aux_mux<=aux_counter;
            when others=> aux_mux<=brench_data;
       end case;
    end process;

    --mux 2
    process(jump,jump_data,aux_mux) 
    begin
        case jump is
            when '0'=> counter<=aux_mux;
            when others=> counter<=jump_data;
        end case;
    end process;

end Behavioral;