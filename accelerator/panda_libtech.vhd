-- 
-- Politecnico di Milano
-- Code created using PandA - Version: PandA 2026.11 - Revision 6407a63da948c1b2223d63a9e91891a5628fe174-dev/panda - Date 2026-11-19T02:12:32
-- Bambu executed with: 'bambu' '--top-fname=mul' '--writer=H' 'func.c'
-- 
-- Send any bug to: panda-info@polimi.it
-- ************************************************************************
-- The following text holds for all the components tagged with MIT.
-- They are all part of the PandA/Bambu IP LIBRARY.
-- Copyright (C) 2004-2026 Politecnico di Milano
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the \"Software\"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
-- ************************************************************************

-- This component is part of the PANDA/BAMBU IP LIBRARY
-- Copyright (C) 2004-2026 Politecnico di Milano
-- Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
-- License: MIT
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use STD.textio.all;
use IEEE.std_logic_textio.all;
-- synthesis translate_off
use STD.env.all;
-- synthesis translate_on
use work.panda_pkg.all;
entity ui_mul_node_FU is 
generic(
 BITSIZE_in1: integer := 1;
 BITSIZE_in2: integer := 1;
 BITSIZE_out1: integer := 1;
 PIPE_PARAMETER: integer := 0);
port (
  -- IN
  clock : in std_logic;
  stall_port : in std_logic;
  in1 : in unsigned (BITSIZE_in1-1 downto 0);
  in2 : in unsigned (BITSIZE_in2-1 downto 0);
  -- OUT
  out1 : out unsigned (BITSIZE_out1-1 downto 0)

);
end ui_mul_node_FU;

architecture ui_mul_node_FU_arch of ui_mul_node_FU is
    signal product_reg : unsigned (BITSIZE_out1-1 downto 0);
  begin
    cond: if (PIPE_PARAMETER=0) generate
      out1 <= resize(in1 * in2, BITSIZE_out1);
    end generate cond;
    cond1: if (PIPE_PARAMETER=1) generate
      process(clock)
      begin
        if clock'event and clock = '1' then
          if stall_port = '0' then
            product_reg <= resize(in1 * in2, BITSIZE_out1);
          end if;
        end if;
      end process;
      out1 <= product_reg;
    end generate cond1;
    cond2: if (PIPE_PARAMETER>1) generate
      type product_pipe_t is array (PIPE_PARAMETER-1 downto 0) of unsigned(BITSIZE_out1-1 downto 0);
      signal product_pipe : product_pipe_t;
    begin
      out1 <= product_pipe(0);
      process(clock)
      begin
        if clock'event and clock = '1' then
          if stall_port = '0' then
            product_pipe(PIPE_PARAMETER-1) <= resize(in1 * in2, BITSIZE_out1);
            for i in 0 to PIPE_PARAMETER-2 loop
              product_pipe(i) <= product_pipe(i+1);
            end loop;
          end if;
        end if;
      end process;
    end generate cond2;
end ui_mul_node_FU_arch;

-- This component is part of the PANDA/BAMBU IP LIBRARY
-- Copyright (C) 2004-2026 Politecnico di Milano
-- Author(s): Fabrizio Ferrandi <fabrizio.ferrandi@polimi.it>
-- License: MIT
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use STD.textio.all;
use IEEE.std_logic_textio.all;
-- synthesis translate_off
use STD.env.all;
-- synthesis translate_on
use work.panda_pkg.all;
entity ui_bitcast_node_FU is 
generic(
 BITSIZE_in1: integer := 1;
 BITSIZE_out1: integer := 1);
port (
  -- IN
  in1 : in std_logic_vector(BITSIZE_in1-1 downto 0) ;
  -- OUT
  out1 : out std_logic_vector(BITSIZE_out1-1 downto 0) 

);
end ui_bitcast_node_FU;

architecture ui_bitcast_node_FU_arch of ui_bitcast_node_FU is
  begin
  out1 <= std_logic_vector(resize(unsigned(in1), BITSIZE_out1));
end ui_bitcast_node_FU_arch;


