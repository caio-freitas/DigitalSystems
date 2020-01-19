ffdr: process(clock, reset)
begin
  if reset='1' then
    q <= '0';
    q_n <= '1';
  elsif clock='1' and clock'event then
    if en = '1' then
      q <= d;
      q_n <= not d;
    end if;
  end if;
end process
