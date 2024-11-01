library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sum_sub_tb is
end entity sum_sub_tb;

architecture a_sum_sub_tb of sum_sub_tb is
  component sum_sub
   port (   x,y       :  in  unsigned(7 downto 0);
            soma,subt :  out unsigned(7 downto 0)
   );
  end component;
  signal x,y,soma, subt : unsigned(7 downto 0);
begin
  
  uut : sum_sub
   port map(
      x => x,
      y => y,
      soma => soma,
      subt => subt
  );
  
  tb: process
  begin
    x <= "00001000";
    y <= "00000111";
    wait for 50 ns;
    x <= "00001001";
    y <= "11111101";
    wait for 50 ns;
    x <= "11001000";
    y <= "11001000";
    wait for 50 ns;
    wait;
  end process tb;
end architecture a_sum_sub_tb;
