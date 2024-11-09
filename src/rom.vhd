library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
   port( clk      : in std_logic;
         endereco : in unsigned(15 downto 0);
         dado     : out unsigned(16 downto 0) 
   );
end entity;

architecture a_rom of rom is
   type mem is array (0 to 65535) of unsigned(16 downto 0);
   constant conteudo_rom : mem := (
      -- caso endereco => conteudo
      0  => '0' & x"008" & "1111",
      1  => "00000000000001111",
      2  => "00000000000001111",
      3  => "00000000000001111",
      4  => '0' & x"009" & "1111",
      5  => "00000000000001111",
      6  => "00000000000001111",
      7  => "00000000000001111",
      8  => '0' & x"004" & "1111",
      9  => "00000000000000000",
      10 => "00000000000001111",
      -- abaixo: casos omissos => (zero em todos os bits)
      others => (others=>'0')
   );
begin

   process(clk)
   begin
      if(rising_edge(clk)) then
         dado <= conteudo_rom(to_integer(endereco));
      end if;
   end process;

end architecture;
