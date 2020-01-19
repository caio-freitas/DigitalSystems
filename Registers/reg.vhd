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
begin
  RegProc: process(clock, reset) is
    begin
      if reset='1' then
        q <= (others => '0');
      elsif load='1' and (clock'event and clock='1') then
        q<=d;
      end if;
    end process;
end architecture;
