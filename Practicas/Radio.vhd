--Librerias
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--Entidad
entity Radio is
    Port ( button : in STD_LOGIC_VECTOR (5 downto 0);
			  senal1: in std_logic;
			  display1,display2,display3 : out STD_LOGIC_VECTOR (6 downto 0);
			  punto :out std_logic);
end Radio;
--Arquitectura
architecture Behavioral of Radio is
function deco (bin : in integer range 0 to 9)
return std_logic_vector is
	variable seg : STD_LOGIC_VECTOR (6 downto 0);
	begin
		case bin is
		when 0 => seg:= "0000001";
		when 1 => seg:= "1001111";
		when 2 => seg:= "0010010";
		when 3 => seg:= "0000110";
		when 4 => seg:= "1001100";
		when 5 => seg:= "0100100";
		when 6 => seg:= "0100000";
		when 7 => seg:= "0001111";
		when 8 => seg:= "0000000";
		when 9 => seg:= "0001100";
		when others => seg:= "1111111";
		end case;
		return seg;
	end deco;
--Señales y variables
signal Cneg : STD_LOGIC_VECTOR (1 downto 0);
signal C : STD_LOGIC_VECTOR (1 downto 0);
signal cuenta: integer range 0 to 25000000;
signal cuenta1: integer range 0 to 250000;
signal num1,num2,num3: integer range 0 to 9;
signal unHz, dcHz: STD_LOGIC;

begin
--Eliminando el debounce (divisor de frecuencia baja)

process(senal1,cuenta,unHz)
	begin 
		if rising_edge(senal1) then
			if(cuenta=999999) then
				cuenta<=0;
				unHz<=not (unHz);
			else
				cuenta<=cuenta+1;
			end if;
		end if;
	end process;
--Seleccionador de push_button
process (num1,num2,num3,unHz)
begin
	if rising_edge (unHz) then
		if (button(0)='1') then
			num1<=9;
			num2<=6;
			num3<=2;
		elsif (button(1)='1') then
			num1<=1;
			num2<=2;
			num3<=3;
		elsif (button(2)='1') then
			num1<=6;
			num2<=6;
			num3<=6;
		elsif (button(3)='1') then
			num1<=3;
			num2<=1;
			num3<=3;
		elsif (button(4)='1') then
			num1<=9;
			num2<=9;
			num3<=9;
		elsif (button(5)='1') then
			num1<=2;
			num2<=4;
			num3<=6;
		end if;
	end if;
end process;
--Divisor de frecuencia alta		
process(senal1,cuenta1,dcHz)
	begin 
		if rising_edge(senal1) then
			if(cuenta1=249999) then
				cuenta1<=0;
				dcHz<=not (dcHz);
			else
				cuenta1<=cuenta1+1;
			end if;
		end if;
	end process;
--Display síncrono
process(C(0),dcHz)
	begin
		if rising_edge (dcHz) then
			C(0)<=not(C(0));
		end if;
	end process;
	Cneg(0)<=not(C(0));
	
	process(C(1),Cneg(0))
	begin
		if rising_edge (Cneg(0)) then
			C(1)<=not(C(1));
		end if;
end process;
Cneg(1)<=not(C(1));
--Decodificador/selector 7 segmentos
process (num1,num2,num3,C,dcHz)
begin
	if rising_edge(dcHz) then
		if (C="00") then
			display1<=deco(num1);
		elsif (C="01") then
			display2<=deco(num2);
		elsif (C="10") then
			display3<=deco(num3);
		end if;
	end if;
end process;
	
end Behavioral;
