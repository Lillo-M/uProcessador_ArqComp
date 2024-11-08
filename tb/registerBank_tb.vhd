library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registerBank_tb is
end entity registerBank_tb;

architecture a_registerBank_tb of registerBank_tb is
  component registerBank
  port (
    reg_sel   : in  UNSIGNED  (2 downto 0);
    reg_write : in  UNSIGNED  (2 downto 0);
    wr_data   : in  UNSIGNED (15 downto 0);
    wr_en     : in  std_logic;
    clk       : in  std_logic;
    reset     : in  std_logic;
    reg_data  : out UNSIGNED (15 downto 0)
  );
  end component;
  signal reg_sel, reg_write  : UNSIGNED  (2 downto 0) :=  "000";
  signal reg_data, wr_data   : UNSIGNED (15 downto 0) := x"0000";
  signal clk, wr_en, reset   : std_logic := '0';
  constant period_time : time      := 100 ns;
  signal   finished    : std_logic := '0';
begin
  uut : registerBank
   port map(
      reg_sel => reg_sel,
      reg_write => reg_write,
      wr_data => wr_data,
      wr_en => wr_en,
      clk => clk,
      reset => reset,
      reg_data => reg_data
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
    reg_write <=  "000";
    wr_data   <= x"0010";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_write <=  "001";
    wr_data   <= x"0100";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_write <=  "010";
    wr_data   <= x"0110";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_write <=  "011";
    wr_data   <= x"1000";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_write <=  "100";
    wr_data   <= x"1010";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_sel   <=  "000";
    reg_write <=  "000";
    wr_en     <=  '0';
    wr_data   <= x"0000";
    wait for 100 ns;
    reg_sel   <=  "001";
    wait for 100 ns;
    reg_sel   <=  "010";
    wait for 100 ns;
    reg_sel   <=  "011";
    wait for 100 ns;
    reg_sel   <=  "100";
    wait for 100 ns;
    wait;
  end process tb;

end architecture a_registerBank_tb;
