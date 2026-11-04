library ieee;
use ieee.std_logic_1164.all;

entity logic is
    port (
        a : in std_logic;
        b : in std_logic;
        r_and : out std_logic;
        r_or : out std_logic
    );
end entity logic;

architecture behavioral of logic is
begin
    r_and <= a and b;
    r_or <= a or b;
end architecture behavioral;