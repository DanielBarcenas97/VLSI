library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--Se declaran las entradas necesarias
entity generico is
 port(
	clk1: in std_logic;
	Pini1 : in  STD_LOGIC;
	Pfin1 : in  STD_LOGIC;
	Inc1 : in  STD_LOGIC;
	Dec1 : in  STD_LOGIC;
	control1 : inout  STD_LOGIC;
	Pini2 : in  STD_LOGIC;
	Pfin2 : in  STD_LOGIC;
	Inc2 : in  STD_LOGIC;
	Dec2 : in  STD_LOGIC;
	control2 : inout  STD_LOGIC;
	cambio: in std_logic;
	cambio1a: in std_logic
	);
end generico;
--Se realizo la asigancion de señales
architecture Behavorial of generico is
	signal reloj : STD_LOGIC;
	signal ancho1 : STD_LOGIC_VECTOR (7 downto 0);
	signal ancho2 : std_logic_vector (7 downto 0);
	signal ancho3 : std_logic_vector (7 downto 0);
	signal controla: std_logic;
	signal controlb: std_logic;
	signal controlc: std_logic;
	signal pini: std_logic;
	signal pfin: std_logic;
	signal inc: std_logic;
	signal dec: std_logic;
	signal cambioa: std_logic:= '0';
	signal cambiob: std_logic:= '0';
	signal cambioa1: std_logic:= '0';
	--instacia de los archivos
	component divisor is
		Port ( clk : in std_logic;
					div_clk : out std_logic);
	end component;
	
	component PWM is
		Port( Reloj:in std_logic;
				D: in std_logic_vector(7 downto 0);
				S: out std_logic);
	end component;			
	
	component Servomotor is
		port(clk : in  STD_LOGIC;
			  Pini : in  STD_LOGIC;
			  Pfin : in  STD_LOGIC;
			  Inc : in  STD_LOGIC;
			  Dec : in  STD_LOGIC;
			  control : inout  STD_LOGIC;
			  ancho: out std_logic_vector(7 downto 0)
			  );
	end component;
begin
U1: divisor port map(clk1, reloj);
U2: PWM port map (reloj, ancho1, controla);
U3: PWM port map (reloj, ancho2, controlb);
U3_1: PWM port map (reloj,ancho3,controlc);
control1<=controla;
control2<=controlb;
U4: Servomotor port map (reloj,Pini1,Pfin1,Inc1,Dec1,control1,ancho1);
--Proceso para el cambio de lo solicitado
cambio1: process (pini2,pfin2,Inc2,Dec2,cambio,cambio1a)
   begin
	if rising_edge(cambio) then
		cambioa<='1';
	end if;
	cambiob<=cambioa;
	if cambiob='0' then
	pini<=pfin1;
	pfin<=pini1;
	inc<=Dec1;
	dec<=Inc1;
	--cambioa<='0';
	elsif cambiob='1' then 
	pini<=pini2;
   pfin<=pfin2;
   inc<=Inc2;
   dec<=Dec2;
	--cambioa<='1';
	end if;
end process;
U6: Servomotor port map (reloj,pini,pfin,inc,dec,control2,ancho2);
end Behavorial;