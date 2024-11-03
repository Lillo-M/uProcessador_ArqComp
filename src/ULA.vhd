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
  component mux17bits4x1
        port(   entr0 : in  unsigned(16 downto 0);
                entr1 : in  unsigned(16 downto 0);
                entr2 : in  unsigned(16 downto 0);
                entr3 : in  unsigned(16 downto 0);
                sel   : in  unsigned(1 downto 0); -- bits de seleção num só bus
                saida : out unsigned(16 downto 0)  -- lembre: sem ';' aqui
            );
  end component;
  signal soma, sub, mux_output: unsigned(16 downto 0) := "00000000000000000";
  -- signal xor_s, mulu: unsigned(16 downto 0);
begin
  saida <= mux_output(15 downto 0);


  soma <= ('0' & operando0 ) + operando1;
  sub  <= ('0' & operando0 ) - operando1;
 
  Carry <= mux_output(16);
  zero  <= '1' when mux_output (15 downto 0) = "0000000000000000" else '0';
  
  muxSaida: mux17bits4x1
   port map(
      entr0 (16 downto 0) => soma (16 downto 0),
      entr1 (16 downto 0) => sub (16 downto 0),
      entr2 (16 downto 0) => "00000000000000000",
      entr3 (16 downto 0) => "00000000000000000",
      sel => op_Select,
      saida (16 downto 0) => mux_output (16 downto 0)
  ); 
  
end architecture a_ULA;
