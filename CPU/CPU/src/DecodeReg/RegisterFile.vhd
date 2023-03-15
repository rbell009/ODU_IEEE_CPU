--==================================================--
-- 				   Register File					--
------------------------------------------------------
--	* Developed to include all 37 Registers used by --
--    the ARM Architecture.							--
--	* User & System Modes use the same registers,   --
--	  R0-R14,PC,CPSR. While others use additional   --
--    alternatives specified by Processor mode.     --
--  * For details on the processor modes, refer to  --
--    the ARM Architecture Reference Manual.		--
--	* We will be opting for write back occuring in  --
--	  the rising edge, while reading of registers   --
--	  will occur in the falling edge.				--
--==================================================--

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerFile is
	port(
		CLK		:	in std_logic;
		regD	:	in std_logic_vector(3 downto 0);
		regN	:	in std_logic_vector(3 downto 0);
		regM	:	in std_logic_vector(3 downto 0);
		regW	:	in std_logic;
		wData	:	in std_logic_vector(31 downto 0);
		Pmode	:	in std_logic_vector(4 downto 0);
		readD1	:	out std_logic_vector(31 downto 0);
		readD2	:	out std_logic_vector(31 downto 0)
	);
end entity registerFile; 

architecture behaveReg of registerFile is

type mainRegs is array (0 to 14) of std_logic_vector(31 downto 0);
type twoRegs is array (0 to 1) of std_logic_vector(31 downto 0); 
type sevenRegs is array (0 to 6) of std_logic_vector(31 downto 0);

signal mainReg : mainRegs := (others => (others => '0'));
signal supervisorRegs : twoRegs := (others => (others => '0'));
signal abortRegs : twoRegs := (others => (others => '0'));
signal undRegs : twoRegs := (others => (others => '0'));
signal interruptRegs : twoRegs := (others => (others => '0'));
signal fastIntRegs : sevenRegs := (others => (others => '0'));

-- User : 10000
-- FIQ : 10001
-- IRQ : 10010
-- Supervisor : 10011
-- Abort : 10111
-- Undef : 11011
-- Syst : 11111

begin
	process(CLK,regW,Pmode)	
	begin
		if CLK = '1' and CLK'event then
			if regW = '1' then
				case Pmode is
					when "10000" =>
						mainReg(to_integer(unsigned(regD))) <= wData;
					when "10001" =>
						if to_integer(unsigned(regD)) < 8 then
							mainReg(to_integer(unsigned(regD))) <= wData;
						else
							fastIntRegs(to_integer(unsigned(regD))) <= wData;
						end if;
					when "10010" =>
						if to_integer(unsigned(regD)) < 13 then
							mainReg(to_integer(unsigned(regD))) <= wData;
						else
							interruptRegs(to_integer(unsigned(regD))) <= wData;
						end if;	
					when "10011" =>
						if to_integer(unsigned(regD)) < 13 then
							mainReg(to_integer(unsigned(regD))) <= wData;
						else
							supervisorRegs(to_integer(unsigned(regD))) <= wData;
						end if;
					when "10111" =>
						if to_integer(unsigned(regD)) < 13 then
							mainReg(to_integer(unsigned(regD))) <= wData;
						else
							abortRegs(to_integer(unsigned(regD))) <= wData;
						end if;
					when "11011" =>
						if to_integer(unsigned(regD)) < 13 then
							mainReg(to_integer(unsigned(regD))) <= wData;
						else
							undRegs(to_integer(unsigned(regD))) <= wData;
						end if;
					when "11111" =>
						mainReg(to_integer(unsigned(regD))) <= wData;
					when others =>
						null;
				end case;
			end if;
		elsif CLK = '0' and CLK'event then
			case Pmode is
				when "10000" =>
					readD1 <= mainReg(to_integer(unsigned(regN)));
					readD2 <= mainReg(to_integer(unsigned(regM)));
				when "10001" =>
					if to_integer(unsigned(regN)) < 8 then
						readD1 <= mainReg(to_integer(unsigned(regN)));
					else
						readD1 <= fastIntRegs(to_integer(unsigned(regN)));
					end if;
					
					if to_integer(unsigned(regM)) < 8 then
						readD2 <= mainReg(to_integer(unsigned(regM)));
					else
						readD2 <= fastIntRegs(to_integer(unsigned(regM)));
					end if;					
				when "10010" =>
					if to_integer(unsigned(regN)) < 13 then
						readD1 <= mainReg(to_integer(unsigned(regN)));
					else
						readD1 <= interruptRegs(to_integer(unsigned(regN)));
					end if;
					
					if to_integer(unsigned(regM)) < 13 then
						readD2 <= mainReg(to_integer(unsigned(regM)));
					else
						readD2 <= interruptRegs(to_integer(unsigned(regM)));
					end if;
				when "10011" =>
					if to_integer(unsigned(regN)) < 13 then
						readD1 <= mainReg(to_integer(unsigned(regN)));
					else
						readD1 <= supervisorRegs(to_integer(unsigned(regN)));
					end if;
					
					if to_integer(unsigned(regM)) < 13 then
						readD2 <= mainReg(to_integer(unsigned(regM)));
					else
						readD2 <= supervisorRegs(to_integer(unsigned(regM)));
					end if;
				when "10111" =>
					if to_integer(unsigned(regN)) < 13 then
						readD1 <= mainReg(to_integer(unsigned(regN)));
					else
						readD1 <= abortRegs(to_integer(unsigned(regN)));
					end if;
					
					if to_integer(unsigned(regM)) < 13 then
						readD2 <= mainReg(to_integer(unsigned(regM)));
					else
						readD2 <= abortRegs(to_integer(unsigned(regM)));
					end if;
				when "11011" =>
					if to_integer(unsigned(regN)) < 13 then
						readD1 <= mainReg(to_integer(unsigned(regN)));
					else
						readD1 <= undRegs(to_integer(unsigned(regN)));
					end if;
					
					if to_integer(unsigned(regM)) < 13 then
						readD2 <= mainReg(to_integer(unsigned(regM)));
					else
						readD2 <= undRegs(to_integer(unsigned(regM)));
					end if;
				when "11111" =>
					readD1 <= mainReg(to_integer(unsigned(regN)));
					readD2 <= mainReg(to_integer(unsigned(regM)));
				when others =>
					null;
			end case;
		end if;
	end process;
end architecture;
						
						
	



