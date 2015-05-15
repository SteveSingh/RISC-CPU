LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

-- 32-bit register
ENTITY register32 IS
PORT(
		D		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Input
		LD		: IN STD_LOGIC;	-- Load/Enable
		CLR		: IN STD_LOGIC;	-- Asynchronous Clear
		CLK		: IN STD_LOGIC;	-- Clock
		Q		: BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0)); -- Output
END register32;

ARCHITECTURE descript32 OF register32 IS
BEGIN
PROCESS(CLR, LD, CLK, D)
	BEGIN
		IF CLR = '1' THEN 
			Q <= (OTHERS => '0');
		
		ELSIF ((LD = '1') AND (RISING_EDGE(CLK))) THEN 
			Q <= D;
				
		END IF;
END PROCESS;
END descript32;