library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port(flag_change: in std_logic;
		  opr1, opr2: in std_logic_vector(15 downto 0):=(others=>'0');
		  func: in std_logic_vector(1 downto 0):=(others=>'1');
		  cf, zf: out std_logic:=('1');
		  alu_out: out std_logic_vector(15 downto 0):=(others=>'0'));
end entity;

architecture alu_arch of alu is
begin
	process(opr1, opr2, func)
	variable o, a, b: std_logic_vector(15 downto 0):=(others=>'0');
	variable c, m: std_logic:='1';
	begin
		a := opr1;
		b := opr2;
		case func is
			when "01" =>
				m := a(15) xor b(15);
				c := a(15) xor b(15);
				o(15) := a(15);
				for i in 0 to 14 loop
					o(i) := a(i) xor (b(i) xor m) xor c;
					c := (a(i) and (b(i) xor m)) or (((b(i) xor m) or a(i)) and c);
				end loop;
			when "10" =>
				o(15 downto 0) := a(15 downto 0) nand b(15 downto 0);
			when "00" =>
				o(15 downto 0) := a(15 downto 0) xor b(15 downto 0);
			when others =>
				null;
		end case;
		alu_out <= o;
		if (flag_change = '1') then
			cf <= c;
			if (o = "0000000000000000") then
				zf <= '1';
			else
				zf <= '0';
			end if;
		else
			null;
		end if;
	end process;
end architecture alu_arch;