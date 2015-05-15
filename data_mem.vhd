LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY data_mem IS

	GENERIC(
		ADDRESS_WIDTH	: INTEGER := 8;
		DATA_WIDTH		: INTEGER := 32
	);

	PORT(
		clk			: IN  STD_LOGIC;
		data_in		: IN  STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
		addr		: IN  UNSIGNED (ADDRESS_WIDTH - 1 DOWNTO 0);
		en			: IN  STD_LOGIC;
		wen			: IN  STD_LOGIC;
		data_out	: OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
	);
END data_mem;

ARCHITECTURE Description OF data_mem IS

TYPE mem IS ARRAY(0 TO 2 ** ADDRESS_WIDTH - 1) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
SIGNAL mem_array : mem;

BEGIN

	PROCESS (clk)
	BEGIN
		IF (clk'EVENT AND clk = '0' AND ((en = '1') OR (en = '1' AND wen = '0'))) THEN
			IF (wen = '1') THEN
			    mem_array(to_integer(unsigned(addr))) <= data_in;
			END IF;
			data_out <= mem_array(TO_INTEGER(UNSIGNED(addr)));
		END IF;
	END PROCESS;
	
END Description;
