library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg_ULA_tb is
end entity reg_ULA_tb;

architecture a_reg_ULA_tb of reg_ULA_tb is
  component registerBank
  port (
    reg_sel   : in  UNSIGNED (02 downto 0);
    reg_write : in  UNSIGNED (02 downto 0);
    wr_data   : in  UNSIGNED (15 downto 0);
    wr_en     : in  std_logic;
    clk       : in  std_logic;
    reset     : in  std_logic;
    reg_data  : out UNSIGNED (15 downto 0)
  );
  end component;
  
  component ULA  
    port ( 
      op_Select       : in  unsigned(01 downto 0);
      operando0       : in  unsigned(15 downto 0);
      operando1       : in  unsigned(15 downto 0);
      saida           : out unsigned(15 downto 0);
      Zero            : out std_logic;
      Carry           : out std_logic
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

  signal reg_sel, reg_write           : UNSIGNED (02 downto 0) :=  "000";
  signal ALU_op_sel                   : UNSIGNED (01 downto 0) :=  "00";
  signal reg_data, wr_data, ULA_out,
  acumulador_out, memDataReg          : UNSIGNED (15 downto 0) := x"0000";
  signal clk, wr_en, reset, 
  Zero, Carry, MemtoReg               : std_logic := '0';
  constant period_time                : time      := 100 ns;
  signal   finished                   : std_logic := '0';

begin

  wr_data <= acumulador_out when MemtoReg = '0' else memDataReg;

  ALU : ULA
   port map(
      op_Select => ALU_op_sel,
      operando0 => reg_data,
      operando1 => acumulador_out,
      saida => ULA_out,
      Zero => Zero,
      Carry => Carry
  );

  regBank : registerBank
   port map(
      reg_sel => reg_sel,
      reg_write => reg_write,
      wr_data => wr_data,
      wr_en => wr_en,
      clk => clk,
      reset => reset,
      reg_data => reg_data
  );

  acumulador : register16bits
   port map(
      data_in => ULA_out,
      data_out => acumulador_out,
      wr_en => '1',
      reset => '0',
      clk => clk
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
    MemtoReg <= '1';
    reg_sel <= "111";
    wait for 2*period_time;
    reg_write <=  "000";
    memDataReg   <= x"0010";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_write <=  "001";
    memDataReg   <= x"0100";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_write <=  "010";
    memDataReg   <= x"0110";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_write <=  "011";
    memDataReg   <= x"1000";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_write <=  "100";
    memDataReg   <= x"1010";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_sel   <=  "000";
    ALU_op_sel<=   "00";
    reg_write <=  "000";
    MemtoReg  <=  '0';
    wr_en     <=  '0';
    memDataReg   <= x"0000";
    wait for 100 ns;
    reg_sel   <=  "001";
    ALU_op_sel<=   "00";
    wait for 100 ns;
    reg_sel   <=  "010";
    wait for 100 ns;
    reg_sel   <=  "011";
    wait for 100 ns;
    reg_sel   <=  "100";
    wait for 100 ns;
    wait;
  end process tb;

end architecture a_reg_ULA_tb;
