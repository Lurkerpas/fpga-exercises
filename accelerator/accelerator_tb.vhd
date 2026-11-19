library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accelerator_tb is
end entity; 

architecture tb of accelerator_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal done : std_logic;
    signal a : std_logic_vector(31 downto 0);
    signal b : std_logic_vector(31 downto 0);
    signal result : std_logic_vector(31 downto 0);
begin
    uut: entity work.accelerator
    port map (
        clk => clk,
        rst => rst,
        done => done,
        a => a,
        b => b,
        result => result
    );
    clk_process: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
    
    sim_proc: process
    begin
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        a <= x"00001234";
        b <= x"00005678";
        wait for 1000 ns;
        assert result = x"06260060" report "Incorrect multiplication result" severity failure;
        wait;
    end process;

end architecture tb;