library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom_tb is
end entity rom_tb;


architecture a_rom_tb of rom_tb is
  component rom
   port( clk      : in std_logic;
         endereco : in unsigned(15 downto 0);
         dado     : out unsigned(16 downto 0) 
   );
  end component;
  signal endereco : unsigned(15 downto 0) := x"0000";
  signal dado : unsigned(16 downto 0) := x"0000" & '0';
  signal clk, finished : std_logic := '0';
  constant period_time : time := 100 ns;
begin

  tb_rom: rom
   port map(
      clk => clk,
      endereco => endereco,
      dado => dado
  );

  clock: process
  begin
    while finished = '0' loop
      clk <= '0';
      wait for period_time/2;
      clk <= '1';
      wait for period_time/2;
    end loop;
  end process clock;

  tb: process
  begin
    wait for period_time*3/2;
    endereco <= x"0001";
    wait for period_time;
    endereco <= x"0002";
    wait for period_time;
    endereco <= x"0003";
    wait for period_time;
    endereco <= x"0004";
    wait for period_time;
    endereco <= x"0005";
    wait for period_time;
    endereco <= x"0006";
    wait for period_time;
    endereco <= x"0007";
    wait for period_time;
    endereco <= x"0008";
    wait for period_time;
    endereco <= x"0009";
    wait for period_time;
    endereco <= x"000A";
    wait for period_time;
    wait;
  end process tb;
   
end architecture a_rom_tb;
