library ieee;
use ieee.numeric_bit.all;

entity datapath is
  port (
  -- Common
  clock : in bit;
  reset : in bit;
  -- From control Unit
  reg2loc : in bit;
  pcsrc : in bit;
  memToReg : in bit;
  aluCtrl: in bit_vector(3 downto 0);
  aluSrc: in bit;
  regWrite: in bit;
  -- To control unit
  opcode: out bit_vector(10 downto 0);
  zero:   out bit;
  -- IM interface
  imAddr: out bit_vector(63 downto 0);
  imOut: in bit_vector(31 downto 0);
  -- DM interface
  dmAddr: out bit_vector(63 downto 0);
  dmIn: out bit_vector(63 downto 0);
  dmOut: out bit_vector(63 downto 0)
  );
end entity datapath;


architecture datapath_arch of datapath is

  component regfile is
    generic(
      regn     : natural := 32;
      wordSize : natural := 64
    );
    port(
      clock        : in bit;
      reset        : in bit;
      regWrite     : in bit;
      rr1, rr2, wr : in bit_vector(natural(ceil(log2(real(regn)))) - 1 downto 0);
      d            : in bit_vector(wordSize - 1 downto 0);

      q1, q2       : out bit_vector(wordSize -1 downto 0)
    );
  end component;

  begin
    dut: regfile port map(clock => clock, reset=> reset, regWrite => regWrite, rr1 =>)


end architecture;
