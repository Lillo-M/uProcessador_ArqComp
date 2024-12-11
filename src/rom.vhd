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
      -- Este programa é um loop produzindo o somatorio de i de i = 0 até i = <valor carregado inicialmente em R1>
      -- caso endereco => conteudo
      0   => '0' & x"000" & "0001", -- Load 0 to A  
      1   => '0' & x"003" & "0111", -- MOVE A to R3 
      2   => '0' & x"06A" & "0001", -- Load 0x6A to A  -- valor a inicial de R1
      3   => '0' & x"001" & "0111", -- MOVE A to R1
      4   => '0' & x"000" & "0001", -- Load 1 to A  
      5   => '0' & x"002" & "0111", -- MOVE A to R2
      6   => '0' & x"002" & "1000", -- MOVE R2 to A
      7   => '0' & x"003" & "0010", -- ADD A, R3
      8   => '0' & x"002" & "0111", -- MOVE A to R2
      9   => '0' & x"003" & "1000", -- MOVE R3 to A
      10  => '1' & x"FFF" & "0011", -- SUBI A, -1   
      11  => '0' & x"003" & "0111", -- MOVE A to R3
      12  => '0' & x"001" & "1000", -- MOVE R1 to A
      13  => '0' & x"003" & "0101", -- CMPR A, R3
      14  => '1' & x"FF8" & "1101", -- BHS
      15  => '0' & x"002" & "1000", -- MOVE R2 to A
      16  => '0' & x"005" & "0111", -- MOVE A to R5



      
        

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
