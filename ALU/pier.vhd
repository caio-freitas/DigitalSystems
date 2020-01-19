library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.numeric_bit.all;

entity alu is
	generic(
		size:natural:=10 --bitsize
	);
	port(
		A,B:	in  bit_vector(size-1 downto 0); --inputs
		F:		out bit_vector(size-1 downto 0); --output
		S:		in  bit_vector(3 downto 0); --opselection
		Z:		out bit; --zeroflag
		Ov:		out bit; --overflowflag
		Co:		out bit --carryout
	);
end entity alu;

architecture arch_alu of alu is

component alu1bit is
	port(
		a,b,less,cin : in bit;
		result,cout,set,overflow : out bit;
		ainvert,binvert : in bit;
		operation : in bit_vector(1 downto 0)
	);
end component;

signal Less : bit;
signal c : bit_vector(size-2 downto 0);
signal sel_op : bit_vector(1 downto 0);
signal set_sig, overflow_sig: bit_vector(size-1 downto 0);


begin
	--with S(0) select
	--		a_n <= 	A when '0',
	--				NOT(A) when '1';
	--with S(1) select
	--		b_n <= 	B when '0',
	--		NOT(B) when '1';

	sel_op <= S(1)&S(0);
	Less <= '0';

	ULA1: alu1bit port map(a => A(0), b => B(0), less => Less, cin => '0', result => F(0), cout => c(0), set => set_sig(0), overflow => overflow_sig(0), ainvert => S(3), binvert => S(2), operation => sel_op);

	gen: for i in 1 to size-2 generate
		conj: alu1bit port map (A(i), B(i), Less, c(i-1), F(i), c(i), set_sig(i), overflow_sig(i), S(3), S(2), sel_op);
	end generate;

	ULA32: alu1bit port map(A(size-1), B(size-1), Less, c(size-2), F(size-1), Co, set_sig(size-1), overflow_sig(size-1), S(3), S(2), sel_op);

	Ov <= overflow_sig(size-1);
	--Co <= c(size-1);


end arch_alu;
