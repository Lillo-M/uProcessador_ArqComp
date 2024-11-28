library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA is
  port (
    op_Select       : in  unsigned(1 downto 0) := "00";
    operando0       : in  unsigned(15 downto 0) := x"0000";
    operando1       : in  unsigned(15 downto 0) := x"0000";
    saida           : out unsigned(15 downto 0) := x"0000";
    CarryFF_i       : in std_logic := '0';
    Zero            : out std_logic := '0';
    Carry           : out std_logic := '0'

  );
end entity ULA;


architecture a_ULA of ULA is
  component mux17bits4x1
        port(   entr0 : in  unsigned(16 downto 0) := '0' & x"0000";
                entr1 : in  unsigned(16 downto 0) := '0' & x"0000";
                entr2 : in  unsigned(16 downto 0) := '0' & x"0000";
                entr3 : in  unsigned(16 downto 0) := '0' & x"0000";
                sel   : in  unsigned( 1 downto 0) := "00";
                saida : out unsigned(16 downto 0) := '0' & x"0000"
            );
  end component;
  signal soma, sub_s, 
  mux_output, subb_s: unsigned(16 downto 0) := x"0000" & '0';
  signal mulu: unsigned(31 downto 0) := x"00000000";
begin
  saida  <= mux_output(15 downto 0);
  soma   <= ('0' & operando0) + operando1;
  sub_s  <= ('0' & operando0) - ('1' & operando1);
  subb_s <= ('0' & operando0) - operando1 - (x"000" & "000" & CarryFF_i);
  mulu   <= operando0 * operando1;
  Carry  <= mux_output(16);
  Zero   <= '1' when mux_output (15 downto 0) = x"0000" else '0';
  
  muxSaida: mux17bits4x1
   port map(
      entr0 (16 downto 0) => soma (16 downto 0),
      entr1 (16 downto 0) => sub_s  (16 downto 0),
      entr2 (16 downto 0) => mulu (16 downto 0),
      entr3 (16 downto 0) => subb_s,
      sel (1 downto 0) => op_Select (1 downto 0),
      saida (16 downto 0) => mux_output (16 downto 0)
  ); 
  
end architecture a_ULA;
