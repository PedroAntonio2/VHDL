--------------------------------------------------------------------
ENTITY lcd_driver IS
GENERIC (clk_divider: INTEGER := 50000); --27MHz to ~500Hz
PORT (CLOCK_50: IN BIT;
SW: IN BIT_VECTOR(0 DOWNTO 0);
LCD_RS, LCD_RW, LCD_ON, LCD_BLON: OUT BIT;
LCD_EN: BUFFER BIT;
LCD_DATA: OUT BIT_VECTOR(7 DOWNTO 0));
END lcd_driver;
--------------------------------------------------------------------
ARCHITECTURE lcd_driver OF lcd_driver IS
TYPE state IS (FunctionSet1, FunctionSet2, FunctionSet3,
FunctionSet4, ClearDisplay, DisplayControl, EntryMode,
WriteData1, WriteData2, WriteData3, WriteData4,
WriteData5,WriteData6,WriteData7, WriteData8, WriteData9,
ReturnHome);
SIGNAL pr_state, nx_state: state;
BEGIN
----- Clock generator (E–>500Hz): -------------
PROCESS (CLOCK_50)
VARIABLE count: INTEGER RANGE 0 TO clk_divider;
BEGIN
IF (CLOCK_50'EVENT AND CLOCK_50='1') THEN
count := count + 1;
IF (count=clk_divider) THEN
LCD_EN <= NOT LCD_EN;
count := 0;
END IF;
END IF;
END PROCESS;
----- Lower section of FSM: --------------------
PROCESS (LCD_EN)
BEGIN
LCD_BLON <= '1';
LCD_ON <= '1';

IF (LCD_EN'EVENT AND LCD_EN='1') THEN
IF (SW(0)='1') THEN
pr_state <= FunctionSet1;
ELSE
pr_state <= nx_state;
END IF;
END IF;
END PROCESS;
PROCESS (pr_state)
BEGIN
CASE pr_state IS
WHEN FunctionSet1 =>
LCD_RS<='0'; LCD_RW<='0';
LCD_DATA <= "00111000";
nx_state <= FunctionSet2;
WHEN FunctionSet2 =>
LCD_RS<='0'; LCD_RW<='0';
LCD_DATA <= "00111000";
nx_state <= FunctionSet3;
WHEN FunctionSet3 =>
LCD_RS<='0'; LCD_RW<='0';
LCD_DATA <= "00111000";
nx_state <= FunctionSet4;
WHEN FunctionSet4 =>
LCD_RS<='0'; LCD_RW<='0';
LCD_DATA <= "00111000";
nx_state <= ClearDisplay;
WHEN ClearDisplay =>
LCD_RS<='0'; LCD_RW<='0';
LCD_DATA <= "00000001";
nx_state <= DisplayControl;
WHEN DisplayControl =>
LCD_RS<='0'; LCD_RW<='0';
LCD_DATA <= "00001100";
nx_state <= EntryMode;
WHEN EntryMode =>
LCD_RS<='0'; LCD_RW<='0';
LCD_DATA <= "00000110";
nx_state <= WriteData1;
WHEN WriteData1 =>
LCD_RS<='1'; LCD_RW<='0';
LCD_DATA <= "01000110"; --'F'
nx_state <= WriteData2;
WHEN WriteData2 =>
LCD_RS<='1'; LCD_RW<='0';
LCD_DATA <= "01000001"; --'A'
nx_state <= WriteData3;
WHEN WriteData3 =>
LCD_RS<='1'; LCD_RW<='0';
LCD_DATA <= "01010011"; --'S'
nx_state <= WriteData4;
WHEN WriteData4 =>
LCD_RS<='1'; LCD_RW<='0';
LCD_DATA <= "01000101"; --'E'
nx_state <= WriteData5;
WHEN WriteData5 =>
LCD_RS<='1'; LCD_RW<='0';
LCD_DATA <= "00110001"; --'1'
nx_state <= WriteData6;
WHEN WriteData6 =>
LCD_RS<='1'; LCD_RW<='0';
LCD_DATA <= "00111010"; --':'
nx_state <= WriteData7;
WHEN WriteData7 =>
LCD_RS<='1'; LCD_RW<='0';
LCD_DATA <= "00010000"; --' '
nx_state <= WriteData8;
WHEN WriteData8 =>
LCD_RS<='1'; LCD_RW<='0';
LCD_DATA <= "01001111"; --'O'
nx_state <= WriteData9;
WHEN WriteData9 =>
LCD_RS<='1'; LCD_RW<='0';
LCD_DATA <= "01001011"; --'K'
nx_state <= ReturnHome;
WHEN ReturnHome =>
LCD_RS<='0'; LCD_RW<='0';
LCD_DATA <= "10000000";
nx_state <= WriteData1;
END CASE;
END PROCESS;
END lcd_driver;