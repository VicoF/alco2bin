----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2021 03:40:58 PM
-- Design Name: 
-- Module Name: MEF_DAC - Behavioral
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

entity MEF_DAC is
    Port ( i_echantillon_0 : in std_logic_vector(11 downto 0);
    i_echantillon_1 : in std_logic_vector(11 downto 0);
           o_bit_0 : out STD_LOGIC;
           o_bit_1 : out STD_LOGIC;
           clk_DAC : in STD_LOGIC;
           reset : in STD_LOGIC;
           i_cpt : in std_logic_vector(3 downto 0);
           o_reset_cpt : out STD_LOGIC;
           o_en_cpt : out STD_LOGIC;
           i_sync : in STD_LOGIC;
           o_DAC_NCS: out STD_LOGIC);
end MEF_DAC;

architecture Behavioral of MEF_DAC is
type state is (INIT, ZERO, SEND);
signal curr_state, next_State : state := INIT;
signal last_sync : std_logic ;
begin

process(clk_DAC, reset)
    begin
        if (reset='1') then
            curr_State <= INIT;
        elsif rising_edge(clk_DAC) then
            curr_state <= next_state;
            last_sync <= i_sync;
        end if;
end process;

process(curr_state, i_cpt, i_sync)
    begin
        case(curr_state) is
        when INIT => 
        if(last_sync='1' and i_sync='0') then
        next_State <= ZERO;
        else next_state <= curr_state;
        end if;
        when ZERO =>
        if (i_cpt = "0011")
        then next_state <= SEND;
        else next_state <= curr_state;
        end if;
        when SEND =>
        if(i_cpt = "1111") then
        next_state<= INIT;
        else next_state <= curr_state;
        end if;
    end case;
end process;

with curr_state select o_bit_0 <= '0' when ZERO, i_echantillon_0(15 - to_integer(unsigned(i_cpt))) when SEND, 'U' when others;
with curr_state select o_bit_1 <= '0' when ZERO, i_echantillon_1(15 - to_integer(unsigned(i_cpt))) when SEND, 'U' when others;
with curr_state select o_reset_cpt <= '1' when INIT, '0' when others;
with curr_state select o_en_cpt <= '0' when INIT, '1' when others;
with curr_State select o_DAC_NCS <= '1' when INIT, '0' when others;
end Behavioral;
