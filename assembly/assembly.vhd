library ieee;
use ieee.std_logic_1164.all;

entity assembly is
    port (
        clk : in std_logic;
        reset : in std_logic;
        clk1_out : out std_logic;
        clk2_out : out std_logic;
        clk3_out : out std_logic
    );
end entity assembly;

architecture rtl of assembly is
    component counter is
        generic (
            LIMIT : integer := 10
        );
        port (
            clk_in : in std_logic;
            reset : in std_logic;
            clk_out : out std_logic
        );
    end component;
begin
    c1 : counter generic map (
            LIMIT => 16
        ) port map (
            clk_in => clk,
            reset => reset,
            clk_out => clk1_out
        );
    c2 : counter generic map (
            LIMIT => 5
        ) port map (
            clk_in => clk,
            reset => reset,
            clk_out => clk2_out
        );
    c3 : counter generic map (
            LIMIT => 2
        ) port map (
            clk_in => clk2_out,
            reset => reset,
            clk_out => clk3_out
        );
end architecture rtl;