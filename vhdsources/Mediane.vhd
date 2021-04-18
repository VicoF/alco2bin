----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2021 06:24:04 PM
-- Design Name: 
-- Module Name: Mediane - Behavioral
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
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mediane is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (11 downto 0);
           o_mediane : out STD_LOGIC_VECTOR (11 downto 0));
end Mediane;

architecture Behavioral of Mediane is

component Reg12bits is
Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           entree : in STD_LOGIC_VECTOR (11 downto 0);
           sortie : out STD_LOGIC_VECTOR (11 downto 0));
end component;

signal sortieReg0 : STD_LOGIC_VECTOR (11 downto 0);
signal sortieReg1 : STD_LOGIC_VECTOR (11 downto 0);
signal sortieReg2 : STD_LOGIC_VECTOR (11 downto 0);

begin

reg0 : Reg12bits
Port map(
clk => clk,
reset => reset,
entree => i_data,
sortie => sortieReg0
);

reg1 : Reg12bits
Port map(
clk => clk,
reset => reset,
entree => sortieReg0,
sortie => sortieReg1
);

reg2 : Reg12bits
Port map(
clk => clk,
reset => reset,
entree => sortieReg1,
sortie => sortieReg2
);

mediane_proc : process (clk, reset, i_data)
   begin
      if ( reset = '1') then
          o_mediane <= (others =>'0');
      else
      if (rising_edge(clk) AND enable = '1') then
           if ( sortieReg0 <= sortieReg1 ) then
            if (sortieReg2 >= sortieReg1 ) then
                o_mediane <= sortieReg1;
            elsif ( sortieReg1 >= sortieReg2 ) then
                o_mediane <= sortieReg2;
            end if;
           elsif (sortieReg2 <= sortieReg0) then
            if (sortieReg0 >= sortieReg2) then
                o_mediane <= sortieReg0;
            elsif (sortieReg0 <= sortieReg2) then
                o_mediane <= sortieReg2;
            else
                o_mediane <= "000000000000";
            end if;            
           end if;
      end if;
      end if;
   end process;


end Behavioral;
