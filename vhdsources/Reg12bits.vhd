----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2021 09:32:32 AM
-- Design Name: 
-- Module Name: Reg12bits - Behavioral
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

entity Reg12bits is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           entree : in STD_LOGIC_VECTOR (11 downto 0);
           sortie : out STD_LOGIC_VECTOR (11 downto 0));
end Reg12bits;

architecture Behavioral of Reg12bits is

component basculeD is
        Port ( entree : in STD_LOGIC;
           Q : out STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

begin

D0 : basculeD
Port map (
        clk    => clk,
        reset  => reset,
        entree => entree(0),
        Q => sortie(0)
);

D1 : basculeD
Port map (
        clk    => clk,
        reset  => reset,
        entree => entree(1),
        Q => sortie(1)
);

D2 : basculeD
Port map (
        clk    => clk,
        reset  => reset,
        entree => entree(2),
        Q => sortie(2)
);

D3 : basculeD
Port map (
        clk    => clk,
        reset  => reset,
        entree => entree(3),
        Q => sortie(3)
);

D4 : basculeD
Port map (
        clk    => clk,
        reset  => reset,
        entree => entree(4),
        Q => sortie(4)
);

D5 : basculeD
Port map (
        clk    => clk,
        reset  => reset,
        entree => entree(5),
        Q => sortie(5)
);

D6 : basculeD
Port map (
        clk    => clk,
        reset  => reset,
        entree => entree(6),
        Q => sortie(6)
);

D7 : basculeD
Port map (
        clk    => clk,
        reset  => reset,
        entree => entree(7),
        Q => sortie(7)
);

D8 : basculeD
Port map (
        clk    => clk,
        reset  => reset,
        entree => entree(8),
        Q => sortie(8)
);
D9: basculeD
Port map (
        clk    => clk,
        reset  => reset,
        entree => entree(9),
        Q => sortie(9)
);
D10 : basculeD
Port map (
        clk    => clk,
        reset  => reset,
        entree => entree(10),
        Q => sortie(10)
);

D11 : basculeD
Port map (
        clk    => clk,
        reset  => reset,
        entree => entree(11),
        Q => sortie(11)
);

end Behavioral;
