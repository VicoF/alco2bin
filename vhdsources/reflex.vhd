----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2021 03:14:14 PM
-- Design Name: 
-- Module Name: reflex - Behavioral
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

entity reflex is
    Port ( i_clk : in STD_LOGIC;
           i_strobe_start : in STD_LOGIC;
           i_strobe_end : in STD_LOGIC;
           o_time : out STD_LOGIC_VECTOR(8 downto 0));
end reflex;

architecture Behavioral of reflex is
component compteur_nbits is
generic (nbits : integer := 8);
   port ( clk             : in    std_logic; 
          i_en            : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
          );
end component;
signal enable : std_logic;
begin

process(i_strobe_start, i_strobe_end)
begin
    if(i_strobe_start = '1') then
        enable <= '1';
    elsif (i_strobe_end= '1') then
        enable<= '0';
    end if;
end process;

cptr: compteur_nbits generic map (nbits => 9)
port map (
clk => i_clk,
i_en => enable,
reset => i_strobe_start,
o_val_cpt => o_time
);

end Behavioral;
