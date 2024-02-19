library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TataLor is
    Port ( 
           clk : in  STD_LOGIC;
           btn : in  STD_LOGIC_VECTOR (4 downto 0);
           sw : in  STD_LOGIC_VECTOR (15 downto 0);
           led : out  STD_LOGIC_VECTOR (15 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           cat : out  STD_LOGIC_VECTOR (6 downto 0)
        );
end TataLor;

architecture Behavioral of TataLor is
component  mips16 is
    Port ( 
           clk : in  STD_LOGIC;
           clkBtn: in  STD_LOGIC;
           selectt: in  STD_LOGIC_VECTOR (2 downto 0);
           switch : in  STD_LOGIC_VECTOR (8 downto 0);
           led : out  STD_LOGIC_VECTOR (15 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           cat : out  STD_LOGIC_VECTOR (6 downto 0)
        );
end component;
begin

mip: mips16 port map (
    clk=>clk,
    clkBtn=>clk,
    selectt=> sw(15 downto 13),
    switch=>sw(8 downto 0),
    led=>led,
    an=>an,
    cat=>cat
);  
end Behavioral;
