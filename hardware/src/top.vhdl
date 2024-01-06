-- Driver for ws2812b addressable rgb leds, commonly called "Neopixels"
-- @author: dwclake

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        sys_clk  : in std_logic;
        enable   : in std_logic;
        spi_clk  : in std_logic;
        mosi     : in std_logic;
        miso     : in std_logic;
        ss       : in std_logic;
        data_out : out std_logic;
        led      : out std_logic_vector(7 downto 0)
    );
end top;

architecture rtl of top is
    signal counter : unsigned(31 downto 0);
begin
    count : process (sys_clk) is 
    begin
        if rising_edge(sys_clk) then
            counter <= counter + 1;
        end if;
    end process count;

    led <= std_logic_vector(counter(25 downto 18));
end rtl;
