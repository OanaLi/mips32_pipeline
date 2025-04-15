library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ID is
  Port ( clk : in STD_LOGIC;
         regWrite: in std_logic;
         extOp: in std_logic;
         instr: in std_logic_vector(25 downto 0);
         WA: in std_logic_vector(4 downto 0);
         WD: in std_logic_vector(31 downto 0);
         RD1 : out std_logic_vector(31 downto 0);
         RD2 : out std_logic_vector(31 downto 0);
         ext_imm: out std_logic_vector(31 downto 0);
         funct: out std_logic_vector(5 downto 0);
         sa: out std_logic_vector(4 downto 0);
         rt: out std_logic_vector(4 downto 0);
         rd: out std_logic_vector(4 downto 0) );
         
end ID;

architecture Behavioral of ID is

component reg_file is
  port ( clk : in std_logic;
         ra1 : in std_logic_vector(4 downto 0);
         ra2 : in std_logic_vector(4 downto 0);
         wa : in std_logic_vector(4 downto 0);
         wd : in std_logic_vector(31 downto 0);
         regwr : in std_logic;
         rd1 : out std_logic_vector(31 downto 0);
         rd2 : out std_logic_vector(31 downto 0));
end component;

begin

 reg_file_piece: reg_file port map
   ( clk=>clk,
     ra1=>instr(25 downto 21),
     ra2=>instr(20 downto 16),
     wa=>wa,
     wd=>WD,
     regwr=>regWrite,
     rd1=>RD1,
     rd2=>RD2 );
     
     ext_imm(15 downto 0) <= instr(15 downto 0);
     ext_imm(31 downto 16) <= (others => instr(15)) when extOp = '1' else (others => '0');
     funct<=instr(5 downto 0);
     sa<=instr(10 downto 6);
     rt<=instr(20 downto 16);
     rd<=instr(15 downto 11);
  

end Behavioral;
