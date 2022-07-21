library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Top_Level_Entity is
	port(clock: in std_logic; Y: out std_logic);
end entity;

architecture control_unit of Top_Level_Entity is
	signal cuout: std_logic_vector(46 downto 0);
	signal cuin: std_logic_vector(9 downto 0);
	signal opcode: std_logic_vector(3 downto 0);
	signal sig_alu1, sig_alu2, sig_alu3, sig_t2_1, sig_t2_2, sig_rf_d3, sig_ir_4, sig_mem_a, sig_t1_2, sig_shifter: std_logic_vector(2 downto 0);
	signal sig_mem_dout, sig_pc_1, sig_pc_2, sig_t1_1, sig_ir_1, sig_ir_2, sig_func, CZ: std_logic_vector(1 downto 0);
	signal sig_ir_3, sig_mem_din, cf, zf, T2_0, T2_15, reset, sig_pc_inc: std_logic;
	type state is (init, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27, s28, s29);
	signal y_present,y_next: state:=init;
	
	component datapath is
		port(CLK: in std_logic; input: in std_logic_vector(46 downto 0); output: out std_logic_vector(9 downto 0));
	end component;
	
begin
	cuout(46)<=sig_pc_inc;
	cuout(45 downto 43)<=sig_alu1;
	cuout(42 downto 40)<=sig_alu2;
	cuout(39 downto 37)<=sig_alu3;
	cuout(36 downto 34)<=sig_t2_1;
	cuout(33 downto 31)<=sig_t2_2;
	cuout(30 downto 28)<=sig_rf_d3;
	cuout(27 downto 25)<=sig_mem_a;
	cuout(24 downto 22)<=sig_t1_2;
	cuout(21 downto 19)<=sig_shifter;
	cuout(18 downto 17)<=sig_mem_dout;
	cuout(16 downto 15)<=sig_pc_1;
	cuout(14 downto 13)<=sig_pc_2;
	cuout(12 downto 11)<=sig_t1_1;
	cuout(10 downto 9)<=sig_ir_1;
	cuout(8 downto 7)<=sig_ir_2;
	cuout(6 downto 4)<=sig_ir_4;
	cuout(3 downto 2)<=sig_func;
	cuout(1)<=sig_ir_3;
	cuout(0)<=sig_mem_din;
	opcode<=cuin(9 downto 6);
	CZ<=cuin(5 downto 4);
	cf<=cuin(3);
	zf<=cuin(2);
	T2_0<=cuin(1);
	T2_15<=cuin(0);
	Y<='0';
	
	dpth:datapath
		port map (CLK=>clock, input=>cuout, output=>cuin);
	
	clock_proc:process(clock,reset, y_present, opcode, CZ)
	begin
		if(clock='1' and clock' event) then
			if(reset='1') then
				if (y_present=init) then
					if (opcode="0001") then
						if (CZ="00") then
							y_present<=s1;
						elsif (CZ="01") then
							y_present<=s3;
						elsif (CZ="10") then
							y_present<=s3;
						else
							y_present<=s28;
						end if;
					elsif (opcode="0011") then
						y_present<=s7;
					elsif (opcode="0010") then
						if (CZ="00") then
							y_present<=s1;
						elsif (CZ="01") then
							y_present<=s3;
						elsif (CZ="10") then
							y_present<=s3;
						end if;
					elsif (opcode="0000") then
						y_present<=s12;
					elsif (opcode="0111") then
						y_present<=s16;
					elsif (opcode="0101") then
						y_present<=s13;
					elsif (opcode="1100") then
						y_present<=s8;
					elsif (opcode="1101") then
						y_present<=s8;
					elsif (opcode="1000") then
						y_present<=s24;
					elsif (opcode="1001") then
						y_present<=s22;
					elsif (opcode="1010") then
						y_present<=s20;
					elsif (opcode="1011") then
						y_present<=s18;
					end if;
				elsif(y_present=s1) then
					y_present<=s2;
				elsif(y_present=s3) then
					if ((cf and CZ(1))='1' or (zf and CZ(0))='1') then
						y_present<=s5;
					else
						y_present<=s4;
					end if;
				elsif(y_present=s5) then
					y_present<=s2;
				elsif(y_present=s7) then
					y_present<=s2;
				elsif(y_present=s8) then
					y_present<=s29;
				elsif(y_present=s9) then
					if (T2_15='0') then
						y_present<=s29;
					else
						y_present<=s4;
					end if;
				elsif(y_present=s10) then
					y_present<=s9;
				elsif(y_present=s11) then
					y_present<=s9;
				elsif(y_present=s12) then
					y_present<=s4;
				elsif(y_present=s13) then
					y_present<=s14;
				elsif(y_present=s14) then
					y_present<=s15;
				elsif(y_present=s16) then
					y_present<=s27;
				elsif(y_present=s18) then
					y_present<=s19;
				elsif(y_present=s19) then
					y_present<=s4;
				elsif(y_present=s20) then
					y_present<=s21;
				elsif(y_present=s22) then
					y_present<=s23;
				elsif(y_present=s23) then
					y_present<=s4;
				elsif(y_present=s24) then
					y_present<=s25;
				elsif(y_present=s25) then
					if (zf='0') then
						y_present<=s3;
					else
						y_present<=s26;
					end if;
				elsif(y_present=s27) then
					y_present<=s17;
				elsif(y_present=s28) then
					y_present<=s6;
				elsif(y_present=s29) then
					if (T2_0='0') then
						y_present<=s9;
					else
						if(opcode="1100") then
							y_present<=s10;
						elsif(opcode="1101") then
							y_present<=s11;
						end if;
					end if;
				else
					y_present<=init;
				end if;
			end if;
		end if;
	end process;
	
	signal_generation_proc:process(y_present, opcode)
	begin
		case y_present is
		
		when init=>
			sig_alu1<="000";
			sig_alu2<="000";
			sig_alu3<="000";
			sig_t2_1<="000";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="000";
			sig_mem_dout<="01";
			sig_pc_1<="00";
			sig_pc_2<="00";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="11";
			sig_ir_3<='1';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s1=>
			sig_alu1<="001";
			sig_alu2<="111";
			sig_alu3<="101";
			sig_t2_1<="001";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="000";
			sig_mem_dout<="00";
			sig_pc_1<="11";
			sig_pc_2<="10";
			sig_t1_1<="01";
			sig_ir_1<="11";
			sig_ir_2<="11";
			sig_ir_4<="001";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s2=>
			sig_alu1<="101";
			sig_alu2<="011";
			sig_alu3<="110";
			sig_t2_1<="000";
			sig_t2_2<="100";
			sig_rf_d3<="111";
			sig_mem_a<="001";
			sig_t1_2<="100";
			sig_shifter<="000";
			sig_mem_dout<="01";
			sig_pc_1<="00";
			sig_pc_2<="11";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			if (opcode = "0001" or opcode = "0011") then
				sig_func<="01";
			else
				sig_func<="10";
			end if;
			sig_ir_3<='1';
			sig_mem_din<='0';
			sig_pc_inc<='1';
			
		when s3=>
	      sig_alu1<="001";
			sig_alu2<="111";
			sig_alu3<="101";
			sig_t2_1<="000";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="000";
			sig_mem_dout<="00";
			sig_pc_1<="11";
			sig_pc_2<="10";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s4=>
			sig_alu1<="000";
			sig_alu2<="000";
			sig_alu3<="000";
			sig_t2_1<="000";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="011";
			sig_t1_2<="000";
			sig_shifter<="000";
			sig_mem_dout<="01";
			sig_pc_1<="00";
			sig_pc_2<="11";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="11";
			sig_ir_3<='1';
			sig_mem_din<='0';
			sig_pc_inc<='1';
			
		when s5=>
			sig_alu1<="000";
			sig_alu2<="000";
			sig_alu3<="000";
			sig_t2_1<="001";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="000";
			sig_mem_dout<="00";
			sig_pc_1<="00";
			sig_pc_2<="00";
			sig_t1_1<="01";
			sig_ir_1<="11";
			sig_ir_2<="11";
			sig_ir_4<="001";
			sig_func<="11";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='1';
			
		when s6=>
			sig_alu1<="101";
			sig_alu2<="101";
			sig_alu3<="110";
			sig_t2_1<="000";
			sig_t2_2<="101";
			sig_rf_d3<="111";
			sig_mem_a<="001";
			sig_t1_2<="100";
			sig_shifter<="111";
			sig_mem_dout<="01";
			sig_pc_1<="00";
			sig_pc_2<="11";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="01";
			sig_ir_3<='1';
			sig_mem_din<='0';
			sig_pc_inc<='1';
			
		when s7=>
			sig_alu1<="001";
			sig_alu2<="111";
			sig_alu3<="101";
			sig_t2_1<="011";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="011";
			sig_mem_dout<="00";
			sig_pc_1<="11";
			sig_pc_2<="10";
			sig_t1_1<="01";
			sig_ir_1<="11";
			sig_ir_2<="00";
			sig_ir_4<="101";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s8=>
			sig_alu1<="001";
			sig_alu2<="111";
			sig_alu3<="101";
			sig_t2_1<="011";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="101";
			sig_mem_dout<="00";
			sig_pc_1<="11";
			sig_pc_2<="10";
			sig_t1_1<="01";
			sig_ir_1<="11";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s9=>
			sig_alu1<="000";
			sig_alu2<="000";
			sig_alu3<="000";
			sig_t2_1<="011";
			sig_t2_2<="101";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="001";
			sig_mem_dout<="00";
			sig_pc_1<="00";
			sig_pc_2<="00";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="11";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s10=>
			sig_alu1<="101";
			sig_alu2<="111";
			sig_alu3<="111";
			sig_t2_1<="000";
			sig_t2_2<="111";
			sig_rf_d3<="110";
			sig_mem_a<="011";
			sig_t1_2<="101";
			sig_shifter<="000";
			sig_mem_dout<="11";
			sig_pc_1<="00";
			sig_pc_2<="00";
			sig_t1_1<="11";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s11=>
			sig_alu1<="101";
			sig_alu2<="111";
			sig_alu3<="111";
			sig_t2_1<="000";
			sig_t2_2<="110";
			sig_rf_d3<="000";
			sig_mem_a<="011";
			sig_t1_2<="101";
			sig_shifter<="000";
			sig_mem_dout<="00";
			sig_pc_1<="00";
			sig_pc_2<="00";
			sig_t1_1<="11";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='1';
			sig_pc_inc<='0';
			
		when s12=>
			sig_alu1<="001";
			sig_alu2<="111";
			sig_alu3<="101";
			sig_t2_1<="000";
			sig_t2_2<="000";
			sig_rf_d3<="101";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="010";
			sig_mem_dout<="00";
			sig_pc_1<="11";
			sig_pc_2<="10";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="011";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s13=>
			sig_alu1<="001";
			sig_alu2<="111";
			sig_alu3<="101";
			sig_t2_1<="011";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="011";
			sig_mem_dout<="00";
			sig_pc_1<="11";
			sig_pc_2<="10";
			sig_t1_1<="00";
			sig_ir_1<="10";
			sig_ir_2<="10";
			sig_ir_4<="000";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';

		when s14=>
			sig_alu1<="000";
			sig_alu2<="011";
			sig_alu3<="111";
			sig_t2_1<="000";
			sig_t2_2<="100";
			sig_rf_d3<="000";
			sig_mem_a<="001";
			sig_t1_2<="000";
			sig_shifter<="000";
			sig_mem_dout<="01";
			sig_pc_1<="00";
			sig_pc_2<="11";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="01";
			sig_ir_3<='1';
			sig_mem_din<='0';
			sig_pc_inc<='0';

		when s15=>
			sig_alu1<="000";
			sig_alu2<="000";
			sig_alu3<="000";
			sig_t2_1<="000";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="011";
			sig_t1_2<="101";
			sig_shifter<="000";
			sig_mem_dout<="00";
			sig_pc_1<="00";
			sig_pc_2<="00";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="11";
			sig_ir_3<='0';
			sig_mem_din<='1';
			sig_pc_inc<='0';
			
		when s16=>
			sig_alu1<="001";
			sig_alu2<="111";
			sig_alu3<="101";
			sig_t2_1<="011";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="011";
			sig_mem_dout<="00";
			sig_pc_1<="11";
			sig_pc_2<="10";
			sig_t1_1<="00";
			sig_ir_1<="10";
			sig_ir_2<="00";
			sig_ir_4<="101";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s17=>
			sig_alu1<="000";
			sig_alu2<="000";
			sig_alu3<="000";
			sig_t2_1<="000";
			sig_t2_2<="000";
			sig_rf_d3<="110";
			sig_mem_a<="011";
			sig_t1_2<="101";
			sig_shifter<="000";
			sig_mem_dout<="11";
			sig_pc_1<="00";
			sig_pc_2<="00";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="11";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s18=>
			sig_alu1<="000";
			sig_alu2<="000";
			sig_alu3<="000";
			sig_t2_1<="011";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="100";
			sig_mem_dout<="00";
			sig_pc_1<="00";
			sig_pc_2<="00";
			sig_t1_1<="01";
			sig_ir_1<="11";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="11";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s19=>
			sig_alu1<="101";
			sig_alu2<="011";
			sig_alu3<="101";
			sig_t2_1<="000";
			sig_t2_2<="100";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="110";
			sig_shifter<="000";
			sig_mem_dout<="00";
			sig_pc_1<="11";
			sig_pc_2<="00";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s20=>
			sig_alu1<="000";
			sig_alu2<="000";
			sig_alu3<="000";
			sig_t2_1<="000";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="111";
			sig_t1_2<="000";
			sig_shifter<="000";
			sig_mem_dout<="00";
			sig_pc_1<="00";
			sig_pc_2<="00";
			sig_t1_1<="01";
			sig_ir_1<="00";
			sig_ir_2<="11";
			sig_ir_4<="101";
			sig_func<="11";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s21=>
			sig_alu1<="001";
			sig_alu2<="111";
			sig_alu3<="110";
			sig_t2_1<="000";
			sig_t2_2<="000";
			sig_rf_d3<="111";
			sig_mem_a<="000";
			sig_t1_2<="110";
			sig_shifter<="000";
			sig_mem_dout<="01";
			sig_pc_1<="01";
			sig_pc_2<="10";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="01";
			sig_ir_3<='1';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s22=>
			sig_alu1<="001";
			sig_alu2<="111";
			sig_alu3<="111";
			sig_t2_1<="011";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="100";
			sig_mem_dout<="00";
			sig_pc_1<="00";
			sig_pc_2<="10";
			sig_t1_1<="11";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="101";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s23=>
			sig_alu1<="001";
			sig_alu2<="011";
			sig_alu3<="101";
			sig_t2_1<="000";
			sig_t2_2<="100";
			sig_rf_d3<="100";
			sig_mem_a<="000";
			sig_t1_2<="111";
			sig_shifter<="000";
			sig_mem_dout<="00";
			sig_pc_1<="11";
			sig_pc_2<="10";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s24=>
			sig_alu1<="001";
			sig_alu2<="101";
			sig_alu3<="111";
			sig_t2_1<="000";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="011";
			sig_mem_dout<="00";
			sig_pc_1<="00";
			sig_pc_2<="10";
			sig_t1_1<="11";
			sig_ir_1<="11";
			sig_ir_2<="11";
			sig_ir_4<="000";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s25=>
			sig_alu1<="011";
			sig_alu2<="001";
			sig_alu3<="000";
			sig_t2_1<="000";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="011";
			sig_t1_2<="101";
			sig_shifter<="000";
			sig_mem_dout<="00";
			sig_pc_1<="00";
			sig_pc_2<="00";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="00";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='1';
			
		when s26=>
			sig_alu1<="000";
			sig_alu2<="000";
			sig_alu3<="000";
			sig_t2_1<="000";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="110";
			sig_shifter<="000";
			sig_mem_dout<="01";
			sig_pc_1<="01";
			sig_pc_2<="00";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="11";
			sig_ir_3<='1';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s27=>
			sig_alu1<="011";
			sig_alu2<="011";
			sig_alu3<="111";
			sig_t2_1<="000";
			sig_t2_2<="100";
			sig_rf_d3<="000";
			sig_mem_a<="001";
			sig_t1_2<="000";
			sig_shifter<="000";
			sig_mem_dout<="01";
			sig_pc_1<="00";
			sig_pc_2<="11";
			sig_t1_1<="11";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="01";
			sig_ir_3<='1';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s28=>
			sig_alu1<="001";
			sig_alu2<="111";
			sig_alu3<="101";
			sig_t2_1<="001";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="000";
			sig_t1_2<="000";
			sig_shifter<="000";
			sig_mem_dout<="00";
			sig_pc_1<="11";
			sig_pc_2<="10";
			sig_t1_1<="01";
			sig_ir_1<="11";
			sig_ir_2<="11";
			sig_ir_4<="001";
			sig_func<="01";
			sig_ir_3<='0';
			sig_mem_din<='0';
			sig_pc_inc<='0';
			
		when s29=>
			sig_alu1<="101";
			sig_alu2<="000";
			sig_alu3<="000";
			sig_t2_1<="000";
			sig_t2_2<="000";
			sig_rf_d3<="000";
			sig_mem_a<="001";
			sig_t1_2<="000";
			sig_shifter<="000";
			sig_mem_dout<="01";
			sig_pc_1<="00";
			sig_pc_2<="11";
			sig_t1_1<="00";
			sig_ir_1<="00";
			sig_ir_2<="00";
			sig_ir_4<="000";
			sig_func<="11";
			sig_ir_3<='1';
			sig_pc_inc<='0';
		end case;
	end process;
	
	state_transition_proc:process(y_present, opcode, cf, zf, T2_0, CZ)
	begin
		case y_present is
		
		when init=>
			reset<='1';
			if (opcode="0001") then
				if (CZ="00") then
					y_next<=s1;
				elsif (CZ="01") then
					y_next<=s3;
				elsif (CZ="10") then
					y_next<=s3;
				else
					y_next<=s28;
				end if;
			elsif (opcode="0011") then
				y_next<=s7;
			elsif (opcode="0010") then
				if (CZ="00") then
					y_next<=s1;
				elsif (CZ="01") then
					y_next<=s3;
				elsif (CZ="10") then
					y_next<=s3;
				end if;
			elsif (opcode="0000") then
				y_next<=s12;
			elsif (opcode="0111") then
				y_next<=s16;
			elsif (opcode="0101") then
				y_next<=s13;
			elsif (opcode="1100") then
				y_next<=s8;
			elsif (opcode="1101") then
				y_next<=s8;
			elsif (opcode="1000") then
				y_next<=s24;
			elsif (opcode="1001") then
				y_next<=s22;
			elsif (opcode="1010") then
				y_next<=s20;
			elsif (opcode="1011") then
				y_next<=s18;
			else
			   reset<='1';
			end if;
			
		when s1=>
			y_next<=s2;
			reset<='1';
			
		when s2=>
			reset<='1';
			
		when s3=>
			if ((cf and CZ(1))='1' or (zf and CZ(0))='1') then
				y_next<=s5;
				reset<='1';
			else
				y_next<=s4;
				reset<='1';
			end if;
			
		when s4=>
			reset<='1';
			
		when s5=>
			y_next<=s2;
			reset<='1';
			
		when s6=>
			reset<='1';
			
		when s7=>
			y_next<=s2;
			reset<='1';
			
		when s8=>
			y_next<=s29;
			reset<='1';
			
		when s9=>
			y_next<=s29;
			reset<='1';
			
		when s10=>
			y_next<=s9;
			reset<='1';
			
		when s11=>
			y_next<=s9;
			reset<='1';
			
		when s12=>
			y_next<=s4;
			reset<='1';
			
		when s13=>
			y_next<=s14;
			reset<='1';

		when s14=>
			y_next<=s15;
			reset<='1';

		when s15=>
			reset<='1';
			
		when s16=>
			y_next<=s27;
			reset<='1';
			
		when s17=>
			reset<='1';
			
		when s18=>
			y_next<=s19;
			reset<='1';
			
		when s19=>
			y_next<=s4;
			reset<='1';
			
		when s20=>
			y_next<=s21;
			reset<='1';
			
		when s21=>
			reset<='1';
			
		when s22=>
			y_next<=s23;
			reset<='1';
			
		when s23=>
			y_next<=s4;
			reset<='1';
			
		when s24=>
			y_next<=s25;
			reset<='1';
			
		when s25=>
			if ((cf and CZ(1))='1' or (zf and CZ(0))='1') then
				y_next<=s26;
				reset<='1';
			else
				y_next<=s3;
				reset<='1';
			end if;
			
		when s26=>
			reset<='1';
			
		when s27=>
			y_next<=s17;
			reset<='1';
			
		when s28=>
			y_next<=s6;
			reset<='1';
			
		when s29=>
			if (T2_0='0') then
				y_next<=s9;
				reset<='1';
			else
				if (opcode="1100") then
					y_next<=s10;
					reset<='1';
				else
					y_next<=s11;
					reset<='1';
				end if;
			end if;
		when others=>
			reset<='1';
		end case;
	end process;
	
end architecture;