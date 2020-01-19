library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.all;

entity reg is
  generic(
    wordSize : natural := 64
  );
  port (
    clock : in bit;
    reset : in bit;
    load  : in bit;
    d     : in bit_vector(wordSize - 1 downto 0);
    q     : out bit_vector(wordSize - 1 downto 0)
  );
end reg;


architecture R of reg is

begin
  process(clock, reset, load) is
  begin
    if reset = '1' then
      q <= (others => '0');
    elsif clock'event and clock ='1' and load = '1' then
        q <= d;
    end if;
  end process;

end R;

library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.all;


-- Parametros:
-- regn -> numero de registradores
-- wordSize -> tamanho das palavras
entity regfile is
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
end regfile;


architecture reg_bank_arch of regfile is
  component reg is
    generic(
      wordSize : natural := 64
    );
    port (
      clock : in bit;
      reset : in bit;
      load  : in bit;
      d     : in bit_vector(wordSize - 1 downto 0);
      q     : out bit_vector(wordSize - 1 downto 0)
    );
  end component;

  type bank_type is array (regn - 1 downto 0) of bit_vector (wordSize - 1 downto 0);
  signal inputs  : bank_type;
  signal outputs : bank_type;
  signal zero     : bit_vector (wordSize - 1 downto 0);

begin
  zero <= (others => '0');
  GenBankRegister: for i in regn - 1 downto 0 generate
    generate_all :if i < regn - 1 generate
      Rx : reg generic map(wordSize)
               port map (clock, reset, regWrite, inputs(i), outputs(i));
    end generate;

    generate_zero: if i = regn - 1 generate
      Rl : reg generic map(wordSize => wordSize)
               port map(clock, '1', '0', inputs(i), outputs(i));
    end generate;
  end generate GenBankRegister;

  q1 <= outputs(to_integer(unsigned(rr1)));
  q2 <= outputs(to_integer(unsigned(rr2)));
  process (clock, reset)
  begin
    if (reset = '1') then
      for i in regn - 1 downto 0 loop
        inputs(i) <= zero;
      end loop;
    else
      inputs(to_integer(unsigned(wr))) <= d;
    end if;
  end process;
end reg_bank_arch;
