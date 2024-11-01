library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sum_sub is
   port (   x,y       :  in  unsigned(7 downto 0);
            soma,subt :  out unsigned(7 downto 0)
   );
end entity;

architecture a_sum_sub of sum_sub is
begin
   soma <= x+y;
   subt <= x-y;
end architecture a_sum_sub;
