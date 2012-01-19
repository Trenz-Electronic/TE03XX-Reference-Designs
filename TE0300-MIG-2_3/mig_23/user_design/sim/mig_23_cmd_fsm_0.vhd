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
--  /   /        Filename	    : mig_23_cmd_fsm_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2008/08/12 15:32:22 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
-- Device      : Spartan-3/3E/3A/3A-DSP
-- Design Name : DDR SDRAM
-- Purpose	: This module consists of s/m which will generate user commands 
--                like initialization, write and read.It also generates control 
--                signals addr_inc,addr_rst,data_rst for addr_gen and data_gen 
--                modules.This control signals are used to generate address 
--                during write and read commands and data for write command. 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.all;

entity mig_23_cmd_fsm_0 is
  port (
    clk          : in  std_logic;
    clk90        : in  std_logic;
    cmd_ack      : in  std_logic;
    cnt_roll     : in  std_logic;
    r_w          : out std_logic;
    refresh_done : in  std_logic;
    rst180       : in  std_logic;
    rst90        : in  std_logic;
    init_val     : in  std_logic;
    addr_inc     : out std_logic;
    addr_rst     : out std_logic;
    u_cmd        : out std_logic_vector(2 downto 0);
    data_rst     : out std_logic;
    auto_ref_req : in  std_logic
    );

end mig_23_cmd_fsm_0;

architecture arc of mig_23_cmd_fsm_0 is

  type s_m is (rst_state, init_start, init, wr, rd, dly);

  signal next_state, next_state1 : s_m;

  signal init_dly     : std_logic_vector(5 downto 0);
  signal init_dly_p   : std_logic_vector(5 downto 0);
  signal u_cmd_p      : std_logic_vector(2 downto 0);
  signal addr_inc_p   : std_logic;
  signal data_rst_p   : std_logic;
  signal data_rst_180 : std_logic;
  signal data_rst_90  : std_logic;
  signal init_done    : std_logic;
  signal next_cmd     : std_logic;
  signal r_w1         : std_logic;
  signal r_w2         : std_logic;
  signal rst_flag     : std_logic;
  signal temp         : std_logic;
  signal rst180_r     : std_logic;
  signal rst90_r      : std_logic;

begin

  data_rst   <= data_rst_90;
  u_cmd_p    <= "110" when (next_state = rd) else "100"
                when (next_state = wr) else "010"
                when (next_state = init_start) else "000";
  addr_inc_p <= '1' when ((cmd_ack = '1') and (next_state = WR or
                                               next_state = RD)) else '0';
  addr_rst   <= rst_flag;
  data_rst_p <= '1' when (r_w2 = '1') else '0';
  init_dly_p <= "111111" when (next_state = init_start) else
                init_dly - "000001" when init_dly /= "000000"
                else "000000";
  next_cmd   <= '1' when (cmd_ack = '0' and next_state = dly) else '0';
  r_w2       <= r_w1;
  r_w        <= r_w1;
  
  process(clk)
  begin
    if(clk'event and clk = '0') then
      rst180_r <= rst180;
    end if;
  end process;

  process(clk90)
  begin
    if(clk90'event and clk90 = '1') then
      rst90_r <= rst90;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '0') then
      rst_flag <= (not(rst180_r) and not(cmd_ack) and not(temp));
      temp     <= (not(rst180_r) and not(cmd_ack));
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '0') then
      if(rst180_r = '1') then
        r_w1   <= '0';
      else
        if(cmd_ack = '0' and next_state = rd) then
          r_w1 <= '1';
        elsif(cmd_ack = '0' and next_state = wr) then
          r_w1 <= '0';
        else
          r_w1 <= r_w1;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '0') then
      if rst180_r = '1' then
        data_rst_180 <= '0';
      else
        data_rst_180 <= data_rst_p;
      end if;
    end if;
  end process;

  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      if rst90_r = '1' then
        data_rst_90 <= '0';
      else
        data_rst_90 <= data_rst_180;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '0') then
      if rst180_r = '1' then
        u_cmd <= "000";
      else
        u_cmd <= u_cmd_p;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '0') then
      if rst180_r = '1' then

        addr_inc <= '0';
        init_dly <= "000000";
      else
        addr_inc <= addr_inc_p;
        init_dly <= init_dly_p;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '0') then
      if rst180_r = '1' then
        init_done <= '0';
      else
        init_done <= init_val;
      end if;
    end if;
  end process;

  process (rst180_r, cnt_roll, r_w2, refresh_done, init_done,
           next_cmd, next_state)
  begin
    if rst180_r = '1' then
      next_state1   <= rst_state;
    else
      case(next_state) is
        when rst_state =>
          next_state1   <= init_start;
        when init_start =>
          next_state1   <= init;
        when init       =>
          if init_done = '1' then
            next_state1 <= wr;
          else
            next_state1 <= init;
          end if;
        when wr         =>
          if cnt_roll = '0' then
            next_state1 <= wr;
          else
            next_state1 <= dly;
          end if;
        when dly        =>
          if(next_cmd = '1' and r_w2 = '0') then
            next_state1 <= rd;
          elsif(next_cmd = '1' and r_w2 = '1') then
            next_state1 <= wr;
          else
            next_state1 <= dly;
          end if;
        when rd         =>
          if cnt_roll = '0' then
            next_state1 <= rd;
          else
            next_state1 <= dly;
          end if;
      end case;
    end if;
end process;

process(clk)
begin
  if(clk'event and clk = '0') then
    if rst180_r = '1' then
      next_state <= rst_state;
    else
      next_state <= next_state1;
    end if;
  end if;
end process;

end arc;
