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
      0    => '0' & x"000" & "0001", -- Ld 0, A
      1    => '0' & x"001" & "0111", -- MOVE A, R1
      2    => '1' & x"FFE" & "0011", -- SUBI A, -2
      3    => '0' & x"001" & "1010", -- SW A, R1
      4    => '0' & x"001" & "1000", -- MOVE R1, A
      5    => '1' & x"FFF" & "0011", -- SUBI A, -1
      6    => '0' & x"01E" & "0110", -- CMPI A, 30
      7    => '1' & x"FFA" & "1100", -- BLO -6
      8    => '0' & x"000" & "0001", -- Ld 0, A
      9    => '0' & x"001" & "0111", -- MOVE A, R1
      10   => '0' & x"001" & "1001", -- LW A, R1
      11   => '0' & x"002" & "0111", -- MOVE A, R2
      12   => '0' & x"002" & "0010", -- ADD A, R2
      13   => '0' & x"002" & "0111", -- MOVE A, R2
      14   => '0' & x"001" & "1000", -- MOVE R1, A
      15   => '1' & x"FFF" & "0011", -- SUBI A, -1
      16   => '0' & x"003" & "0111", -- MOVE A, R3
      17   => '0' & x"01E" & "0110", -- CMPI A, 30
      18   => '0' & x"00E" & "1101", -- BHS +14
      19   => '0' & x"003" & "1001", -- LW A, R3
      20   => '0' & x"002" & "0101", -- CMPR A, R2
      21   => '0' & x"003" & "1110", -- BEQ +3  -- seta como 0x1FFF
      22   => '0' & x"004" & "1100", -- BLT +4 -- continua somando
      23   => '0' & x"01C" & "1111", -- JUMP 28 -- recomeça com o proximo
      24   => '1' & x"FFF" & "0001", -- Ld -1, A
      25   => '0' & x"080" & "1111", -- JUMP 128 -- recomeça com o proximo
      26   => '0' & x"003" & "1000", -- MOVE R3, A
      27   => '0' & x"00F" & "1111", -- JUMP 15
      28   => '0' & x"001" & "1001", -- LW A, R1
      29   => '0' & x"002" & "0010", -- ADD A, R2
      30   => '0' & x"002" & "0111", -- MOVE A, R2
      31   => '0' & x"00E" & "1111", -- JUMP 14
      32   => '0' & x"001" & "1000", -- MOVE R1, A
      33   => '0' & x"001" & "0111", -- MOVE A, R1
      34   => '1' & x"FFF" & "0011", -- SUBI A, -1
      35   => '0' & x"01E" & "0110", -- CMPI A, 30
      36   => '0' & x"002" & "1101", -- BHS +2
      37   => '0' & x"009" & "1111", -- JUMP 9
      38   => '0' & x"000" & "0001", -- Ld 0, A
      39   => '0' & x"001" & "0111", -- MOVE A, R1
      40   => '0' & x"001" & "1001", -- LW A, R1
      41   => '0' & x"005" & "0111", -- MOVE A, R5
      42   => '0' & x"001" & "1000", -- MOVE R1, A
      43   => '1' & x"FFF" & "0011", -- SUBI A, -1
      44   => '0' & x"080" & "0110", -- CMPI A, 128
      45   => '1' & x"FFA" & "1100", -- BLO -6



      128 => '0' & x"003" & "1001", -- LW A, R3
      129 => '1' & x"FC0" & "0011", -- SUBI A, -64
      130 => '0' & x"000" & "0111", -- MOVE A, R0
      131 => '0' & x"003" & "1001", -- LW A, R3
      132 => '0' & x"000" & "1010", -- SW A, R0
      133 => '0' & x"01A" & "1111", -- JUMP 26




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
