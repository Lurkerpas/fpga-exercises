library ieee;
use ieee.std_logic_1164.all;
use work.rom_data.all;

entity rom_tb is
end entity rom_tb;

architecture sim of rom_tb is

    signal clk : std_logic := '0';
    signal address : t_address := 0;
    signal data : t_word;

begin

    uut: entity work.rom
        port map (
            clk => clk,
            address => address,
            data => data
        );

    clk_process: process
    begin
        address <= 0;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert (data = "00000001") report "Test failed for address 0" severity error;

        address <= 3;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert (data = "00001000") report "Test failed for address 3" severity error;
        
        address <= 7;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        assert (data = "11111111") report "Test failed for address 7" severity error;        
        wait;
    end process;

end architecture sim;