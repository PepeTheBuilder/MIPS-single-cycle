library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InstructionDecoder is
    Port ( clk : in STD_LOGIC;
           inst : in STD_LOGIC_VECTOR (15 downto 0);
           extOp : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;
           regWrite : in STD_LOGIC;
           regDst : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end InstructionDecoder;

architecture Behavioral of InstructionDecoder is
component reg_file is 
port ( clk : in std_logic;
  ra1 : in std_logic_vector (2 downto 0);
  ra2 : in std_logic_vector (2 downto 0);
  wa : in std_logic_vector (2 downto 0);
  wd : in std_logic_vector (15 downto 0);
  wen : in std_logic;
  rd1 : out std_logic_vector (15 downto 0); 
  rd2 : out std_logic_vector (15 downto 0) ); 
  end component;  
signal wa:STD_LOGIC_VECTOR (2 downto 0);
signal rd22:STD_LOGIC_VECTOR (15 downto 0);
begin
process(regDst,extOp)
begin
if regDst='1' then
    wa<=inst(9 downto 7);
    else 
    wa<=inst(7 downto 4);
end if;
if extOp='1' then 
    if inst(6)='1' then
        ext_imm<=inst(6)&x"11"&'1'&inst(5 downto 0);
    else
        ext_imm<=inst(6)&x"00"&'0'&inst(5 downto 0);
    end if;
else 
    ext_imm<=x"00"& inst(6 downto 0);
end if;

end process;
u1: reg_file port map (clk,
                       inst(12 downto 10), 
                       inst(9 downto 7),
                       wa,
                       wd,
                       '1',
                       rd1,
                       rd22
                       );
					   
sa<=inst(3);
func<=inst(2 downto 0);                       
                 
end Behavioral;