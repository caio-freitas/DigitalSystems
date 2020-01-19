library ieee;
use ieee.numeric_bit.all;

entity ram is
  generic (
    addressSize : natural := 64;
    wordSize   : natural := 32
  );
  port (
    ck, wr : in  bit;
    addr   : in  bit_vector(addressSize-1 downto 0);
    data_i : in  bit_vector(wordSize - 1 downto 0);
    data_o : out bit_vector(wordSize - 1 downto 0)
  );
end ram;

architecture ram_arch of ram is

  type ram_type is array(0 to 2**addressSize - 1) of bit_vector(wordSize - 1 downto 0);
  signal ram_mem : ram_type;
  --signal address: std_logic_vector(0 to addressSize-1);
begin
  RAMProc: process(ck) is
  begin

    if ck'event and ck='1' then
      if wr = '1' then
        ram_mem(to_integer(unsigned(addr))) <= data_i;
      end if;
    end if;
  end process;
  data_o <= ram_mem(to_integer(unsigned(addr)));

end ram_arch;
