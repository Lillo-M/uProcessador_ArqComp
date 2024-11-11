library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA is
  port (
    op_Select       : in  unsigned(1 downto 0) := "00";
    operando0       : in  unsigned(15 downto 0) := x"0000";
    operando1       : in  unsigned(15 downto 0) := x"0000";
    saida           : out unsigned(15 downto 0) := x"0000";
    Zero            : out std_logic := '0';
    Carry           : out std_logic := '0'

  );
end entity ULA;


architecture a_ULA of ULA is
  component mux17bits4x1
        port(   entr0 : in  unsigned(16 downto 0);
                entr1 : in  unsigned(16 downto 0);
                entr2 : in  unsigned(16 downto 0);
                entr3 : in  unsigned(16 downto 0);
                sel   : in  unsigned( 1 downto 0); -- bits de seleção num só bus
                saida : out unsigned(16 downto 0)  -- lembre: sem ';' aqui
            );
  end component;
  signal soma, sub_s, 
  mux_output, xor_s: unsigned(16 downto 0) := x"0000" & '0';
  signal mulu: unsigned(31 downto 0) := x"00000000";
begin
  saida <= mux_output(15 downto 0);
  soma  <= ('0' & operando0) + operando1;
  sub_s <= ('0' & operando0) - ('1' & operando1);
  xor_s <=  '0' & (operando0 xor operando1);
  mulu  <= operando0 * operando1;
  Carry <= mux_output(16);
  Zero  <= '1' when mux_output (15 downto 0) = x"0000" else '0';
  
  muxSaida: mux17bits4x1
   port map(
      entr0 (16 downto 0) => soma (16 downto 0),
      entr1 (16 downto 0) => sub_s  (16 downto 0),
      entr2 (16 downto 0) => mulu (16 downto 0),
      entr3 (16 downto 0) => xor_s,
      sel (1 downto 0) => op_Select (1 downto 0),
      saida (16 downto 0) => mux_output (16 downto 0)
  ); 
  
end architecture a_ULA;
