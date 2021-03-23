--------------------------------------------------------------------------------
-- Controle du module pmod AD1
-- Ctrl_AD1.vhd
-- ref: http://www.analog.com/media/cn/technical-documentation/evaluation-documentation/AD7476A_7477A_7478A.pdf 

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity Ctrl_AD1 is
port ( 
    reset                       : in    std_logic;  
    clk_ADC                     : in    std_logic; 						-- Horloge à fournir à l'ADC
    i_DO                        : in    std_logic;                      -- Bit de donnée en provenance de l'ADC         
    i_D1                        : in    std_logic;                      -- Bit de donnée en provenance de l'ADC         
    o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
    i_ADC_Strobe                : in    std_logic;                      -- Synchronisation: strobe déclencheur de la séquence de réception    
    o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une réception complète d'un échantillon  
    o_echantillon_0               : out   std_logic_vector (11 downto 0);  -- valeur de l'échantillon reçu
    o_echantillon_1               : out   std_logic_vector (11 downto 0)  -- valeur de l'échantillon reçu
);
end Ctrl_AD1;

architecture Behavioral of Ctrl_AD1 is
  signal o_cpt : std_logic_vector(3 downto 0);
  signal o_decale : std_logic;
  signal reset_cpt : std_logic:='0' ;
    component AD7476_mef
    port ( 
       clk_ADC                 : in std_logic;
    reset			        : in std_logic;
    i_ADC_Strobe            : in std_logic;     --  cadence echantillonnage AD1   
    i_cpt : in std_logic_vector (3 downto 0); 
    i_bit : in std_logic; 
    o_reset_cpt : out std_logic;
    o_ADC_nCS		        : out std_logic;    -- Signal Chip select vers l'ADC  
    o_Decale			    : out std_logic;    -- Signal de décalage   
    o_FinSequence_Strobe    : out std_logic     -- Strobe de fin de séquence d'échantillonnage 
    );
    end component;  
    
    component reg_dec_12b is
  Port ( 
    i_clk       : in std_logic;      -- horloge
    i_reset     : in std_logic;      -- reinitialisation
    i_load      : in std_logic;      -- activation chargement parallele
    i_en        : in std_logic;      -- activation decalage
    i_dat_bit   : in std_logic;      -- entree serie
    i_dat_load  : in std_logic_vector(11 downto 0);    -- entree parallele
    o_dat       : out  std_logic_vector(11 downto 0)   -- sortie parallele
);
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

reg0 : reg_dec_12b
Port map (
i_clk     => clk_ADC, 
    i_reset    =>  '0',
    i_load     => '0',
    i_en    => o_decale,   
    i_dat_bit   => i_DO,
    i_dat_load  => "000000000000",
    o_dat => o_echantillon_0
    );
    
reg1 : reg_dec_12b
Port map (
i_clk     => clk_ADC, 
    i_reset    =>  '0',
    i_load     => '0',
    i_en    => o_decale,   
    i_dat_bit   => i_D1,
    i_dat_load  => "000000000000",
    o_dat => o_echantillon_1
    );
    
cpt : compteur_nbits
generic map (nbits => 4)
port map (
clk => clk_ADC,
i_en => '1',
reset => reset_cpt,
o_val_cpt => o_cpt
);
--  Machine a etats finis pour le controle du AD7476
    MEF : AD7476_mef
    port map (
        clk_ADC                 => clk_ADC,
        reset                   => reset,
        o_reset_cpt => reset_cpt,
        i_ADC_Strobe            => i_ADC_Strobe,
        i_cpt                   => o_cpt,
        i_bit                   => i_DO,
        o_ADC_nCS               => o_ADC_nCS,
        o_Decale                => o_decale,
        o_FinSequence_Strobe    => o_echantillon_pret_strobe
    );

end Behavioral;
