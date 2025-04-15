----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2024 04:25:51 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;


architecture Behavioral of test_env is

component MPG is
Port ( signal clk: in std_logic;
       signal btn: in std_logic;
       signal en: out std_logic);
end component;

component SSD is 
Port ( signal clk: in std_logic;
       signal digits: in std_logic_vector(31 downto 0);
       signal cat: out std_logic_vector(6 downto 0);
       signal an: out std_logic_vector(7 downto 0));
end component;

component IFetch is
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
end component;

component ID is
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
end component;

component UC is
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
         JumpR: out std_logic );
end component;

component EX is

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
end component;

component MEM is
  Port ( clk : in std_logic;
         MemWrite: in std_logic;
         ALURes_in: in std_logic_vector(31 downto 0);
         RD2: in std_logic_vector(31 downto 0);
         en: in std_logic; --en e setat mereu pe 1 sau trebuie debouncer?
         MemData: out std_logic_vector(31 downto 0);
         ALURes_out: out std_logic_vector(31 downto 0) ); 
end component;

signal digits, pcNext, instruction, WD, ext_imm, RD1, RD2, ALURes, branchAdress, jumpAdress, MemData, ALURes_out: std_logic_vector(31 downto 0):=(others=>'0');
signal jump, PCSrc, regWrite, regWrite2, regDst, extOp, ALUSrc, Branch, MemWrite, MemtoReg, zero, en0, JumpR: std_logic:='0';
signal ALUOp: std_logic_vector(2 downto 0):=(others=>'0');
signal sa, WA, rt, rd, rWA: std_logic_vector(4 downto 0):=(others=>'0');
signal func: std_logic_vector(5 downto 0):=(others=>'0');

signal REG_IF_ID: std_logic_vector(63 downto 0):=(others=>'0');
signal REG_ID_EX: std_logic_vector(157 downto 0):=(others=>'0');
signal REG_EX_MEM: std_logic_vector(105 downto 0):=(others=>'0');
signal REG_MEM_WB: std_logic_vector(70 downto 0):=(others=>'0');


begin
    
   btn_0: MPG port map
      ( btn=>btn(0),
        clk=>clk,
        en=>en0 );
   
   ssd_piece: SSD port map
   ( clk=>clk,
     digits=>digits, 
     cat=>cat,
     an=>an );
     
   IFetch_piece: IFetch port map
        ( clk=>clk,
          btn=>btn, 
          jump=>jump,
          JumpR=>JumpR, --nou
          pcSrc=>PCSrc,
          en0=>en0,
          branchAdress => REG_EX_MEM(35 downto 4), --branchAdress,
          jumpAdress => jumpAdress, 
          jumpAdressR=>REG_ID_EX(72 downto 41), --RD1, 
          pcNext=>pcNext,
          instruction=>instruction );
          
   ID_piece: ID port map       
          ( clk => clk,
            regWrite => regWrite2,
            extOp => extOp,
            instr => REG_IF_ID(57 downto 32), --instruction(25 downto 0), 
            WA=>REG_MEM_WB(70 downto 66), --rWA 
            WD => WD,
            RD1 => RD1,
            RD2 => RD2,
            ext_imm => ext_imm,
            funct => func,
            sa => sa,
            rt => rt,
            rd => rd );
            
   UC_piece: UC port map
          ( instr => REG_IF_ID(63 downto 58), --instruction(31 downto 26), 
            RegDst => regDst,
            ExtOp => ExtOp,
            ALUSrc => ALUSrc,
            Branch => Branch,
            Jump => jump,
            ALUOp => ALUOp,
            MemWrite => MemWrite,
            RegWrite => RegWrite,
            MemtoReg => MemtoReg,
            JumpR => JumpR );     
            
   EX_piece: EX port map
          ( RD1 => REG_ID_EX(72 downto 41), --RD1,
            RD2 => REG_ID_EX(104 downto 73), --RD2,
            Ext_imm =>REG_ID_EX(141 downto 110), --ext_imm,
            sa =>REG_ID_EX(109 downto 105), --instruction(10 downto 6),
            func => REG_ID_EX(147 downto 142), --instruction(5 downto 0),
            ALUOp => REG_ID_EX(6 downto 4), --ALUOp,
            PCnext => REG_ID_EX(40 downto 9), --pcNext,
            ALUSrc => REG_ID_EX(7), --ALUSrc,
            rt => REG_ID_EX(152 downto 148), --rt,
            rd => REG_ID_EX(157 downto 153), --rd,
            regDst => REG_ID_EX(8), --regDst,
            rWA => rWA, 
            Zero => zero,
            ALURes => ALURes,
            BranchAddress => branchAdress);
            
   MEM_piece: MEM port map
          ( clk => clk,
            MemWrite => REG_EX_MEM(2), --MemWrite,
            ALURes_in => REG_EX_MEM(68 downto 37), --ALURes,
            RD2 => REG_EX_MEM(100 downto 69), --RD2,
            en => en0,
            MemData => MemData,
            ALURes_out => ALURes_out );   
   
   regWrite2<=REG_MEM_WB(1) and en0; --regWrite
   jumpAdress <= REG_IF_ID(31 downto 28) & REG_IF_ID(57 downto 32) & "00"; -- (PC + 4)[31:28] & Instr[25:0] & "00"
   WD <= REG_MEM_WB(33 downto 2) when REG_MEM_WB(0)='1' else REG_MEM_WB(65 downto 34); --MemData when MemtoReg='1' else ALURes_out; --Write Back WB
   PCSrc <= REG_EX_MEM(3) and REG_EX_MEM(36); --Branch and zero;
   
   
   process(clk, en0)
   begin
         if clk'event and clk='1' then
             --if en0='1' then
             
             REG_MEM_WB(0)<=REG_EX_MEM(0); --MemtoReg;
             REG_MEM_WB(1)<=REG_EX_MEM(1); --RegWrite;
             REG_MEM_WB(33 downto 2)<=MemData;
             REG_MEM_WB(65 downto 34)<=ALURes_out;
             REG_MEM_WB(70 downto 66)<=REG_EX_MEM(105 downto 101); --rWA
             
             REG_EX_MEM(0)<=REG_ID_EX(0); --MemtoReg;
             REG_EX_MEM(1)<=REG_ID_EX(1); --RegWrite;
             REG_EX_MEM(2)<=REG_ID_EX(2); --MemWrite;
             REG_EX_MEM(3)<=REG_ID_EX(3); --Branch;
             REG_EX_MEM(35 downto 4)<=branchAdress;
             REG_EX_MEM(36)<=zero;
             REG_EX_MEM(68 downto 37)<=ALURes;
             REG_EX_MEM(100 downto 69)<=REG_ID_EX(104 downto 73); --RD2
             REG_EX_MEM(105 downto 101)<=rWA;
             
             REG_ID_EX(0)<=MemtoReg;
             REG_ID_EX(1)<=RegWrite;
             REG_ID_EX(2)<=MemWrite;
             REG_ID_EX(3)<=Branch;
             REG_ID_EX(6 downto 4)<=AluOp;
             REG_ID_EX(7)<=AluSrc;
             REG_ID_EX(8)<=RegDst;
             REG_ID_EX(40 downto 9)<=REG_IF_ID(31 downto 0); --pcnext
             REG_ID_EX(72 downto 41)<=RD1;
             REG_ID_EX(104 downto 73)<=RD2;
             REG_ID_EX(109 downto 105)<=sa;
             REG_ID_EX(141 downto 110)<=ext_imm;
             REG_ID_EX(147 downto 142)<=func;
             REG_ID_EX(152 downto 148)<=rt;
             REG_ID_EX(157 downto 153)<=rd;
                          
             REG_IF_ID(31 downto 0)<=pcNext;
             REG_IF_ID(63 downto 32)<=instruction;
             --end if;
         end if;
   end process;
   
   
   process(sw(7 downto 5), REG_IF_ID, REG_ID_EX, REG_EX_MEM, REG_MEM_WB, WD)
   begin
         case(sw(7 downto 5)) is
              when "000" => digits <= REG_IF_ID(63 downto 32); --instruction;
              when "001" => digits <= REG_IF_ID(31 downto 0); --pcNext;
              when "010" => digits <= REG_ID_EX(72 downto 41); --RD1; 
              when "011" => digits <= REG_ID_EX(104 downto 73); --RD2; 
              when "100" => digits <= REG_ID_EX(141 downto 110); --Ext_imm; 
              when "101" => digits <= REG_EX_MEM(68 downto 37); --ALURes;
              when "110" => digits <= REG_MEM_WB(33 downto 2); --MemData;
              when "111" => digits <= WD;
              when others => digits <= X"00000000";                 
              
         end case;
   end process;
  
 -- led(8 downto 0) <= RegDst & ExtOp & ALUSrc & Branch & Jump & JumpR & MemWrite & MemtoReg & RegWrite;
   
end Behavioral;
