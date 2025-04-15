library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity UC is
  Port ( instr: in std_logic_vector(5 downto 0);
         RegDst: out std_logic;
         ExtOp: out std_logic;
         ALUSrc: out std_logic;
         Branch: out std_logic;
         Jump: out std_logic;
         ALUOp: out std_logic_vector(2 downto 0);
         MemWrite: out std_logic;
         RegWrite: out std_logic;
         MemtoReg: out std_logic;
         JumpR: out std_logic); --nou
end UC;

architecture Behavioral of UC is

begin
   process(instr)
   begin
         RegDst<='0'; ExtOp<='0'; ALUSrc<='0'; ALUOp<="000"; Branch<='0'; Jump<='0'; JumpR<='0'; MemWrite<='0'; MemtoReg<='0'; RegWrite<='0';
         case(instr) is 
                 when "000000" => RegDst<='1'; RegWrite<='1'; ALUOp<="010"; --tip R gata
                 when "000001" => ExtOp<='1'; ALUSrc<='1'; RegWrite<='1'; ALUOp<="000"; --addi gata
                 when "000010" => ExtOp<='1'; ALUSrc<='1'; RegWrite<='1'; MemtoReg<='1'; ALUOp<="000"; --lw gata
                 when "000011" => ExtOp<='1'; ALUSrc<='1'; MemWrite<='1'; ALUOp<="000"; --sw gata
                 when "000100" => ExtOp<='1'; Branch<='1'; ALUOp<="001";  --beq gata
                 when "000101" => ExtOp<='1'; ALUSrc<='1'; RegWrite<='1'; ALUOp<="100"; --andi
                 when "000110" => ALUSrc<='1'; RegWrite<='1'; ALUOp<="011"; --ori gata
                 when "000111" => Jump<='1'; --j gata 
                 when "001000" => JumpR<='1'; --jr gata --nou
                 when others => RegDst<='0'; ExtOp<='0'; ALUSrc<='0'; ALUOp<="000"; Branch<='0'; Jump<='0'; JumpR<='0'; MemWrite<='0'; MemtoReg<='0'; RegWrite<='0';
         end case;
   end process;


end Behavioral;
