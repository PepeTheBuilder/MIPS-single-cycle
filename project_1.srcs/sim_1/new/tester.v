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
  signal sw       : STD_LOGIC_VECTOR (15 downto 0) := (others => '1'); -- Placeholder for wd signal
  signal led      : STD_LOGIC_VECTOR (15 downto 0) := (others => '1'); -- Placeholder for wen signal
  signal an       : STD_LOGIC_VECTOR (3 downto 0) := (others => '0'); -- Placeholder for rd1 signal
  signal cat      : STD_LOGIC_VECTOR (6 downto 0) := (others => '0'); -- Placeholder for sa signal

begin
  uut: mips16
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

    -- Test case 1
    -- Set input signals to desired values
    btn <= "00001";
    sw <= "1111111111111111";
    
    -- Stimulus for one clock cycle
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    -- Check output signals
    assert led = "1111111111111111" report "Test case 1 failed: Unexpected value of LED" severity note;
    assert an = "0000" report "Test case 1 failed: Unexpected value of AN" severity note;
    assert cat = "0000000" report "Test case 1 failed: Unexpected value of CAT" severity note;

    -- Test case 2
    -- Set input signals to desired values
    btn <= "00010";
    sw <= "0000000000000000";
    
    -- Stimulus for one clock cycle
    wait for 10 ns;
    clk <= not clk;
    wait for 10 ns;
    clk <= not clk;
    
    -- Check output signals
    assert led = "1111111111111111" report "Test case 2 failed: Unexpected value of LED" severity note;
    assert an = "0000" report "Test case 2 failed: Unexpected value of AN" severity note;
    assert cat = "0000000" report "Test case 2 failed: Unexpected value of CAT" severity note;
    
    wait;
  end process stim_proc;
end Behavioral;
