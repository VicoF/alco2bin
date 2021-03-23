--------------------------------------------------------------------------------
-- MEF de controle du convertisseur AD7476  
-- AD7476_mef.vhd
-- ref: http://www.analog.com/media/cn/technical-documentation/evaluation-documentation/AD7476A_7477A_7478A.pdf 
---------------------------------------------------------------------------------------------
--	Librairy and Package Declarations
---------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

---------------------------------------------------------------------------------------------
--	Entity Declaration
---------------------------------------------------------------------------------------------
entity AD7476_mef is
port(
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
end AD7476_mef;
 
---------------------------------------------------------------------------------------------
--	Object declarations
---------------------------------------------------------------------------------------------
architecture Behavioral of AD7476_mef is

--	Components

--	Constantes
type state is (INIT, VALID, SAMPLE,DONE);
--	Signals
signal curr_state : state := INIT;
signal next_state : state := INIT;
--	Registers

-- Attributes

begin

-- Assignation du prochain état
clockTick: process(clk_ADC, reset)
begin
    if (reset='1') then
        curr_state<= INIT;
    elsif (rising_edge(clk_ADC))then
        curr_State <= next_state;
    end if;
 end process;
-- Calcul du prochain état
nextState : process(curr_state, i_ADC_STROBE, i_bit, i_cpt)
begin
    case curr_state is 
    WHEN INIT =>
    if i_ADC_strobe = '1' then
        next_state <= VALID;
    else next_state <= curr_state;
    end if;
    WHEN VALID =>
    if(i_cpt="0010" and i_bit = '0') then
    next_state<= SAMPLE;
    elsif (i_bit /= '0') then
    next_State<= INIT;
    else next_state <= curr_state;
    end if;
    WHEN SAMPLE =>
    if(i_cpt="1110") then
    next_state <= DONE;
    else next_State<= curr_State;
    end if;
    WHEN DONE =>
    next_State<= INIT;
    end case;

end process;


-- Calcul des sorties
with curr_state select o_reset_cpt <= '1' when INIT, '0' WHEN others;
with curr_state select o_ADC_nCS <= '0' when VALID | SAMPLE, '1' WHEN others;
with curr_state select o_Decale <= '1' when SAMPLE, '0' WHEN others;
with curr_state select o_FinSequence_Strobe <= '1' when DONE, '0' WHEN others;
 
end Behavioral;
