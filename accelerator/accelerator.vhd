library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accelerator is
    port (
        clk : in std_logic;
        rst : in std_logic;
        done : out std_logic;
        a : in std_logic_vector(31 downto 0); 
        b : in std_logic_vector(31 downto 0); 
        result : out std_logic_vector(31 downto 0)
    );
end entity accelerator;

architecture rtl of accelerator is
    component mul is
        port (
            -- IN
            clock : in std_logic;
            reset : in std_logic;
            start_port : in std_logic;
            a : in std_logic_vector(31 downto 0) ;
            b : in std_logic_vector(31 downto 0) ;
            -- OUT
            done_port : out std_logic;
            idle_port : out std_logic;
            return_port : out std_logic_vector(31 downto 0) 
        );
    end component;
    
    type state_type is (WAITING, BUSY);
    
    signal state : state_type := WAITING;
    signal start : std_logic := '0';
    signal idle : std_logic;

begin
    u_mul: mul
        port map (
            clock => clk,
            reset => not rst,
            start_port => start,
            a => a,
            b => b,
            done_port => done,
            idle_port => idle,
            return_port => result
        );
    process(clk, rst)
    begin
        if rst = '1' then
            state <= WAITING;
            start <= '0';
        elsif rising_edge(clk) then
            case state is
                when WAITING =>
                    if idle = '1' then
                        start <= '1';
                        state <= BUSY;
                    end if;
                when BUSY =>
                    if done = '1' then
                        start <= '0';
                        state <= BUSY;
                    end if;
                when others =>
                    state <= WAITING;
            end case;
        end if;
    end process;


end architecture rtl;

