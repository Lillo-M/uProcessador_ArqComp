library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity stateMachine is
  port (
    clk,rst: in std_logic;
    estado: out unsigned(2 downto 0)
  );
end entity stateMachine;

architecture a_stateMachine of stateMachine is
   signal estado_s: unsigned(2 downto 0);
begin
   process(clk,rst)
   begin
      if rst='1' then
         estado_s <= "000";
      elsif rising_edge(clk) then
         if estado_s="101" then        -- se agora esta em 2
            estado_s <= "000";         -- o prox vai voltar ao zero
         else
            estado_s <= estado_s+1;   -- senao avanca
         end if;
      end if;
   end process;
   estado <= estado_s;
end architecture;
