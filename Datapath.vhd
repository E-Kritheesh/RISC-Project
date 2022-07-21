library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
	port(CLK: in std_logic;
		  input: in std_logic_vector(46 downto 0);
		  output: out std_logic_vector(9 downto 0));
end entity;

architecture datapath_arch of datapath is
	signal IR, T1, RF_D1, RF_D2, RF_D3, MEM_Dout, MEM_Din, MEM_A: std_logic_vector(15 downto 0);
	signal RF_A1, RF_A2, RF_A3, sig_alu1, sig_alu2, sig_alu3, sig_t2_1, sig_t2_2, sig_rf_d3, sig_mem_a, sig_t1_2, sig_shifter, sig_ir_4: std_logic_vector(2 downto 0);
	signal sig_mem_dout, sig_pc_1, sig_pc_2, sig_t1_1, sig_ir_1, sig_ir_2: std_logic_vector(1 downto 0);
	signal sig_ir_3, sig_mem_din, cf, zf, sig_pc_inc: std_logic;
	signal PC, ALU_B, ALU_A, T2, S, ALU_OUT: std_logic_vector(15 downto 0):=(others=>'0');
	signal sig_func: std_logic_vector(1 downto 0):="11";
	signal k: std_logic_vector(15 downto 0):=("0000000000000001");
	
	component RF is
		port(CLK, EN: in std_logic; RF_A1, RF_A2, RF_A3: in std_logic_vector(2 downto 0); RF_D3: in std_logic_vector(15 downto 0); RF_D1, RF_D2: out  std_logic_vector(15 downto 0));
	end component;
	
	component alu is
		port(opr1, opr2: in std_logic_vector(15 downto 0); func: in std_logic_vector(1 downto 0); flag_change: in std_logic; cf, zf: out std_logic; alu_out: out std_logic_vector(15 downto 0));
	end component;
	
	component memory is
		generic(mem_a_width	: integer := 16; data_width: integer := 16);
		port(clock: in  std_logic; din: in  std_logic_vector(data_width - 1 DOWNTO 0); mem_a: in  std_logic_vector(mem_a_width - 1 DOWNTO 0); wr_en: in  std_logic; dout: OUT std_logic_vector(data_width - 1 DOWNTO 0));
	end component;
	
begin
	sig_pc_inc<=input(46);
	sig_alu1<=input(45 downto 43);
	sig_alu2<=input(42 downto 40);
	sig_alu3<=input(39 downto 37);
	sig_t2_1<=input(36 downto 34);
	sig_t2_2<=input(33 downto 31);
	sig_rf_d3<=input(30 downto 28);
	sig_mem_a<=input(27 downto 25);
	sig_t1_2<=input(24 downto 22);
	sig_shifter<=input(21 downto 19);
	sig_mem_dout<=input(18 downto 17);
	sig_pc_1<=input(16 downto 15);
	sig_pc_2<=input(14 downto 13);
	sig_t1_1<=input(12 downto 11);
	sig_ir_1<=input(10 downto 9);
	sig_ir_2<=input(8 downto 7);
	sig_ir_4<=input(6 downto 4);
	sig_func<=input(3 downto 2);
	sig_ir_3<=input(1);
	sig_mem_din<=input(0);
	output(9 downto 6)<=IR(15 downto 12);
	output(5 downto 4)<=IR(1 downto 0);
	output(3)<=cf;
	output(2)<=zf;
	output(1)<=T2(0);
	output(0)<=T2(15);
	
	RegisterFile:RF
		port map(CLK=>CLK, RF_A1=>RF_A1, RF_A2=>RF_A2, RF_A3=>RF_A3, RF_D3=>RF_D3, EN=>sig_rf_d3(2), RF_D1=>RF_D1, RF_D2=>RF_D2);
	MEM:memory
		port map(clock=>CLK, din=>MEM_Din, mem_a=>MEM_A, wr_en=>sig_mem_din, dout=>MEM_Dout);
	ALU1:alu
		port map(flag_change=>sig_pc_inc, opr1=>ALU_A, opr2=>ALU_B, func=>sig_func, cf=>cf, zf=>zf, alu_out=>ALU_OUT);
	process (sig_alu1, sig_t2_1, sig_t2_2, sig_alu2, sig_t1_2, sig_shifter, sig_mem_dout, sig_pc_2, sig_ir_1, sig_ir_2, sig_ir_4, sig_func, sig_ir_3, sig_mem_din)
		variable A, B: std_logic_vector(3 downto 0);
		variable C: std_logic_vector(3 downto 0):=("0001");
	begin
		
		case sig_alu1 is
		when "001" =>
			ALU_A<=PC;
		when "011" =>
			ALU_A<=RF_D1;
		when "101"=>
			ALU_A<=T1;
		when others =>
			NULL;
		end case;
		
		case sig_alu2 is
		when "001" =>
		 ALU_B<=RF_D2;
		when "011" =>
		 ALU_B<=T2;
		when "101" =>
		 ALU_B<=S;
		when "111" =>
		 ALU_B<=K;
		when others =>
			NULL;
		end case;
		
		case sig_mem_dout is
		when "01" =>
			IR<=MEM_Dout;
		when others =>
			NULL;
		end case;
		
		case sig_mem_din is
		when '1' =>
			MEM_Din<=RF_D2;
		when others =>
			NULL;
		end case;
		
		case sig_t2_2 is
		when "110" =>
			RF_A2<=T2(14 downto 12);
		when "111" =>
			RF_A3<=T2(14 downto 12);
		when others =>
			NULL;
		end case;
		
		case sig_pc_2 is
		when "10" =>
		 ALU_A<=PC;
		when others =>
			NULL;
		end case;
		 
		case sig_t1_2 is
		when "100" =>
		 ALU_A<=T1;
		when others =>
			NULL;
		end case;
		
		case sig_ir_1 is
		when "10" =>
		 RF_A1<=IR(8 downto 6);
		when "11" =>
		 RF_A1<=IR(11 downto 9);
		when others =>
			NULL;
		end case;
		
		case sig_ir_2 is
		when "10" =>
		 RF_A2<=IR(11 downto 9);
		when "11" =>
		 RF_A2<=IR(8 downto 6);
		when others =>
			NULL;
		end case;
		
		case sig_ir_3 is
		when '1' =>
		 IR<=MEM_Dout;
		when others =>
			NULL;
		end case;
		
		case sig_ir_4 is
		when "001" =>
		 RF_A3<=IR(5 downto 3);
		when "011" =>
		 RF_A3<=IR(11 downto 9);
		when "101" =>
		 RF_A3<=IR(8 downto 6);
		when others =>
			NULL;
		end case;
		
		case sig_shifter is
		when "111" =>                                   --1 bit left shift
			s(15 downto 15)<=T2(15 downto 15);
			s(14 downto 1)<=T2(13 downto 0);
			s(0)<='0';
		when "001" =>												--1 bit right shift
			s(11 downto 7)<="00000";
			s(6 downto 0)<=T2(7 downto 1);
			B:=T2(15 downto 12);
			A:=std_logic_vector(unsigned(B) + unsigned(C));
			s(15 downto 12)<=A;
		when "010" =>												--7 bit left shift
			s(15 downto 7)<=IR(8 downto 0);
			s(6 downto 0)<="0000000";
		when "011" =>           								--6 to 16 bit sign extender
			s(15)<=IR(5);
			s(14 downto 5)<="0000000000";
			s(4 downto 0)<=IR(4 downto 0);
		when "100" =>												--9 to 16 bit sign extender
			s(15)<=IR(8);
			s(14 downto 8)<="0000000";
			s(7 downto 0)<=IR(7 downto 0);
		when "101" =>												--9 to 16 bit unsigned extender
			s(15 downto 9)<="0000000";
			s(8 downto 0)<=IR(8 downto 0);
		when others =>
			NULL;
		end case;
	end process;
	
	ALU_proc: process(ALU_OUT, RF_D1, RF_D2, MEM_Dout, S, sig_alu3, sig_mem_a, sig_rf_d3, sig_pc_1, sig_t1_1)
	begin
		
		case sig_alu3 is
		when "100" =>
			MEM_A<=ALU_OUT;
		when "101" =>
			PC<=ALU_OUT;
		when "110" =>
			RF_D3<=ALU_OUT;
		when "111" =>
			T1<=ALU_OUT;
		when others =>
			NULL;
		end case;
		
		case sig_mem_a is
		when "001" =>
			MEM_A<=PC;
		when "011" =>
			MEM_A<=T1;
		when "101" =>
			MEM_A<=ALU_OUT;
		when "111" =>
			MEM_A<=RF_D1;
		when others =>
			NULL;
		end case;
		
		case sig_rf_d3 is
		when "100" =>
			RF_D3<=T1;
		when "101" =>
			RF_D3<=S;
		when "110" =>
			RF_D3<=MEM_Dout;
		when "111" =>
			RF_D3<=ALU_OUT;
		when others =>
			NULL;
		end case;
		
		case sig_pc_1 is
		when "01" =>
			PC<=T1;
		when "11" =>
			PC<=ALU_OUT;
		when others =>
			NULL;
		end case;
		
		case sig_t1_1 is
		when "01" =>
			T1<=RF_D1;
		when "11" =>
			T1<=ALU_OUT;
		when others =>
			NULL;
		end case;
		
		case sig_t2_1 is
		when "001" =>
			T2<=RF_D2;
		when "011" =>
			T2<=S;
		when others =>
			NULL;
		end case;
		
	end process;
end architecture;