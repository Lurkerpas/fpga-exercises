library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wishboneslave_tb is  
end wishboneslave_tb;

architecture tb of wishboneslave_tb is
    signal clk     : std_logic := '0';
    signal rst     : std_logic := '0';
    signal adr_i   : std_logic_vector(7 downto 0) := (others => '0');
    signal dat_i   : std_logic_vector(7 downto 0) := (others => '0');
    signal dat_o   : std_logic_vector(7 downto 0);
    signal we_i    : std_logic := '0';
    signal stb_i   : std_logic := '0';
    signal cyc_i   : std_logic := '0';
    signal ack_o   : std_logic;

begin

    uut: entity work.wishboneslave(rtl)
        port map (
            clk     => clk,
            rst     => rst,
            adr_i   => adr_i,
            dat_i   => dat_i,
            dat_o   => dat_o,
            we_i    => we_i,
            stb_i   => stb_i,
            cyc_i   => cyc_i,
            ack_o   => ack_o
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
    stim_process : process
    begin
        -- Reset for one cycle
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;
        -- Write to data register
        adr_i <= x"00";
        dat_i <= x"50";
        we_i <= '1';
        stb_i <= '1';
        cyc_i <= '1';
        wait for 10 ns;
        assert ack_o = '1' report "Write not acknowledged" severity failure;
        we_i <= '0';
        stb_i <= '0';
        cyc_i <= '0';
        wait for 10 ns;
        -- nothing should happen inside the component
        wait for 100 ns;
        -- Read data register
        adr_i <= x"00";
        we_i <= '0';
        stb_i <= '1';
        cyc_i <= '1';
        wait for 10 ns;
        assert ack_o = '1' report "Read not acknowledged" severity failure;
        assert dat_o = x"50" report "Read data mismatch" severity failure;
        stb_i <= '0';
        cyc_i <= '0';
        wait for 10 ns;
        -- Enable counter
        adr_i <= x"01";
        dat_i <= x"01";
        we_i <= '1';
        stb_i <= '1';
        cyc_i <= '1';
        wait for 10 ns;
        assert ack_o = '1' report "Counter enable not acknowledged" severity failure;
        we_i <= '0';
        stb_i <= '0';
        cyc_i <= '0';
        -- Wait for counter to increment
        wait for 100 ns;
        -- Read counter value
        adr_i <= x"00";
        we_i <= '0';
        stb_i <= '1';
        cyc_i <= '1';
        wait for 10 ns;
        assert ack_o = '1' report "Counter read not acknowledged" severity failure;
        stb_i <= '0';
        cyc_i <= '0';
        wait for 10 ns;
        assert dat_o = x"5A" report "Counter value mismatch: expected 5A, got " & to_hstring(dat_o) severity failure;
        wait;
    end process;

end tb;