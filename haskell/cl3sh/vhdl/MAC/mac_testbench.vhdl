-- Automatically generated VHDL-93
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use std.textio.all;
use work.all;
use work.mac_types.all;

entity mac_testbench is
  port(done : out boolean);
end;

architecture structural of mac_testbench is
  signal finished        : boolean;
  signal system1000      : std_logic;
  signal system1000_rstn : std_logic;
  signal w3              : mac_types.tup2;
  signal result          : signed(8 downto 0);
begin
  done <= finished;
  
  -- pragma translate_off
  process is
  begin
    system1000 <= '0';
    wait for 3 ns;
    while (not finished) loop
      system1000 <= not system1000;
      wait for 500 ns;
      system1000 <= not system1000;
      wait for 500 ns;
    end loop;
    wait;
  end process;
  -- pragma translate_on
  
  -- pragma translate_off
  system1000_rstn <= '0',
             '1' after 2 ns;
  -- pragma translate_on
  
  totest : entity mac_topentity_0
    port map
      (system1000      => system1000
      ,system1000_rstn => system1000_rstn
      ,w3              => w3
      ,result          => result);
  
  stimuli : entity mac_testinput
    port map
      (system1000      => system1000
      ,system1000_rstn => system1000_rstn
      ,result          => w3);
  
  verify : entity mac_expectedoutput
    port map
      (system1000      => system1000
      ,system1000_rstn => system1000_rstn
      ,arg             => result
      ,result          => finished);
end;
