library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity arithmetic_tb is
end entity arithmetic_tb;   

architecture sim of arithmetic_tb is
    constant WIDTH : integer := 4;

    signal a : std_logic_vector(WIDTH-1 downto 0);
    signal b : std_logic_vector(WIDTH-1 downto 0);
    signal sum : std_logic_vector(WIDTH-1 downto 0);
    signal diff : std_logic_vector(WIDTH-1 downto 0);
    signal mul : std_logic_vector(WIDTH-1 downto 0);
    signal div : std_logic_vector(WIDTH-1 downto 0);

begin

    uut: entity work.arithmetic
        generic map (
            WIDTH => WIDTH
        )
        port map (
            a => a,
            b => b,
            sum => sum,
            diff => diff,
            mul => mul,
            div => div
        );

        process
        begin
            a <= "0001";
            b <= "0010";
            wait for 10 ns;
            assert (sum = "0011" and diff = "1111" and mul = "0010" and div = "0000")
            report "Test failed for a = 0001, b = 0010"
            severity error;

            a <= "0100";
            b <= "0010";
            wait for 10 ns;
            assert (sum = "0110" and diff = "0010" and mul = "1000" and div = "0010")
            report "Test failed for a = 0100, b = 0010"
            severity error;
 
            wait;
        end process;

end architecture sim;