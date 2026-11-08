library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uartspammer_tb is
end entity uartspammer_tb;

architecture sim of uartspammer_tb is
    signal rst : std_logic := '1';
    signal clk : std_logic := '0';
    signal tx : std_logic;

    constant CLK_PERIOD : time := 100 ns; -- 10 MHz clock
begin

    uut: entity work.uartspammer
        port map (
            rst => rst,
            clk => clk,
            tx => tx
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    sim_process : process
        constant SYMBOL_TIME : time := 105 us; -- 9600 baud, 1 symbol = 1/9600 s = 104.1667 us; +1 to accomodate accuracy
    begin
        -- Reset
        rst <= '0';
        wait for 10 us;
        assert tx = '1' report "TX should be idle high after reset" severity failure;

        rst <= '1';
        -- Start observing TX, giving some time for the clock
        -- We need to observe:
        -- START (0) + S ('01010011', LSB first) + STOP (1)
        wait for 2 * CLK_PERIOD;
        assert tx = '0' report "TX should start with START bit" severity failure;
        wait for SYMBOL_TIME;
        assert tx = '1' report "TX should transmit (S) bit 0" severity failure;
        wait for SYMBOL_TIME;
        assert tx = '1' report "TX should transmit (S) bit 1" severity failure;
        wait for SYMBOL_TIME;
        assert tx = '0' report "TX should transmit (S) bit 2" severity failure;
        wait for SYMBOL_TIME;
        assert tx = '0' report "TX should transmit (S) bit 3" severity failure;
        wait for SYMBOL_TIME;
        assert tx = '1' report "TX should transmit (S) bit 4" severity failure;
        wait for SYMBOL_TIME;
        assert tx = '0' report "TX should transmit (S) bit 5" severity failure;
        wait for SYMBOL_TIME;
        assert tx = '1' report "TX should transmit (S) bit 6" severity failure;
        wait for SYMBOL_TIME;
        assert tx = '0' report "TX should transmit (S) bit 7" severity failure;
        wait for SYMBOL_TIME;
        assert tx = '1' report "TX should transmit STOP bit" severity failure;
        wait;

    end process;

end architecture sim;