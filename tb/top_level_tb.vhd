library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level_tb is
end entity top_level_tb;


architecture a_top_level_tb of top_level_tb is
  component top_level
    port(
      clk                          : in  std_logic := '0';
      reset                        : in  std_logic := '0';
      Zero, Carry                  : out std_logic := '0'
    );
  end component;
  signal Zero, Carry                  : std_logic := '0';
  constant period_time                : time      := 10 ns;
  signal   finished, reset, clk       : std_logic := '0';
begin
  
  uut : top_level
   port map(
      clk => clk,
      reset => reset,
      Zero => Zero,
      Carry => Carry
  );

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
  
  tb: process
  begin 
    wait for 2*period_time;
    wait;
  end process tb;

end architecture a_top_level_tb;
