-------------------------------------------------------------------------------
-- DISCLAIMER OF LIABILITY
-- 
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you a 
-- license to use this text/file solely for design, simulation, 
-- implementation and creation of design files limited 
-- to Xilinx devices or technologies. Use with non-Xilinx 
-- devices or technologies is expressly prohibited and 
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information 
-- "as-is" solely for use in developing programs and 
-- solutions for Xilinx devices, with no obligation on the 
-- part of Xilinx to provide support. By providing this design, 
-- code, or information as one possible implementation of 
-- this feature, application or standard, Xilinx is making no 
-- representation that this implementation is free from any 
-- claims of infringement. You are responsible for 
-- obtaining any rights you may require for your implementation. 
-- Xilinx expressly disclaims any warranty whatsoever with 
-- respect to the adequacy of the implementation, including 
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied 
-- warranties of merchantability or fitness for a particular 
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications is
-- expressly prohibited.
--
-- Any modifications that are made to the Source Code are 
-- done at the user's sole risk and will be unsupported.
--
-- Copyright (c) 2006-2007 Xilinx, Inc. All rights reserved.
--
-- This copyright and support notice must be retained as part 
-- of this text at all times.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor		    : Xilinx
-- \   \   \/    Version	    : 2.3
--  \   \        Application	    : MIG
--  /   /        Filename           : mig_23_addr_gen_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2008/08/12 15:32:22 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
-- Device      : Spartan-3/3E/3A/3A-DSP
-- Design Name : DDR SDRAM
-- Purpose	: This module generates address and burst done signals to the 
--		  controller. Address consists of bank address at the lsb followed
--		  by column and row address. This module generates address depending 
--                on the addr_rst,addr_inc and r_w signals from the cmd_fsm module. 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mig_23_parameters_0.all;
library UNISIM;
use UNISIM.VCOMPONENTS.all;

entity mig_23_addr_gen_0 is
  port(
    clk        : in  std_logic;
    rst180     : in  std_logic;
    addr_rst   : in  std_logic;
    addr_inc   : in  std_logic;
    r_w        : in  std_logic;
    addr_out   : out std_logic_vector(((ROW_ADDRESS + COLUMN_ADDRESS + BANK_ADDRESS)-1) downto 0);
    burst_done : out std_logic;
    cnt_roll   : out std_logic
    );
end mig_23_addr_gen_0;

architecture arc of mig_23_addr_gen_0 is

  signal column_counter   : std_logic_vector(7 downto 0);
  signal cnt              : std_logic_vector(1 downto 0);
  signal cnt1             : std_logic_vector(1 downto 0);
  signal burst_cnt        : std_logic_vector(2 downto 0);
  signal ba_count         : std_logic_vector((BANK_ADDRESS-1) downto 0);
  signal row_address1     : std_logic_vector(ROW_ADDRESS-1 downto 0);
  signal burst_done_r1   : std_logic;
  signal burst_done_r2 : std_logic;
  signal burst_done_r3 : std_logic;
  signal burst_done_r4 : std_logic;
  signal burst_done_r5 : std_logic;
  signal rst180_r         : std_logic;
  signal burst_len        : std_logic_vector(2 downto 0); 
  signal col_incr         : std_logic_vector(3 downto 0); 
  signal col_val          : std_logic_vector(1 downto 0); 
  signal low              : std_logic_vector(13 downto 0); 
  signal lmr              : std_logic_vector((ROW_ADDRESS - 1) downto 0);

begin
  lmr        <= LOAD_MODE_REGISTER;
  low        <= "00000000000000";
  burst_len  <= lmr(2 downto 0);

  burst_done <= burst_done_r4 when (burst_len = "011") else
                burst_done_r2   when (burst_len = "010") else
                burst_done_r1;

  cnt_roll   <= burst_done_r3 when (burst_len = "011") else
                burst_done_r1;

  col_incr   <= "1000" when (burst_len = "011") else "0100"
                when (burst_len = "010") else "0010"
                when (burst_len = "001") else "0000";
  col_val    <= "11" when (burst_len = "011") else "01"
                when (burst_len = "010") else "00";
  addr_out   <= (row_address1 & (low(COLUMN_ADDRESS -9 downto 0)) &
                 column_counter & ba_count);

  process(clk)
  begin
    if clk'event and clk = '0' then
      rst180_r <= rst180;
    end if;
  end process;

--row address counter increments after every five writes and five reads
  process ( clk )
  begin
    if falling_edge(clk) then
      if(rst180_r = '1' or row_address1(5) = '1') then
        row_address1 <= low(ROW_ADDRESS-3 downto 0) & "10";
      elsif( r_w = '1' and burst_done_r4 = '0' and burst_done_r5 = '1') then
        row_address1 <= row_address1 + "10";
      else
        row_address1 <= row_address1;
      end if;
    end if;
  end process;

-- bank address counter increments after every five writes and five reads 
-- commands
  process ( clk )
  begin
    if falling_edge(clk) then
      if(rst180_r = '1') then
        ba_count <= (others => '0');
      elsif( r_w = '1' and burst_done_r4 = '0' and burst_done_r5 = '1') then
        ba_count <= ba_count + '1';
      else
        ba_count <= ba_count;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '0' then
      if (rst180_r = '1' or addr_rst = '1') then
        cnt   <= "00";
      elsif (addr_inc = '1' and cnt1 = "01") then
        if (cnt = col_val ) then
          cnt <= "00";
        else
          cnt <= cnt + '1';
        end if;
      end if;
    end if;
  end process;

-- burst cnt to count number of the writes/reads ccommands
  process(clk)
  begin
    if clk'event and clk = '0' then
      if (rst180_r = '1' or addr_rst = '1') then
        burst_cnt <= "000";
      elsif (addr_inc = '1' and cnt = "00") then
        burst_cnt <= burst_cnt + '1';
      else
        burst_cnt <= burst_cnt;
      end if;
    end if;
  end process;

-- column address counter increments in multilple of 2,4,8 depending 
-- on the burst length 2,4 and 8 respectively 
  process(clk)
  begin
    if clk'event and clk = '0' then
      if (rst180_r = '1' or addr_rst = '1') then
        column_counter   <= "00000000";
        cnt1             <= "00";
      elsif(addr_inc = '1') then
        if(cnt1 = "00") then
          cnt1           <= cnt1 + '1';
        elsif(cnt1 = "01" and cnt = "00" and burst_cnt < "101") then
          column_counter <= column_counter + col_incr;
        else
          column_counter <= column_counter;
        end if;
      elsif(burst_done_r4 = '0' and burst_done_r5 = '1') then
        column_counter   <= "00000000";
      end if;
    end if;
  end process;

-- burst done is generated  after five writes/reads
  process(clk)
  begin
    if(clk'event and clk = '0') then
      if (rst180_r = '1' ) then
        burst_done_r1 <= '0';
      elsif(burst_cnt = "101") then
        burst_done_r1 <= '1';
      else
        burst_done_r1 <= '0';
      end if;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '0') then
      burst_done_r2 <= burst_done_r1;
      burst_done_r3 <= burst_done_r2;
      burst_done_r4 <= burst_done_r3;
      burst_done_r5 <= burst_done_r4;
    end if;
  end process;

end arc;



