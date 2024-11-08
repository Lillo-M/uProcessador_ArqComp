library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level_tb is
end entity top_level_tb;


architecture a_top_level_tb of top_level_tb is
  component top_level
    port(
      ALU_Op                       : in UNSIGNED (01 downto 0);
      reg_sel, reg_write           : in UNSIGNED (02 downto 0);
      wr_data_sel                  : in UNSIGNED (01 downto 0);
      ALU_Src_A, ALU_Src_B         : in UNSIGNED (01 downto 0);
      imm_gen_out, Inst_Pointer    : in UNSIGNED (15 downto 0);
      reset                        : in std_logic;
      clk                          : in std_logic;
      wr_en                        : in  std_logic;
      Zero, Carry                  : out std_logic
    );
  end component;
  signal ALU_Op                       :  UNSIGNED (01 downto 0) :=  "00";
  signal reg_sel, reg_write           :  UNSIGNED (02 downto 0) :=  "000";
  signal wr_data_sel                  :  UNSIGNED (01 downto 0) :=  "00";
  signal ALU_Src_A, ALU_Src_B         :  UNSIGNED (01 downto 0) :=  "00";
  signal imm_gen_out, Inst_Pointer    :  UNSIGNED (15 downto 0) := x"0000";
  signal Zero, Carry                  :  std_logic := '0';
  constant period_time                : time      := 100 ns;
  signal   finished, reset, clk, wr_en: std_logic := '0';
begin
  
  uut: top_level
   port map(
      ALU_Op => ALU_Op,
      reg_sel => reg_sel,
      reg_write => reg_write,
      wr_data_sel => wr_data_sel,
      ALU_Src_A => ALU_Src_A,
      ALU_Src_B => ALU_Src_B,
      imm_gen_out => imm_gen_out,
      Inst_Pointer => Inst_Pointer,
      Zero => Zero,
      reset => reset,
      wr_en => wr_en,
      clk => clk,
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
    reg_sel   <="111";
    ALU_Src_A <= "01";
    ALU_Src_B <= "00";
    wait for 2*period_time;
    reg_write <=  "000";
    wr_data_sel <= "10";
    imm_gen_out <= x"0010";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_write <=  "001";
    wr_data_sel <= "10";
    imm_gen_out <= x"0100";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_write <=  "010";
    imm_gen_out   <= x"0110";
    wr_data_sel <= "10";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_write <=  "011";
    imm_gen_out   <= x"1000";
    wr_data_sel <= "10";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_write <=  "100";
    imm_gen_out   <= x"1010";
    wr_data_sel <= "10";
    wr_en     <=  '1';
    wait for 100 ns;
    reg_sel   <=  "000";
    reg_write <=  "000";
    wr_en     <=  '0';
    imm_gen_out   <= x"0000";
    wr_data_sel <= "10";
    wait for 100 ns;
    wr_data_sel <= "00";
    reg_sel   <=  "001";
    wait for 100 ns;
    reg_sel   <=  "010";
    wait for 100 ns;
    reg_sel   <=  "011";
    wait for 100 ns;
    reg_sel   <=  "100";
    wait for 100 ns;
    reg_sel   <=  "111";
    wr_en <= '1';
    reg_write <= "000";
    wait for 100 ns;
    wr_en <= '0';
    ALU_Src_B <= "00";
    ALU_Op <= "01";
    reg_sel <= "000";
    wait for 100 ns;
    ALU_Src_A <= "00";
    ALU_Src_B <= "01";
    ALU_Op <= "00";
    wait;
  end process tb;

end architecture a_top_level_tb;
