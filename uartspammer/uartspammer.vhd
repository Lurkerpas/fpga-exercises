library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uartspammer is
    port (
        rst : in std_logic;
        clk : in std_logic;
        tx : out std_logic
    );
end entity uartspammer;

architecture rtl of uartspammer is
-- https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter
-- 1 Start Bit, ACTIVE LOW
-- 8 Data Bits
-- 1 Stop Bit, ACTIVE HIGH

-- Baud is 9600
-- Input clock is assumed 10 MHz

constant CLOCK_FREQ : integer := 10_000_000; -- 10 MHz
constant BAUD_RATE : integer := 9600;
constant BAUD_TICKS : integer := CLOCK_FREQ / BAUD_RATE;
constant SPAM_LENGTH : integer := 5;

type spam_array is array (0 to SPAM_LENGTH-1) of std_logic_vector(7 downto 0);
constant SPAM : spam_array := (
    x"53", -- 'S'
    x"50", -- 'P'
    x"41", -- 'A'
    x"4D", -- 'M'
    x"21"  -- '!'
);

subtype shifter_index is integer range 0 to 9; 
subtype shifter_array is std_logic_vector(0 to 9);

signal baud_counter : integer range 0 to BAUD_TICKS := 0;
signal spam_index : integer range 0 to SPAM_LENGTH-1 := 0;
signal shifter : shifter_array := (others => '0');
signal shifter_bit : shifter_index := 0;

function load_shifter(index : integer range 0 to SPAM_LENGTH-1) return shifter_array is
begin
    return (
        0 => '0',
        1 => SPAM(index)(0),
        2 => SPAM(index)(1),
        3 => SPAM(index)(2),
        4 => SPAM(index)(3), 
        5 => SPAM(index)(4),
        6 => SPAM(index)(5),
        7 => SPAM(index)(6),
        8 => SPAM(index)(7),
        9 => '1');
end function;

begin
    process(clk, rst)
    begin
        if rst = '1' then
            baud_counter <= 0;
            spam_index <= 0;
            shifter <= load_shifter(spam_index);
            shifter_bit <= 0;
            tx <= '1';
        elsif rising_edge(clk) then
            if baud_counter = BAUD_TICKS then
                -- UART TICK -> shift out next bit
                baud_counter <= 0;
                if shifter_bit = 9 then
                    -- BYTE COMPLETE -> set shifter with next byte
                    shifter_bit <= 0;
                    spam_index <= (spam_index + 1) mod SPAM_LENGTH;
                    shifter <= load_shifter(spam_index);
                else
                    shifter_bit <= shifter_bit + 1;
                end if;
            else
                baud_counter <= baud_counter + 1;
            end if;
            -- Update TX with current shifter bit
            tx <= shifter(shifter_bit);
        end if;
    end process;
end architecture rtl;