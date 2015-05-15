LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

-- Steve Singh
-- ID: 500389934

ENTITY datapath IS

PORT( 

-- Clock Signal
Clk, mClk  :  IN STD_LOGIC;  

-- Memory Signals

WEN, EN : IN STD_LOGIC;

-- Register Control Signals (CLR and LD).

Clr_A , Ld_A   :  IN STD_LOGIC; -- Clear Reg. A, Load Reg. A
Clr_B , Ld_B   :  IN STD_LOGIC;	-- Clear Reg. B, Load Reg. B
Clr_C , Ld_C   :  IN STD_LOGIC;	-- Clear Carry, Load Carry
Clr_Z , Ld_Z   :  IN STD_LOGIC;	-- Clear Zero, Load Zero
Clr_PC , Ld_PC :  IN STD_LOGIC; -- Clear PC, Load PC
Clr_IR , Ld_IR :  IN STD_LOGIC; -- Clear IR, Load IR

-- Register outputs (Some needed to feed back to control unit. Others pulled out for testing.

Out_A  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
Out_B  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
Out_C  : OUT STD_LOGIC;
Out_Z  : OUT STD_LOGIC;
Out_PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
Out_IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

-- Special inputs to PC.

Inc_PC :  IN STD_LOGIC;

-- Address and Data Bus.

ADDR_OUT :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
DATA_IN  :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);
DATA_OUT :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

-- Various MUX controls.

DATA_Mux :  IN STD_LOGIC_VECTOR(1 DOWNTO 0);
REG_Mux  :  IN STD_LOGIC;
PC_Mux   :  IN STD_LOGIC;
IM_MUX1  :  IN STD_LOGIC;
IM_MUX2  :  IN STD_LOGIC_VECTOR(1 DOWNTO 0);

-- ALU Operations.

ALU_Op :  IN STD_LOGIC_VECTOR(2 DOWNTO 0));

END datapath;

ARCHITECTURE description OF datapath IS

-- Component instantiations --

-- 32-bit Registers

COMPONENT Register_IR 
PORT(
		D		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input
		LD		: IN STD_LOGIC;	-- Load/Enable
		CLR		: IN STD_LOGIC;	-- Asynchronous Clear
		CLK		: IN STD_LOGIC;	-- Clock
		Q		: BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0)); -- Output
END COMPONENT;

COMPONENT Register_A 
PORT(
		D		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input
		LD		: IN STD_LOGIC;	-- Load/Enable
		CLR		: IN STD_LOGIC;	-- Asynchronous Clear
		CLK		: IN STD_LOGIC;	-- Clock
		Q		: BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0)); -- Output
END COMPONENT;

COMPONENT Register_B 
PORT(
		D		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input
		LD		: IN STD_LOGIC;	-- Load/Enable
		CLR		: IN STD_LOGIC;	-- Asynchronous Clear
		CLK		: IN STD_LOGIC;	-- Clock
		Q		: BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0)); -- Output
END COMPONENT;

COMPONENT PC
PORT(
		CLR	: IN STD_LOGIC;	-- Asynchronous Clear
		CLK	: IN STD_LOGIC;	-- Clock)
		LD	: IN STD_LOGIC;	-- Load/Enable
		INC	: IN STD_LOGIC;	-- Input Selector
		D	: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input
		Q	: BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0)); -- Output
END COMPONENT;

-- 1-bit Registers

COMPONENT Register_C
PORT(
		D		: IN STD_LOGIC; -- Input
		LD		: IN STD_LOGIC;	-- Load/Enable
		CLR		: IN STD_LOGIC;	-- Asynchronous Clear
		CLK		: IN STD_LOGIC;	-- Clock
		Q		: OUT STD_LOGIC); -- Output
END COMPONENT;

COMPONENT Register_Z
PORT(
		D		: IN STD_LOGIC; -- Input
		LD		: IN STD_LOGIC;	-- Load/Enable
		CLR		: IN STD_LOGIC;	-- Asynchronous Clear
		CLK		: IN STD_LOGIC;	-- Clock
		Q		: OUT STD_LOGIC); -- Output
END COMPONENT;

-- ALU

COMPONENT ALU 
PORT( a      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	  b      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      op     : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      cout   : OUT STD_LOGIC;
      zero   : OUT STD_LOGIC);
END COMPONENT;

-- Memory Module

COMPONENT data_mem 

GENERIC( ADDRESS_WIDTH	: INTEGER := 8;
		 DATA_WIDTH		: INTEGER := 32);
		 
PORT(	 clk			: IN  STD_LOGIC;
		 data_in		: IN  STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
		 addr			: IN  STD_LOGIC_VECTOR(ADDRESS_WIDTH - 1 DOWNTO 0);
		 en				: IN  STD_LOGIC;
		 wen			: IN  STD_LOGIC;
		 data_out		: OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0));
END COMPONENT;

-----------------------------------------------------------------------------------

---------------------- Internal Signals ---------------------- 

SIGNAL DATA_OUT2    : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL ADDR_OUT2    : STD_LOGIC_VECTOR (31 DOWNTO 0);

SIGNAL IR_out       : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL RegA_out     : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL RegB_out     : STD_LOGIC_VECTOR (31 DOWNTO 0);

SIGNAL ALU_out      : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL cout_alu     : STD_LOGIC;

SIGNAL zout_alu     : STD_LOGIC;

SIGNAL REG_Mux_out  : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL IM_MUX1_out  : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL IM_MUX2_out  : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL PC_Mux_out   : STD_LOGIC_VECTOR (31 DOWNTO 0);

SIGNAL mem_out      : STD_LOGIC_VECTOR (31 DOWNTO 0);

SIGNAL IR_UZE       : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL IR_UZE1       : STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL IR_LZE		: STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL Zero_Vector	: STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
SIGNAL One 			: STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL IR_RED       : STD_LOGIC_VECTOR (7 DOWNTO 0);

----------------- End of internal signals -----------------

BEGIN

--- Signal designations ---
	Out_A  <= RegA_out;
	Out_B  <= RegB_out;
	Out_PC <= ADDR_OUT2;
	Out_IR <= IR_out;
	DATA_OUT <= DATA_OUT2;
	ADDR_OUT <= ADDR_OUT2;
	One <= "00000000000000000000000000000001";
--- End of designations ---

----------------------------------------------------- Port maps for components -----------------------------------------------------

IR: Register_IR  PORT MAP (D => DATA_OUT2, LD => Ld_IR, CLR => Clr_IR, CLK => Clk, Q => IR_out);
RegA: Register_A PORT MAP (D => Zero_Vector&DATA_OUT2(15 DOWNTO 0), LD => Ld_A, CLR => Clr_A, CLK => Clk, Q => RegA_out);
RegB: Register_B PORT MAP (D => Zero_Vector&DATA_OUT2(15 DOWNTO 0), LD => Ld_B, CLR => Clr_B, CLK => Clk, Q => RegB_out);
PCMap: PC 		 PORT MAP (D => PC_Mux_out, LD => Ld_PC, CLR => Clr_IR, CLK => Clk, INC => Inc_PC, Q => ADDR_OUT2);
RegC: Register_C PORT MAP (D => cout_alu, LD => Ld_C, CLR => Clr_C, CLK => Clk, Q => Out_C);
RegZ: Register_Z PORT MAP (D => zout_alu, LD => Ld_Z, CLR => Clr_Z, CLK => Clk, Q => Out_Z);
ALUMap: ALU 	 PORT MAP (a => IM_MUX1_out, b => IM_MUX2_out, op => ALU_Op, result => ALU_out, cout => cout_alu, zero => zout_alu);
Mem: data_mem    PORT MAP (clk => mClk, data_in => REG_Mux_out, addr => IR_RED, en => EN, wen => WEN, data_out => mem_out);
--------------------------------------------------------- End of port maps ---------------------------------------------------------

---------------- MUX section ----------------

WITH DATA_Mux SELECT 
DATA_OUT2 <= DATA_IN 		   WHEN "00",
			 mem_out 		   WHEN "01",
			 ALU_out    	   WHEN "10",
			 (OTHERS =>'X')    WHEN OTHERS;
			 
WITH IM_MUX2 SELECT 
IM_MUX2_out <= RegB_out 	   WHEN "00",
			   IR_LZE   	   WHEN "01",
			   One 			   WHEN "10",
			   (OTHERS =>'X')  WHEN OTHERS;	
			   		 
WITH REG_Mux SELECT 
REG_Mux_out <= RegA_out  	   WHEN '0',
			   RegB_out  	   WHEN '1',
			   (OTHERS =>'X')  WHEN OTHERS;
			 
WITH PC_Mux SELECT 
PC_Mux_out <= IR_LZE   		   WHEN '0',
			  ADDR_OUT2		   WHEN '1',
			  (OTHERS =>'X')   WHEN OTHERS;
			  
WITH IM_MUX1 SELECT 
IM_MUX1_out <= RegA_out        WHEN '0',
			   IR_UZE          WHEN '1',
			   (OTHERS =>'X')  WHEN OTHERS;			   

------------ End of MUX section -------------

-- Zero Extenders --

PROCESS(IR_UZE)
BEGIN

IR_UZE1 <= IR_out(15 DOWNTO 0);
IR_UZE <= IR_UZE1 & Zero_Vector;

END PROCESS;

IR_LZE <= (Zero_Vector&IR_out(15 DOWNTO 0));

-- End of Zero Extenders --


-- Reducer --

IR_RED <= (IR_out(7 DOWNTO 0));

-- End of Reducer --

END description;

------------ Questions Section -------------

-- 1. How does this data-path implement INCA, MUL2A, and ADDI operations?

-- Ans: INCA is implemented by using the ALU's ADD operation, with B set to '1'. 
--      IM_MUX1 is set to '0', IM_MUX2 to "10", ALU_OP to "010", DATA_MUX to "10",
--      and CLR_A to '0', and LD_A to '1' in order to store the result back into A.
--      Everything else is set to 'X' or '0', depending on other requirements.

--      MUL2A is implemented with a left rotate ALU operation on A. IM_MUX is set to 
--		'0', IM_MUX to 'X', ALU_OP to "100", DATA_MUX to "10", CLR_A to '0', 
--      and LD_A to '1'. Again, Everything else is set to 'X' or '0', depending on 
--      other requirements.

--      ADDI is implemented using the LZE and IR, added with A. IM_MUX1 is set to '1',
--      IM_MUX2 to 'X', ALU_OP to "010", DATA_MUX to "10", CLR_A to '0', and LD_A to '1'.
--      Everything else is set to 'X' or '0', depending on other requirements.

-- 2. The data-path has a maximum reliable operating speed (Clk). What determines this speed? 
--    (i.e. how would you estimate the data-path circuit clock)? 

-- Ans:	You would estimate the data-path clock based off of the memory clock (mClk). 
--		The data-path clock needs to have a frequency half as much as mClk (and in  
--      turn, the period is twice as long). Clocks should have a period >= 10 ns.

-- 3. What is a reliable limit for your data-path clock?

-- Ans: As mentioned in the previous question, a good measure of datapath clock is 
--      based off of the mClk; since I will be using a 20 ns clock period for mClk, a
--		reliable (lower-limit) for the data-path clock would be 40 ns. 