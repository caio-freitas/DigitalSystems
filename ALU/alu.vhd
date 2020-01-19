library ieee;
use ieee.numeric_bit.all;


entity alu is
  generic (
    size : natural := 64 --bit size
  );
  port (
    A, B : in bit_vector(size-1 downto 0); -- inputs
    F    : out bit_vector(size-1 downto 0); -- output
    S    : in bit_vector(3 downto 0); -- operation select
    Z    : out bit; -- zero flag
    Ov   : out bit; -- overflow flag
    Co   : out bit  --carry out
  );
end entity alu;


architecture structural of alu is
  component alu1bit is
    port (
      a, b, less, cin: in bit;
      result, cout, set, overflow: out bit;
      ainvert, binvert: in bit;
      operation: in bit_vector(1 downto 0)
    );
  end component;

signal c: bit_vector(size-2 downto 0);
signal less: bit;
signal ainvert, binvert: bit;
signal opcode : bit_vector(1 downto 0);
signal sets : bit_vector(size-1 downto 0);
signal overflows : bit_vector(size-1 downto 0);
signal Fz : bit_vector(size-1 downto 0);
begin
  less <= '0';
  
  -- with S select ainvert <=
  --               '1' when "1100",
  --               '0' when others;
  -- with S select binvert <=
  --               '1' when "0110" or "1100",
  --               '0' when others;
  -- with S select opcode <=
  --               "00" when "0000" or "1100",
  --               "01" when "0001",
  --               "10" when ("0010" or "0110"),
  --               "11" when "0111",
  --               "00" when others;


  opcode <= S(1)&S(0);
  ainvert <= S(3);
  binvert <= S(2);
  A1: alu1bit port map (A(0), B(0), less, '0', F(0), c(0), sets(0), overflows(0), ainvert, binvert, opcode);
  G1: for i in 1 to size-2 generate
         ALUs: alu1bit port map (
                 A(i), B(i), less, c(i-1), F(i), c(i), sets(i), overflows(i), ainvert, binvert, opcode);
  end generate;
  A32: alu1bit port map (A(size-1), B(size-1), less, c(size-2), F(size-1), Co, sets(size-1), overflows(size-1), ainvert, binvert, opcode);
  Ov <= overflows(size-1);
end structural;
