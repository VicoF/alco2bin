----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2021 01:53:46 PM
-- Design Name: 
-- Module Name: Ctrl_DAC - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Ctrl_DAC is
port(
reset                       : in    std_logic;  
clk_DAC                     : in    std_logic; 
i_DAC_Strobe                : in    std_logic;
o_bit_1               : out std_logic;
o_bit_0               : out std_logic;
 o_DAC_NCS: out STD_LOGIC
);
end Ctrl_DAC;

architecture Behavioral of Ctrl_DAC is
constant nbEchantillonMemoire : integer := 48;
type tableau is array (integer range 0 to nbEchantillonMemoire -1) of std_logic_vector(11 downto 0);
constant forme_signal_0 : tableau := (
x"000",
x"541",
x"5CA",
x"63E",
x"6A2",
x"6FB",
x"74A",
x"792",
x"7D3",
x"810",
x"847",
x"87B",
x"8AC",
x"8D9",
x"904",
x"92D",
x"953",
x"978",
x"99B",
x"9BD",
x"9DD",
x"9FB",
x"A19",
x"A35",
x"A35",
x"A19",
x"9FB",
x"9DD",
x"9BD",
x"99B",
x"978",
x"953",
x"92D",
x"904",
x"8D9",
x"8AC",
x"87B",
x"847",
x"810",
x"7D3",
x"792",
x"74A",
x"6FB",
x"6A2",
x"63E",
x"5CA",
x"541",
x"000"
);
--Signal de débit (données aléatoires entre 0 et 1000)
constant forme_signal_1 : tableau := (
x"23C",
x"1D6",
x"18D",
x"2EA",
x"127",
x"2D4",
x"216",
x"013",
x"022",
x"28E",
x"1A8",
x"34A",
x"068",
x"209",
x"08C",
x"243",
x"10A",
x"33A",
x"228",
x"072",
x"39E",
x"173",
x"2A8",
x"363",
x"32C",
x"205",
x"3C5",
x"150",
x"166",
x"283",
x"1B1",
x"20F",
x"3B1",
x"1BC",
x"0A7",
x"130",
x"1FB",
x"206",
x"13B",
x"220",
x"046",
x"38E",
x"3BF",
x"19B",
x"171",
x"020",
x"022",
x"05D"
);
signal d_echantillonMemoire_0 : std_logic_vector(11 downto 0);
signal d_echantillonMemoire_1 : std_logic_vector(11 downto 0);
signal d_compteur_echantillonMemoire : unsigned(7 downto 0);
signal q_iteration : unsigned(16 downto 0);
signal d_cpt : std_logic_vector(3 downto 0);
signal d_reset_cpt, d_en_cpt : std_logic :='0';
constant c_nbIterations : integer :=100000;
component  MEF_DAC is
    Port ( i_echantillon_0 : in std_logic_vector(11 downto 0);
            i_echantillon_1 : in std_logic_vector(11 downto 0);
           o_bit_1 : out STD_LOGIC;
           o_bit_0 : out STD_LOGIC;
           clk_DAC : in STD_LOGIC;
           reset : in STD_LOGIC;
           i_cpt : in std_logic_vector(3 downto 0);
           o_reset_cpt : out STD_LOGIC;
           o_en_cpt : out STD_LOGIC;
           i_sync : in STD_LOGIC;
            o_DAC_NCS: out STD_LOGIC);
end component;
component compteur_nbits is
generic (nbits : integer := 8);
   port ( clk             : in    std_logic; 
          i_en            : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
          );
end component;
begin

cptr : compteur_nbits generic map (nbits=>4)
port map (
clk => clk_DAC,
i_en => d_en_cpt,
reset => d_reset_cpt,
o_val_cpt => d_cpt
);

mef : mef_DAC port map(
i_echantillon_1 => d_echantillonMemoire_1,
i_echantillon_0 => d_echantillonMemoire_0,
clk_DAC => clk_DAC,
reset => reset,
i_cpt => d_cpt,
i_sync => i_DAC_Strobe,
o_bit_0 => o_bit_0,
o_bit_1 => o_bit_1,
o_reset_cpt => d_reset_cpt,
o_en_cpt => d_en_cpt,
o_DAC_NCS => o_DAC_NCS
);






lireEchantillon : process(reset, clk_DAC)
begin
    if(reset = '1') then
    d_compteur_echantillonMemoire <= x"00";
    d_echantillonMemoire_0 <= x"000";
    d_echantillonMemoire_1 <= x"000";
    q_iteration <= (others => '0');
    else
      if (clk_DAC'event and clk_DAC = '1') then
      
        if(i_DAC_strobe = '1') then
            d_echantillonMemoire_0 <= forme_signal_0(to_integer(d_compteur_echantillonMemoire));
            d_echantillonMemoire_1 <= forme_signal_1(to_integer(d_compteur_echantillonMemoire));
                --if(to_integer(q_iteration) < c_nbIterations) then
                
                    if(d_compteur_echantillonMemoire = forme_signal_0'length-1) then
                        d_compteur_echantillonMemoire <= x"00";
                        q_iteration <= q_iteration + 1;
                        else
                        d_compteur_echantillonMemoire <= d_compteur_echantillonMemoire + 1;
                        end if;
                    --end if;
                end if;
            end if;
      end if;
  end process; 



end Behavioral;
