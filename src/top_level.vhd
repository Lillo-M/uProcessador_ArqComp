library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is
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
end entity top_level;

architecture a_top_level of top_level is 

  component rom
    port( 
          clk      : in std_logic := '0';
          endereco : in unsigned(15 downto 0) := x"0000";
          dado     : out unsigned(16 downto 0) := '0' & x"0000"
        );
  end component;

  component mux16bits4x1 is
    port(   
          entr0 : in  unsigned(15 downto 0) := x"0000";
          entr1 : in  unsigned(15 downto 0) := x"0000";
          entr2 : in  unsigned(15 downto 0) := x"0000";
          entr3 : in  unsigned(15 downto 0) := x"0000";
          sel   : in  unsigned(01 downto 0) := "00";
          saida : out unsigned(15 downto 0) := x"0000"
        );
  end component;

  component registerBank
    port (
           reg_sel   : in  UNSIGNED (02 downto 0) := "000";
           reg_write : in  UNSIGNED (02 downto 0) := "000";
           wr_data   : in  UNSIGNED (15 downto 0) := x"0000";
           reg_data  : out UNSIGNED (15 downto 0) := x"0000";
           wr_en     : in  std_logic := '0';
           clk       : in  std_logic := '0';
           reset     : in  std_logic := '0';
           reg_0  : out UNSIGNED (15 downto 0) := x"0000";
           reg_1  : out UNSIGNED (15 downto 0) := x"0000";
           reg_2  : out UNSIGNED (15 downto 0) := x"0000";
           reg_3  : out UNSIGNED (15 downto 0) := x"0000";
           reg_4  : out UNSIGNED (15 downto 0) := x"0000"

         );
  end component;

  component ULA  
    port ( 
           op_Select       : in  unsigned(01 downto 0) := "00";
           operando0       : in  unsigned(15 downto 0) := x"0000";
           operando1       : in  unsigned(15 downto 0) := x"0000";
           saida           : out unsigned(15 downto 0) := x"0000";
           Zero            : out std_logic := '0';
           Carry           : out std_logic := '0';
           CarryFF_i       : in std_logic := '0'
         );
  end component;

  component register16bits  
    port (
           data_in  : in  UNSIGNED (15 downto 0) := x"0000";
           data_out : out UNSIGNED (15 downto 0) := x"0000";
           wr_en    : in std_logic := '0';
           reset    : in std_logic := '0';
           clk      : in std_logic := '0'
         );
  end component;

  component UC
    port (
      instr                 : in unsigned (16 downto 0) := x"0000" & '0';
      clk, reset            : in std_logic := '0';
      ALU_Op                : out unsigned (1 downto 0) := "00";
      ALU_Src_A, ALU_Src_B  : out unsigned (1 downto 0) := "00";
      Acumulador_Write      : out std_logic := '0';
      PC_Write              : out std_logic := '0';
      IR_Write              : out std_logic := '0';
      RegBank_Write         : out std_logic := '0';
      Flags_Write           : out std_logic := '0';
      PC_Source             : out std_logic := '0';
      jump_en               : out std_logic := '0';
      Estado_o              : out UNSIGNED (2 downto 0)
    );
  end component;

  component  register17bits
    port (
      data_in  : in  UNSIGNED (16 downto 0) := '0' & x"0000";
      data_out : out UNSIGNED (16 downto 0) := '0' & x"0000";
      wr_en    : in std_logic := '0';
      reset    : in std_logic := '0';
      clk      : in std_logic := '0'
    );
  end component;

  component d_flip_flop
    port (
      D        : in std_logic := '0'; 
      clk      : in std_logic := '0';
      reset    : in std_logic := '0';
      Q        : out std_logic := '0'
    );
  end component;

  signal operand_A, 
  operand_B, imm_gen_out: UNSIGNED (15 downto 0) := x"0000";
  signal rom_o, IR_o: unsigned (16 downto 0) := x"0000" & '0';
  signal reg_data, wr_data, ULA_out,
  acumulador_out, PC_i, PC_o          : UNSIGNED (15 downto 0) := x"0000";
  signal PC_Write, jump_en, Acumulador_Write, IR_Write,
  PC_Source, RegBank_Write, Flags_Write, ZeroFF_o, Zero, CarryFF_o, Carry: std_logic := '0';
  signal ALU_Src_A, ALU_Src_B, ALU_Op:  UNSIGNED (01 downto 0) :=  "00";
  signal reg_sel:  UNSIGNED (02 downto 0) :=  "000";

begin 

--  wr_data_MUX : mux16bits4x1
--  port map(
--            entr0 => acumulador_out,
--            entr1 => memDataReg,
--            entr2 => imm_gen_out,
--            entr3 => x"0000",
--            sel => reg_wr_data_sel,
--            saida => wr_data
--          );
  wr_data <= acumulador_out;

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
            Carry => Carry,
            CarryFF_i => CarryFF_o
          );

  regBank : registerBank
  port map(
            reg_sel => reg_sel,
            reg_write => reg_sel,
            wr_data => wr_data,
            wr_en => RegBank_Write,
            clk => clk,
            reset => reset,
            reg_data => reg_data,
            reg_0 => reg_0,
            reg_1 => reg_1,
            reg_2 => reg_2,
            reg_3 => reg_3,
            reg_4 => reg_4
          );

  acumulador : register16bits
  port map(
            data_in => ULA_out,
            data_out => acumulador_out,
            wr_en => Acumulador_Write,
            reset => reset,
            clk => clk
          ); 

  Instruction_Register: register17bits
   port map(
      data_in => rom_o,
      data_out => IR_o,
      wr_en => IR_Write,
      reset => reset,
      clk => clk
  );

  PC : register16bits
  port map(
            data_in => PC_i,
            data_out => PC_o,
            wr_en => PC_Write,
            reset => reset,
            clk => clk
          );

  program_mem: rom
   port map(
      clk => clk,
      endereco => PC_o,
      dado => rom_o
  );

  CU : UC
   port map(
      instr => IR_o,
      clk => clk,
      reset => reset,
      ALU_Op => ALU_Op,
      ALU_Src_A => ALU_Src_A,
      ALU_Src_B => ALU_Src_B,
      PC_Write => PC_Write,
      IR_Write => IR_Write,
      RegBank_Write => RegBank_Write,
      Flags_Write => Flags_Write,
      PC_Source => PC_Source,
      Acumulador_Write => Acumulador_Write,
      jump_en => jump_en,
      Estado_o => Estado_Out
  );

  CarryFlag: d_flip_flop
   port map(
      D => Zero,
      clk => Flags_Write,
      reset => reset,
      Q => ZeroFF_o
  );

  ZeroFlag: d_flip_flop
   port map(
      D => Carry,
      clk => Flags_Write,
      reset => reset,
      Q => CarryFF_o
  );

  reg_sel <= IR_o (6 downto 4);

  imm_gen_out <= "000" & rom_o (16 downto 4) when IR_o (3 downto 0) = "1111" else
                 rom_o(16) & rom_o(16) & rom_o(16) & rom_o (16 downto 4);

  PC_i <= (PC_o + 1) when PC_Source = '0' else 
          imm_gen_out when jump_en = '1' else
          x"0000";

  PC_Out <= PC_o;
  ALU_Out <= ULA_out;
  InstReg_o <= IR_o;
  Acumulador_o <= acumulador_out;

end architecture a_top_level;
