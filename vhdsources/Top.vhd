----------------------------------------------------------------------------------
-- Exercice1 Atelier #3 S4 Génie informatique - H21
-- Larissa Njejimana
-- v.3 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity Top is
port (
    sys_clock       : in std_logic;
    o_led6_r       : out std_logic;
    o_led6_g       : out std_logic;
    o_leds          : out std_logic_vector ( 3 downto 0 );
    i_sw            : in std_logic_vector ( 3 downto 0 );
    i_btn           : in std_logic_vector ( 3 downto 0 );
    o_ledtemoin_b   : out std_logic;
    
    Pmod_8LD        : inout std_logic_vector ( 7 downto 0 );  -- port JF
    Pmod_OLED       : inout std_logic_vector ( 7 downto 0 );  -- port_JE
    
    -- Pmod_AD1 - port_JC haut
    o_ADC_NCS       : out std_logic;  
    i_ADC_D0        : in std_logic;
    i_ADC_D1        : in std_logic;
    o_ADC_CLK       : out std_logic;
    --
    -- Pmod_DAC - port_JC haut
    o_DAC_NCS       : out std_logic;  
    o_DAC_D0        : out std_logic;
    o_DAC_D1        : out std_logic;
    o_DAC_CLK       : out std_logic;
    --
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
DDR_cas_n : inout STD_LOGIC;
DDR_ck_n : inout STD_LOGIC;
DDR_ck_p : inout STD_LOGIC;
DDR_cke : inout STD_LOGIC;
DDR_cs_n : inout STD_LOGIC;
DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
DDR_odt : inout STD_LOGIC;
DDR_ras_n : inout STD_LOGIC;
DDR_reset_n : inout STD_LOGIC;
DDR_we_n : inout STD_LOGIC;
FIXED_IO_ddr_vrn : inout STD_LOGIC;
FIXED_IO_ddr_vrp : inout STD_LOGIC;
FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
FIXED_IO_ps_clk : inout STD_LOGIC;
FIXED_IO_ps_porb : inout STD_LOGIC;
FIXED_IO_ps_srstb : inout STD_LOGIC 
);
end Top;

architecture Behavioral of Top is

    constant freq_sys_MHz: integer := 125;  -- MHz

    component Ctrl_AD1 is
    port ( 
        reset                       : in    std_logic;  
        
        clk_ADC                     : in    std_logic;                      -- Horloge fourni à l'ADC
        i_DO                        : in    std_logic;                      -- Bit de donnée en provenance de l'ADC           
        i_D1                        : in    std_logic;                      -- Bit de donnée en provenance de l'ADC           
        o_ADC_nCS                   : out   std_logic;                      -- Signal Chip select vers l'ADC 
        
        i_ADC_Strobe                : in    std_logic;                      -- synchronisation: déclencheur de la séquence d'échantillonnage  
        o_echantillon_pret_strobe   : out   std_logic;                      -- strobe indicateur d'une réception complète d'un échantillon  
        o_echantillon_0               : out   std_logic_vector (11 downto 0);  -- valeur de l'échantillon reçu
        o_echantillon_1               : out   std_logic_vector (11 downto 0)  -- valeur de l'échantillon reçu
    );
    end  component;
    
    component Ctrl_DAC is
    port(
    reset                       : in    std_logic;  
    clk_DAC                     : in    std_logic; 
    i_DAC_Strobe                : in    std_logic;
    o_bit_1               : out std_logic;
    o_bit_0               : out std_logic;
    o_DAC_NCS : out std_logic
    );
    end component;
   
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
    
    component kcpsm6
    generic( 
        hwbuild                     : std_logic_vector(7 downto 0) := X"00";
        interrupt_vector            : std_logic_vector(11 downto 0) := X"3FF";
        scratch_pad_memory_size     : integer := 64 -- other options are 128, 256
    );
    port ( 
        address         : out std_logic_vector(11 downto 0);
        instruction     : in std_logic_vector(17 downto 0);
        bram_enable     : out std_logic;
        in_port         : in std_logic_vector(7 downto 0);
        out_port        : out std_logic_vector(7 downto 0);
        port_id         : out std_logic_vector(7 downto 0);
        write_strobe    : out std_logic;
        k_write_strobe  : out std_logic;
        read_strobe     : out std_logic;
        interrupt       : in std_logic;
        interrupt_ack   : out std_logic;
        sleep           : in std_logic;
        reset           : in std_logic;
        clk             : in std_logic
    );
    end component;
    
    component myProgram                             
        generic(             
                             C_FAMILY : string := "S6"; 
                    C_RAM_SIZE_KWORDS : integer := 1;
                 C_JTAG_LOADER_ENABLE : integer := 0);
        Port (      
                    address : in std_logic_vector(11 downto 0);
                instruction : out std_logic_vector(17 downto 0);
                     enable : in std_logic;
                        rdl : out std_logic;                    
                        clk : in std_logic);
      end component;
    
    component mef_adc_wrapper is
  port (
     DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    Pmod_8LD_pin10_io : inout STD_LOGIC;
    Pmod_8LD_pin1_io : inout STD_LOGIC;
    Pmod_8LD_pin2_io : inout STD_LOGIC;
    Pmod_8LD_pin3_io : inout STD_LOGIC;
    Pmod_8LD_pin4_io : inout STD_LOGIC;
    Pmod_8LD_pin7_io : inout STD_LOGIC;
    Pmod_8LD_pin8_io : inout STD_LOGIC;
    Pmod_8LD_pin9_io : inout STD_LOGIC;
    Pmod_OLED_pin10_io : inout STD_LOGIC;
    Pmod_OLED_pin1_io : inout STD_LOGIC;
    Pmod_OLED_pin2_io : inout STD_LOGIC;
    Pmod_OLED_pin3_io : inout STD_LOGIC;
    Pmod_OLED_pin4_io : inout STD_LOGIC;
    Pmod_OLED_pin7_io : inout STD_LOGIC;
    Pmod_OLED_pin8_io : inout STD_LOGIC;
    Pmod_OLED_pin9_io : inout STD_LOGIC;
    i_data_echantillon_1 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    i_data_echantillon_0 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    i_sw_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
    o_data_out_0 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    o_leds_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    i_data_maxPico_0 : in std_logic_vector(11 downto 0)
  );
  end component;
    
    signal clk_5MHz                     : std_logic;
    signal d_S_5MHz                     : std_logic;
    signal d_strobe_100Hz               : std_logic := '0';  -- cadence echantillonnage AD1
    
    signal reset                        : std_logic; 
    signal reset_adc                        : std_logic; 
    
    signal o_echantillon_pret_strobe    : std_logic;
    signal d_ADC_Dselect                : std_logic; 
    signal d_echantillon_0                : std_logic_vector (11 downto 0):= (others=> '0'); 
    signal d_echantillon_1                : std_logic_vector (11 downto 0); 
    signal d_adc_echantillon_0                : std_logic_vector (11 downto 0); 
    signal d_adc_echantillon_1                : std_logic_vector (11 downto 0); 
    signal d_data_maxpico            : std_logic_vector (11 downto 0); 
    signal d_data              : std_logic_vector (31 downto 0); 
    signal d_do_ethylo_test              : std_logic; 
    signal S_5MHz : STD_LOGIC;
    
    signal         address : std_logic_vector(11 downto 0);
    signal     instruction : std_logic_vector(17 downto 0);
    signal     bram_enable : std_logic;
    signal         in_port : std_logic_vector(7 downto 0);
    signal        out_port : std_logic_vector(7 downto 0);
    signal         port_id : std_logic_vector(7 downto 0);
    signal    write_strobe : std_logic;
    signal  k_write_strobe : std_logic;
    signal     read_strobe : std_logic;
    signal       interrupt : std_logic;
    signal   interrupt_ack : std_logic;
    signal    kcpsm6_sleep : std_logic;
    signal    kcpsm6_reset : std_logic;
    signal bonne_valeur_flow : std_logic;
    signal compteur_flow : unsigned (8 downto 0);
    signal erreur_flow : std_logic := '0';
    
    signal q_leds          : std_logic_vector ( 3 downto 0 ) := (others => '1');
    signal q_Pmod_8LD      : std_logic_vector ( 7 downto 0 ) := (others => '1');

begin
    reset    <= i_btn(0);    
        
     mux_select_Entree_AD1 : process (i_btn(3), i_ADC_D0, i_ADC_D1)
     begin
          if (i_btn(3) ='0') then 
            d_ADC_Dselect <= i_ADC_D0;
          else
            d_ADC_Dselect <= i_ADC_D1;
          end if;
     end process;
     
     read_pico: process(sys_clock)
     begin
     if bonne_valeur_flow = '1' then
     read_strobe <= '0';
     compteur_flow <= compteur_flow + 1;
     else
     read_strobe <= '1';
     end if;
     end process;
    
    check_result : process(sys_clock,compteur_flow)
    begin
    if compteur_flow > "100000000" then
    erreur_flow <= '1';
    end if;
    end process;
    
    bonne_valeur : process(sys_clock)
    begin
    if d_adc_echantillon_1 > "011001100011" and d_adc_echantillon_1 < "100110011001" then
    bonne_valeur_flow <= '0';
    else
    bonne_valeur_flow <= '1';
    end if;
    end process;
     
      processor: kcpsm6
    generic map (                 
        hwbuild => X"00", 
        interrupt_vector => X"3FF",
        scratch_pad_memory_size => 64) -- other options are 128, 256
    port map(      
                   address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => sys_clock
           );
       output_pico: process(sys_clock)
       begin
        if write_strobe = '1' then
            d_data_maxpico<= out_port&"0000";
            --d_data_maxpico <= "111111110000";
        end if;
       end process;
       input_ports: process(sys_clock)
      begin
        if sys_clock'event and sys_clock = '1' then
          in_port(7 downto 0) <= d_echantillon_0(11 downto 4);
        end if;
    
      end process input_ports;
      --d_data_maxpico<= out_port&"0000";
      --d_data_maxpico <= "111111110000";
     program_rom: myProgram                            --Name to match your PSM file
    generic map(             
            C_FAMILY => "7S",                       --Family 'S6', 'V6' or '7S'
            C_RAM_SIZE_KWORDS => 2,                 --Program size '1', '2' or '4'
            C_JTAG_LOADER_ENABLE => 0               --Include JTAG Loader when set to '1' 
               )      
    port map(      
               address => address,      
           instruction => instruction,
                enable => bram_enable,
                   rdl => kcpsm6_reset,
                   clk => sys_clock
              );
     
    Controleur :  Ctrl_AD1 
    port map(
        reset                       => reset_adc,
        
        clk_ADC                     => clk_5MHz,                    -- pour horloge externe de l'ADC 
        i_DO                        => i_ADC_D0,               -- bit de données provenant de l'ADC (via um mux)       
        i_D1                        => i_ADC_D1,               -- bit de données provenant de l'ADC (via um mux)       
        o_ADC_nCS                   => o_ADC_NCS,                   -- chip select pour le convertisseur (ADC )
        
        i_ADC_Strobe                => d_strobe_100Hz,              -- synchronisation: déclencheur de la séquence d'échantillonnage 
        o_echantillon_pret_strobe   => o_echantillon_pret_strobe,   -- strobe indicateur d'une réception complète d'un échantillon 
        o_echantillon_0               => d_adc_echantillon_0,                -- valeur de l'échantillon reçu (12 bits)
        o_echantillon_1               => d_adc_echantillon_1                -- valeur de l'échantillon reçu (12 bits)
    );
    
    --update echantillon signal only when it is ready
    output_adc: process(sys_clock)
       begin
        if o_echantillon_pret_strobe = '1' then
            d_echantillon_0 <= d_adc_echantillon_0;
            d_echantillon_1 <= d_adc_echantillon_1;
        end if;
       end process;
    
    
    controleur_DAC: Ctrl_DAC 
    port map(
    reset                       => reset,  
    clk_DAC                   => clk_5MHz,
    i_DAC_Strobe                => d_strobe_100Hz,
    o_bit_0               => o_DAC_D0,
    o_bit_1               => o_DAC_D1,
    o_DAC_NCS => o_DAC_NCS
    );

      
   Synchronisation : Synchro_Horloges
    port map (
           clkm         =>  sys_clock,
           o_S_5MHz     =>  S_5MHz,
           o_CLK_5MHz   => clk_5MHz,
           o_S_100Hz    => open,
           o_stb_100Hz  => d_strobe_100Hz,
           --o_S_1Hz      => o_ledtemoin_b
           o_S_1Hz      => open
    );
    o_ADC_CLK <= S_5MHz;
    o_DAC_CLK <= S_5MHz;
    
BlockDesign : mef_adc_wrapper
port map(
DDR_addr => DDR_addr,
DDR_ba => DDR_ba,
DDR_cas_n => DDR_cas_n,
DDR_ck_n => DDR_ck_n,
DDR_ck_p => DDR_ck_p,
DDR_cke => DDR_cke,
DDR_cs_n => DDR_cs_n,
DDR_dm => DDR_dm,
DDR_dq => DDR_dq,
DDR_dqs_n => DDR_dqs_n,
DDR_dqs_p => DDR_dqs_p,
DDR_odt => DDR_odt,
DDR_ras_n => DDR_ras_n,
DDR_reset_n => DDR_reset_n,
DDR_we_n => DDR_we_n,
FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
FIXED_IO_mio =>FIXED_IO_mio ,
FIXED_IO_ps_clk => FIXED_IO_ps_clk,
FIXED_IO_ps_porb => FIXED_IO_ps_porb,
FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
Pmod_8LD_pin1_io => Pmod_8LD(0),
Pmod_8LD_pin2_io => Pmod_8LD(1),
Pmod_8LD_pin3_io => Pmod_8LD(2),
Pmod_8LD_pin4_io => Pmod_8LD(3),
Pmod_8LD_pin7_io => Pmod_8LD(4),
Pmod_8LD_pin8_io => Pmod_8LD(5),
Pmod_8LD_pin9_io => Pmod_8LD(6),
Pmod_8LD_pin10_io => Pmod_8LD(7),
Pmod_OLED_pin1_io => Pmod_OLED(0),
Pmod_OLED_pin2_io => Pmod_OLED(1),
Pmod_OLED_pin3_io => Pmod_OLED(2),
Pmod_OLED_pin4_io => Pmod_OLED(3),
Pmod_OLED_pin7_io => Pmod_OLED(4),
Pmod_OLED_pin8_io => Pmod_OLED(5),
Pmod_OLED_pin9_io => Pmod_OLED(6),
Pmod_OLED_pin10_io => Pmod_OLED(7),
i_data_echantillon_1 => d_echantillon_1,
i_data_echantillon_0 => d_echantillon_0,
i_sw_tri_i => i_sw,
o_data_out_0 => d_data,
o_leds_tri_o => o_leds,
i_data_maxPico_0 => d_data_maxPico
--o_leds_tri_o => open
); 
d_do_ethylo_test <= d_data(0);    
o_led6_r <= not d_do_ethylo_test;
o_led6_g <= d_do_ethylo_test;
reset_adc <= reset or not d_do_ethylo_test;
--o_leds(0) <= d_data(0);    
end Behavioral;

