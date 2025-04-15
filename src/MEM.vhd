library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity MEM is
  Port ( clk : in std_logic;
         MemWrite: in std_logic;
         ALURes_in: in std_logic_vector(31 downto 0);
         RD2: in std_logic_vector(31 downto 0);
         en: in std_logic; --en e setat mereu pe 1 sau trebuie debouncer?
         MemData: out std_logic_vector(31 downto 0);
         ALURes_out: out std_logic_vector(31 downto 0) ); 
end MEM;

architecture Behavioral of MEM is
type ram is array(0 to 63) of std_logic_vector(31 downto 0);
signal mem : ram:= (
X"00000040", -- 0 -- A, adresa din memorie de la care incepe sirul 40/4=10
X"00000000", -- 1
X"00000000", -- 2
X"00000000", -- 3 
X"00000005", -- 4 -- N, numarul de elemente din sir
X"00000000", -- 5
X"00000000", -- 6
X"00000000", -- 7
X"00000000", -- 8
X"00000000", -- 9
X"00000000", -- 10
X"00000000", -- 11
X"00000000", -- 12
X"00000000", -- 13
X"00000000", -- 14
X"00000000", -- 15
X"00000001", -- 16 -- 1
X"00000002", -- 17 -- 2
X"00000003", -- 18 -- 3
X"00000004", -- 19 -- 4
X"00000005", -- 20 -- 5
others => X"00000000" );

begin
     MemData <= mem(conv_integer(ALURes_in(7 downto 2)));
     
     process(clk)
     begin
         if (clk'event and clk='1') then
             if (en='1' and MemWrite='1') then
                mem(conv_integer(ALURes_in(7 downto 2)))<=RD2;
             end if;
         end if;
     end process;
     
     ALURes_out <= ALURes_in;
end Behavioral;
