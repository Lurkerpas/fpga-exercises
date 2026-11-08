library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package statemachine_pkg is
    constant INITIALIZING_BIT : integer := 1;
    constant READY_BIT : integer := 2;
    constant ENABLE_BIT : integer := 6;
    constant RESET_BIT : integer := 7;
end package statemachine_pkg;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity statemachine is
    port (
        clk : in std_logic;
        ctrl_in : in std_logic_vector(7 downto 0);
        ctrl_out : out std_logic_vector(7 downto 0)
    );
end entity statemachine;

architecture rtl of statemachine is
    use work.statemachine_pkg.all;
    type STATE_TYPE is (RESET, INITIALIZING, READY);
    signal state : STATE_TYPE;
    signal counter : integer range 0 to 255;
begin
    process(clk)
    begin
        if (ctrl_in(RESET_BIT) = '1') then
            ctrl_out <= (RESET_BIT => '1', others => '0');
            state <= RESET;
            counter <= 0;
        elsif rising_edge(clk) then
            case state is
                when RESET =>
                    if (ctrl_in(ENABLE_BIT) = '1') then
                        state <= INITIALIZING;
                        counter <= 0;
                    end if;
                when INITIALIZING =>
                    counter <= counter + 1;
                    if (counter = 16) then
                        state <= READY;
                    end if;
                when READY =>
                    null;
            end case;
            ctrl_out <= ctrl_in;
            -- Quartus does not understand conditional, single-line assignment
            if (state = READY) then
                ctrl_out(READY_BIT) <= '1';
            else
                ctrl_out(READY_BIT) <= '0';
            end if;
            if (state = INITIALIZING) then
                ctrl_out(INITIALIZING_BIT) <= '1';
            else
                ctrl_out(INITIALIZING_BIT) <= '0';
            end if;
         end if;
    end process;

end architecture rtl;