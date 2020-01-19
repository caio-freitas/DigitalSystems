library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;
-- Parametros:
-- regn -> numero de registradores
-- wordSize -> tamanho das palavras

entity regfile is
  generic(
    regn: natural := 32;
    wordSize: natural := 64
  );
  port(
    clock: in bit;
    reset: in bit;
    regWrite: in bit;
    rr1, rr2, wr: in bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
    d: in bit_vector(wordSize-1 downto 0);
    q1, q2: out bit_vector(wordSize-1 downto 0)
  );
end regfile;

architecture reg_arch of regfile is

  type registerFile is array(0 to regn-1) of bit_vector(wordSize-1 downto 0);
  signal registers : registerFile;

begin
  RegFileProc : process(clock)
  begin
    -- ultimo registrador nulo
    registers(regn-1) <= (others => '0');
    -- parcela sincrona (escrita)
    if (clock'event and clock='1') then
      if regWrite='1' then
        if to_integer(unsigned(wr)) /= regn - 1 then
          registers(to_integer(unsigned(wr))) <= d;
        end if;
      end if;
    end if;

    -- parcela assincrona (leitura)
    q1 <= registers(to_integer(unsigned(rr1)));
    q2 <= registers(to_integer(unsigned(rr2)));
    -- reset assincrono
    if reset = '1' then
      for I in 0 to regn-1 loop
        registers(I) <= (others => '0');
      end loop;
    end if;
  end process;
end architecture;
