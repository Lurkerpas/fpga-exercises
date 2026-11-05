library ieee;
use ieee.std_logic_1164.all;

entity state_tb is
end entity state_tb;

architecture sim of state_tb is
	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal i : std_logic := '0';
	signal r : std_logic;
begin
	uut: entity work.state
		port map (
			clk => clk,
			rst => rst,
			i => i,
			r => r
		);

	process
	begin
        rst <= '0';
        i <= '0';
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
        assert (r = '0') report "Set 0 failed" severity failure;

        rst <= '1';
		wait for 10 ns;
        rst <= '0';
        i <= '1';
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
        assert (r = '1') report "Set 1 failed" severity failure;

        rst <= '1';
		wait for 10 ns;
        rst <= '0';
        i <= '1';
		clk <= '0';
		wait for 10 ns;
        assert (r = '0') report "Output set without clock edge" severity failure;

        rst <= '1';
        i <= '1';
		clk <= '0';
		wait for 10 ns;
        clk <= '1';
		wait for 10 ns;
        assert (r = '0') report "Output set while reset is active" severity failure;

        rst <= '1';
		wait for 10 ns;
        rst <= '0';
        i <= '1';
		clk <= '0';
		wait for 10 ns;
        clk <= '1';
		wait for 10 ns;
        rst <= '1';
        wait for 10 ns;
        assert (r = '0') report "Reset not working" severity failure;
        wait;
	end process;

end architecture sim;