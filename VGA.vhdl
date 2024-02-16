library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my.all;
ENTITY SYNC IS
PORT(
CLK: IN STD_LOGIC;
SW_1: IN STD_LOGIC;
SW_2: IN STD_LOGIC;
SW_3: IN STD_LOGIC;
HSYNC: OUT STD_LOGIC;
VSYNC: OUT STD_LOGIC;
R: OUT STD_LOGIC_VECTOR(7 downto 0);
G: OUT STD_LOGIC_VECTOR(7 downto 0);
B: OUT STD_LOGIC_VECTOR(7 downto 0)
);
END SYNC;
ARCHITECTURE MAIN OF SYNC IS
component pll is
port (
 pll_0_outclk0_clk : out std_logic; 
-- pll_0_outclk0.clk
 pll_0_refclk_clk : in std_logic := 
'0'; -- pll_0_refclk.clk
 pll_0_reset_reset : in std_logic := '0' 
-- pll_0_reset.reset
);
end component pll;
SIGNAL RGB1: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL RGB2: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL square1_x_axis,square2_X_axis: INTEGER 
RANGE 0 TO 1688 := 125; 
SIGNAL square1_y_axis,square2_y_axis: INTEGER 
RANGE 0 TO 1688 := 330; 
SIGNAL HPOS: INTEGER RANGE 0 TO 1688:=0;
SIGNAL VPOS: INTEGER RANGE 0 TO 1066:=0;
SIGNAL clk_in: STD_LOGIC;
SIGNAL reset: STD_LOGIC;
SIGNAL clk_out: STD_LOGIC;
 
BEGIN
plldrive: pll PORT MAP(clk_out, clk_in, reset);
square(HPOS,VPOS,square1_x_axis,square1_y_axis,RGB
1);
square(HPOS,VPOS,square2_x_axis,square2_y_axis,RGB
2);
PROCESS(CLK, SW_1, SW_2, SW_3)
 BEGIN
IF(CLK'EVENT AND CLK='1')THEN
if((HPOS >= 360) AND (HPOS <= 1640) AND 
(VPOS >= 41) AND (VPOS <= 1065)) then
R<="11111111";
G<="11111111";
B<="11111111";
HSYNC<='0';
VSYNC<='0';
end if;
--Front Porch controls
if((HPOS < 1688) AND (HPOS >= 1640)) then
R<="00000000";
G<="00000000";
B<="00000000";
HSYNC<='0';
end if;
if((VPOS >= 1066) AND (VPOS < 1065)) then
R<="00000000";
G<="00000000";
B<="00000000";
VSYNC<='0';
end if;
--Back Porch controls
if((HPOS >= 112) AND (HPOS < 360)) then
R<="00000000";
G<="00000000";
B<="00000000";
HSYNC<='0';
end if;
if((VPOS >= 3) AND (VPOS < 38)) then
R<="00000000";
G<="00000000";
B<="00000000";
VSYNC<='0';
end if;
--Synch control code
if((HPOS >= 0) AND (HPOS < 112)) then
R<="00000000";
G<="00000000";
B<="00000000";
HSYNC<='1';
end if;
if((VPOS >= 0) AND (VPOS < 3)) then
R<="00000000";
G<="00000000";
B<="00000000";
VSYNC<='1';
end if;
--Frame control code
IF (HPOS <= 1688) THEN
HPOS <= 0;
IF (VPOS <= 1066) THEN
VPOS <= 0;
IF(SW_1 ='1')THEN
square1_x_axis <= square1_x_axis + 1;
END IF;
IF(SW_2 ='1')THEN
square2_x_axis <= square2_x_axis + 1;
END IF;
ELSE
VPOS <= VPOS + 1;
END IF;
ELSE
HPOS <= HPOS + 1;
END IF;
--Square signal control
IF(RGB1 = "1111") THEN
IF(SW_3 = '1')THEN
R<="00000000";
G<="00000000";
B<="11111111";
ELSE
R<="10011001";
G<="00000000";
B<="00000000";
END IF;
end if;
IF(RGB2 = "1111") THEN
IF(SW_3 = '1')THEN
R<="11001100";
G<="11111111";
B<="00000000";
ELSE
R<="10011001";
G<="11111111";
B<="00000000";
END IF;
end if;
END IF;
 
END PROCESS;
END MAIN;
--Square signal control
IF(RGB1 = "1111") THEN
IF(SW_3 = '1')THEN
R<="00000000";
G<="00000000";
B<="11111111";
ELSE
R<="10011001";
G<="00000000";
B<="00000000";
END IF;
end if;
IF(RGB2 = "1111") THEN
IF(SW_3 = '1')THEN
R<="11001100";
G<="11111111";
B<="00000000";

ELSE
R<="10011001";
G<="11111111";
B<="00000000";
END IF;
end if;
END IF;
 
END PROCESS;
END MAIN;
