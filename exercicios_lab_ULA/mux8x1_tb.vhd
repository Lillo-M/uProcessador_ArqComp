library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux8x1_tb is
end entity mux8x1_tb;


architecture a_mux8x1_tb of mux8x1_tb is
  component mux8x1 
   port( sel0,sel1,sel2          : in std_logic;
         entr : in std_logic_vector (7 downto 0);
         saida                   : out std_logic
   );
  end component;
  signal entr : std_logic_vector (7 downto 0);
  signal saida: std_logic;
  signal sel: STD_LOGIC_VECTOR (2 downto 0);
begin
  uut: mux8x1
   port map(
      sel0 => sel(0),
      sel1 => sel(1),
      sel2 => sel(2),
      entr (7 downto 0) => entr (7 downto 0),
      saida => saida
  );
  entr(0) <= '0';
  entr(1) <= '0';
  entr(2) <= '1';
  entr(3) <= '1';
  entr(4) <= '0';
  entr(5) <= '0';
  entr(6) <= '1';
  entr(7) <= '1';

  tb: process
  begin
    sel(0) <= '0';
    sel(1) <= '0';
    sel(2) <= '0';
    wait for 50 ns;
    sel(0) <= '1';
    sel(1) <= '0';
    sel(2) <= '0';
    wait for 50 ns;
    sel(0) <= '0';
    sel(1) <= '1';
    sel(2) <= '0';
    wait for 50 ns;
    sel(0) <= '1';
    sel(1) <= '1';
    sel(2) <= '0';
    wait for 50 ns;
    sel(0) <= '0';
    sel(1) <= '0';
    sel(2) <= '1';
    wait for 50 ns;
    sel(0) <= '1';
    sel(1) <= '0';
    sel(2) <= '1';
    wait for 50 ns;
    sel(0) <= '0';
    sel(1) <= '1';
    sel(2) <= '1';
    wait for 50 ns;
    sel(0) <= '1';
    sel(1) <= '1';
    sel(2) <= '1';
    wait for 50 ns;
    wait;
  end process tb; 
end architecture a_mux8x1_tb;
