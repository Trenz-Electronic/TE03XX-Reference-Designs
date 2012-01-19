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
--  /   /        Filename	    : mig_23_cmp_data_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2008/08/12 15:32:22 $	
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
-- Device      : Spartan-3/3E/3A/3A-DSP
-- Design Name : DDR SDRAM
-- Purpose	: This module compare the read data with compare data and 
--		  generates the error signal in case of data mismatch. 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mig_23_parameters_0.all;
library UNISIM;
use UNISIM.VCOMPONENTS.all;

entity mig_23_cmp_data_0 is
  port (
    clk90            : in  std_logic;
    data_valid       : in  std_logic;
    cmp_data        : in  std_logic_vector((2*DATA_WIDTH-1) downto 0);
    read_data        : in  std_logic_vector((2*DATA_WIDTH-1) downto 0);
    rst90            : in  std_logic;
    led_error_output : out std_logic;
    data_valid_out   : out std_logic
    );
end mig_23_cmp_data_0;

architecture arc of mig_23_cmp_data_0 is

  signal   led_state     : std_logic;
  signal   valid         : std_logic;
  signal   error         : std_logic;
  signal   byte_err_fall : std_logic_vector((DATA_WIDTH/8)-1 downto 0);
  signal   byte_err_rise : std_logic_vector((DATA_WIDTH/8)-1 downto 0);
  signal   val_reg       : std_logic;
  signal   read_data_reg : std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
  signal   rst90_r       : std_logic;

begin

  data_valid_out   <= valid;
  led_error_output <= '1' when led_state = '1' else '0';
  error            <= ((byte_err_fall(0) or byte_err_fall(1)) or (byte_err_rise(0) or byte_err_rise(1))) and val_reg;

  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      rst90_r <= rst90;
    end if;
  end process;

  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      read_data_reg <= read_data;
    end if;
  end process;

  process (clk90)
  begin
    if clk90'event and clk90 = '1' then
      if rst90_r = '1' then
        valid <= '0';
      else
        valid <= data_valid;
      end if;
    end if;
  end process;

  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      if (rst90_r = '1') then
        val_reg <= '0';
      else
        val_reg <= valid;
      end if;
    end if;
  end process;


  gen_err : for err_i in 0 to (DATA_WIDTH/8)-1 generate
    process(clk90)
    begin
      if clk90'event and clk90 = '1' then
        if (read_data_reg((err_i*8-1)+8 downto err_i*8) /= 
			cmp_data((err_i*8-1)+8 downto err_i*8)) then
          byte_err_fall(err_i) <= '1';
        else
          byte_err_fall(err_i) <= '0';
        end if;
        if (read_data_reg(((err_i*8)+DATA_WIDTH-1)+8 downto ((err_i*8)+DATA_WIDTH)) /= 
			cmp_data(((err_i*8)+DATA_WIDTH-1)+8 downto ((err_i*8)+DATA_WIDTH))) then
          byte_err_rise(err_i) <= '1';
        else
          byte_err_rise(err_i) <= '0';
        end if;
      end if;          
    end process;
  end generate gen_err;

  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      led_state <= (not rst90_r and ( error or led_state));
    end if;
  end process;

-- DATA ERROR

  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      if (rst90_r = '0') then
        --synthesis translate_off
        assert (led_state = '0') report " DATA ERROR at time " & time'image(now);
        --synthesis translate_on
      end if;
    end if;
  end process;

end   arc;
