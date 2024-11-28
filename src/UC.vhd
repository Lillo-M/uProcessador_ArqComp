library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UC is
  port (
    instr                : in unsigned (16 downto 0) := x"0000" & '0';
    clk, reset           : in std_logic := '0';
    ALU_Op               : out unsigned (1 downto 0) := "00";
    ALU_Src_A, ALU_Src_B : out unsigned (1 downto 0) := "00";
    Acumulador_Write     : out std_logic := '0';
    Flags_Write   : out std_logic := '0';
    RegBank_Write : out std_logic := '0';
    PC_Write      : out std_logic := '0';
    IR_Write      : out std_logic := '0';
    PC_Source     : out std_logic := '0';
    jump_en       : out std_logic := '0';
    Estado_o      : out UNSIGNED (2 downto 0) := "000"
  );
end entity UC;

architecture a_UC of UC is
  component stateMachine
    port (
      clk,rst: in std_logic := '0';
      estado: out unsigned(2 downto 0) := "000"
    );
  end component;
  signal opcode : UNSIGNED (3 downto 0) := x"0";
  signal estado : UNSIGNED (2 downto 0) := "000";
begin
  
  -- 000 Fetch -> 0x0012  / 0x0071
  -- 001 Decode -> ula instr, seta os mutiplex 
  -- 010 Execute -> reg, ac || setar o pontero da ram || selecionar reg pra lw
  -- 011 Memory -> acessar
  -- 100 Wr Back -> escrever na memoria 

  StateMach: stateMachine
   port map(
      clk => clk,
      rst => reset,
      estado => estado
  );

  IR_Write <= '1' when estado = "000" else '0';

  ALU_Op <= "00" when (opcode = "0010" or opcode = "1000" or opcode = "0001") else
            "01" when opcode = "0011" else
            "11" when opcode = "0100" else
            "00";

  Acumulador_Write <= '1' when estado = "010" and (
                      opcode = "0001" or
                      opcode = "0010" or
                      opcode = "0011" or
                      opcode = "0100" or
                      opcode = "0101" or
                      opcode = "0110" or 
                      opcode = "1000") 
                      else
                      '0';

  Flags_Write <= '1' when (estado = "010" and (opcode = "0101" or opcode = "0110")) else
                 '1' when (estado = "011" and (opcode = "0100")) else -- isso aqui é gambiarra *para testar*
                 '0';

  ALU_Src_A <= "10" when opcode = "0001" else
               "11" when opcode = "1000" else
               "01";

  ALU_Src_B <= "11" when opcode = "0001" else
               "10" when (opcode = "0011" or opcode = "0100") else
               "00";
  
  PC_Write <= '1' when estado = "010" else '0';

  opcode <= instr (3 downto 0);

  RegBank_Write <= '1' when opcode = "0111" and estado = "010" else '0';

  jump_en <= '1' when opcode = "1111" else '0';

  PC_Source <= '1' when (opcode = "1111" or opcode = "1101" or opcode = "1110") else
               '0';
    
  Estado_o <= estado;
end architecture a_UC;
