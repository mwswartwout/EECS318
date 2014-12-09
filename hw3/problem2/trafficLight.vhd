library ieee;
use ieee.std_logic_1164.all;

entity trafficLight is
	port ( 	clock : in std_logic;
		Sa : in bit;
		Sb : in bit;
		Ga : out bit;
		Ya : out bit;
		Ra : out bit;
		Gb : out bit;
		Yb : out bit;
		Rb : out bit);
end trafficLight;

architecture trafficLight_arch of trafficLight is

	type trafficLightState is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
	

	
begin
	process
		variable currentState : trafficLightState := s0;
		

		procedure changeState is 
		variable alreadyChanged : bit := '0';

		begin
			case currentState is
				when s0 => if alreadyChanged = '0' then currentState := s1; Ga <= '1'; Ya <= '0'; Ra <= '0'; Gb <= '0'; Yb <= '0'; Rb <= '1'; alreadyChanged := '1'; end if;
				when s1 => if alreadyChanged = '0' then currentState := s2; alreadyChanged := '1'; end if;
 				when s2 => if alreadyChanged = '0' then currentState := s3; alreadyChanged := '1'; end if;
				when s3 => if alreadyChanged = '0' then currentState := s4; alreadyChanged := '1'; end if;
				when s4 => if alreadyChanged = '0' then currentState := s5; alreadyChanged := '1'; end if;
				when s5 =>
					if Sb = '1' and alreadyChanged = '0' then Ga <= '0'; Ya <= '1'; currentState := s6; alreadyChanged := '1'; end if;
				when s6 => if alreadyChanged = '0' then Ya <= '0'; Ra <= '1'; Rb <= '0'; Gb <= '1'; currentState := s7; alreadyChanged := '1'; end if;
				when s7 => if alreadyChanged = '0' then currentState := s8; alreadyChanged := '1'; end if;
				when s8 => if alreadyChanged = '0' then currentState := s9; alreadyChanged := '1'; end if;
				when s9 => if alreadyChanged = '0' then currentState := s10; alreadyChanged := '1'; end if;
				when s10 => if alreadyChanged = '0' then  currentState := s11; alreadyChanged := '1'; end if;
				when s11 =>
					if Sa = '1' and Sb = '0' and alreadyChanged = '0' then Gb <= '0'; Yb <= '1'; currentState := s12; alreadyChanged := '1'; end if;
				when s12 => if alreadyChanged = '0' then Yb <= '0'; Rb <= '1'; Ra <= '0'; Ga <= '1'; currentState := s0; alreadyChanged := '1'; end if;
			end case;
		end procedure;

	begin
		if (rising_edge(clock)) then changeState; end if;
		wait for 1 ns;
	end process;


end trafficLight_arch;

