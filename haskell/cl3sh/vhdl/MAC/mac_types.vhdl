library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package mac_types is
  type tup2 is record
    tup2_sel0 : signed(8 downto 0);
    tup2_sel1 : signed(8 downto 0);
  end record;
  type tup2_1 is record
    tup2_1_sel0 : signed(8 downto 0);
    tup2_1_sel1 : boolean;
  end record;
  type array_of_tup2 is array (integer range <>) of mac_types.tup2;
  type tup2_2 is record
    tup2_2_sel0 : unsigned(1 downto 0);
    tup2_2_sel1 : mac_types.tup2_1;
  end record;
  type tup2_0 is record
    tup2_0_sel0 : unsigned(1 downto 0);
    tup2_0_sel1 : mac_types.tup2;
  end record;
  type array_of_signed_9 is array (integer range <>) of signed(8 downto 0);
  function toSLV (s : in signed) return std_logic_vector;
  function toSLV (p : mac_types.tup2) return std_logic_vector;
  function toSLV (b : in boolean) return std_logic_vector;
  function fromSLV (sl : in std_logic_vector) return boolean;
  function tagToEnum (s : in signed) return boolean;
  function dataToTag (b : in boolean) return signed;
  function toSLV (p : mac_types.tup2_1) return std_logic_vector;
  function toSLV (value :  mac_types.array_of_tup2) return std_logic_vector;
  function toSLV (u : in unsigned) return std_logic_vector;
  function toSLV (p : mac_types.tup2_2) return std_logic_vector;
  function toSLV (p : mac_types.tup2_0) return std_logic_vector;
  function toSLV (value :  mac_types.array_of_signed_9) return std_logic_vector;
end;

package body mac_types is
  function toSLV (s : in signed) return std_logic_vector is
  begin
    return std_logic_vector(s);
  end;
  function toSLV (p : mac_types.tup2) return std_logic_vector is
  begin
    return (toSLV(p.tup2_sel0) & toSLV(p.tup2_sel1));
  end;
  function toSLV (b : in boolean) return std_logic_vector is
  begin
    if b then
      return "1";
    else
      return "0";
    end if;
  end;
  function fromSLV (sl : in std_logic_vector) return boolean is
  begin
    if sl = "1" then
      return true;
    else
      return false;
    end if;
  end;
  function tagToEnum (s : in signed) return boolean is
  begin
    if s = to_signed(0,64) then
      return false;
    else
      return true;
    end if;
  end;
  function dataToTag (b : in boolean) return signed is
  begin
    if b then
      return to_signed(1,64);
    else
      return to_signed(0,64);
    end if;
  end;
  function toSLV (p : mac_types.tup2_1) return std_logic_vector is
  begin
    return (toSLV(p.tup2_1_sel0) & toSLV(p.tup2_1_sel1));
  end;
  function toSLV (value :  mac_types.array_of_tup2) return std_logic_vector is
    alias ivalue    : mac_types.array_of_tup2(1 to value'length) is value;
    variable result : std_logic_vector(1 to value'length * 18);
  begin
    for i in ivalue'range loop
      result(((i - 1) * 18) + 1 to i*18) := toSLV(ivalue(i));
    end loop;
    return result;
  end;
  function toSLV (u : in unsigned) return std_logic_vector is
  begin
    return std_logic_vector(u);
  end;
  function toSLV (p : mac_types.tup2_2) return std_logic_vector is
  begin
    return (toSLV(p.tup2_2_sel0) & toSLV(p.tup2_2_sel1));
  end;
  function toSLV (p : mac_types.tup2_0) return std_logic_vector is
  begin
    return (toSLV(p.tup2_0_sel0) & toSLV(p.tup2_0_sel1));
  end;
  function toSLV (value :  mac_types.array_of_signed_9) return std_logic_vector is
    alias ivalue    : mac_types.array_of_signed_9(1 to value'length) is value;
    variable result : std_logic_vector(1 to value'length * 9);
  begin
    for i in ivalue'range loop
      result(((i - 1) * 9) + 1 to i*9) := toSLV(ivalue(i));
    end loop;
    return result;
  end;
end;
