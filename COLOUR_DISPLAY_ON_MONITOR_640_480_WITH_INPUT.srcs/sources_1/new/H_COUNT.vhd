----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/21/2026 11:17:02 AM
-- Design Name: 
-- Module Name: H_COUNT - Behavioral
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

entity H_COUNT is
Port ( 
    clk : in std_logic;
    reset: in std_logic;
    en : in std_logic;
    end_of_line : out std_logic;
    Q : out std_logic_vector (9 downto 0)

);
end H_COUNT;

architecture Behavioral of H_COUNT is
signal counter : INTEGER RANGE 0 TO 799 := 0; 
signal h_max : integer := 799;
begin


--counter will start at 0 and end at 799 to reflect standard VGA values for 640 by 480 resolution
process (clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            counter <= 0;
            end_of_line <= '0';
        elsif en = '1' then
            if counter = h_max then
                counter <= 0;
                end_of_line <= '1'; -- output a pulse to indicate that end of line has been reached
            else
                counter <= counter + 1;
                end_of_line <= '0'; --no longer at end of line
            end if;
        else
            end_of_line <= '0';
        end if;
    end if;
end process;

Q <= std_logic_vector(to_unsigned(counter, 10)); --convert integer values to bit

end Behavioral;
