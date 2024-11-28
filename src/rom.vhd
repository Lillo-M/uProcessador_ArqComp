library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
   port( clk      : in std_logic := '0';
         endereco : in unsigned(15 downto 0) := x"0000";
         dado     : out unsigned(16 downto 0) := '0' & x"0000"
   );
end entity;

architecture a_rom of rom is
   type mem is array (0 to 65535) of unsigned(16 downto 0);
   constant conteudo_rom : mem := (
      -- caso endereco => conteudo
      0  => '0' & x"005" & "0001", -- Load 5 to A
      1  => '0' & x"002" & "0111", -- MOVE A to R2
      2  => '0' & x"008" & "0001", -- Load 8 to A
      3  => '0' & x"003" & "0111", -- MOVE A to R3
      4  => '0' & x"002" & "1000", -- MOVE R2 to A
      5  => '0' & x"003" & "0010", -- add A, R3
      6  => '0' & x"001" & "0011", -- subi A, 1
      7  => '0' & x"004" & "0111", -- MOVE A to R4
      8  => '0' & x"014" & "1111", -- jump to 20
      9  => '0' & x"000" & "0001", -- Load 0 to A
      10 => '0' & x"004" & "0111", -- MOVE A to R4
      20 => '0' & x"004" & "1000", -- MOVE R4 to A
      21 => '0' & x"002" & "0111", -- MOVE A to R2
      22 => '0' & x"004" & "1111", -- jump to 4 (C.)
      23 => '0' & x"000" & "0001", -- Load 0 to A
      24 => '0' & x"002" & "0111", -- MOVE A to R2
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
