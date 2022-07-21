library ieee;
use ieee.std_logic_1164.all;
entity DUT is
   port(input_vector: in std_logic;
       	output_vector: out std_logic);
end entity;

architecture DutWrap of DUT is
   component Top_Level_Entity is
		port(clock: in std_logic; Y: out std_logic);
	end component Top_Level_Entity;
begin
   TLE: Top_Level_Entity 
			port map (clock => input_vector, Y => output_vector);
end DutWrap;