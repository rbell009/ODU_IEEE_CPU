--==================================================--
-- 				Instruction Fetch 					--
------------------------------------------------------
--	* Under the assumption that the address will be --
--    passed to the Instruction Cache				--													--
--==================================================--

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity InstructionFetch is
	port(
		CLK			:	in std_logic;						-- Pass Through for Instruction Cache / Instruction Mem
		PC			:	in std_logic_vector(31 downto 0);					
		nPC			:	out std_logic_vector(31 downto 0);
		Instruct	:	out std_logic_vector(31 downto 0)
	);
end entity InstructionFetch;

architecture behaveIF of InstructionFetch is

-- Insert Component of Instruction Cache --

signal instruction : std_logic_vector(31 downto 0);

begin
	-- Port Map to Cache --'
		
	Instruct <= instruction;
	nPC <= std_logic_vector(unsigned(PC) + 4);

end architecture;
	
	

		
	