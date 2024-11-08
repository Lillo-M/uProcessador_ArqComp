library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity t_flip_flop is
  port (
    T        : in std_logic; 
    clk      : in std_logic;
    reset    : in std_logic;
    Q        : out std_logic
  );
end entity t_flip_flop;

architecture a_t_flip_flop of t_flip_flop is
  signal estado : std_logic := '0';
begin
  
  handle_inputs: process(clk, reset)
  begin
    if (reset = '1') then
      estado <= '0';
    elsif (T = '1') then
      if rising_edge(clk) then
        estado <= not estado;
      end if;
    end if;
  end process handle_inputs;
  Q <= estado;
end architecture a_t_flip_flop;
