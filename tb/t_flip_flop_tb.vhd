library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity t_flip_flop_tb is
end entity t_flip_flop_tb;

architecture a_t_flip_flop_tb of t_flip_flop_tb is
  signal clk, reset, T, Q   : std_logic := '0';
  constant period_time : time      := 100 ns;
  signal   finished    : std_logic := '0';
  component t_flip_flop
  port (
    T        : in std_logic; 
    clk      : in std_logic;
    reset    : in std_logic;
    Q        : out std_logic
  );
  end component;
begin
  
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
  
  t_flip_flop_inst: t_flip_flop
   port map(
      T => T,
      clk => clk,
      reset => reset,
      Q => Q
  );

  tb: process
  begin
    wait for period_time*2;
      T <= '0'; 
    wait for period_time;
      T <= '0'; 
    wait for period_time;
      T <= '0'; 
    wait for period_time;
      T <= '0'; 
    wait for period_time;
      T <= '1'; 
    wait for period_time;
      T <= '1'; 
    wait for period_time;
      T <= '1'; 
    wait for period_time;
      T <= '1'; 
    wait for period_time;
      T <= '1'; 
    wait for period_time;
      T <= '1'; 
    wait for period_time;
    wait;
  end process tb;
  
end architecture a_t_flip_flop_tb;
