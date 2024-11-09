library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux17bits4x1 is
        port(   entr0 : in  unsigned(16 downto 0) := x"0000" & '0';
                entr1 : in  unsigned(16 downto 0) := x"0000" & '0';
                entr2 : in  unsigned(16 downto 0) := x"0000" & '0';
                entr3 : in  unsigned(16 downto 0) := x"0000" & '0';
                sel   : in  unsigned(1 downto 0) := "00"; -- bits de seleção num só bus
                saida : out unsigned(16 downto 0) := x"0000" & '0'  -- lembre: sem ';' aqui
            );
end entity mux17bits4x1;

architecture a_mux17bits4x1 of mux17bits4x1 is
begin
   saida <=    entr0 when sel="00" else -- observe as aspas duplas!
               entr1 when sel="01" else
               entr2 when sel="10" else
               entr3 when sel="11" else
               x"0000" & '0';              -- saida tem 17 bits, portanto 17 zeros
end architecture a_mux17bits4x1;
