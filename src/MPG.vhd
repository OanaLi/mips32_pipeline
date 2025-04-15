library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MPG is
Port ( signal clk: in std_logic;
       signal btn: in std_logic;
       signal en: out std_logic);
end MPG;

architecture Behavioral of MPG is

signal counter: std_logic_vector(15 downto 0):=(others=>'0');
signal Q1: std_logic;
signal Q2: std_logic;
signal Q3: std_logic;

begin

en<=not(Q3) and Q2;
process(clk)
begin
    if (clk'event and clk='1') then
        counter<=counter+1;
        if counter="1111111111111111" then
           Q1<=btn;
        end if;
        Q2<=Q1;
        Q3<=Q2;
    end if;
end process;
    
end Behavioral;
