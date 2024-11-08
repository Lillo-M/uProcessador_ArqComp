library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux8x1 is
   port( sel0,sel1,sel2          : in std_logic := '0';
         entr                    : in std_logic_vector (7 downto 0) := x"00";
         saida                   : out std_logic := '0'
   );
end entity;

architecture a_mux8x1 of mux8x1 is
begin
   saida <=    entr(0)    when sel2='0' and sel1='0' and sel0='0' else
               entr(1)    when sel2='0' and sel1='0' and sel0='1' else
               entr(2)    when sel2='0' and sel1='1' and sel0='0' else
               entr(3)    when sel2='0' and sel1='1' and sel0='1' else
               entr(4)    when sel2='1' and sel1='0' and sel0='0' else
               entr(5)    when sel2='1' and sel1='0' and sel0='1' else
               entr(6)    when sel2='1' and sel1='1' and sel0='0' else
               entr(7)    when sel2='1' and sel1='1' and sel0='1' else
               '0';     -- esse '0' é pra quando "der pau" em sel1 ou sel0
end architecture;
