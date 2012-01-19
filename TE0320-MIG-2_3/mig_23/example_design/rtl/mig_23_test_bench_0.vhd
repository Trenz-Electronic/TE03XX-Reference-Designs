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
--  /   /        Filename	    : mig_23_test_bench_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2008/08/12 15:32:22 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
-- Device      : Spartan-3/3E/3A/3A-DSP
-- Design Name : DDR SDRAM
-- Purpose	: This module generate the commands, address and data associated
--                with a write and a read command. This module consists of 
--                addr_gen, data_gen, cmd_fsm and cmp_data modules. 
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.mig_23_parameters_0.all;

entity mig_23_test_bench_0 is
  port (
    fpga_clk         : in  std_logic;
    fpga_rst90       : in  std_logic;
    fpga_rst180      : in  std_logic;
    clk90            : in  std_logic;
    burst_done       : out std_logic;
    init_done        : in  std_logic;
    auto_ref_req     : in  std_logic;
    ar_done          : in  std_logic;
    u_ack            : in  std_logic;
    u_data_val       : in  std_logic;
    u_data_o         : in  std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
    u_addr           : out std_logic_vector(((ROW_ADDRESS + COLUMN_ADDRESS +
                                              BANK_ADDRESS)- 1) downto 0);
    u_cmd            : out std_logic_vector(2 downto 0);
    u_data_i         : out std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
    u_data_m         : out std_logic_vector(((2*DATA_MASK_WIDTH)-1) downto 0);
    led_error_output : out std_logic;
    data_valid_out   : out std_logic
    );
end mig_23_test_bench_0;


architecture arc of mig_23_test_bench_0 is
  attribute syn_keep : boolean;

  component mig_23_addr_gen_0
    port (
      clk        : in  std_logic;
      rst180     : in  std_logic;
      addr_rst   : in  std_logic;
      addr_inc   : in  std_logic;
      addr_out   : out std_logic_vector(((ROW_ADDRESS +
                                          COLUMN_ADDRESS + BANK_ADDRESS)- 1) downto 0);
      r_w        : in  std_logic;
      burst_done : out std_logic;
      cnt_roll   : out std_logic
      );
  end component;

  component mig_23_cmd_fsm_0
    port (
      clk          : in  std_logic;
      clk90        : in  std_logic;
      auto_ref_req : in  std_logic;
      cmd_ack      : in  std_logic;
      cnt_roll     : in  std_logic;
      r_w          : out std_logic;
      refresh_done : in  std_logic;
      rst90        : in  std_logic;
      rst180       : in  std_logic;
      init_val     : in  std_logic;
      addr_inc     : out std_logic;
      addr_rst     : out std_logic;
      u_cmd        : out std_logic_vector(2 downto 0);
      data_rst     : out std_logic
      );
  end component;

  component mig_23_cmp_data_0
    port (
      clk90            : in  std_logic;
      data_valid       : in  std_logic;
      cmp_data         : in  std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
      read_data        : in  std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
      rst90            : in  std_logic;
      led_error_output : out std_logic;
      data_valid_out   : out std_logic
      );
  end component;

  component mig_23_data_gen_0
    port (
      clk90       : in  std_logic;
      rst90       : in  std_logic;
      data_rst      : in  std_logic;
      data_ena      : in  std_logic;
      mask_data     : out std_logic_vector(((2*DATA_MASK_WIDTH)-1) downto 0);
      data_out      : out std_logic_vector(((2*DATA_WIDTH)-1) downto 0)
      );
  end component;

  signal clk            : std_logic;
  signal rst90_r        : std_logic;
  signal addr_inc       : std_logic;
  signal addr_rst       : std_logic;
  signal cmd_ack        : std_logic;
  signal cnt_roll       : std_logic;
  signal data_ena_r     : std_logic;
  signal data_ena_w     : std_logic;
  signal data_rst_r     : std_logic;
  signal data_rst_r1    : std_logic;
  signal data_rst_w     : std_logic;
  signal r_w            : std_logic;
  signal cmp_data_r    : std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
  signal cmp_data_m_r  : std_logic_vector(((2*DATA_MASK_WIDTH)-1) downto 0);
  signal app_data_w0   : std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
  signal app_data_w1   : std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
  signal app_data_w2   : std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
  signal app_data_w3   : std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
  signal app_data_w4   : std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
  signal app_data_m_w0 : std_logic_vector(((2*DATA_MASK_WIDTH)-1) downto 0);
  signal app_data_m_w1 : std_logic_vector(((2*DATA_MASK_WIDTH)-1) downto 0);
  signal app_data_m_w2 : std_logic_vector(((2*DATA_MASK_WIDTH)-1) downto 0);
  signal app_data_m_w3 : std_logic_vector(((2*DATA_MASK_WIDTH)-1) downto 0);
  signal app_data_m_w4 : std_logic_vector(((2*DATA_MASK_WIDTH)-1) downto 0);
  signal addr_out       : std_logic_vector(((ROW_ADDRESS + COLUMN_ADDRESS + BANK_ADDRESS)- 1) downto 0);
  signal u_dat_flag     : std_logic;
  signal u_dat_fl       : std_logic;

begin

--  Test_bench uses two clock phases clk180 and clk90. User write 
--  data is generated with clk90 phase, for memory write command 
--  data and strobe are center aligned. Write data to the memory 
--  is clk90 phase w.r.t strobe. So user write data is generated 
--  with clk90 phase.Address and commands are generated w.r.t 
--  clk180. To meet the setup/hold time for memory, memory clk is 
--  clk0 and all the commands and address are generated with 
--  clk180 phase.

-- Output : COMMAND REGISTER FORMAT
-- 000 - NOP
--          010  - Initialize memory
--          100  - Write Request
-- 110 - Read request

-- Output : Address format
-- row address = address((ROW_ADDRESS + COLUMN_ADDRESS + BANK_ADDRESS) -1 downto
-- (COLUMN_ADDRESS + BANK_ADDRESS))
-- column addrs = address((COLUMN_ADDRESS + BANK_ADDRESS)-1 downto BANK_ADDRESS)
-- bank address = address(BANK_ADDRESS - 1 downto 0)

  clk      <= fpga_clk;
  cmd_ack  <= u_ack;
  u_addr   <= addr_out;
  u_data_i <= app_data_w0;
  u_data_m <= app_data_m_w0;


  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      rst90_r <= fpga_rst90;
    end if;
  end process;

  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      if rst90_r = '1' then
        app_data_w1   <= (others => '0');
        app_data_w2   <= (others => '0');
        app_data_w3   <= (others => '0');
        app_data_w4   <= (others => '0');
        app_data_m_w1 <= (others => '0');
        app_data_m_w2 <= (others => '0');
        app_data_m_w3 <= (others => '0');
        app_data_m_w4 <= (others => '0');
      else
        app_data_w1   <= app_data_w0;
        app_data_w2   <= app_data_w1;
        app_data_w3   <= app_data_w2;
        app_data_w4   <= app_data_w3;
        app_data_m_w1 <= app_data_m_w0;
        app_data_m_w2 <= app_data_m_w1;
        app_data_m_w3 <= app_data_m_w2;
        app_data_m_w4 <= app_data_m_w3;
      end if;
    end if;
  end process;

  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      if rst90_r = '1' then
        data_ena_r <= '0';
      else
        if (u_data_val = '1') then
          data_ena_r <= '1';
        else
          data_ena_r <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      if rst90_r = '1' then
        data_ena_w <= '0';
      else
        if ((r_w = '0') and (u_ack = '1')) then
          data_ena_w <= '1';
        else
          data_ena_w <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      if(rst90_r = '1') then
        u_dat_flag <= '0';
      else
        u_dat_flag <= cmd_ack;
      end if;
    end if;
  end process;

  u_dat_fl    <= cmd_ack and (not u_dat_flag) and r_w;
  data_rst_r1 <= u_dat_fl;

  process(clk90)
  begin
    if clk90'event and clk90 = '1' then
      if(rst90_r = '1') then
        data_rst_r <= '0';
      else
        data_rst_r <= data_rst_r1;
      end if;
    end if;
  end process;

  INST1 : mig_23_addr_gen_0
    port map (
      clk        => clk,
      rst180     => fpga_rst180,
      addr_rst   => addr_rst,
      addr_inc   => addr_inc,
      addr_out   => addr_out,
      r_w        => r_w,
      burst_done => burst_done,
      cnt_roll   => cnt_roll
      );

  INST_2 : mig_23_cmd_fsm_0
    port map (
      clk          => clk,
      clk90        => clk90,
      cmd_ack      => cmd_ack,
      cnt_roll     => cnt_roll,
      auto_ref_req => auto_ref_req,
      r_w          => r_w,
      refresh_done => ar_done,
      rst90        => fpga_rst90,
      rst180       => fpga_rst180,
      init_val     => init_done,
      addr_inc     => addr_inc,
      addr_rst     => addr_rst,
      u_cmd        => u_cmd,
      data_rst     => data_rst_w
      );

  INST3 : mig_23_cmp_data_0
    port map (
      clk90            => clk90,
      data_valid       => u_data_val,
      cmp_data         => cmp_data_r,
      read_data        => u_data_o,
      rst90            => fpga_rst90,
      led_error_output => led_error_output,
      data_valid_out   => data_valid_out
      );

  INST5 : mig_23_data_gen_0
    port map (
      clk90       => clk90,
      rst90       => fpga_rst90,
      data_rst    => data_rst_r,
      data_ena    => data_ena_r,
      mask_data   => cmp_data_m_r,
      data_out    => cmp_data_r
      );

  INST7 : mig_23_data_gen_0
    port map (
      clk90       => clk90,
      rst90       => fpga_rst90,
      data_rst    => data_rst_w,
      data_ena    => data_ena_w,
      mask_data   => app_data_m_w0,
      data_out    => app_data_w0
      );

end arc;
