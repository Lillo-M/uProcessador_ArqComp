library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity d_flip_flop is
  port (
    D        : in std_logic := '0'; 
    clk      : in std_logic := '0';
    reset    : in std_logic := '0';
    Q        : out std_logic := '0'
  );
end entity d_flip_flop;

architecture a_d_flip_flop of d_flip_flop is
  signal data : std_logic := '0';
begin
  
  handle_inputs: process(clk, reset)
  begin
    if (reset = '1') then
      data <= '0';
    elsif rising_edge(clk) then
      data <= D;
    end if;
  end process handle_inputs;
  Q <= data;
end architecture a_d_flip_flop;
