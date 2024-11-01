library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux8bits4x1 is
        port(   entr0 : in  unsigned(7 downto 0);
                entr1 : in  unsigned(7 downto 0);
                entr2 : in  unsigned(7 downto 0);
                entr3 : in  unsigned(7 downto 0);
                sel   : in  unsigned(1 downto 0); -- bits de seleção num só bus
                saida : out unsigned(7 downto 0)  -- lembre: sem ';' aqui
            );
end entity mux8bits4x1;

architecture a_mux8bits4x1 of mux8bits4x1 is
begin
   saida <=    entr0 when sel="00" else -- observe as aspas duplas!
               entr1 when sel="01" else
               entr2 when sel="10" else
               entr3 when sel="11" else
               "00000000";              -- saida tem 8 bits, portanto 8 zeros
end architecture a_mux8bits4x1;
