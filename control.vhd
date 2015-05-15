library ieee;
use ieee.std_logic_1164.ALL;

ENTITY control IS
PORT(
	clk, mclk : IN STD_LOGIC;
	enable : IN STD_LOGIC;
	statusC, statusZ : IN STD_LOGIC;
	INST : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	PC_Mux : OUT STD_LOGIC;
	IM_MUX1, REG_Mux : OUT STD_LOGIC;
	IM_MUX2, DATA_Mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	ALU_op : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	inc_PC, ld_PC : OUT STD_LOGIC;
	clr_IR : OUT STD_LOGIC;
	ld_IR : OUT STD_LOGIC;
	clr_A, clr_B, clr_C, clr_Z : OUT STD_LOGIC;
	ld_A, ld_B, ld_C, ld_Z : OUT STD_LOGIC;
	T : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	wen, en : OUT STD_LOGIC);
END control;

ARCHITECTURE description OF control IS
	TYPE STATETYPE IS (state_0, state_1, state_2);
	SIGNAL present_state: STATETYPE;
BEGIN
	
	-- OPERATION DECODER --
	PROCESS (present_state, INST, statusC, statusZ, enable)
	BEGIN
			if (present_state = state_0 and enable = '1') then 
				clr_IR <= '0';ld_IR <= '1';
				ld_pc <= '0';inc_PC <= '0';
				clr_A <= '0';ld_A <= '0';
				clr_B <= '0';ld_B <= '0';
				clr_C <= '0';ld_C <= '0';
				clr_Z <= '0';ld_Z <= '0';
				ALU_op <= "000";PC_Mux <= '0';
				REG_Mux <= '0';DATA_Mux <= "00";
				IM_MUX1 <= '0';IM_MUX2 <= "00";
				
--				clr_IR <= '0';ld_IR <= '1';
--				ld_pc <= '1';inc_PC <= '1';
--				clr_A <= '0';ld_A <= '0';
--				clr_B <= '0';ld_B <= '0';
--				clr_C <= '0';ld_C <= '0';
--				clr_Z <= '0';ld_Z <= '0';
--				ALU_op <= "000";PC_Mux <= '1';
--				REG_Mux <= '0';DATA_Mux <= "00";
--				IM_MUX1 <= '0';IM_MUX2 <= "00";
				
			elsif (present_state = state_1 and enable = '1') then 
				clr_IR <= '0';ld_IR <= '0';
				ld_pc <= '1';inc_PC <= '1';
				clr_A <= '0';ld_A <= '0';
				clr_B <= '0';ld_B <= '0';
				clr_C <= '0';ld_C <= '0';
				clr_Z <= '0';ld_Z <= '0';
				ALU_op <= "000";PC_Mux <= '1';
				REG_Mux <= '0';DATA_Mux <= "00";
				IM_MUX1 <= '0';IM_MUX2 <= "00";
				if (INST(31 DOWNTO 28) ="0000") then
						clr_IR <= '0';ld_IR <= '0';
						ld_pc <= '1';inc_PC <= '1';
						clr_A <= '0';ld_A <= '1';
						clr_B <= '0';ld_B <= '0';
						clr_C <= '0';ld_C <= '0';
						clr_Z <= '0';ld_Z <= '0';
						ALU_op <= "000";PC_Mux <= '1';
						REG_Mux <= '0';DATA_Mux <= "00";
						IM_MUX1 <= '0';IM_MUX2 <= "00";
					elsif (INST(31 DOWNTO 28) ="0001") then
						clr_IR <= '0';ld_IR <= '0';
						ld_pc <= '1';inc_PC <= '1';
						clr_A <= '0';ld_A <= '0';
						clr_B <= '0';ld_B <= '1';
						clr_C <= '0';ld_C <= '0';
						clr_Z <= '0';ld_Z <= '0';
						ALU_op <= "000";PC_Mux <= '1';
						REG_Mux <= '0';DATA_Mux <= "00";
						IM_MUX1 <= '0';IM_MUX2 <= "00";
					elsif (INST(31 DOWNTO 28) ="0010") then
						clr_IR <= '0';ld_IR <= '0';
						ld_pc <= '1';inc_PC <= '1';
						clr_A <= '0';ld_A <= '0';
						clr_B <= '0';ld_B <= '0';
						clr_C <= '0';ld_C <= '0';
						clr_Z <= '0';ld_Z <= '0';
						ALU_op <= "000";PC_Mux <= '1';
						REG_Mux <= '0';DATA_Mux <= "00";
						IM_MUX1 <= '0';IM_MUX2 <= "00";
					elsif (INST(31 DOWNTO 28) ="0011") then
						clr_IR <= '0';ld_IR <= '0';
						ld_pc <= '1';inc_PC <= '1';
						clr_A <= '0';ld_A <= '0';
						clr_B <= '0';ld_B <= '0';
						clr_C <= '0';ld_C <= '0';
						clr_Z <= '0';ld_Z <= '0';
						ALU_op <= "000";PC_Mux <= '1';
						REG_Mux <= '1';DATA_Mux <= "00";
						IM_MUX1 <= '0';IM_MUX2 <= "00";
					else
						clr_IR <= '0';ld_IR <= '0';
						ld_pc <= '1';inc_PC <= '1';
						clr_A <= '0';ld_A <= '0';
						clr_B <= '0';ld_B <= '0';
						clr_C <= '0';ld_C <= '0';
						clr_Z <= '0';ld_Z <= '0';
						ALU_op <= "000";PC_Mux <= '1';
						REG_Mux <= '0';DATA_Mux <= "00";
						IM_MUX1 <= '0';	IM_MUX2 <= "00";
				end if;
			elsif (present_state = state_2 and enable = '1') then
				if (INST(31 DOWNTO 28) = "0111") then
						if (INST (27 DOWNTO 24)="0000") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '1';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '1';
								clr_Z <= '0';ld_Z <= '1';
								ALU_op <= "010";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "10";
								IM_MUX1 <= '0';IM_MUX2 <= "00";
							elsif (INST (27 DOWNTO 24)="0001") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '1';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '1';
								clr_Z <= '0';ld_Z <= '1';
								ALU_op <= "010";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "10";
								IM_MUX1 <= '0';IM_MUX2 <= "01";
							elsif (INST (27 DOWNTO 24)="0010") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '1';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '1';
								clr_Z <= '0';ld_Z <= '1';
								ALU_op <= "110";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "10";
								IM_MUX1 <= '0';IM_MUX2 <= "00";
							elsif (INST (27 DOWNTO 24)="0011") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '1';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '1';
								clr_Z <= '0';ld_Z <= '1';
								ALU_op <= "010";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "10";
								IM_MUX1 <= '0';IM_MUX2 <= "10";
							elsif (INST (27 DOWNTO 24)="0100") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '1';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '1';
								clr_Z <= '0';ld_Z <= '1';
								ALU_op <= "100";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "10";
								IM_MUX1 <= '0';IM_MUX2 <= "00";
							elsif (INST (27 DOWNTO 24)="0101") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '1';ld_A <= '0';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '0';
								clr_Z <= '0';ld_Z <= '0';
								ALU_op <= "000";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "00";
								IM_MUX1 <= '0';IM_MUX2 <= "00";
							elsif (INST (27 DOWNTO 24)="0110") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '0';
								clr_B <= '1';ld_B <= '0';
								clr_C <= '0';ld_C <= '0';
								clr_Z <= '0';ld_Z <= '0';
								ALU_op <= "000";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "00";
								IM_MUX1 <= '0';IM_MUX2 <= "00";
							elsif (INST (27 DOWNTO 24)="0111") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '0';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '1';ld_C <= '0';
								clr_Z <= '0';ld_Z <= '0';
								ALU_op <= "000";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "00";
								IM_MUX1 <= '0';IM_MUX2 <= "00";
							elsif (INST (27 DOWNTO 24)="1000") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '0';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '0';
								clr_Z <= '1';ld_Z <= '0';
								ALU_op <= "000";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "00";
								IM_MUX1 <= '0';IM_MUX2 <= "00";
							elsif (INST (27 DOWNTO 24)="1001") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '0';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '1';
								clr_Z <= '0';ld_Z <= '0';
								ALU_op <= "111";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "00";
								IM_MUX1 <= '0';IM_MUX2 <= "00";
							elsif (INST (27 DOWNTO 24)="1010") then
								if (statusZ = '1') then
									clr_IR <= '0';ld_IR <= '0';
									ld_pc <= '1';inc_PC <= '1';
									clr_A <= '0';ld_A <= '0';
									clr_B <= '0';ld_B <= '0';
									clr_C <= '0';ld_C <= '0';
									clr_Z <= '0';ld_Z <= '0';
									ALU_op <= "000";PC_Mux <= '1';
									REG_Mux <= '0';DATA_Mux <= "00";
									IM_MUX1 <= '0';IM_MUX2 <= "00";
								end if;
							elsif (INST (27 DOWNTO 24)="1011") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '1';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '1';
								clr_Z <= '0';ld_Z <= '1';
								ALU_op <= "000";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "10";
								IM_MUX1 <= '0';IM_MUX2 <= "00";
							elsif (INST (27 DOWNTO 24)="1100") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '0';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '1';
								clr_Z <= '0';ld_Z <= '1';
								ALU_op <= "011";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "00";
								IM_MUX1 <= '0';IM_MUX2 <= "00";
							elsif (INST (27 DOWNTO 24)="1101") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '1';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '1';
								clr_Z <= '0';ld_Z <= '1';
								ALU_op <= "001";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "10";
								IM_MUX1 <= '0';IM_MUX2 <= "01";
							elsif (INST (27 DOWNTO 24)="1110") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '1';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '1';
								clr_Z <= '0';ld_Z <= '1';
								ALU_op <= "110";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "10";
								IM_MUX1 <= '0';IM_MUX2 <= "10";
							elsif (INST (27 DOWNTO 24)="1111") then
								clr_IR <= '0';ld_IR <= '0';
								ld_pc <= '0';inc_PC <= '0';
								clr_A <= '0';ld_A <= '1';
								clr_B <= '0';ld_B <= '0';
								clr_C <= '0';ld_C <= '1';
								clr_Z <= '0';ld_Z <= '1';
								ALU_op <= "101";PC_Mux <= '0';
								REG_Mux <= '0';DATA_Mux <= "10";
								IM_MUX1 <= '0';IM_MUX2 <= "00";
						end if;
					elsif (INST(31 DOWNTO 28) = "1001") then
						clr_IR <= '0';ld_IR <= '0';
						ld_pc <= '0';inc_PC <= '0';
						clr_A <= '0';ld_A <= '1';
						clr_B <= '0';ld_B <= '0';
						clr_C <= '0';ld_C <= '0';
						clr_Z <= '0';ld_Z <= '0';
						ALU_op <= "000";PC_Mux <= '0';
						REG_Mux <= '0';DATA_Mux <= "01";
						IM_MUX1 <= '0';IM_MUX2 <= "00";
					elsif (INST(31 DOWNTO 28) = "1010") then
						clr_IR <= '0';ld_IR <= '0';
						ld_pc <= '0';inc_PC <= '0';
						clr_A <= '0';ld_A <= '0';
						clr_B <= '0';ld_B <= '1';
						clr_C <= '0';ld_C <= '0';
						clr_Z <= '0';ld_Z <= '0';
						ALU_op <= "000";PC_Mux <= '0';
						REG_Mux <= '0';DATA_Mux <= "01";
						IM_MUX1 <= '0';IM_MUX2 <= "00";
					elsif (INST(31 DOWNTO 28) = "0100") then
						clr_IR <= '0';ld_IR <= '0';
						ld_pc <= '0';inc_PC <= '0';
						clr_A <= '0';ld_A <= '1';
						clr_B <= '1';ld_B <= '0';
						clr_C <= '0';ld_C <= '1';
						clr_Z <= '0';ld_Z <= '1';
						ALU_op <= "010";PC_Mux <= '0';
						REG_Mux <= '0';DATA_Mux <= "10";
						IM_MUX1 <= '1';IM_MUX2 <= "00";
					elsif (INST(31 DOWNTO 28) = "0101") then
						clr_IR <= '0';ld_IR <= '0';
						ld_pc <= '1';inc_PC <= '0';
						clr_A <= '0';ld_A <= '0';
						clr_B <= '0';ld_B <= '0';
						clr_C <= '0';ld_C <= '0';
						clr_Z <= '0';ld_Z <= '0';
						ALU_op <= "000";PC_Mux <= '0';
						REG_Mux <= '0';DATA_Mux <= "00";
						IM_MUX1 <= '0';IM_MUX2 <= "00";
					elsif (INST(31 DOWNTO 28) = "0110") then
						if (statusZ = '1') then
							clr_IR <= '0';ld_IR <= '0';
							ld_pc <= '1';inc_PC <= '0';
							clr_A <= '0';ld_A <= '0';
							clr_B <= '0';ld_B <= '0';
							clr_C <= '0';ld_C <= '0';
							clr_Z <= '0';ld_Z <= '0';
							ALU_op <= "000";PC_Mux <= '0';
							REG_Mux <= '0';DATA_Mux <= "00";
							IM_MUX1 <= '0';IM_MUX2 <= "00";
						end if;
					elsif (INST(31 DOWNTO 28) = "1000") then
						if (statusC = '1') then
							clr_IR <= '0';ld_IR <= '0';
							ld_pc <= '1';inc_PC <= '0';
							clr_A <= '0';ld_A <= '0';
							clr_B <= '0';ld_B <= '0';
							clr_C <= '0';ld_C <= '0';
							clr_Z <= '0';ld_Z <= '0';
							ALU_op <= "000";PC_Mux <= '0';
							REG_Mux <= '0';DATA_Mux <= "00";
							IM_MUX1 <= '0';IM_MUX2 <= "00";
						end if;					
					else
						clr_IR <= '0';ld_IR <= '0';
						ld_pc <= '0';inc_PC <= '0';
						clr_A <= '0';ld_A <= '0';
						clr_B <= '0';ld_B <= '0';
						clr_C <= '0';ld_C <= '0';
						clr_Z <= '0';ld_Z <= '0';
						ALU_op <= "000";PC_Mux <= '0';
						REG_Mux <= '0';DATA_Mux <= "00";
						IM_MUX1 <= '0';IM_MUX2 <= "00";					
				end if;
		elsif (enable = '0') then
			clr_IR <= '0';ld_IR <= '0';
			ld_pc <= '0';inc_PC <= '0';
			clr_A <= '0';ld_A <= '0';
			clr_B <= '0';ld_B <= '0';
			clr_C <= '0';ld_C <= '0';
			clr_Z <= '0';ld_Z <= '0';
			ALU_op <= "000";PC_Mux <= '0';
			REG_Mux <= '0';DATA_Mux <= "00";
			IM_MUX1 <= '0';IM_MUX2 <= "00";
		end if;
	END process;
	
	-- STATE MACHINE --
	
	PROCESS (clk, enable)
	BEGIN
		if (enable = '1') then
			if (clk'event and clk = '1') then
				if (present_state = state_0) then --State 1
						present_state <= state_1;
						T <= "010";
				elsif (present_state = state_1) then -- State 2
						present_state <= state_2;
						T <= "100";
				elsif (present_state = state_2) then --State 3
						present_state <= state_0;
						T <= "001";
				end if;
			end if;
		elsif (enable = '0') then --Disable 'enable'
			present_state <= state_0;
			T <= "001";
		end if;
	END process;
	
	
	-- DATA MEMORY INSTRUCTIONS --
	
	PROCESS (mclk, clk, INST)
	BEGIN
		IF(mclk'EVENT and mclk = '0') THEN
			IF(present_state = state_1 AND clk = '0') THEN
				if (INST(31 DOWNTO 28) = "1001") then --LDA
						en <= '1';
						wen <= '0';
				elsif (INST(31 DOWNTO 28) = "1010") then --LDB
						en <= '1';
						wen <= '0';
				elsif (INST(31 DOWNTO 28) = "0010") then --STA
						en <= '1';
						wen <= '1';
				elsif (INST(31 DOWNTO 28) = "0011") then --STB
						en <= '1';
						wen <= '1';
				else 									 --Default Case
						en <= '0';
						wen <= '0';
				end if;
			--STB and STA and LDA and LDB are not being used.
			ELSIF(present_state = state_2 AND clk = '1') THEN 
				wen <= '0';
				en <= '0';
			--STB and STA and LDA and LDB are not being used.
			ELSIF(present_state = state_1) THEN
				wen <= '0';
				en <= '0';
			END IF;
		END IF;
	END process;
END description;