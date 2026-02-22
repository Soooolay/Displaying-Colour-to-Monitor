----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/21/2026 11:17:02 AM
-- Design Name: 
-- Module Name: V_COUNT - Behavioral
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

entity V_COUNT is
Port ( 
    clk : in std_logic;
    reset: in std_logic;
    en : in std_logic;
    Q : out std_logic_vector (9 downto 0)
);
end V_COUNT;

architecture Behavioral of V_COUNT is
--signals to hold counter values
signal counter : INTEGER RANGE 0 TO 524 := 0;  
signal v_max : integer := 524;
begin

--counter will start at 0 and end at 524 to reflect standard VGA values for 640 by 480 resolution
process (clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            counter <= 0;
        elsif en = '1' then
        --vertical counter needs to only increment once end of line is reached
            if counter = v_max then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end if;
end process;

Q <= std_logic_vector(to_unsigned(counter, 10)); --convert integer values to bit

end Behavioral;
