library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.statemachine_pkg.all;

entity statemachine_tb is
end entity statemachine_tb;

architecture sim of statemachine_tb is
    signal clk : std_logic := '0';
    signal ctrl_in : std_logic_vector(7 downto 0) := (others => '0');
    signal ctrl_out : std_logic_vector(7 downto 0) := (others => '0');
begin
    uut: entity work.statemachine
        port map (
            clk => clk,
            ctrl_in => ctrl_in,
            ctrl_out => ctrl_out
        );

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    sim_proc: process
    begin
        -- Reset
        ctrl_in(RESET_BIT) <= '1';
        wait for 20 ns;
        assert ctrl_out(RESET_BIT) = '1' report "Reset not asserted" severity failure;
        assert ctrl_out(INITIALIZING_BIT) = '0' report "Initializing despite reset" severity failure;
        assert ctrl_out(READY_BIT) = '0' report "Ready despite reset" severity failure;

        -- Stop resetting
        ctrl_in(RESET_BIT) <= '0';
        wait for 20 ns;
        assert ctrl_out(RESET_BIT) = '0' report "Reset not deasserted" severity failure;
        assert ctrl_out(INITIALIZING_BIT) = '0' report "Initializing despite not enabled" severity failure;
        assert ctrl_out(READY_BIT) = '0' report "Ready despite not enabled" severity failure;

        -- Enable
        ctrl_in(ENABLE_BIT) <= '1';
        wait for 20 ns;
        assert ctrl_out(ENABLE_BIT) = '1' report "Enable not asserted" severity failure;
        assert ctrl_out(INITIALIZING_BIT) = '1' report "Initializing not asserted" severity failure;
        assert ctrl_out(READY_BIT) = '0' report "Ready despite initializing" severity failure;
        
        -- Wait for initialization to complete
        wait for 500 ns; -- Wait for initialization to complete
        assert ctrl_out(INITIALIZING_BIT) = '0' report "Initializing not deasserted" severity failure;
        assert ctrl_out(READY_BIT) = '1' report "Ready not asserted" severity failure;


        -- Reset again
        ctrl_in(RESET_BIT) <= '1';
        wait for 1 ns;
        assert ctrl_out(RESET_BIT) = '1' report "Reset not asserted" severity failure;
        assert ctrl_out(INITIALIZING_BIT) = '0' report "Initializing despite reset" severity failure;
        assert ctrl_out(READY_BIT) = '0' report "Ready despite reset" severity failure;

        wait;
    end process;

end architecture sim;