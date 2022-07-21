library ieee;
use ieee.std_logic_1164.all;
library work;
use work.all;

entity RF is
	port(CLK: in std_logic; RF_A1, RF_A2, RF_A3: in std_logic_vector(2 downto 0);
		  RF_D3: in std_logic_vector(15 downto 0); EN: in std_logic;
		  RF_D1, RF_D2: out std_logic_vector(15 downto 0));
end entity;

architecture RF_arch of RF is
	signal r0, r1, r2, r3, r4, r5, r6, r7: std_logic_vector(15 downto 0):=("0000000000000000");
	
	component mux8 is
		port(sel1: in std_logic_vector(2 downto 0); inp1, inp2, inp3, inp4, inp5, inp6, inp7, inp8: in std_logic_vector(15 downto 0); opt: out std_logic_vector(15 downto 0));
	end component;
	
begin
	m0: mux8
		port map(sel1=>RF_A1, inp1=>r0, inp2=>r1, inp3=>r2, inp4=>r3, inp5=>r4, inp6=>r5, inp7=>r6, inp8=>r7, opt=>RF_D1);
	m1: mux8
		port map(sel1=>RF_A2, inp1=>r0, inp2=>r1, inp3=>r2, inp4=>r3, inp5=>r4, inp6=>r5, inp7=>r6, inp8=>r7, opt=>RF_D2);
	process (RF_A3, CLK)
	begin
		if (CLK'event and CLK = '1') then
			if EN = '1' then
				case RF_A3 is
					when "000"=>
								r0 <= RF_D3;
					when "001"=>
								r1 <= RF_D3;
					when "010"=>
								r2 <= RF_D3;
					when "011"=>
								r3 <= RF_D3;
					when "100"=>
								r4 <= RF_D3;
					when "101"=>
								r5 <= RF_D3;
					when "110"=>
								r6 <= RF_D3;
					when others=>
								r7 <= RF_D3;
				end case;
			end if;
		end if;
	end process;
end architecture;