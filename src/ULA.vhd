library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA is
  port (
    op_Select       : in  unsigned(1 downto 0);
    operando0       : in  unsigned(15 downto 0);
    operando1       : in  unsigned(15 downto 0);
    saida           : out unsigned(15 downto 0);
    Zero            : out std_logic;
    Carry           : out std_logic

  );
end entity ULA;


architecture a_ULA of ULA is
  component mux16bits4x1
        port(   entr0 : in  unsigned(15 downto 0);
                entr1 : in  unsigned(15 downto 0);
                entr2 : in  unsigned(15 downto 0);
                entr3 : in  unsigned(15 downto 0);
                sel   : in  unsigned(1 downto 0); -- bits de seleção num só bus
                saida : out unsigned(15 downto 0)  -- lembre: sem ';' aqui
            );
  end component;
  signal soma, sub, xor_s, mulu: unsigned(16 downto 0);
begin

  soma <= ('0' & operando0 ) + operando1;
  sub  <= ('0' & operando0 ) - operando1;
  
  Carry <= soma(16) when op_Select = "00" else
            sub(16) when op_Select = "01" else
            '0';

  zero  <= '1' when saida (15 downto 0) = "0000000000000000" else '0';
  
  muxSaida: mux16bits4x1
   port map(
      entr0 (15 downto 0) => soma (15 downto 0),
      entr1 (15 downto 0) => sub (15 downto 0),
      entr2 (15 downto 0) => "0000000000000000",
      entr3 (15 downto 0) => "0000000000000000",
      sel => op_Select,
      saida (15 downto 0) => saida (15 downto 0)
  );

  
  
end architecture a_ULA;
