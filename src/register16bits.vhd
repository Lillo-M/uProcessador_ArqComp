library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register16bits is
  port (
    data_in  : in  UNSIGNED (15 downto 0);
    data_out : out UNSIGNED (15 downto 0);
    wr_en    : in std_logic;
    reset    : in std_logic;
    clk      : in std_logic
  );
end entity register16bits;

architecture a_register16bits of register16bits is
  signal data : unsigned (15 downto 0) := x"0000";
begin
  
  handle_inputs: process(clk, reset, wr_en)
  begin
    if (reset = '1') then
      data <= x"0000";
    elsif (wr_en = '1') then
      if rising_edge(clk) then
        data <= data_in;
      end if;
    end if;
  end process handle_inputs;
  
  data_out <= data;
  
end architecture a_register16bits;
