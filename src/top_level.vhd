library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is
  port(
    ALU_Op                       : in UNSIGNED (01 downto 0) :=  "00";
    reg_sel, reg_write           : in UNSIGNED (02 downto 0) :=  "000";
    wr_data_sel                  : in UNSIGNED (01 downto 0) :=  "00";
    ALU_Src_A, ALU_Src_B         : in UNSIGNED (01 downto 0) :=  "00";
    imm_gen_out, Inst_Pointer    : in UNSIGNED (15 downto 0) := x"0000";
    clk                          : in  std_logic := '0';
    reset                        : in  std_logic := '0';
    wr_en                        : in  std_logic := '0';
    Zero, Carry                  : out std_logic := '0'
      );
end entity top_level;

architecture a_top_level of top_level is 
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

  signal memDataReg, operand_A, 
                            operand_B : UNSIGNED (15 downto 0) := x"0000";
  signal reg_data, wr_data, ULA_out,
  acumulador_out                      : UNSIGNED (15 downto 0) := x"0000";
begin 

  wr_data <= acumulador_out when wr_data_sel = "00" else 
                 memDataReg when wr_data_sel = "01" else
                imm_gen_out when wr_data_sel = "10" else
             x"0000";
  
  operand_A <= Inst_Pointer when ALU_Src_A = "00" else
             acumulador_out when ALU_Src_A = "01" else
                imm_gen_out when ALU_Src_A = "10" else
               x"0000";
  
  operand_B <=  reg_data when ALU_Src_B = "00" else
                 x"0001" when ALU_Src_B = "01" else
             imm_gen_out when ALU_Src_B = "10" else
               x"0000";

  ALU : ULA
   port map(
      op_Select => ALU_Op,
      operando0 => operand_A,
      operando1 => operand_B,
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
end architecture a_top_level;
