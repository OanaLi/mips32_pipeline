library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity IFetch is
  Port (   clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           jump : in STD_LOGIC;
           JumpR: in STD_LOGIC; --nou
           pcSrc : in STD_LOGIC;
           en0 : in STD_LOGIC;
           branchAdress: in STD_LOGIC_VECTOR(31 DOWNTO 0);
           jumpAdress: in STD_LOGIC_VECTOR(31 DOWNTO 0);
           jumpAdressR: in STD_LOGIC_VECTOR(31 DOWNTO 0); --nou
           pcNext: out STD_LOGIC_VECTOR(31 downto 0);
           instruction: out STD_LOGIC_VECTOR(31 downto 0));
end IFetch;

architecture Behavioral of IFetch is
signal pcIn, pcOut, pc4, muxOut1, muxOut2: std_logic_vector(31 downto 0) := (others =>'0');

type memory_rom is array (0 to 31) of std_logic_vector(31 downto 0);
signal mem : memory_rom := (
b"000001_00000_00001_0000000000000000",   -- 0. | X"04010000" | addi $1, $0, 0         | i=0;
b"000010_00000_00011_0000000000000000",   -- 1. | X"08030000" | lw $3, 0($0)           | A=mem(0) = 64 (in A se pune numarul de la adresa 0 din memorie - numarul de pe linia 0 din MEM)
b"000010_00000_00100_0000000000010000",   -- 2. | X"08040010" | lw $4, 16($0)          | N=mem(16) = 5 (in N se pune numarul de la adresa 16 din memorie - adica ce avem pe linia 4)
b"000001_00000_00110_0000000000100000",   -- 3. | X"04060020" | addi $6, $0, 32        | R6=32
b"000001_00000_00000_0000000000000000",   -- 4. | X"04000000" | NoOp
b"000001_00000_00000_0000000000000000",   -- 5. | X"04000000" | NoOp
b"000000_00011_00110_00010_00000_000010", -- 6. | X"00661002" | sub $2, $3, $6         | A2=32 (adresa la care se muta sirul)
b"000100_00001_00100_0000000000001100",   -- 7. | X"1024000C" | start: beq $1, $4, 12 | cat timp i<N
b"000001_00000_00000_0000000000000000",   -- 8. | X"04000000" | NoOp
b"000001_00000_00000_0000000000000000",   -- 9. | X"04000000" | NoOp
b"000001_00000_00000_0000000000000000",   --10. | X"04000000" | NoOp
b"000010_00011_00101_0000000000000000",   --11. | X"08650000" | lw $5, 0($3)           | R5=mem(A) (in registrul 5 se pune numarul de la adresa A)
b"000001_00000_00000_0000000000000000",   --12. | X"04000000" | NoOp
b"000001_00000_00000_0000000000000000",   --13. | X"04000000" | NoOp
b"000011_00010_00101_0000000000000000",   --14. | X"0C450000" | sw $5, 0($2)           | mem(A2)=R5 (in memorie se pune la adresa A2 numarul din registrul 5)
b"000001_00010_00010_0000000000000100",   --15. | X"04420004" | addi $2, $2, 4         | A2=A2+4 (se trece la urmatoarea adresa din memorie de dupa A2)
b"000001_00001_00001_0000000000000001",   --16. | X"04210001" | addi $1, $1, 1         | i=i+1 (se incrementeaza contorul)
b"000011_00011_00000_0000000000000000",   --17. | X"0C600000" | sw $0, 0($3)           | mem(A)=0 (se sterge numarul de la adresa A)
b"000111_00000000000000000000000111",     --18. | X"1C000007" | j 7                    | salt la linia 5
b"000001_00011_00011_0000000000000100",   --19. | X"04630004" | addi $3, $3, 4         | A=A+4 (se terce la  urmatoarea adresa din memorie de dupa A)
others => X"00000000"                     --20. | X"00000000" | NOOP                   | NOOP
);

begin

   process(clk, en0, btn(1))
   begin
       if (btn(1)='1') then         --reset asincron
           pcOut <= (others => '0');
       elsif (clk'event and clk='1') then
           if (en0='1')then         --enable PC
               pcOut <= pcIn;
           end if;
       end if;
   end process;
   
   pc4<=pcOut + 4;
   instruction <= mem(conv_integer(pcOut(6 downto 2)));
   
   muxOut1 <= pc4 when pcSrc = '0' else branchAdress; --mux cu sel PCSrc
   muxOut2 <= muxOut1 when jump = '0' else jumpAdress; --mux cu sel Jump 
   pcIn <= muxOut2 when JumpR = '0' else jumpAdressR; --mux cu sel JumpR 
   pcNext <= pc4;
   
   
   
end Behavioral;
