library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    generic (
        LIMIT : integer := 10
    );
    port (
        clk_in : in std_logic;
        reset : in std_logic;
        clk_out : out std_logic
    );
end counter;

architecture rtl of counter is
    signal counter_reg : integer := 0;
begin

    process(clk_in, reset)
    begin
        if reset = '1' then
            counter_reg <= 0;
            clk_out <= '0';
        elsif rising_edge(clk_in) then
            if counter_reg = LIMIT - 1 then
                counter_reg <= 0;
                clk_out <= '1';
            else
                counter_reg <= counter_reg + 1;
                clk_out <= '0';
            end if;
        end if;
    end process;

end rtl;