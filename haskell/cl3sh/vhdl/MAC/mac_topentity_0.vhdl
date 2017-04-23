-- Automatically generated VHDL-93
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use std.textio.all;
use work.all;
use work.mac_types.all;

entity mac_topentity_0 is
  port(w3              : in mac_types.tup2;
       -- clock
       system1000      : in std_logic;
       -- asynchronous reset: active low
       system1000_rstn : in std_logic;
       result          : out signed(8 downto 0));
end;

architecture structural of mac_topentity_0 is
begin
  mac_mealy_result : entity mac_mealy
    port map
      (result          => result
      ,system1000      => system1000
      ,system1000_rstn => system1000_rstn
      ,w2              => w3);
end;
