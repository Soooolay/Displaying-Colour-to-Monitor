----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/21/2026 11:09:53 AM
-- Design Name: 
-- Module Name: RGB_GENERATOR - Behavioral
-- Project Name: COLOUR_DISPLAY_ON_MONITOR_640_480
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

entity RGB_GENERATOR is
Port ( 
video_on : in std_logic;
R_in : in std_logic_vector (3 downto 0);
G_in : in std_logic_vector (3 downto 0);
B_in : in std_logic_vector (3 downto 0);
R_out : out std_logic_vector (3 downto 0);
G_out : out std_logic_vector (3 downto 0);
B_out : out std_logic_vector (3 downto 0)
);
end RGB_GENERATOR;

architecture Behavioral of RGB_GENERATOR is

--signals for when video_on is off (shows black)
signal black_r : std_logic_vector (3 downto 0) := (others => '0');
signal black_g : std_logic_vector (3 downto 0) := (others => '0');
signal black_b : std_logic_vector (3 downto 0) := (others => '0');


begin

mux : process (video_on, R_in, G_in, B_in)
begin
    -- outside display area is black
    if video_on = '0' then
        R_out <= black_r;
        G_out <= black_g;
        B_out <= black_b;
    else
    -- inside display area is input colour
        R_out <= R_in;
        G_out <= G_in;
        B_out <= B_in;
    end if; 


end process;


end Behavioral;
