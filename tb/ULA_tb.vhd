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
                     unsigned(15 downto 0) := x"0000";
  signal zero, carry : std_logic := '0';
  signal op_select : unsigned(1 downto 0) := "00";
begin
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
    operando_A <= x"7F0A"; -- caso normal de soma de unsigned's
    operando_B <= x"801B";
    op_Select (1 downto 0) <= "00"; -- soma
    wait for 50 ns;
    operando_A <= x"0FFF"; -- caso de carry
    operando_B <= x"F00A";
    op_Select (1 downto 0) <= "00"; -- soma
    wait for 50 ns;
    operando_A <= x"0FFF"; -- a - b, onde a > b
    operando_B <= x"0AAA";
    op_Select (1 downto 0) <= "01"; -- sub
    wait for 50 ns;
    operando_A <= x"0FFF"; -- a - b, onde a = b
    operando_B <= x"0FFF";
    op_Select (1 downto 0) <= "01"; -- sub
    wait for 50 ns;
    operando_A <=  x"00A7"; -- a - b, onde a < b
    operando_B <=  x"00D3";
    op_Select (1 downto 0) <= "01"; -- sub
    wait for 50 ns;
    operando_A <= x"0007";
    operando_B <= x"0007";
    op_Select (1 downto 0) <= "10"; -- mult
    wait for 50 ns;
    operando_A <= x"0007";
    operando_B <= x"FFF9"; -- -7 em complemento de 2
    op_Select (1 downto 0) <= "10"; -- mult
    wait for 50 ns;
    operando_A <= x"0033";
    operando_B <= x"FFFF"; -- -1 em complemento de 2
    op_Select (1 downto 0) <= "10"; -- mult
    wait for 50 ns;
    operando_A <= x"0033";
    operando_B <= x"FFFE"; -- -2 em complemento de 2
    op_Select (1 downto 0) <= "10"; -- mult
    wait for 50 ns;
    operando_A <= x"0033";
    operando_B <= x"0064";
    op_Select (1 downto 0) <= "10"; -- mult
    wait for 50 ns;
    operando_A <= "0000000000000010";
    operando_B <= "0000000000000101";
    op_Select (1 downto 0) <= "11"; -- xor
    wait for 50 ns;
    operando_A <= "0000000000000101";
    operando_B <= "0000000011110101";
    op_Select (1 downto 0) <= "11"; -- xor
    wait for 50 ns;
    operando_A <= x"FFFF";
    operando_B <= x"FFFF";
    op_Select (1 downto 0) <= "11"; -- xor
    wait for 50 ns;
    wait;
  end process;

end architecture a_ULA_tb;
