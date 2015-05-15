LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

-- Steve Singh
-- ID: 500389934

ENTITY ALU IS

PORT( a      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	  b      : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      op     : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      cout   : OUT STD_LOGIC;
      zero   : OUT STD_LOGIC);
END ALU;

ARCHITECTURE description OF ALU IS

-- Signals --
SIGNAL        Cin: STD_LOGIC;
SIGNAL          z: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL     enable: STD_LOGIC;
SIGNAL enable_sub: STD_LOGIC;
SIGNAL add_result: STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL sub_result: STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL   cout_add: STD_LOGIC;
SIGNAL   cout_sub: STD_LOGIC;
SIGNAL    result2: STD_LOGIC_VECTOR (31 DOWNTO 0);

-- Components --
COMPONENT c_l_adder IS
  PORT( enable	  : IN  std_logic;
        x_in      : IN  std_logic_vector(31 downto 0);
        y_in      : IN  std_logic_vector(31 downto 0);
        carry_in  : IN  std_logic; 
        sum       : OUT std_logic_vector(31 downto 0);
        carry_out : OUT std_logic);
END COMPONENT;


COMPONENT c_l_subber IS
  PORT( enable	  : IN  std_logic;
        x_in      : IN  std_logic_vector(31 downto 0);
        y_in      : IN  std_logic_vector(31 downto 0);
        carry_in  : IN  std_logic; 
        sum       : OUT std_logic_vector(31 downto 0);
        carry_out : OUT std_logic);
END COMPONENT;

BEGIN

z <= (OTHERS => '0');
result <= result2;

PROCESS (op, a, b)
BEGIN 
CASE op IS 

WHEN "000" => -- AND

result2 <= (a AND b);

IF (result2 = z) THEN
zero <= '1';
END IF;

WHEN "001" => -- OR

result2 <= (a OR b);

IF (result2 = z) THEN
zero <= '1';
END IF;

WHEN "010" => -- ADD

zero <= '0';
enable <= '1';
Cin <= '0';
result2 <= add_result;
cout <= cout_add;

IF (result2 = z) THEN
zero <= '1';
END IF;

WHEN "110" => -- SUBTRACT

zero <= '0';
Cin <= '1';
enable_sub <= '1';
result2 <= sub_result;
cout <= cout_sub;

IF (result2 = z) THEN
zero <= '1';
END IF;

WHEN "011" =>  -- SEQ

zero <= '0';                                                                                                                                                                                                                            

IF (A = B) THEN
	zero <= '1';
	result2 <= (OTHERS => '0');
END IF;
	
WHEN "111" => -- SCO

cout <= '1';

WHEN "100" => -- ROL

FOR i IN 1 to 31 LOOP
result2(i) <= a(i-1);
END LOOP;
result2(0) <= '0';

IF (result2 = z) THEN
zero <= '1';
END IF;

WHEN "101" => -- ROR

FOR i IN 0 TO 30 LOOP
result2(i) <= a(i+1);
END LOOP;
result2(7) <= '0'; 

IF (result2 = z) THEN
zero <= '1';
END IF;

WHEN OTHERS =>

result2 <= (OTHERS => '0');

IF (result2 = z) THEN
zero <= '1';
END IF;

END CASE;

END PROCESS;

------------------------ Add and Subtract port maps -------------------------
add: c_l_adder PORT MAP(enable, a, b, Cin, add_result, cout_add);
sub: c_l_subber PORT MAP(enable_sub, a, (NOT b), Cin, sub_result, cout_sub);
-----------------------------------------------------------------------------
	  
END description;
