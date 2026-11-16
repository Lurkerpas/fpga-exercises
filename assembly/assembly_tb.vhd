library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity assembly_tb is
end assembly_tb;

architecture rtl of assembly_tb is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal clk1_out : std_logic;
    signal clk2_out : std_logic;
    signal clk3_out : std_logic;
begin

    uut : entity work.assembly
        port map (
            clk => clk,
            reset => reset,
            clk1_out => clk1_out,
            clk2_out => clk2_out,
            clk3_out => clk3_out
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    test_process : process
    begin
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;
        assert clk1_out = '0' report "CLK1 not zeroed after reset" severity failure;
        assert clk2_out = '0' report "CLK2 not zeroed after reset" severity failure;
        assert clk3_out = '0' report "CLK3 not zeroed after reset" severity failure;
        wait for 40 ns;
        assert clk1_out = '0' report "CLK1 incorrect for time == 50 ns" severity failure;
        assert clk2_out = '1' report "CLK2 incorrect for time == 50 ns" severity failure;
        assert clk3_out = '0' report "CLK3 incorrect for time == 50 ns" severity failure;
        wait for 50 ns;
        assert clk1_out = '0' report "CLK1 incorrect for time == 100 ns" severity failure;
        assert clk2_out = '1' report "CLK2 incorrect for time == 100 ns" severity failure;
        assert clk3_out = '1' report "CLK3 incorrect for time == 100 ns" severity failure;
        wait for 60 ns;
        assert clk1_out = '1' report "CLK1 incorrect for time == 160 ns" severity failure;
        assert clk2_out = '0' report "CLK2 incorrect for time == 160 ns" severity failure;
        assert clk3_out = '0' report "CLK3 incorrect for time == 160 ns" severity failure;

        wait;
    end process;

end architecture rtl;