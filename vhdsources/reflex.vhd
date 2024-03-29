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
           i_cpt_clk : in STD_LOGIC;
           i_strobe_start : in STD_LOGIC;
           o_strobe_end : out STD_LOGIC;
           o_data : out STD_LOGIC_VECTOR(8 downto 0);
           o_green: out std_logic;
           o_red: out std_logic;
           o_blue: out std_logic;
           i_btn: in STD_LOGIC);
end reflex;

architecture Behavioral of reflex is
component compteur_nbits is
generic (nbits : integer := 8);
   port ( clk             : in    std_logic; 
          i_en            : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0);
          o_overflow : out std_logic
          );
end component;
signal enable : std_logic;
signal d_val_cpt: STD_LOGIC_VECTOR(8 downto 0);
signal d_delay: STD_LOGIC_VECTOR(8 downto 0);
signal d_en_cpt: STD_LOGIC;
signal d_reset_cpt: STD_LOGIC;
signal d_next_delay: STD_LOGIC;
signal d_overflow: STD_LOGIC;
signal index: integer:=0;

type tableau is array (integer range 0 to 8) of std_logic_vector(8 downto 0);
constant delay_tab : tableau := (
'0'& x"AF",
'0'& x"FF",
'1'& x"F1",
'1'& x"DF",
'1'& x"0A",
'1'& x"CD",
'0'& x"BC",
'1'& x"77",
'1'& x"66"
--'0'& x"0F",
--'0'& x"0F",
--'0'& x"0F",
--'0'& x"0F",
--'0'& x"0A",
--'0'& x"0D",
--'0'& x"0C",
--'0'& x"07",
--'0'& x"06"
);


type state is (IDLE, RESET_CPT1, WAIT_DELAY, RESET_CPT2, TIMER, SEND_RESULT, SEND_ERROR);
signal curr_state, next_state: state := IDLE;
begin

process(i_clk)
begin
    if (i_clk'event and i_clk='1') then
        curr_state<= next_state;
    end if;
end process;

process(curr_state, i_btn, i_strobe_start,d_val_cpt)
begin
case curr_state is 
    when IDLE=>
        if(i_strobe_start='1') then 
            next_state<= RESET_CPT1;
        else next_state<= curr_state;
        end if;
    when RESET_CPT1 =>
        next_state<=  WAIT_DELAY;
    when WAIT_DELAY =>
        if(d_val_cpt >= d_delay) then
            next_state<= RESET_CPT2;
       elsif(i_btn='1') then  
            next_state<=SEND_ERROR;
        else next_state<= curr_state;
        end if;
                
    when RESET_CPT2 =>
        next_state<=  TIMER;
    when TIMER =>
             if(i_btn='1') then  
                next_state<=SEND_RESULT;
             elsif (d_overflow = '1') then 
                next_state <= SEND_ERROR;
             else next_state<= curr_state;
             end if;
             
    when SEND_RESULT =>
             next_state <= IDLE;
    when SEND_ERROR =>
             next_state <= IDLE;
    end case;
end process;

process(i_clk, d_next_delay)
begin
if(d_next_delay='1') then
if(index=8) then
index<= 0;
else index<= index+1;
end if;
d_delay <= delay_tab(index);
end if;
end process;

with curr_state select d_en_cpt <= '1' WHEN WAIT_DELAY|TIMER, '0' when others;
with curr_state select d_reset_cpt <= '1' WHEN RESET_CPT1|RESET_CPT2|SEND_ERROR, '0' when others;
with curr_state select o_data <= d_val_cpt WHEN SEND_RESULT |IDLE | TIMER, "000000000" when others;
with curr_state select o_strobe_end <= '1' WHEN SEND_RESULT|SEND_ERROR, '0' when others;
with curr_state select d_next_delay <= '1' WHEN IDLE, '0' when others;
with curr_state select o_red <= '0' WHEN TIMER, '1' when others;
with curr_state select o_green <= '1' WHEN TIMER, '0' when others;

cptr: compteur_nbits generic map (nbits => 9)
port map (
clk => i_cpt_clk,
i_en => d_en_cpt,
reset => d_reset_cpt,
o_val_cpt => d_val_cpt,
o_overflow => d_overflow
);

end Behavioral;
