----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2021 10:12:35 PM
-- Design Name: 
-- Module Name: top_tb - Behavioral
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

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is
component Ctrl_AD1 is
port ( 
    reset                       : in    std_logic;  
    clk_ADC                     : in    std_logic; 						-- Horloge à fournir à l'ADC
    i_DO                        : in    std_logic;                      -- Bit de donnée en provenance de l'ADC         
    o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
	
    i_ADC_Strobe                : in    std_logic;                      -- Synchronisation: strobe déclencheur de la séquence de réception    
    o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une réception complète d'un échantillon  
    o_echantillon               : out   std_logic_vector (11 downto 0)  -- valeur de l'échantillon reçu
);
end component;

constant freq_sys_MHz: integer := 125;  -- MHz

component Synchro_Horloges is
    generic (const_CLK_syst_MHz: integer := freq_sys_MHz);
    Port ( 
        clkm        : in  std_logic;  -- Entrée  horloge maitre   (50 MHz soit 20 ns ou 100 MHz soit 10 ns)
        o_S_5MHz    : out std_logic;  -- source horloge divisee          (clkm MHz / (2*constante_diviseur_p +2) devrait donner 5 MHz soit 200 ns)
        o_CLK_5MHz  : out std_logic;
        o_S_100Hz   : out  std_logic; -- source horloge 100 Hz : out  std_logic;   -- (100  Hz approx:  99,952 Hz) 
        o_stb_100Hz : out  std_logic; -- strobe 100Hz synchro sur clk_5MHz 
        o_S_1Hz     : out  std_logic  -- Signal temoin 1 Hz
    );
    end component;
    signal d_reset, d_clk_DAC, d_DAC_nSYNC, d_i_DO, d_strobe_100Hz : std_logic;

signal sim_sys_clock : std_logic;

constant sim_sys_clk_period : time := 20ns;
begin
 -- clock 50MHz
    sys_clock_process : process
       begin
            sim_sys_clock <= '0';
            wait for sim_sys_clk_period/2;
            sim_sys_clock <= '1';
            wait for sim_sys_clk_period/2;
       end process;
       
    Synchronisation : Synchro_Horloges
    port map (
           clkm         =>  sim_sys_clock,
           o_S_5MHz     =>  d_clk_DAC,
           o_CLK_5MHz   => open,
           o_S_100Hz    => open,
           o_stb_100Hz  => d_strobe_100Hz,
           o_S_1Hz      => open
    );
    
    Contoleur: Ctrl_AD1
    port map(
    reset => d_reset,
    clk_ADC => d_CLK_DAC,
    i_DO                        => d_i_DO,                    -- Bit de donnée en provenance de l'ADC         
    o_ADC_nCS               =>    open,                 -- Signal Chip select vers l'ADC 
	
    i_ADC_Strobe                => d_strobe_100Hz,                     -- Synchronisation: strobe déclencheur de la séquence de réception    
    o_echantillon_pret_strobe   =>open,                     -- strobe indicateur d'une réception complète d'un échantillon  
    o_echantillon               =>open  -- valeur de l'échantillon reçu
    );
    
      TB: process
    
        begin
            
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT for sim_sys_clk_period; 
        d_i_DO <= '1';
        WAIT for sim_sys_clk_period;         
        d_i_DO <= '0';
        WAIT;
        
        end process;
end Behavioral;
