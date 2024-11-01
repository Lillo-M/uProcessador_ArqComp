library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA_tb is
end entity ULA_tb;


architecture a_ULA_tb of ULA_tb is
  component ULA  
    port ( 
      op_Select       : in  unsigned(1 downto 0);
      operando0       : in  unsigned(15 downto 0);
      operando1       : in  unsigned(15 downto 0);
      saida           : out unsigned(15 downto 0);
      Zero            : out std_logic;
      Carry           : out std_logic
    );
  end component;
  signal operando_A, operando_B, saida : 
                     unsigned(15 downto 0) := "0000000000000000";
  signal zero, carry : std_logic := '0';
  signal op_select : unsigned(1 downto 0) := "00";
begin
  
  operando_A <= "0000000000000100";
  operando_B <= "0000000000000100";

  uut : ULA
   port map(
      op_Select => op_Select,
      operando0 => operando_A,
      operando1 => operando_B,
      saida => saida,
      Zero => zero,
      Carry => carry
  );
  
  process
  begin
    op_Select (1 downto 0) <= "00";
    wait for 50 ns;
    op_Select (1 downto 0) <= "01";
    wait for 50 ns;
    op_Select (1 downto 0) <= "10";
    wait for 50 ns;
    op_Select (1 downto 0) <= "11";
    wait for 50 ns;
    wait;
  end process;

end architecture a_ULA_tb;
