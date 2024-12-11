library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registerBank is
  port (
       -- Isso aqui eu tô supondo que a gente vai ter
       -- no máximo 8 registradores, já que teremos no mínimo 5.
       -- Por enquanto eu acho que é muito
       -- trabalho fazer com que a gente possa processar instruções
       -- na ULA com o acumulador como entrada A e B.
    reg_sel   : in  UNSIGNED  (2 downto 0) := "000";
    reg_write : in  UNSIGNED  (2 downto 0) := "000";
    wr_data   : in  UNSIGNED (15 downto 0) := x"0000";
    wr_en     : in  std_logic := '0';
    clk       : in  std_logic := '0';
    reset     : in  std_logic := '0';
    reg_data  : out UNSIGNED (15 downto 0) := x"0000";
    reg_0  : out UNSIGNED (15 downto 0) := x"0000";
    reg_1  : out UNSIGNED (15 downto 0) := x"0000";
    reg_2  : out UNSIGNED (15 downto 0) := x"0000";
    reg_3  : out UNSIGNED (15 downto 0) := x"0000";
    reg_4  : out UNSIGNED (15 downto 0) := x"0000"
  );
end entity registerBank;

architecture a_registerBank of registerBank is
  component register16bits  
    port (
      data_in  : in  UNSIGNED (15 downto 0);
      data_out : out UNSIGNED (15 downto 0);
      wr_en    : in std_logic;
      reset    : in std_logic;
      clk      : in std_logic
    );
  end component;
  
  component mux16bits8x1
    port(   entr0 : in  unsigned(15 downto 0);
            entr1 : in  unsigned(15 downto 0);
            entr2 : in  unsigned(15 downto 0);
            entr3 : in  unsigned(15 downto 0);
            entr4 : in  unsigned(15 downto 0);
            entr5 : in  unsigned(15 downto 0);
            entr6 : in  unsigned(15 downto 0);
            entr7 : in  unsigned(15 downto 0);
            sel   : in  unsigned( 2 downto 0);
            saida : out unsigned(15 downto 0)
        );
  end component; 
  signal mux_input0, mux_input1, mux_input2,
  mux_input3, mux_input4, mux_input5,
  mux_input6, mux_input7 : unsigned(15 downto 0) := x"0000";
  signal sel_and_wr0, sel_and_wr1, sel_and_wr2,
  sel_and_wr3, sel_and_wr4, sel_and_wr5: std_logic := '0';
begin
  sel_and_wr0 <= '1' when reg_write = "000" and wr_en = '1' else '0';
  sel_and_wr1 <= '1' when reg_write = "001" and wr_en = '1' else '0';
  sel_and_wr2 <= '1' when reg_write = "010" and wr_en = '1' else '0';
  sel_and_wr3 <= '1' when reg_write = "011" and wr_en = '1' else '0';
  sel_and_wr4 <= '1' when reg_write = "100" and wr_en = '1' else '0';
  sel_and_wr5 <= '1' when reg_write = "101" and wr_en = '1' else '0';

  muxRegisters : mux16bits8x1
   port map(
      entr0 => mux_input0,
      entr1 => mux_input1,
      entr2 => mux_input2,
      entr3 => mux_input3,
      entr4 => mux_input4,
      entr5 => mux_input5,
      entr6 => mux_input6,
      entr7 => mux_input7,
      sel => reg_sel,
      saida => reg_data
  );
  
  register0 : register16bits
   port map(
      data_in => wr_data,
      data_out => mux_input0,
      wr_en => sel_and_wr0,
      reset => reset,
      clk => clk
  );
  
  register1 : register16bits
   port map(
      data_in => wr_data,
      data_out => mux_input1,
      wr_en => sel_and_wr1,
      reset => reset,
      clk => clk
  );
  
  register2 : register16bits
   port map(
      data_in => wr_data,
      data_out => mux_input2,
      wr_en => sel_and_wr2,
      reset => reset,
      clk => clk
  );
  
  register3 : register16bits
   port map(
      data_in => wr_data,
      data_out => mux_input3,
      wr_en => sel_and_wr3,
      reset => reset,
      clk => clk
  );
  
  register4 : register16bits
   port map(
      data_in => wr_data,
      data_out => mux_input4,
      wr_en => sel_and_wr4,
      reset => reset,
      clk => clk
  );  

  register5 : register16bits
   port map(
      data_in => wr_data,
      data_out => mux_input5,
      wr_en => sel_and_wr5,
      reset => reset,
      clk => clk
  );  

  reg_0 <= mux_input0;
  reg_1 <= mux_input1;
  reg_2 <= mux_input2;
  reg_3 <= mux_input3;
  reg_4 <= mux_input4;
end architecture a_registerBank;
