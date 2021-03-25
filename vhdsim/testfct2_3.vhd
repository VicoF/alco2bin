----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2021 05:01:03 PM
-- Design Name: 
-- Module Name: testfct2_3 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testfct2_3 is
--  Port ( );
end testfct2_3;

architecture Behavioral of testfct2_3 is
component fct12_8 is
Port ( entre : in STD_LOGIC_VECTOR (11 downto 0);
           sortie : out STD_LOGIC_VECTOR (7 downto 0));
        end component;
  signal sortie_tb : STD_LOGIC_VECTOR (7 downto 0);
  signal entre_tb : std_logic_vector (11 downto 0);      
begin

fct : fct12_8
port map(
entre => entre_tb,
sortie => sortie_tb
);

tb : process

begin

entre_tb <= "111111111111";
wait for 100ns;
entre_tb <= "011111111111";
wait for 100ns;
entre_tb <= "000000000000";
wait for 100ns;
entre_tb <= "111111100011";
wait for 100ns;
entre_tb <= "111111000000";
wait for 100ns;
entre_tb <= "000000111111";
wait for 100ns;

End process;

end Behavioral;
