----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/21/2026 11:09:53 AM
-- Design Name: 
-- Module Name: VGA_CONTROLLER - Behavioral
-- Project Name: COLOUR_DISPLAY_ON_MONITOR_640_480_WITH_INPUT
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

entity VGA_CONTROLLER is
Port ( 
    clk : in std_logic;
    reset: in std_logic;
    h_sync : out std_logic;
    v_sync : out std_logic;
    video_on : out std_logic
);
end VGA_CONTROLLER;

--note: this VGA controller is designed to display a resolution of 640 by 480 @ 60Hz


architecture Behavioral of VGA_CONTROLLER is

--signals that tracks value of 25Mhz clock
signal clk_en : std_logic := '0';
signal div_count : unsigned(1 downto 0) := (others => '0');

--signals that track counter values
signal h_count : std_logic_vector (9 downto 0);
signal v_count : std_logic_vector (9 downto 0);

--signal that tracks when end of a line has been reached
signal eol : std_logic;
signal v_en : std_logic;


begin

-- divide clk from 100MHz to 25 MHz
process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            div_count <= (others => '0');
            clk_en <= '0';
        else
            div_count <= div_count + 1;
            if div_count = "11" then   -- divide by 4 (since 100/25 is 4)
                clk_en <= '1';
            else
                clk_en <= '0';
            end if;
        end if;
    end if;
end process;

--instantiate counters

HOR_COUNT: entity work.H_COUNT
port map (
clk => clk,
reset => reset,
en => clk_en,
end_of_line => eol,
Q => h_count
);

v_en <= eol and clk_en;

VER_COUNT: entity work.V_COUNT
port map (
clk => clk,
reset => reset,
en => v_en,
Q => v_count
);

-- compartators

--h_sync comparator:
process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            h_sync <= '1';
        elsif clk_en = '1' then
            if (to_integer(unsigned(h_count)) >= 656) AND (to_integer(unsigned(h_count)) <= 751 ) then
                h_sync <= '0';
            else
                h_sync <= '1';
            end if;
        end if;  
    end if;  
end process;

--v_sync comparator:
process(clk)
begin
    if rising_edge(clk) then 
        if reset = '1' then
            v_sync <= '1';
        elsif clk_en = '1' then
            if (to_integer(unsigned(v_count)) >= 490) AND (to_integer(unsigned(v_count)) <= 491 ) then
                v_sync <= '0';
            else
                v_sync <= '1';
            end if;
        end if;   
    end if; 
end process;

--display area comparator:

process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            video_on <= '0';
        elsif clk_en = '1' then
            if (to_integer(unsigned(h_count)) < 640) AND (to_integer(unsigned(v_count)) < 480 ) then
                    video_on <= '1';
            else
                video_on <= '0';
           end if;
        end if;  
      
    end if;
end process;

end Behavioral;
