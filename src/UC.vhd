library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UC is
  port (
    instr                : in unsigned (16 downto 0) := x"0000" & '0';
    clk, reset           : in std_logic := '0';
    reg_wr_data_sel      : out unsigned (1 downto 0) := "00";
    ALU_Op               : out unsigned (1 downto 0) := "00";
    ALU_Src_A, ALU_Src_B : out unsigned (1 downto 0) := "00";
    Acumulador_Write     : out std_logic := '0';
    PC_Write : out std_logic := '0';
    IR_Write : out std_logic := '0';
    PC_Source: out std_logic := '0';
    jump_en  : out std_logic := '0'
  );
end entity UC;

architecture a_UC of UC is
  component stateMachine
    port (
      clk,rst: in std_logic;
      estado: out unsigned(2 downto 0)
    );
  end component;
  signal opcode : UNSIGNED (3 downto 0) := x"0";
  signal estado : UNSIGNED (2 downto 0) := "000";
begin
  
  -- 000 Fetch
  -- 001 Decode
  -- 010 Execute
  -- 011 Memory
  -- 100 Wr Back

  StateMach: stateMachine
   port map(
      clk => clk,
      rst => reset,
      estado => estado
  );

  IR_Write <= '1' when estado = "000" else '0';

  ALU_Op <= "00" when opcode = "0010" else
            "01" when opcode = "0011" else
            "10" when opcode = "0100" else
            "00";

  Acumulador_Write <= '1' when estado = "010" and (opcode = "0010" or opcode = "0011") else
                      '1' when estado = "010" and opcode = "0011" else
                      '1' when estado = "010" and opcode = "0100" else
                      '1' when estado = "010" and opcode = "0101" else
                      '1' when estado = "010" and opcode = "0110" else
                      '0';

  ALU_Src_A <= "10" when opcode = x"F" else
               "00";

  ALU_Src_B <= "11" when opcode = x"F" else
               "01";
  
  PC_Write <= ?;

  opcode <= instr (3 downto 0);

  jump_en <= '1' when opcode = x"F" else '0';
  
  
end architecture a_UC;
