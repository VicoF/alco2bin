----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2021 09:16:52 AM
-- Design Name: 
-- Module Name: Moyenneur - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Moyenneur is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (11 downto 0);
           o_moy : out STD_LOGIC_VECTOR (11 downto 0));
           
end Moyenneur;


architecture Behavioral of Moyenneur is

component Reg12bits is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           entree : in STD_LOGIC_VECTOR (11 downto 0);
           sortie : out STD_LOGIC_VECTOR (11 downto 0));
end component;

signal entreeRegistre: std_logic_vector (11 downto 0);
signal sortieRegistre: std_logic_vector (11 downto 0);
signal sortieAdd: std_logic_vector (11 downto 0);

begin

registre: Reg12bits
port map(
clk => clk,
reset => reset,
sortie => sortieRegistre,
entree => entreeRegistre
);

entreeRegistre <= '0' & sortieAdd(11 downto 1);
sortieAdd <= i_data + sortieRegistre;
o_moy <= sortieRegistre;

end Behavioral;
