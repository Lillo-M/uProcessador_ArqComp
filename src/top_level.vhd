library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is
  port(
  ALU_Op                       : in UNSIGNED (01 downto 0) :=  "00";
  reg_sel, reg_write           : in UNSIGNED (02 downto 0) :=  "000";
  clk                          : in  std_logic := '0';
  reset                        : in  std_logic := '0';
  wr_en                        : in  std_logic := '0';
  Zero, Carry                  : out std_logic := '0'
);
end entity top_level;

architecture a_top_level of top_level is 

  component rom
    port( 
          clk      : in std_logic;
          endereco : in unsigned (06 downto 0);
          dado     : out unsigned(16 downto 0) 
        );
  end component;

  component mux16bits4x1 is
    port(   
          entr0 : in  unsigned(15 downto 0);
          entr1 : in  unsigned(15 downto 0);
          entr2 : in  unsigned(15 downto 0);
          entr3 : in  unsigned(15 downto 0);
          sel   : in  unsigned(1 downto 0); -- bits de seleção num só bus
          saida : out unsigned(15 downto 0)  -- lembre: sem ';' aqui
        );
  end component;

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

  component UC
    port (
      instr : in unsigned (16 downto 0);
      clk, reset : in std_logic;
      reg_wr_data_sel : out unsigned (1 downto 0);
      ALU_Src_A, ALU_Src_B : out unsigned (1 downto 0);
      PC_Write : out std_logic;
      jump_en : out std_logic
    );
  end component;

  signal memDataReg, operand_A, 
  operand_B, imm_gen_out: UNSIGNED (15 downto 0) := x"0000";
  signal rom_o : unsigned (16 downto 0) := x"0000" & '0';
  signal reg_data, wr_data, ULA_out,
  acumulador_out, PC_i, PC_o          : UNSIGNED (15 downto 0) := x"0000";
  signal PC_Write, PC_wr_en, jump_en: std_logic := '0';
  signal ALU_Src_A, ALU_Src_B, reg_wr_data_sel :  UNSIGNED (01 downto 0) :=  "00";
begin 

  wr_data_MUX : mux16bits4x1
  port map(
            entr0 => acumulador_out,
            entr1 => memDataReg,
            entr2 => imm_gen_out,
            entr3 => x"0000",
            sel => reg_wr_data_sel,
            saida => wr_data
          );

  operand_A_MUX: mux16bits4x1
  port map(
            entr0 => PC_o,
            entr1 => acumulador_out,
            entr2 => imm_gen_out,
            entr3 => x"0000",
            sel => ALU_Src_A,
            saida => operand_A
          );

  operand_B_MUX: mux16bits4x1
  port map(
            entr0 => reg_data,
            entr1 => x"0001",
            entr2 => imm_gen_out,
            entr3 => x"0000",
            sel => ALU_Src_B,
            saida => operand_B
          );

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

  PC : register16bits
  port map(
            data_in => PC_i,
            data_out => PC_o,
            wr_en => PC_wr_en,
            reset => reset,
            clk => clk
          );

  program_mem: rom
   port map(
      clk => clk,
      endereco (6 downto 0) => PC_o (6 downto 0),
      dado => rom_o
  );

  CU : UC
   port map(
      instr => rom_o,
      clk => clk,
      reset => reset,
      reg_wr_data_sel => reg_wr_data_sel,
      ALU_Src_A => ALU_Src_A,
      ALU_Src_B => ALU_Src_B,
      PC_Write => PC_Write,
      jump_en => jump_en
  );

  PC_wr_en <= PC_Write or jump_en;
  
  imm_gen_out <= "000" & rom_o (16 downto 4);

  PC_i <= ULA_out;

end architecture a_top_level;
