----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/30/2021 07:31:12 PM
-- Design Name: 
-- Module Name: basculeD - Behavioral
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

entity basculeD is
    Port ( entree : in STD_LOGIC;
           Q : out STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC);
end basculeD;

architecture Behavioral of basculeD is
type State_type is (copie, clr);
signal Sactuel, Sprochain: State_type; -- Signaux pour l'état actuel et le prochain état

begin

process (clk) -- Mémoire de l'état
    begin
        if clk'event AND clk = '1' then
        Sactuel <= Sprochain;
        end if;
end process;

bascD : process( RESET, CLK ) is
    begin
    if RESET='1' then
    Q <= '0';
    elsif CLK='1' and CLK'event then
    Q <= entree;
    end if ;
    
end process bascD;

end Behavioral;

