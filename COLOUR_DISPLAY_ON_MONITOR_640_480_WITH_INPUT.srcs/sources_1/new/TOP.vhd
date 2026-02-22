----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/21/2026 11:09:53 AM
-- Design Name: 
-- Module Name: TOP - Structural
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
-- TOP level design that connects inputs, VGA controller, RGB generator, and outputs together
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

entity TOP is
Port ( 
clk : in std_logic;
reset : in std_logic;
R_in : in std_logic_vector (3 downto 0);
G_in : in std_logic_vector (3 downto 0);
B_in : in std_logic_vector (3 downto 0);
R_out : out std_logic_vector (3 downto 0);
G_out : out std_logic_vector (3 downto 0);
B_out : out std_logic_vector (3 downto 0);
h_sync : out std_logic;
v_sync: out std_logic

);
end TOP;

architecture Structural of TOP is

signal vid_on : std_logic;
begin

--connecting modules together
VGA : entity work.VGA_CONTROLLER
port map (
clk => clk,
reset => reset,
h_sync => h_sync,
v_sync => v_sync,
video_on => vid_on
);

RGB : entity work.RGB_GENERATOR
port map (
video_on => vid_on,
R_in => R_in,
G_in => G_in,
B_in => B_in,
R_out => R_out,
G_out => G_out,
B_out => B_out
);

end Structural;
