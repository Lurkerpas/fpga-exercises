library ieee;
use ieee.std_logic_1164.all;

entity logic_tb is
end entity logic_tb;

architecture sim of logic_tb is
    signal a : std_logic;
    signal b : std_logic;
    signal r_and : std_logic;
    signal r_or : std_logic;
begin
    uut: entity work.logic
        port map (
            a => a,
            b => b,
            r_and => r_and,
            r_or => r_or
        );

    process
    begin
        a <= '0';
        b <= '0';
        wait for 10 ns;
        assert (r_and = '0' and r_or = '0') report "Test case 00 failed" severity error;
        a <= '0';
        b <= '1';
        wait for 10 ns;
        assert (r_and = '0' and r_or = '1') report "Test case 01 failed" severity error;
        a <= '1';
        b <= '0';
        wait for 10 ns;
        assert (r_and = '0' and r_or = '1') report "Test case 10 failed" severity error;
        a <= '1';
        b <= '1';
        wait for 10 ns;
        assert (r_and = '1' and r_or = '1') report "Test case 11 failed" severity error;
        wait;
    end process;

end architecture sim;