-- Automatically generated VHDL-93
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use std.textio.all;
use work.all;
use work.mac_types.all;

entity mac_expectedoutput is
  port(arg             : in signed(8 downto 0);
       -- clock
       system1000      : in std_logic;
       -- asynchronous reset: active low
       system1000_rstn : in std_logic;
       result          : out boolean);
end;

architecture structural of mac_expectedoutput is
begin
  mac_outputverifier_soutputverifier_result : entity mac_outputverifier_soutputverifier
    port map
      (result          => result
      ,system1000      => system1000
      ,system1000_rstn => system1000_rstn
      ,i               => arg);
end;
