LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
USE ieee.std_logic_arith.ALL; 
USE ieee.std_logic_unsigned.ALL; 

ENTITY reset_circuit IS 
PORT 
( 
  Reset 		: IN STD_LOGIC; 
  Clk 			: IN STD_LOGIC; 
  Enable_PD 	: OUT STD_LOGIC; 
  Clr_PC 		: OUT STD_LOGIC 
);
END reset_circuit;

ARCHITECTURE description OF reset_circuit IS 

SIGNAL count 		: INTEGER := 0;
SIGNAL hold			: STD_LOGIC:= '0';
SIGNAL Enable_PD_i	: STD_LOGIC := '1';
SIGNAL Clr_PC_i		: STD_LOGIC := '0';

BEGIN

Enable_PD <= Enable_PD_i;
Clr_PC <= Clr_PC_i;


PROCESS(Clk, count)
BEGIN

IF (RISING_EDGE(Clk)) THEN

IF (Reset = '0' AND hold <= '0') THEN

Enable_PD_i <= '1';
Clr_PC_i <= '0';

	ELSIF (Reset = '1') THEN

	Enable_PD_i <= '0';
	Clr_PC_i <= '1';
	hold <= '1';
	count <= 0;

		ELSIF(Reset = '0' AND hold <= '1' AND count <= 3) THEN
			
			IF (RISING_EDGE(Clk)) THEN
			
			Enable_PD_i <= '0';
			Clr_PC_i <= '1';
			count <= count +1;
			
			END IF;
	
	END IF;

END IF;

IF (count = 3) THEN

count <= 0;
hold <= '0';

END IF;


END PROCESS;

END description; 