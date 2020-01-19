library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity ram is
  port (
    ck   : in  std_logic;
    wr      : in  std_logic;
    addr : in  std_logic_vector;
    data_i  : in  std_logic_vector;
    data_o : out std_logic_vector
  );
end entity ram;

architecture ram_arch of ram is

   type ram_type is array (0 to (2**addr'length)-1) of std_logic_vector(data_i'range);
   signal ram_sign : ram_type;
   signal read_addr : std_logic_vector(addr'range);

begin

  RamProc: process(ck) is

  begin
    if rising_edge(ck) then
      if wr = '1' then
        ram_sign(to_integer(unsigned(addr))) <= data_i;
      end if;
      read_addr <= addr;
    end if;
  end process RamProc;

  data_o <= ram_sign(to_integer(unsigned(read_addr)));

end architecture ram_arch;

---------------------------------------------------------------


entity ram is
  generic(
    address_size : natural := 64;
    word_size    : natural := 32
  );
  port(
    ck, wr : in  bit;
    addr   : in  bit_vector(address_size-1 downto 0);
    data_i : in  bit_vector(word_size-1 downto 0);
    data_o : out bit_vector(word_size-1 downto 0)
  );
end ram;

architecture vendorfree of ram is
  constant depth : natural := 2**address_size;
  type mem_type is array (0 to depth-1) of bit_vector(word_size-1 downto 0);
  signal mem : mem_type;
begin
  wrt: process(ck)
  begin
    if (ck='1' and ck'event) then
      if (wr='1') then
        mem(to_integer(unsigned(addr))) <= data_i;
      end if;
    end if;
  end process;
  data_o <= mem(to_integer(unsigned(addr)));
end vendorfree;
