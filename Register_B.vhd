LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

-- 32-bit register
ENTITY Register_B IS
PORT(
		D		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input
		LD		: IN STD_LOGIC;	-- Load/Enable
		CLR		: IN STD_LOGIC;	-- Asynchronous Clear
		CLK		: IN STD_LOGIC;	-- Clock
		Q		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); -- Output
END Register_B;

ARCHITECTURE descript32 OF Register_B IS

SIGNAL Q2 : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN

Q <= Q2;

PROCESS(CLR, LD, CLK, D)
	BEGIN
		IF CLR = '1' THEN 
			Q2 <= (OTHERS => '0');
		
		ELSIF ((LD = '1') AND (RISING_EDGE(CLK))) THEN 
			Q2 <= D;
				
		END IF;
END PROCESS;
END descript32;