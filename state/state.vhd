library ieee;
use ieee.std_logic_1164.all;

entity state is
	port (
		clk : in std_logic;
		rst : in std_logic;
        i : in std_logic;
		r : out std_logic
	);
end entity state;

architecture behavioral of state is
	signal s : std_logic := '0';
begin
	process(clk, rst)
	begin
		if rst = '1' then
			s <= '0';
		elsif rising_edge(clk) then
			s <= i;
		end if;
	end process;
	r <= s;
end architecture behavioral;