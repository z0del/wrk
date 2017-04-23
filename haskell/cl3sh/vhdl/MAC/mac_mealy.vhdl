-- Automatically generated VHDL-93
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use std.textio.all;
use work.all;
use work.mac_types.all;

entity mac_mealy is
  port(w2              : in mac_types.tup2;
       -- clock
       system1000      : in std_logic;
       -- asynchronous reset: active low
       system1000_rstn : in std_logic;
       result          : out signed(8 downto 0));
end;

architecture structural of mac_mealy is
  signal y             : signed(8 downto 0);
  signal result_0      : mac_types.tup2;
  signal tup_case_alt  : mac_types.tup2;
  signal tup_app_arg   : signed(8 downto 0);
  signal x             : signed(8 downto 0);
  signal tup_app_arg_0 : signed(8 downto 0);
  signal x_app_arg     : signed(8 downto 0);
  signal x_0           : signed(8 downto 0);
  signal y_0           : signed(8 downto 0);
  signal x_1           : signed(8 downto 0);
begin
  result <= y;
  
  y <= result_0.tup2_sel1;
  
  result_0 <= tup_case_alt;
  
  tup_case_alt <= (tup2_sel0 => tup_app_arg
                  ,tup2_sel1 => x);
  
  tup_app_arg <= x + tup_app_arg_0;
  
  -- register begin
  mac_mealy_register : process(system1000,system1000_rstn)
  begin
    if system1000_rstn = '0' then
      x <= to_signed(0,9);
    elsif rising_edge(system1000) then
      x <= x_app_arg;
    end if;
  end process;
  -- register end
  
  tup_app_arg_0 <= resize(x_0 * y_0, 9);
  
  x_app_arg <= x_1;
  
  x_0 <= w2.tup2_sel0;
  
  y_0 <= w2.tup2_sel1;
  
  x_1 <= result_0.tup2_sel0;
end;
