library ieee;
use ieee.std_logic_1164.all;

entity mux8 is
	port(sel1: in std_logic_vector(2 downto 0);
		  inp1, inp2, inp3, inp4, inp5, inp6, inp7, inp8: in std_logic_vector(15 downto 0);
		  opt: out std_logic_vector(15 downto 0));
end entity;

architecture mux8_arch of mux8 is
begin
	process (sel1, inp1, inp2, inp3, inp4, inp5, inp6, inp7, inp8)
	begin
		case sel1 is
			when "000"=>
				opt <= inp1;
			when "001"=>
				opt <= inp2;
			when "010"=>
				opt <= inp3;
			when "011"=>
				opt <= inp4;
			when "100"=>
				opt <= inp5;
			when "101"=>
				opt <= inp6;
			when "110"=>
				opt <= inp7;
			when others=>
				opt <= inp8;
		end case;
	end process;
end architecture;