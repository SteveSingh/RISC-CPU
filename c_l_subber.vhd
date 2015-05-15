LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY c_l_subber IS
    PORT
        (
		 enable    :  IN   STD_LOGIC;
         x_in      :  IN   STD_LOGIC_VECTOR(31 DOWNTO 0);
         y_in      :  IN   STD_LOGIC_VECTOR(31 DOWNTO 0);
         carry_in  :  IN   STD_LOGIC;
         sum       :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
         carry_out :  OUT  STD_LOGIC
        );
        
END c_l_subber;

ARCHITECTURE behavioral OF c_l_subber IS

SIGNAL    h_sum              :    STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL    carry_generate     :    STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL    carry_propagate    :    STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL    carry_in_internal  :    STD_LOGIC_VECTOR(31 DOWNTO 1);

BEGIN
 
    h_sum <= x_in XOR y_in;
    carry_generate <= x_in AND y_in;
    carry_propagate <= x_in OR y_in;
    PROCESS (enable, carry_generate,carry_propagate,carry_in_internal)
    BEGIN
 
    IF (enable = '1') THEN carry_in_internal(1) <= carry_generate(0) OR (carry_propagate(0) AND carry_in);
        inst: FOR i IN 1 TO 30 LOOP
              carry_in_internal(i+1) <= carry_generate(i) OR (carry_propagate(i) AND carry_in_internal(i));
              END LOOP;
     END IF;
    carry_out <= carry_generate(31 ) OR (carry_propagate(31 ) AND carry_in_internal(31 ));
    END PROCESS; 

    sum(0) <= h_sum(0) XOR carry_in;
    sum(31 DOWNTO 1) <= h_sum(31 DOWNTO 1) XOR carry_in_internal(31 DOWNTO 1);
END behavioral;
