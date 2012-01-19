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
--  /   /        Filename	    : mig_23_data_gen_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2008/08/12 15:32:22 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
-- Device      : Spartan-3/3E/3A/3A-DSP
-- Design Name : DDR SDRAM
-- Purpose	: This module generate write data during the write command 
--                and compare data during read command. For write command,
--                mask data is also generated. Mask data is tied to low. 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.mig_23_parameters_0.all;

entity mig_23_data_gen_0 is
  port (
    clk90       : in  std_logic;
    rst90       : in  std_logic;
    data_rst    : in  std_logic;
    data_ena    : in  std_logic;
    mask_data : out std_logic_vector((2*DATA_MASK_WIDTH-1) downto 0);
    data_out    : out std_logic_vector((2*DATA_WIDTH-1) downto 0));
end mig_23_data_gen_0;

architecture arc of mig_23_data_gen_0 is

  signal rise_data   : std_logic_vector(7 downto 0);
  signal fall_data   : std_logic_vector(7 downto 0);
  signal rst90_r  : std_logic;

  attribute syn_preserve : boolean;
  
  attribute syn_preserve of rise_data : signal is true;
  attribute syn_preserve of fall_data : signal is true;
  
begin

  process(clk90)
  begin
    if rising_edge(clk90) then
      rst90_r <= rst90;
    end if;
  end process;
-- Incremental data pattern is generated

  process(clk90)
  begin
    if rising_edge(clk90) then
      if (rst90_r = '1') then
        rise_data   <= (others => '0');
        fall_data   <= "00000001";
      else
        if data_rst = '1' then
          rise_data <= (others => '0');
          fall_data <= "00000001";
        elsif data_ena = '1' then
          rise_data <= rise_data + "00000010";
          fall_data <= fall_data + "00000010";
        else
          rise_data <= rise_data;
          fall_data <= fall_data;
        end if;
      end if;
    end if;
  end process;

  data_out <=     rise_data  &     rise_data  &     rise_data  &     rise_data  &     fall_data  &     fall_data  &     fall_data  &     fall_data ;
  mask_data <= (others => '0');

end arc;
