library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arithmetic is
    generic (
        WIDTH : integer := 7
    );
    port (
        a : in  std_logic_vector(WIDTH-1 downto 0);
        b : in  std_logic_vector(WIDTH-1 downto 0);
        sum : out std_logic_vector(WIDTH-1 downto 0);
        diff : out std_logic_vector(WIDTH-1 downto 0);
        mul : out std_logic_vector(WIDTH-1 downto 0);
        div : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity arithmetic;

architecture rtl of arithmetic is
    signal product : unsigned(2*WIDTH-1 downto 0);
begin
    sum <= std_logic_vector(unsigned(a) + unsigned(b));
    diff <= std_logic_vector(unsigned(a) - unsigned(b));
    product <= unsigned(a) * unsigned(b);
    mul <= std_logic_vector(product(WIDTH-1 downto 0));
    div <= std_logic_vector(unsigned(a) / unsigned(b));
end architecture rtl;