library ieee;
use ieee.numeric_bit.all;

entity reg is
  generic(wordSize: natural :=4); -- wordSize e o parametro
  port(
    clock: in bit;
    reset: in bit;
    load:  in bit;
    d:     in bit_vector(wordSize-1 downto 0);
    q:     out bit_vector(wordSize-1 downto 0)
  );
end reg;

architecture arch_reg of reg is
  type ff_vector is array (0 to 2**wordSize - 1) of ffdr
  signal ffs : ff_vector;
begin
  RegProc: process(clock, reset) is
    begin
      if load='1' and (ck'event and ck='1') then
        ffs<=d;
      end if;
    end process;
    q <= ffs;
end architecture;
