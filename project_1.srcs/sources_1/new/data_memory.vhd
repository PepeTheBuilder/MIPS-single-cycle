library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-------------VERIFICAt 27.05.23
entity memory_unit is
    Port ( address : in STD_LOGIC_VECTOR (15 downto 0);
           write_data : in STD_LOGIC_VECTOR (15 downto 0);
           write_enable : in STD_LOGIC;
           memtoreg : in STD_LOGIC;
           clk : in STD_LOGIC;
           read_data : out STD_LOGIC_VECTOR (15 downto 0));
end memory_unit;

architecture data_behv of memory_unit is
type ram_type is array (0 to 255) of std_logic_vector (15 downto 0);
signal RAM: ram_type:=(others => x"0000");

begin
process(address,write_data,write_enable,memtoreg,clk)
begin
if memtoreg = '1' then
    if rising_edge(clk) then
        if write_enable = '1' then 
            RAM(conv_integer(address)) <= write_data;
        else
            read_data<= RAM( conv_integer(address));
        end if;
    end if;
else
    read_data<=address;
end if;
end process;
end data_behv;
