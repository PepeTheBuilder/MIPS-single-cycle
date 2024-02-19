library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- VERIFICAT IN SIMULARE vechi
entity InstructionDecoder is
    Port ( clk : in STD_LOGIC;
           inst : in STD_LOGIC_VECTOR (15 downto 0);
           extOp : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           regWrite : in STD_LOGIC;
           regDst : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);

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
begin
process(regDst,extOp)
begin
if regDst='1' then
    wa<=inst(9 downto 7);
    else 
    wa<=inst(6 downto 4);
end if;


if extOp='1' then 
    if inst(6)='1' then  --Signed extestion
        ext_imm<=inst(6)&x"11"&'1'&inst(5 downto 0);
    else
        ext_imm<=inst(6)&x"00"&'0'&inst(5 downto 0);
    end if;
else                     --Zero extestion
    ext_imm<=x"00"&'0'& inst(6 downto 0);
end if;


end process;

u1: reg_file
    port map (
        clk  => clk,
        ra1  => inst(12 downto 10),
        ra2  => inst(9 downto 7),
        wa   => wa,
        wd   => wd,
        wen  => regWrite,
        rd1  => rd1,
        rd2  => rd2
    );
    
sa<=inst(7);

end Behavioral;