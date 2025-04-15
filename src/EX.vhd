library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;



entity EX is
  Port ( signal RD1: in std_logic_vector(31 downto 0);
         signal RD2: in std_logic_vector(31 downto 0);
         signal Ext_imm: in std_logic_vector(31 downto 0);
         signal sa: in std_logic_vector(4 downto 0);
         signal func: in std_logic_vector(5 downto 0);
         signal ALUOp: in std_logic_vector(2 downto 0);
         signal PCnext: in std_logic_vector(31 downto 0);
         signal ALUSrc: in std_logic;
         signal rt: in std_logic_vector(4 downto 0);
         signal rd: in std_logic_vector(4 downto 0);
         signal regDst: in std_logic;
         signal rWA: out std_logic_vector(4 downto 0);
         signal Zero: out std_logic;
         signal ALURes: out std_logic_vector(31 downto 0);
         signal BranchAddress: out std_logic_vector(31 downto 0) );
end EX;


architecture Behavioral of EX is

signal nr2, nrMux, res: std_logic_vector(31 downto 0);
signal ALUCtrl: std_logic_vector(2 downto 0);
begin
      
      
      rWA<=rt when regDst='0' else rd;
     
      process(ALUOp, func)
      begin
            case(ALUOp)is
            when "000" => ALUCtrl <="000"; --adunare
            when "001" => ALUCtrl <= "001"; --scadere, beq
            when "010" => case(func) is
                               when "000001" => ALUCtrl <= "000"; --adunare
                               when "000010" => ALUCtrl <= "001"; --scadere
                               when "000011" => ALUCtrl <= "100"; --sll
                               when "000100" => ALUCtrl <= "101"; --srl
                               when "000101" => ALUCtrl <= "010"; --and
                               when "000110" => ALUCtrl <= "011"; --or      
                               when "001000" => ALUCtrl <= "110"; --xor
                               when  others => ALUCtrl <= (others => 'X');             
                          end case;
            when "011" => ALUCtrl <="011"; --or
            when "100" => ALUCtrl <="010"; --and
            when others => ALUCtrl <= (others => 'X');
            end case;
      
      end process;
      
      nrMux<=RD2 when ALUSrc='0' else Ext_imm;
      
      process(ALUCtrl, RD1, nrMux, sa)
      begin
      --std_logic_vector(signed(RD1) \+ signed(b));
            case(ALUCtrl)is
            when "000" => res <= RD1 + nrMux; --adunare
            when "001" => res <= RD1 - nrMux; --scadere
            when "010" => res <= RD1 and nrMux; --and
            when "011" => res <= RD1 or nrMux; --or
            when "100" => res <= to_stdlogicvector(to_bitvector(RD1)sll conv_integer(sa)); --sll
            when "101" => res <= to_stdlogicvector(to_bitvector(RD1)srl conv_integer(sa)); --srl
            when "110"  => res <= RD1 xor nrMux; --xor
            when others => res <= (others => 'X'); 
            end case;
      end process;
      
      ALURes<=res;
      zero <= '1' when res=X"00000000" else '0'; 
      BranchAddress<=PCnext + (Ext_imm(29 downto 0) & "00");
      
end Behavioral;
