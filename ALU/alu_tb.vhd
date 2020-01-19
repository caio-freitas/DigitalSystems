library ieee;
use ieee.numeric_bit.all;
--use ieee.math_real.all;
use ieee.std_logic_1164.ALL;


entity alu_tb is end; --entity vazia


architecture dut of alu_tb is
  component alu1bit is
    port (
      a, b, less, cin: in bit;
      result, cout, set, overflow: out bit;
      ainvert, binvert: in bit;
      operation: in bit_vector(1 downto 0)
    );
  end component;
  signal p_a, p_b, p_less, p_cin, p_result, p_cout, p_set, p_overflow, p_ainvert, p_binvert : bit;
  signal p_operation : bit_vector(1 downto 0) := "00";
  constant clockPeriod : time := 10 ns;
  signal clock :bit := '0';
begin
  clock <= not clock after clockPeriod;
  dut: alu1bit port map(a=>p_a, b=>p_b, less=>p_less, cin=>p_cin, result=>p_result, cout=>p_cout, set=>p_set, overflow=>p_overflow, ainvert=>p_ainvert, binvert=>p_binvert, operation=>p_operation);

    st: process is
      begin
        wait until rising_edge(clock);
        p_a <= '0'; p_b <= '0';
        p_ainvert <= '0'; p_binvert <= '1';
        p_operation <= "10";
        wait until rising_edge(clock);
        report bit'image(p_result);
    end process;
end dut;


architecture alu1_arch of alu1bit is
  signal op_a, op_b : bit;
  signal sum : bit;
  signal carry_out : bit;
  begin
    op_a <= a xor ainvert;
    op_b <= b xor binvert;
    sum <= ((not cin) and (op_a xor op_b)) or (cin and (not (op_a xor op_b)));
    set <= sum;
    carry_out <= (op_a and op_b) or (op_b and cin) or (op_a and cin);
    cout <= carry_out;
    overflow <= cin xor carry_out;
  with operation select result <=
      (op_a and op_b) when "00",
      (op_a or op_b) when "01",
      sum when "10",
      less when "11";
      --(not a) and b when "11";
  end architecture;
