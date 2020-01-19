library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.ceil;
use ieee.math_real.log2;

entity stackoverflow is
    generic(
      regn: natural := 32;
      wordSize: natural := 64
    );
    port
    (
    q1          : out std_logic_vector(wordSize-1 downto 0);
    q2          : out std_logic_vector(wordSize-1 downto 0);
    d         : in  std_logic_vector(wordSize-1 downto 0);
    regWrite   : in std_logic;
    rr1       : in std_logic_vector(natural(ceil(log2(real(regn))))-1 downto 0);
    rr2       : in std_logic_vector(natural(ceil(log2(real(regn))))-1 downto 0);
    wr   : in std_logic_vector(natural(ceil(log2(real(regn))))-1 downto 0);
    clock           : in std_logic
    );
end stackoverflow;

architecture reg_arch of stackoverflow is
type registerFile is array(0 to regn) of std_logic_vector(wordSize-1 downto 0);
signal registers : registerFile;
begin

    regFile: process(clock)
    begin
        if rising_edge(clock) then
            if(regWrite = '1') then
                registers(to_integer(unsigned(wr))) <= d;
            end if;
            if falling_edge(clock) then
                q1 <= registers(to_integer(unsigned(rr1)));
                q2 <= registers(to_integer(unsigned(rr2)));
            end if;
        end if;
        if falling_edge(clock) then
                q1 <= registers(to_integer(unsigned(rr1)));
                q2 <= registers(to_integer(unsigned(rr2)));
        end if;
    end process;
end reg_arch;
