library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UC is
  port (
    instr : in unsigned (16 downto 0) := x"0000" & '0';
    clk, reset : in std_logic := '0';
    reg_wr_data_sel : out unsigned (1 downto 0) := "00";
    ALU_Src_A, ALU_Src_B : out unsigned (1 downto 0) := "00";
    PC_Write : out std_logic := '0';
    jump_en : out std_logic := '0'
  );
end entity UC;

architecture a_UC of UC is
  component t_flip_flop
    port (
           T        : in std_logic; 
           clk      : in std_logic;
           reset    : in std_logic;
           Q        : out std_logic
         );
  end component;
  signal opcode : UNSIGNED (3 downto 0) := x"0";
  signal estado: std_logic := '0';
begin
  
  Fetch_Decode: t_flip_flop
  port map(
            T => '1',
            clk => clk,
            reset => reset,
            Q => estado
          );

  ALU_Src_A <= "10" when opcode = x"F" else
               "00";

  ALU_Src_B <= "11" when opcode = x"F" else
               "01";
  
  PC_Write <= not estado;

  opcode <= instr (3 downto 0);

  jump_en <= '1' when opcode = x"F" else '0';
  
  
end architecture a_UC;
