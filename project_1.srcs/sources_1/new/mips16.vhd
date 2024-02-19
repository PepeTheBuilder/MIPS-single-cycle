library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- MAIN MIPS
entity mips16 is
    Port ( 
           clk : in  STD_LOGIC;
           clkBtn: in  STD_LOGIC;
           selectt: in  STD_LOGIC_VECTOR (2 downto 0);
           switch : in  STD_LOGIC_VECTOR (8 downto 0);
           led : out  STD_LOGIC_VECTOR (15 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           cat : out  STD_LOGIC_VECTOR (6 downto 0)
        );
end mips16;


-------------------------------------------------------------
architecture Behavioral of mips16 is
-------------------------------------------------------------\

component instruction_fetch is
  Port (   clk : in STD_LOGIC;
           jump_data : in STD_LOGIC_VECTOR (15 downto 0);
           brench_data : in STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC;
           jump : in STD_LOGIC;
           pcsrc : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           pc_next : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component InstructionDecoder is
    Port ( clk : in STD_LOGIC;
           inst : in STD_LOGIC_VECTOR (15 downto 0);
           extOp : in STD_LOGIC;
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           regWrite : in STD_LOGIC;
           regDst : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           sa : out STD_LOGIC);
end component;

component ALU is 
	Port(
          ALUop : in STD_LOGIC_VECTOR(2 downto 0);
          input1 : in STD_LOGIC_VECTOR(15 downto 0);
          input2 : in STD_LOGIC_VECTOR(15 downto 0);
          sa : in std_logic_vector(0 downto 0);
          output : out STD_LOGIC_VECTOR(15 downto 0);
          zero: out STD_LOGIC
		);
end component;

component memory_unit is
    Port ( address : in STD_LOGIC_VECTOR (15 downto 0);
           write_data : in STD_LOGIC_VECTOR (15 downto 0);
           write_enable : in STD_LOGIC;
           memtoreg : in STD_LOGIC;
           clk : in STD_LOGIC;
           read_data : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           sw: in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

signal sa1,alu_zero,jump,regDst,memtoreg,branch,memwrite,regwrite,ALUsrc,extop,beq,pcsrc :  STD_LOGIC :='0';
signal func1 : STD_LOGIC_VECTOR (2 downto 0):=(Others=>'0');
signal aluop:  STD_LOGIC_VECTOR (2 downto 0):=(Others=>'0');
signal sa:  STD_LOGIC_VECTOR (1 downto 0):=(Others=>'0');
signal rd11,rd21,ext_imm1,rd2imm: STD_LOGIC_VECTOR (15 downto 0):=(Others=>'0');
signal input1_signal, input2_signal, alu_output, to_show: STD_LOGIC_VECTOR (15 downto 0):=(Others=>'0');
signal jump_data_signal, branch_data_signal: STD_LOGIC_VECTOR (15 downto 0):=(Others=>'0');
signal pc_next_signal, instruction_signal: STD_LOGIC_VECTOR (15 downto 0):=(Others=>'0');
signal memory_address_signal, memory_write_data_signal, memory_read_data_signal: STD_LOGIC_VECTOR (15 downto 0):=(Others=>'0');

begin

pcsrc<=beq and alu_zero;

pc: instruction_fetch port map(
    clk => clkBTn,
    jump_data => jump_data_signal,
    brench_data => branch_data_signal,
    jump => jump,
    pcsrc => pcsrc,
    en => '1',
    pc_next => pc_next_signal,
    instruction => instruction_signal
);

process(instruction_signal)
begin
 -- opCode=>"000" -Type R, "001"-ADDI, "010"-ANDI, "011"-ORI, "100" -lW, "101"-SW, "110"-BEQ, "111"-JUMP;
 -- aluop code meaning: "000"- ADD, "001"-SUB,"010"-AND ,"011"-OR  ,"100"-XOR,"101"-SLL,"110"-SRL, "111"-SLT;
 case instruction_signal(15 downto 13) is
 
  when "000" => -- Type R
    aluop <= instruction_signal(2 downto 0);-- ALUop daa
    regDst <= '0';				-- 0 - write from rd2 ....... 1 - write from immd 
    memtoreg<='0';				-- mux betweem memory and alu output
    jump <= '0';				-- jump flag
    branch <= '0';				-- branch flag
    memwrite <= '0';			-- write in Memory or read?
    ALUsrc <= '0';				-- ALU second operand is from: 0- rd2 ....... 1- extImm
    regwrite <= '1';			-- 0 - write in rd2 ....... 1 - write in rd2 
    extop <= '0';				-- 0 - ZeroExtenion .......... 1 - Signed extension
                           

  when "001" => -- ADDI
    regDst <= '1';				-- 0 - write in rd2 ....... 1 - write in immd 
    memtoreg<='0';				-- mux betweem memory and alu output
    aluop <= "000";				-- ALUop daa
    jump <= '0';				-- jump flag
    branch <= '0';				-- branch flag
    memwrite <= '0';			-- write in Memory or read?
    ALUsrc <= '1';				-- ALU second operand is from: 0- rd2 or 1- extImm
    regwrite <= '1';			-- 0 - write in rd2 ....... 1 - write in rd2 
    extop <= '1';				-- 0 - ZeroExtenion .......... 1 - Signed extension
   
  when "010" => -- ANDI
    regDst <= '1';				-- 0 - write in rd2 ....... 1 - write in immd 
    memtoreg<='0';				-- mux betweem memory and alu output
    aluop <= "010";				-- ALUop daa
    jump <= '0';				-- jump flag
    branch <= '0';				-- branch flag
    memwrite <= '0';			-- write in Memory or read?
    ALUsrc <= '1';				-- ALU second operand is from: 0- rd2 or 1- extImm
    regwrite <= '1';			-- 0 - write in rd2 ....... 1 - write in rd2 
    extop <= '1';				-- 0 - ZeroExtenion .......... 1 - Signed extension
   
 when "011" =>-- ORI
    regDst <= '1';				-- 0 - write in rd2 ....... 1 - write in immd 
    memtoreg<='0';				-- mux betweem memory and alu output
    aluop <= "011";				-- ALUop daa
    jump <= '0';				-- jump flag
    branch <= '0';				-- branch flag
    memwrite <= '0';			-- write in Memory or read?
    ALUsrc <= '1';				-- ALU second operand is from: 0- rd2 or 1- extImm
    regwrite <= '1';			-- 0 - write in rd2 ....... 1 - write in rd2 
    extop <= '1';				-- 0 - ZeroExtenion .......... 1 - Signed extension
	
 when "100" =>-- lW
    regDst <= '0';				-- 0 - write in rd2 ....... 1 - write in immd 
    memtoreg<='1';				-- mux betweem memory and alu output
    aluop <= "000";				-- ALUop daa
    jump <= '0';				-- jump flag
    branch <= '0';				-- branch flag
    memwrite <= '0';			-- 1 - write in Memory 0 - read?
    ALUsrc <= '1';				-- ALU second operand is from: 0- rd2 or 1- extImm
    regwrite <= '1';			-- 0 - write in rd2 ....... 1 - write in rd2 
    extop <= '0';				-- 0 - ZeroExtenion .......... 1 - Signed extension
   
 when "101" => -- SW  A.K.A. asta pune in memorie un nr
    regDst <= '0';				-- 0 - write in rd2 ....... 1 - write in immd 
    memtoreg<='1';				-- mux betweem memory and alu output
    aluop <= "000";				-- ALUop daa
    jump <= '0';				-- jump flag
    branch <= '0';				-- branch flag
    memwrite <= '1';			-- write in Memory or read?
    ALUsrc <= '1';				-- ALU second operand is from: 0- rd2 or 1- extImm
    regwrite <= '1';			-- 0 - write in rd2 ....... 1 - write in rd2 
    extop <= '1';				-- 0 - ZeroExtenion .......... 1 - Signed extension
   
 when "110" => --BEQ
    regDst <= '0';				-- 0 - write in rd2 ....... 1 - write in immd 
    memtoreg<='0';				-- mux betweem memory and alu output
    aluop <= "001";				-- ALUop daa
    jump <= '0';				-- jump flag
    branch <= '1';				-- branch flag
    memwrite <= '0';			-- write in Memory or read?
    ALUsrc <= '0';				-- ALU second operand is from: 0- rd2 or 1- extImm
    regwrite <= '0';			-- 0 - write in rd2 ....... 1 - write in rd2 
    extop <= '0';				-- 0 - ZeroExtenion .......... 1 - Signed extension
   
 when "111" =>-- JUMP
    regDst <= '0';				-- 0 - write in rd2 ....... 1 - write in immd 
    memtoreg<='0';				-- mux betweem memory and alu output
    aluop <= "000";				-- ALUop daa
    jump <= '1';				-- jump flag
    branch <= '0';				-- branch flag
    memwrite <= '0';			-- write in Memory or read?
    ALUsrc <= '0';				-- ALU second operand is from: 0- rd2 or 1- extImm
    regwrite <= '0';			-- 0 - write in rd2 ....... 1 - write in rd2 
    extop <= '0';				-- 0 - ZeroExtenion .......... 1 - Signed extension
   
 when others =>-- WTF IS ELSE SO TYPE R
    regDst <= '0';				-- 0 - write in rd2 ....... 1 - write in immd 
    memtoreg<='0';				-- mux betweem memory and alu output
    aluop <= "000";				-- ALUop daa
    jump <= '0';				-- jump flag
    branch <= '0';				-- branch flag
    memwrite <= '0';			-- write in Memory or read?
    ALUsrc <= '0';				-- ALU second operand is from: 0- rd2 or 1- extImm
    regwrite <= '0';			-- 0 - write in rd2 ....... 1 - write in rd2 
    extop <= '0';				-- 0 - ZeroExtenion .......... 1 - Signed extension
 end case;
end process;

regFile: InstructionDecoder port map(
    clk => clk,
    inst => instruction_signal,
    extOp => extop,
    wd => memory_read_data_signal,
    regWrite => regwrite,
    regDst => regdst,
    rd1 => rd11,
    rd2 => rd21,
    ext_imm => ext_imm1,

    sa => sa1
);

rd2imm<=ext_imm1 when ALUsrc ='1' else rd21;

sa(0)<=sa1;
led(7)<=regDst;
led(6)<=extop;
led(5)<=ALUSrc;
led(4)<=branch;
led(3)<=jump;
led(2)<=memwrite;
led(1)<=memtoreg;
led(0)<=regwrite;     	
led(10 downto 8)<=ALUOp(2 downto 0);
led(15 downto 11)<="00000";

    
--ALU ii bun
altu : ALU port map(
    ALUop => aluop,
    input1 => rd11,
    input2 => rd2imm,
    sa => sa(0 downto 0),
    output => alu_output,
    zero => alu_zero
);

-- Memory's code is good
memory: memory_unit port map(
    address => alu_output,
    write_data => rd21,
    write_enable => memwrite,
    memtoreg => memtoreg,
    clk => clk,
    read_data => memory_read_data_signal
);
    
process(rd11, rd21, ext_imm1, alu_output, memory_read_data_signal, memory_write_data_signal, selectt)
    begin
	case(selectt(2 downto 0)) is
		when "000"=>
				to_show <= alu_output;				        -----AFISARE ReadData1-----
		when "001"=>
		        to_show <= input1_signal;			        -----AFISARE ALU INPUT1-----			
		when "010"=>
				to_show<= input2_signal;                    -----AFISAR ALU INPUT2------
		when "011"=>
		        to_show <= rd11;                  	        -----AFISARE ReadData1 -----
		when "100"=>
		        to_show <= rd21;                      		-----AFISARE ReadData2 -----
		when "101" =>
		        to_show <= ext_imm1;                      	-----AFISARE EXT_IMM-----		
		when "110"=>
				to_show <= memory_read_data_signal;			-----AFISARE MemData-----
		when "111"=>
				to_show <= memory_write_data_signal;	    -----AFISARE regwrite - RegisterFile-----
		when others=>
				to_show <= instruction_signal;              
	end case;
end process;

-- Un simplu ssd
ssdu: ssd port map(clk=>clk,
        sw=>to_show,
        cat=>cat,
        an=>an
);

end Behavioral;
