----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2021 05:40:27 PM
-- Design Name: 
-- Module Name: reflex_tb - Behavioral
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

entity reflex_tb is
--  Port ( );
end reflex_tb;

architecture Behavioral of reflex_tb is
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
component reflex is
    Port ( i_clk : in STD_LOGIC;
     i_cpt_clk : in STD_LOGIC;
           i_strobe_start : in STD_LOGIC;
           o_strobe_end : out STD_LOGIC;
           o_data : out STD_LOGIC_VECTOR(8 downto 0);
           o_green: out std_logic;
           o_red: out std_logic;
           i_btn: in STD_LOGIC);
end component;
signal sim_sys_clock : std_logic;
signal d_100_hz: STD_LOGIC;
signal i_strobe_start :  STD_LOGIC;
 signal          o_strobe_end :  STD_LOGIC;
   signal        o_data :  STD_LOGIC_VECTOR(8 downto 0);
    signal       o_green:  std_logic;
    signal       o_red:  std_logic;
     signal      i_btn:  STD_LOGIC;
     signal      reflex_test_done:  STD_LOGIC:='0';
     signal      d_do_reflex_test:  STD_LOGIC:='0';
     signal      last_d_do_reflex_test:  STD_LOGIC:='0';
constant sim_sys_clk_period : time := 20ns;
constant second : time := 1000ms;
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
           o_S_100Hz    => d_100_hz,
           o_stb_100Hz  => d_strobe_100Hz,
           o_S_1Hz      => open
    );
    rflx: reflex
    port map ( 
         i_clk =>sim_sys_clock,
         i_cpt_clk=>d_100_hz,
 i_strobe_start=>i_strobe_start,
 o_strobe_end =>o_strobe_end,
 o_data =>o_data,
 o_green =>o_green,
 o_red =>o_red,
 i_btn =>i_btn
    );
    
    reflex_process: process(sim_sys_clock, d_do_reflex_test, last_d_do_reflex_test,o_strobe_end )
        begin
            if(sim_sys_clock'event and sim_sys_clock ='1') then
                if(d_do_reflex_test='1' and last_d_do_reflex_test ='0') then
                    i_strobe_start<= '1';
                    reflex_test_done<='0';
                elsif(o_strobe_end='1') then
        reflex_test_done<='1';
        i_strobe_start <= '0';
                else i_strobe_start <= '0';
                end if;
           last_d_do_reflex_test<=d_do_reflex_test;
            end if;
            
        end process;
    

    
     TB: process
    
        begin
            
        WAIT for sim_sys_clk_period; 
        d_do_reflex_test <= '1';
        WAIT for sim_sys_clk_period; 
        d_do_reflex_test <= '0';
        WAIT for 12 sec; 
        i_btn <= '1';
         WAIT for sim_sys_clk_period*4; 
         i_btn <= '0';
         WAIT for sim_sys_clk_period*10; 
         d_do_reflex_test <= '1';
        WAIT;
        end process;
    
end Behavioral;
