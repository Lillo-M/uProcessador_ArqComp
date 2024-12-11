library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processador_tb is
end entity processador_tb;


architecture a_processador_tb of processador_tb is
  component top_level
    port(
      clk                          : in  std_logic := '0';
      reset                        : in  std_logic := '0';
      reg_0  : out UNSIGNED (15 downto 0) := x"0000";
      reg_1  : out UNSIGNED (15 downto 0) := x"0000";
      reg_2  : out UNSIGNED (15 downto 0) := x"0000";
      reg_3  : out UNSIGNED (15 downto 0) := x"0000";
      reg_4  : out UNSIGNED (15 downto 0) := x"0000";
      PC_Out : out UNSIGNED (15 downto 0) := x"0000";
      Estado_Out : out UNSIGNED (2 downto 0):= "000";
      InstReg_o  : out UNSIGNED (16 downto 0) := '0' & x"0000";
      ALU_Out    : out UNSIGNED (15 downto 0) := x"0000";
      Acumulador_o : out UNSIGNED (15 downto 0) := x"0000"
    );
  end component;
  constant period_time                : time      := 10 ns;
  signal   finished, reset, clk       : std_logic := '0';
  signal reg_0  : UNSIGNED (15 downto 0) := x"0000";
  signal reg_1  : UNSIGNED (15 downto 0) := x"0000";
  signal reg_2  : UNSIGNED (15 downto 0) := x"0000";
  signal reg_3  : UNSIGNED (15 downto 0) := x"0000";
  signal reg_4  : UNSIGNED (15 downto 0) := x"0000";
  signal PC_Out : UNSIGNED (15 downto 0) := x"0000";
  signal Estado_Out  : UNSIGNED (2 downto 0):= "000";
  signal InstReg_o   : UNSIGNED (16 downto 0) := '0' & x"0000";
  signal ALU_Out     : UNSIGNED (15 downto 0) := x"0000";
  signal Acumulador_o : UNSIGNED (15 downto 0) := x"0000";
begin
  
  uut: top_level
   port map(
      clk => clk,
      reset => reset,
      reg_0 => reg_0,
      reg_1 => reg_1,
      reg_2 => reg_2,
      reg_3 => reg_3,
      reg_4 => reg_4,
      PC_Out => PC_Out,
      Estado_Out => Estado_Out,
      InstReg_o => InstReg_o,
      ALU_Out => ALU_Out,
      Acumulador_o => Acumulador_o
  );

  reset_global: process
    begin
        reset <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        reset <= '0';
        wait;
    end process;

--  sim_time_proc: process
--    begin
--        wait for 15 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
--        finished <= '1';
--        wait;
--    end process sim_time_proc;

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

end architecture a_processador_tb;
