-- Automatically generated VHDL-93
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use std.textio.all;
use work.all;
use work.mac_types.all;

entity mac_outputverifier_soutputverifier is
  port(i               : in signed(8 downto 0);
       -- clock
       system1000      : in std_logic;
       -- asynchronous reset: active low
       system1000_rstn : in std_logic;
       result          : out boolean);
end;

architecture structural of mac_outputverifier_soutputverifier is
  signal app_arg        : signed(8 downto 0);
  signal app_arg_0      : boolean;
  signal app_arg_1      : boolean;
  signal x              : signed(8 downto 0);
  signal result_0       : mac_types.tup2_1;
  signal y              : boolean;
  signal y_0            : mac_types.tup2_1;
  signal result_1       : mac_types.tup2_2;
  signal tup_app_arg    : unsigned(1 downto 0);
  signal tup_app_arg_0  : mac_types.tup2_1;
  signal tup_case_scrut : boolean;
  signal tup_case_alt   : unsigned(1 downto 0);
  signal result_2       : signed(8 downto 0);
  signal tup_app_arg_1  : boolean;
  signal x_0            : unsigned(1 downto 0);
  signal tup_app_arg_2  : signed(63 downto 0);
  signal x_app_arg      : unsigned(1 downto 0);
  signal wild           : signed(63 downto 0);
  signal wild_app_arg   : signed(63 downto 0);
  signal x_1            : unsigned(1 downto 0);
begin
  -- assert begin
  assert_r : block
    -- pragma translate_off
    function slv2string (slv : std_logic_vector) return STRING is
       variable result : string (1 to slv'length);
       variable res_l : string (1 to 3);
       variable r : integer;
     begin
       r := 1;
       for i in slv'range loop
          res_l := std_logic'image(slv(i));
          result(r) := res_l(2);
          r := r + 1;
       end loop;
       return result;
    end;
    signal actual : signed(8 downto 0);
    signal expected : signed(8 downto 0);
    -- pragma translate_on
  begin
    -- pragma translate_off
    actual <= i;
    expected <= app_arg;
    process(system1000,system1000_rstn) is
    begin
      if (rising_edge(system1000) or rising_edge(system1000_rstn)) then
        assert (actual = expected) report (("outputVerifier") & ", expected: " & slv2string(toSLV(expected)) & ", actual: " & slv2string(toSLV(actual))) severity error;
      end if;
    end process;
    -- pragma translate_on
    result <= app_arg_0;
  end block;
  -- assert end
  
  app_arg <= x;
  
  -- register begin
  mac_outputverifier_soutputverifier_register : process(system1000,system1000_rstn)
  begin
    if system1000_rstn = '0' then
      app_arg_0 <= false;
    elsif rising_edge(system1000) then
      app_arg_0 <= app_arg_1;
    end if;
  end process;
  -- register end
  
  app_arg_1 <= y;
  
  x <= result_0.tup2_1_sel0;
  
  result_0 <= y_0;
  
  y <= result_0.tup2_1_sel1;
  
  y_0 <= result_1.tup2_2_sel1;
  
  result_1 <= (tup2_2_sel0 => tup_app_arg
              ,tup2_2_sel1 => tup_app_arg_0);
  
  tup_app_arg <= tup_case_alt when tup_case_scrut else
                 x_0;
  
  tup_app_arg_0 <= (tup2_1_sel0 => result_2
                   ,tup2_1_sel1 => tup_app_arg_1);
  
  tup_case_scrut <= x_0 < (resize(unsigned(std_logic_vector(((to_signed(4,64) - to_signed(1,64))))),2));
  
  tup_case_alt <= x_0 + to_unsigned(1,2);
  
  -- index begin
  indexvec : block 
  signal vec : mac_types.array_of_signed_9(0 to 3);
  signal vec_index : integer range 0 to 4-1;
  begin
    vec <= mac_types.array_of_signed_9'(to_signed(0,9),to_signed(1,9),to_signed(5,9),to_signed(14,9));
    vec_index <= to_integer(tup_app_arg_2)
    -- pragma translate_off
                 mod 4
    -- pragma translate_on
                 ;
    result_2 <= vec(vec_index);
  end block;
  -- index end
  
  tup_app_arg_1 <= x_0 = (resize(unsigned(std_logic_vector(((to_signed(4,64) - to_signed(1,64))))),2));
  
  -- register begin
  mac_outputverifier_soutputverifier_register_0 : process(system1000,system1000_rstn)
  begin
    if system1000_rstn = '0' then
      x_0 <= to_unsigned(0,2);
    elsif rising_edge(system1000) then
      x_0 <= x_app_arg;
    end if;
  end process;
  -- register end
  
  tup_app_arg_2 <= wild;
  
  x_app_arg <= x_1;
  
  wild <= wild_app_arg;
  
  wild_app_arg <= signed(std_logic_vector(resize(x_0,64)));
  
  x_1 <= result_1.tup2_2_sel0;
end;
