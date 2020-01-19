library IEEE;
use IEEE.Numeric_bit.all;
use std.textio.all;

entity rom is
  generic (
    addressSize  : natural := 64;
    wordSize    : natural := 32;
    mifFileName : string  := "rom.dat"
  );
  port (
    addr   : in  bit_vector(addressSize-1 downto 0);
    data : out bit_vector(wordSize - 1 downto 0)
  );
end rom;

architecture rom_arch of rom is

  type rom_type is array  (0 to 2**addressSize - 1) of bit_vector(wordSize - 1 downto 0);

  impure function init_mem(mif_file_name : in string) return rom_type is
      file mif_file : text open read_mode is mif_file_name;
      variable mif_line : line;
      variable temp_bv : bit_vector(wordSize-1 downto 0);
      variable temp_mem : rom_type;
  begin
      for i in rom_type'range loop
          readline(mif_file, mif_line);
          read(mif_line, temp_bv);
          temp_mem(i) := temp_bv;
      end loop;
      return temp_mem;
  end;
  signal rom_mem : rom_type;
begin
  rom_mem <= init_mem(mifFileName);
  data <= rom_mem(to_integer(unsigned(addr)));

end rom_arch;
