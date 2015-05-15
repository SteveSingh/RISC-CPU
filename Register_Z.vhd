LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;


-- 1-bit register
ENTITY Register_Z IS
PORT(
		D		: IN STD_LOGIC; -- Input
		LD		: IN STD_LOGIC;	-- Load/Enable
		CLR		: IN STD_LOGIC;	-- Asynchronous Clear
		CLK		: IN STD_LOGIC;	-- Clock
		Q		: OUT STD_LOGIC); -- Output
END Register_Z;

ARCHITECTURE descript1 OF Register_Z IS
BEGIN
PROCESS(CLR, LD, CLK, D)
	BEGIN
		IF CLR = '1' THEN 
			Q <= '0';
				
		ELSIF ((LD = '1') AND (RISING_EDGE(CLK))) THEN 
			Q <= D;
		END IF;
END PROCESS;
END descript1;

