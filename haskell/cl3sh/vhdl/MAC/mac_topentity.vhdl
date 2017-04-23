-- Automatically generated VHDL-93
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use std.textio.all;
use work.all;
use work.mac_types.all;

entity mac_topentity is
  port(input_0_0       : in signed(8 downto 0);
       input_0_1       : in signed(8 downto 0);
       -- clock
       system1000      : in std_logic;
       -- asynchronous reset: active low
       system1000_rstn : in std_logic;
       output_0        : out signed(8 downto 0));
end;

architecture structural of mac_topentity is
  signal input_0 : mac_types.tup2;
begin
  input_0 <= (tup2_sel0 => input_0_0
             ,tup2_sel1 => input_0_1);
  
  mac_topentity_0_inst : entity mac_topentity_0
    port map
      (w3              => input_0
      ,system1000      => system1000
      ,system1000_rstn => system1000_rstn
      ,result          => output_0);
end;
