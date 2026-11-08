library ieee;
use ieee.std_logic_1164.all;

package rom_data is

constant ROM_SIZE : integer := 10;
constant ROM_WIDTH : integer := 8;

type t_address is range 0 to ROM_SIZE-1;
type t_word is array (ROM_WIDTH-1 downto 0) of std_logic;
type t_rom is array (t_address) of t_word;

end package rom_data;

-- entity and package may be in the same file, but...
-- imports apply only to the next design unit
-- https://stackoverflow.com/questions/19815066/vhdl-can-you-declare-a-package-and-an-entity-in-the-same-file

library ieee;
use ieee.std_logic_1164.all;
use work.rom_data.all;

entity rom is
    port (
        clk : in std_logic;
        address : in t_address;
        data : out t_word
    );

end entity rom;

architecture rtl of rom is

    constant ROM_MEMORY : t_rom := (
        0 => "00000001",
        1 => "00000010",
        2 => "00000100",
        3 => "00001000",
        4 => "00000100",
        5 => "00000010",
        6 => "00000001",
        7 => "11111111",
        8 => "00000000",
        9 => "11111111"
    );

begin

    process(clk)
    begin
        if rising_edge(clk) then
            data <= ROM_MEMORY(address);
        end if;
    end process;

end architecture rtl;