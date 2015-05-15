LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

-- Program Counter (PC)
ENTITY pc IS

GENERIC(X: INTEGER := 1);  -- Integer used to add to Q (ADDER to MUX input)

PORT(
		CLR	: IN STD_LOGIC;	-- Asynchronous Clear
		CLK	: IN STD_LOGIC;	-- Clock)
		LD	: IN STD_LOGIC;	-- Load/Enable
		INC	: IN STD_LOGIC;	-- Input Selector
		D	: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input
		Q	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); -- Output
END pc;

ARCHITECTURE func OF pc IS
SIGNAL D0	: STD_LOGIC_VECTOR(31 DOWNTO 0); -- Output (Intermediate)
SIGNAL Q2   : STD_LOGIC_VECTOR(31 DOWNTO 0);

COMPONENT register32 
	PORT(
		D	: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input
		LD	: IN STD_LOGIC;	-- Load/Enable
		CLR	: IN STD_LOGIC;	-- Asynchronous Clear
		CLK	: IN STD_LOGIC;	-- Clock
		Q	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); -- Output
		
END COMPONENT;

BEGIN

Q <= Q2;

-- 2-to-1 Multiplexer with 'INC' signal as the select
		WITH INC SELECT 
		D0 <= (Q2 + 1) WHEN '1',
				D WHEN '0';
				
-- Port map to the 32-bit register component (register32)
	mapreg: register32 PORT MAP(D0, LD, CLR, CLK, Q2);
 				
END func;

 	

	
