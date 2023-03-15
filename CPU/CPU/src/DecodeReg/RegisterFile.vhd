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
--	  will occur in the falling edge.
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
		mode	:	in std_logic_vector(4 downto 0);
		regPC	:	in std_logic_vector(31 downto 0);
		readD1	:	out std_logic_vector(31 downto 0);
		readD2	:	out std_logic_vector(31 downto 0)
	);
end entity registerFile; 