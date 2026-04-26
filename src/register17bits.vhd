library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register17bits is
  port (
    data_in  : in  UNSIGNED (16 downto 0) := '0' & x"0000";
    data_out : out UNSIGNED (16 downto 0) := '0' & x"0000";
    wr_en    : in std_logic := '0';
    reset    : in std_logic := '0';
    clk      : in std_logic := '0'
  );
end entity register17bits;

architecture a_register17bits of register17bits is
  signal data : unsigned (16 downto 0) := x"0000" & '0';
begin
  
  handle_inputs: process(clk, reset, wr_en)
  begin
    if (reset = '1') then
      data <= x"0000" & '0';
    elsif (wr_en = '1') then
      if rising_edge(clk) then
        data <= data_in;
      end if;
    end if;
  end process handle_inputs;
  
  data_out <= data;
  
end architecture a_register17bits;
