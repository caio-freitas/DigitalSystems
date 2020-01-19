library ieee;
use ieee.numeric_bit.all;

entity signExtend is
  port(
    i : in bit_vector(31 downto 0); -- 32 bit input
    o : out bit_vector(63 downto 0) --32 bits output, extended to 64 bits
  );
end signExtend;

architecture ext_arch of signExtend is
  signal d  : bit_vector(1 downto 0);
  signal c_b : bit_vector(1 downto 0);
  signal b  : bit;
begin
  d <= "11";
  c_b <= "10";
  b <= '0';
 o <= (63 downto 9 => i(20)) & i(20 downto 12) when i(31 downto 30) = d else
      (63 downto 19 => i(23)) & i(23 downto 5) when i(31 downto 30) = c_b else
      (63 downto 26 => i(25)) & i(25 downto 0) when i(31) = b;
end architecture;
