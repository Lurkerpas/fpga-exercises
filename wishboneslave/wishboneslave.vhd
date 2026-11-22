library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Wishbone slave interface VHDL module
-- Implemented per https://wishbone-interconnect.readthedocs.io/en/latest/
-- Signals
--   clk     : Clock input
--   rst     : Reset input
--   adr_i   : Address input
--   dat_i   : Data input
--   dat_o   : Data output
--   we_i    : Write enable input
--   stb_i   : Strobe input
--   cyc_i   : Cycle input
--   ack_o   : Acknowledge output
-- Spec is:
-- 8 bit address
-- 8 bit data

entity wishboneslave is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        adr_i   : in  std_logic_vector(7 downto 0);
        dat_i   : in  std_logic_vector(7 downto 0);
        dat_o   : out std_logic_vector(7 downto 0);
        we_i    : in  std_logic;
        stb_i   : in  std_logic;
        cyc_i   : in  std_logic;
        ack_o   : out std_logic
    );
end wishboneslave;

architecture rtl of wishboneslave is
    constant ENABLE_BIT : integer := 0;
    constant DATA_REG_ADDR : std_logic_vector(1 downto 0) := "00";
    constant STATUS_REG_ADDR : std_logic_vector(1 downto 0) := "01";
    signal status_reg : std_logic_vector(7 downto 0);
    signal data_reg : std_logic_vector(7 downto 0);
begin

    process(clk, rst) is
        -- Procedures need to be in process scope to have access to signals
        procedure reset_regs is
        begin
            status_reg <= (others => '0');
            data_reg <= (others => '0');
            ack_o <= '0';
        end procedure;

        procedure set_data is
        begin
            data_reg <= dat_i;
            ack_o <= '1';
        end procedure;

        procedure get_data is
        begin
            dat_o <= data_reg;
            ack_o <= '1';
        end procedure;

        procedure set_status is
        begin
            status_reg <= dat_i;
            ack_o <= '1';
        end procedure;

        procedure do_processing is
        begin
            if status_reg(ENABLE_BIT) = '1' then
                data_reg <= std_logic_vector(unsigned(data_reg) + 1);
            end if;
        end procedure;

    begin
       if rising_edge(clk) then
           if rst = '1' then
               reset_regs;
           elsif cyc_i = '1' and stb_i = '1' then
               -- single read or write operation
               case adr_i(1 downto 0) is
                   when DATA_REG_ADDR =>
                       if we_i = '1' then
                           set_data;
                       else
                           get_data;
                       end if;
                   when STATUS_REG_ADDR =>
                       if we_i = '1' then
                           set_status;
                       end if;
                   when others =>
                       ack_o <= '0';
               end case;
           else
               -- no valid cycle, clear acknowledge and do processing
               do_processing;
               ack_o <= '0';
           end if;
       end if;
    end process;

end rtl;