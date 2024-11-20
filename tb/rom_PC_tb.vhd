library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom_PC_tb is
end entity rom_PC_tb;

architecture a_rom_PC_tb of rom_PC_tb is
  component rom
   port( clk      : in std_logic;
         endereco : in unsigned (06 downto 0);
         dado     : out unsigned(16 downto 0) 
   );
  end component;
  component register16bits  
    port (
      data_in  : in  UNSIGNED (15 downto 0);
      data_out : out UNSIGNED (15 downto 0);
      wr_en    : in std_logic;
      reset    : in std_logic;
      clk      : in std_logic
    );
  end component;
  signal soma, PC_o : UNSIGNED (15 downto 0);
  signal dado : unsigned(16 downto 0) := x"0000" & '0';
  signal reset, clk, finished : std_logic := '0';
  constant period_time : time := 100 ns;
begin

  tb_rom: rom
   port map(
      clk => clk,
      endereco (6 downto 0) => PC_o (6 downto 0),
      dado => dado
  );


  soma <= PC_o + 1;

  reset_global: process
    begin
        reset <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        reset <= '0';
        wait;
    end process;

  clock: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished = '0' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clock;
  
  PC : register16bits
   port map(
      data_in => soma,
      data_out => PC_o,
      wr_en => '1',
      reset => reset,
      clk => clk
  );
   
end architecture a_rom_PC_tb;
