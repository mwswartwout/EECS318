entity trafficLight is
	port ( 	clock : in bit;
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
		

		procedure changeState is begin
			case currentState is
				when s0 => currentState := s1; Ga <= '1'; Ya <= '0'; Ra <= '0'; Gb <= '0'; Yb <= '0'; Rb <= '1';	
				when s1 => currentState := s2;
				when s2 => currentState := s3;
				when s3 => currentState := s4;
				when s4 => currentState := s5;
				when s5 =>
					if Sb = '1' then Ga <= '0'; Ya <= '1'; currentState := s6; end if;
				when s6 => Ya <= '0'; Ra <= '1'; Rb <= '0'; Gb <= '1'; currentState := s7;
				when s7 => currentState := s8;
				when s8 => currentState := s9;
				when s9 => currentState := s10;
				when s10 => currentState := s11;
				when s11 =>
					if Sa = '1' and Sb = '0' then Gb <= '0'; Yb <= '1'; currentState := s12; end if;
				when s12 => Yb <= '0'; Rb <= '1'; Ra <= '0'; Ga <= '1'; currentState := s0;
			end case;
		end procedure;

	begin
		if clock = '1' then changeState; end if;
	end process;


end trafficLight_arch;

