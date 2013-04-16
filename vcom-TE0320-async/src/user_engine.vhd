-------------------------------------------------------------------------------
-- Copyright (C) 2012 Trenz Electronic
--
-- Permission is hereby granted, free of charge, to any person obtaining a 
-- copy of this software and associated documentation files (the "Software"), 
-- to deal in the Software without restriction, including without limitation 
-- the rights to use, copy, modify, merge, publish, distribute, sublicense, 
-- and/or sell copies of the Software, and to permit persons to whom the 
-- Software is furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included 
-- in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
-- IN THE SOFTWARE.
-------------------------------------------------------------------------------
-- Company: Trenz Electronics GmbH
-- Engineer: Oleksandr Kiyenko (a.kienko@gmail.com)
-- 
-- Create Date: 19:51:49 09/03/2012 
-- Design Name: user test
-- Module Name: user_engine - RTL 
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-------------------------------------------------------------------------------
entity user_engine is
port ( 
    clk					: in  STD_LOGIC;
    fx2user_rd			: out STD_LOGIC;
    fx2user_data		: in  STD_LOGIC_VECTOR(7 downto 0);
    fx2user_empty		: in  STD_LOGIC;
    user2fx_data		: out STD_LOGIC_VECTOR(7 downto 0);
    user2fx_last		: out STD_LOGIC;
    user2fx_wr 			: out STD_LOGIC;
    user2fx_full 		: in  STD_LOGIC;
	led					: out STD_LOGIC_VECTOR(3 downto 0)
);
end user_engine;
-------------------------------------------------------------------------------
architecture RTL of user_engine is
-------------------------------------------------------------------------------
function bin2char(b: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
begin
	case b(3 downto 0) is
		when "0000"	=> return x"30";
		when "0001"	=> return x"31";
		when "0010"	=> return x"32";
		when "0011"	=> return x"33";
		when "0100"	=> return x"34";
		when "0101"	=> return x"35";
		when "0110"	=> return x"36";
		when "0111"	=> return x"37";
		when "1000"	=> return x"38";
		when "1001"	=> return x"39";
		when "1010" => return x"41";
		when "1011" => return x"42";
		when "1100" => return x"43";
		when "1101" => return x"44";
		when "1110" => return x"45";
		when "1111" => return x"46";
		when others => null;
	end case;
end function bin2char;

type sm_state_type is (		-- States of FSM
	ST_IDLE, 
	ST_RD_1, ST_RD_2,
	ST_WR_1, ST_WR_2, ST_WR_3, ST_WR_4, ST_WR_5, ST_WR_6, ST_WR_7 
);
signal sm_state	: sm_state_type := ST_IDLE;

signal rec_char		: STD_LOGIC_VECTOR(7 downto 0);
signal byte_cnt		: STD_LOGIC_VECTOR(7 downto 0);
-------------------------------------------------------------------------------
begin
-------------------------------------------------------------------------------
process(clk)
begin
	if(clk = '1' and clk'event)then
		 case sm_state is
			 when ST_IDLE =>		-- Initial state
				fx2user_rd		<= '0';
				user2fx_last	<= '0';
				user2fx_wr 		<= '0';
				if(fx2user_empty = '0')then
					fx2user_rd	<= '1';
					sm_state	<= ST_RD_1;
				end if;
			
			when ST_RD_1 => 
				fx2user_rd		<= '0';
				sm_state		<= ST_RD_2;
				
			when ST_RD_2 => 
				rec_char		<= fx2user_data;
				sm_state		<= ST_WR_1;
				
			when ST_WR_1 => 
				user2fx_data	<= bin2char(byte_cnt(7 downto 4));
				user2fx_last	<= '0';
				user2fx_wr 		<= '1';
				sm_state		<= ST_WR_2;
				
			when ST_WR_2 => 
				user2fx_data	<= bin2char(byte_cnt(3 downto 0));
				user2fx_last	<= '0';
				user2fx_wr 		<= '1';
				sm_state		<= ST_WR_3;

			when ST_WR_3 => 
				user2fx_data	<= x"5b";
				user2fx_last	<= '0';
				user2fx_wr 		<= '1';
				sm_state		<= ST_WR_4;

			when ST_WR_4 => 
				user2fx_data	<= rec_char;
				user2fx_last	<= '0';
				user2fx_wr 		<= '1';
				sm_state		<= ST_WR_5;

			when ST_WR_5 => 
				user2fx_data	<= x"5d";
				user2fx_last	<= '0';
				user2fx_wr 		<= '1';
				sm_state		<= ST_WR_6;
			
			when ST_WR_6 => 
				user2fx_data	<= x"0d";
				user2fx_last	<= '0';
				user2fx_wr 		<= '1';
				sm_state		<= ST_WR_7;
				
			when ST_WR_7 => 
				user2fx_data	<= x"0a";
				user2fx_last	<= '1';
				user2fx_wr 		<= '1';
				byte_cnt		<= byte_cnt + 1;
				sm_state		<= ST_IDLE;
				
		 end case;
	 end if;
 end process;

--led	<= rec_char(3 downto 0);
led	<= not byte_cnt(3 downto 0);
-------------------------------------------------------------------------------
end RTL;
