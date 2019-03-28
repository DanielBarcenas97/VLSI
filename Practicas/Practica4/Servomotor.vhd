library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Servomotor is
    Port ( clk : in  STD_LOGIC;
			  Pini : in  STD_LOGIC;
			  Pfin : in  STD_LOGIC;
			  Inc : in  STD_LOGIC;
			  Dec : in  STD_LOGIC;
			  control : inout  STD_LOGIC;
			  ancho: out std_logic_vector(7 downto 0)
			  );
end Servomotor;

architecture Behavioral of Servomotor is
signal ancho1 : STD_LOGIC_VECTOR (7 downto 0) := X"0F";

begin
	process (clk, Pini, Pfin, Inc, Dec)
		variable valor : STD_LOGIC_VECTOR (7 downto 0) := X"0F";
		variable cuenta : integer range 0 to 1023 := 0;
		
	begin
		if clk='1' and clk'event then
			if cuenta>0 then
				cuenta := cuenta -1;
			else
				if Pini='1' then
					valor := X"0D";
				elsif Pfin='1' then
					valor := X"18";
				elsif Inc='1' and valor<X"18" then
					valor := valor + 1;
				elsif Dec='1' and valor>X"0D" then
					valor := valor -1;
				end if;
				cuenta := 1023;
				ancho1 <= valor;
				ancho<= ancho1;
			end if;
		 end if;
	 end process;
end Behavioral;