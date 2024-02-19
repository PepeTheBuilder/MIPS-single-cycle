library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is
component TataLor is
    Port ( 
           clk : in  STD_LOGIC;
           btn : in  STD_LOGIC_VECTOR (4 downto 0);
           sw : in  STD_LOGIC_VECTOR (15 downto 0);
           led : out  STD_LOGIC_VECTOR (15 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           cat : out  STD_LOGIC_VECTOR (6 downto 0)
        );

  end component;
  
  signal clk      : std_logic := '0';
  signal btn      : STD_LOGIC_VECTOR (4 downto 0) := (others => '0'); -- Placeholder for instruction signal
  signal sw       : STD_LOGIC_VECTOR (15 downto 0) := (others => '0'); -- Placeholder for wd signal
  signal led      : STD_LOGIC_VECTOR (15 downto 0) := (others => '0'); -- Placeholder for wen signal
  signal an       : STD_LOGIC_VECTOR (3 downto 0) := (others => '0'); -- Placeholder for rd1 signal
  signal cat      : STD_LOGIC_VECTOR (6 downto 0) := (others => '0'); -- Placeholder for sa signal

begin
--clk<='0';
--btn<=(others => '0');
--sw <=(others => '0');
--an <=(others => '0');
--an <=(others => '0');
--led<=(others => '0');
  uut: TataLor
    port map (
      clk => clk,
      btn => btn,
      sw => sw,
      led => led,
      an => an,
      cat => cat
    );

  stim_proc: process
  begin
    wait for 10 ns;


    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;

    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    wait;
  end process stim_proc;
end Behavioral;
