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
-- done at the user’s sole risk and will be unsupported.
--
-- Copyright (c) 2006-2007 Xilinx, Inc. All rights reserved.
--
-- This copyright and support notice must be retained as part 
-- of this text at all times.
------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : 2.3
--  \   \        Application	    : MIG
--  /   /        Filename           : sim_tb_top.vhd
-- /___/   /\    Date Last Modified : $Date: 2008/08/12 15:32:22 $
-- \   \  /  \   Date Created       : Mon May 14 2007
--  \___\/\___\
--
-- Device      : Spartan-3/3E/3A/3A-DSP
-- Design Name : DDR SDRAM
-- Purpose     : This is the simulation testbench which is used to verify the
--               design. The basic clocks and resets to the interface are
--               generated here. This also connects the memory interface to the
--               memory model.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mig_23_parameters_0.all;

library unisim;
use unisim.vcomponents.all;

entity sim_tb_top is

end entity sim_tb_top;

architecture arch of sim_tb_top is

  constant DEVICE_WIDTH   : integer := 16;  -- Memory device data width
  constant REG_ENABLE     : integer := REGISTERED;  -- registered addr/ctrl
  
  constant CLK_PERIOD_NS     : real := 7518.0 / 1000.0;   -- Clock-Period in ns
  constant TCYC_SYS          : real := CLK_PERIOD_NS/2.0;  
  constant TCYC_SYS_DIV2     : time := TCYC_SYS * 1 ns;    
  constant TEMP2             : real := 5.0/2.0;
  constant TCYC_200          : time := TEMP2 * 1 ns;
  constant TPROP_DQS         : time := 0.00 ns;           -- Delay for DQS signal during Write Operation
  constant TPROP_DQS_RD      : time := 0.00 ns;           -- Delay for DQS signal during Read Operation
  constant TPROP_PCB_CTRL    : time := 0.00 ns;           -- Delay for Address and Ctrl signals 
  constant TPROP_PCB_DATA    : time := 0.00 ns;           -- Delay for data signal during Write operation
  constant TPROP_PCB_DATA_RD : time := 0.00 ns;           -- Delay for data signal during Read operation

  component mig_23
    port (
      reset_in_n                   : in    std_logic;
      clk_int                      : in    std_logic;
      clk90_int                    : in    std_logic;
      dcm_lock                     : in    std_logic;
      cntrl0_ddr_a                 : out   std_logic_vector((ROW_ADDRESS-1) downto 0);
      cntrl0_ddr_ba                : out   std_logic_vector((BANK_ADDRESS-1) downto 0);
      cntrl0_ddr_ras_n             : out   std_logic;
      cntrl0_ddr_cas_n             : out   std_logic;
      cntrl0_ddr_we_n              : out   std_logic;
      cntrl0_ddr_cs_n              : out   std_logic;
      cntrl0_ddr_cke               : out   std_logic;
      cntrl0_ddr_ck                : out   std_logic_vector((CLK_WIDTH-1) downto 0);
      cntrl0_ddr_ck_n              : out   std_logic_vector((CLK_WIDTH-1) downto 0);
      cntrl0_ddr_dq                : inout std_logic_vector((DATA_WIDTH-1) downto 0);
      cntrl0_ddr_dqs               : inout std_logic_vector((DATA_STROBE_WIDTH-1) downto 0);
      cntrl0_ddr_dm                : out   std_logic_vector((DATA_MASK_WIDTH-1) downto 0);
      
      cntrl0_burst_done            : in    std_logic;
      cntrl0_init_val              : out   std_logic;
      cntrl0_ar_done               : out   std_logic;
      cntrl0_user_data_valid       : out   std_logic;
      cntrl0_auto_ref_req          : out   std_logic;
      cntrl0_user_cmd_ack          : out   std_logic;
      cntrl0_user_command_register : in    std_logic_vector(2 downto 0);
      cntrl0_clk_tb                : out   std_logic;
      cntrl0_clk90_tb              : out   std_logic;
      cntrl0_sys_rst_tb            : out   std_logic;
      cntrl0_sys_rst90_tb          : out   std_logic;
      cntrl0_sys_rst180_tb         : out   std_logic;      
      cntrl0_user_output_data      : out   std_logic_vector((2*DATA_WIDTH-1) downto 0);
      cntrl0_user_input_data       : in    std_logic_vector((2*DATA_WIDTH-1) downto 0);
      cntrl0_user_input_address    : in    std_logic_vector(((ROW_ADDRESS + COLUMN_ADDRESS +
                                                            BANK_ADDRESS)- 1) downto 0);
      cntrl0_user_data_mask        : in    std_logic_vector((2*DATA_MASK_WIDTH-1) downto 0);
      cntrl0_rst_dqs_div_in        : in    std_logic;
      cntrl0_rst_dqs_div_out       : out   std_logic
      );
  end component;

  component ddr_model
    port (
      Dq    : inout std_logic_vector((DEVICE_WIDTH - 1) downto 0);
      Dqs   : inout std_logic_vector((DEVICE_WIDTH/16) downto 0);
      Addr  : in    std_logic_vector((ROW_ADDRESS - 1) downto 0);
      Ba    : in    std_logic_vector((BANK_ADDRESS - 1) downto 0);
      Clk   : in    std_logic;
      Clk_n : in    std_logic;
      Cke   : in    std_logic;
      Cs_n  : in    std_logic;
      Ras_n : in    std_logic;
      Cas_n : in    std_logic;
      We_n  : in    std_logic;
      Dm    : in    std_logic_vector((DEVICE_WIDTH/16) downto 0)
      );
  end component;

  component WireDelay
    generic (
      Delay_g  : time;
      Delay_rd : time);
    port (
      A : inout Std_Logic;
      B : inout Std_Logic;
      reset : in Std_Logic);
  end component;

    component mig_23_test_bench_0 is
    port(
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
      u_data_m         : out std_logic_vector(((2*DATA_MASK_WIDTH)-1) downto 0);
      u_data_i         : out std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
      led_error_output : out std_logic;
      data_valid_out   : out std_logic
      );
  end component;

  signal sys_clk               : std_logic := '0';
  signal sys_clk_n             : std_logic;
  signal sys_clk_p             : std_logic;
  signal sys_clk200            : std_logic := '0';
  signal clk200_n              : std_logic;
  signal clk200_p              : std_logic;
  signal sys_rst_n             : std_logic := '0';
  signal sys_rst_out           : std_logic;
  signal ddr_dq_sdram          : std_logic_vector((DATA_WIDTH - 1) downto 0);
  signal ddr_dqs_sdram         : std_logic_vector((DATA_STROBE_WIDTH - 1) downto 0);
  signal ddr_dm_sdram          : std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
  signal ddr_clk_sdram         : std_logic_vector((CLK_WIDTH - 1) downto 0);
  signal ddr_clk_n_sdram       : std_logic_vector((CLK_WIDTH - 1) downto 0);
  signal ddr_address_sdram     : std_logic_vector((ROW_ADDRESS - 1) downto 0);
  signal ddr_ba_sdram          : std_logic_vector((BANK_ADDRESS - 1) downto 0);
  signal ddr_ras_l_sdram       : std_logic;
  signal ddr_cas_l_sdram       : std_logic;
  signal ddr_we_l_sdram        : std_logic;
  signal ddr_cs_l_sdram        : std_logic;
  signal ddr_cke_sdram         : std_logic;
  signal error                 : std_logic;
  signal init_done             : std_logic;
  signal ddr_address_reg       : std_logic_vector((ROW_ADDRESS - 1) downto 0);
  signal ddr_ba_reg            : std_logic_vector((BANK_ADDRESS - 1) downto 0);
  signal ddr_cke_reg           : std_logic;
  signal ddr_ras_l_reg         : std_logic;
  signal ddr_cas_l_reg         : std_logic;
  signal ddr_we_l_reg          : std_logic;
  signal ddr_cs_l_reg          : std_logic;

  -- Only RDIMM memory parts support the reset signal, 
  -- hence the ddr_reset_n_sdram and ddr_reset_n_fpga signals can be 
  -- ignored for other memory parts
  signal ddr_reset_n_sdram     : std_logic;
  signal ddr_reset_n_fpga      : std_logic;

--below signals will be driven only in case of component or unbuffered 
--and data_width not multiple of 16 and selected component width is x16
  signal dq_vector             : std_logic_vector(15 downto 0);
  signal dqs_vector            : std_logic_vector(1 downto 0);
  signal dqs_n_vector          : std_logic_vector(1 downto 0);
  signal dm_vector             : std_logic_vector(1 downto 0);
  signal command               : std_logic_vector(2 downto 0);
  signal enable                : std_logic;
  signal enable_o              : std_logic;

  signal command1              : std_logic_vector(2 downto 0);
  signal enable1               : std_logic;
  signal enable2               : std_logic;
  signal ddr_dq_fpga           : std_logic_vector((DATA_WIDTH - 1) downto 0);
  signal ddr_dqs_fpga          : std_logic_vector((DATA_STROBE_WIDTH - 1) downto 0);
  signal ddr_dm_fpga           : std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
  signal ddr_clk_fpga          : std_logic_vector((CLK_WIDTH - 1) downto 0);
  signal ddr_clk_n_fpga        : std_logic_vector((CLK_WIDTH - 1) downto 0);
  signal ddr_address_fpga      : std_logic_vector((ROW_ADDRESS - 1) downto 0);
  signal ddr_ba_fpga           : std_logic_vector((BANK_ADDRESS - 1) downto 0);
  signal ddr_ras_l_fpga        : std_logic;
  signal ddr_cas_l_fpga        : std_logic;
  signal ddr_we_l_fpga         : std_logic;
  signal ddr_cs_l_fpga         : std_logic;
  signal ddr_cke_fpga          : std_logic;
  signal data_valid_out        : std_logic;
  signal rst_dqs_div_loop      : std_logic;
  signal ddr_dm_8_16           : std_logic_vector(1 downto 0);-- this signal will be driven only for x16 components
  signal burst_done            : std_logic;
  signal ar_done               : std_logic;
  signal user_data_valid       : std_logic;
  signal auto_ref_req          : std_logic;
  signal user_cmd_ack          : std_logic;
  signal user_command_register : std_logic_vector(2 downto 0);
  signal clk_tb                : std_logic;
  signal clk90_tb              : std_logic;
  signal sys_rst_tb            : std_logic;
  signal sys_rst90_tb          : std_logic;
  signal sys_rst180_tb         : std_logic;
  signal user_data_mask        : std_logic_vector(((2*DATA_MASK_WIDTH)-1) downto 0);
  signal user_output_data      : std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
  signal user_input_data       : std_logic_vector(((2*DATA_WIDTH)-1) downto 0);
  signal user_input_address    : std_logic_vector(((ROW_ADDRESS + COLUMN_ADDRESS +
                                                    BANK_ADDRESS)- 1) downto 0);
  signal clk0dcm               : std_logic;
  signal clk90dcm		       : std_logic;          
  signal clk0_buf              : std_logic;
  signal clk90_buf             : std_logic;
  signal dcm1_lock             : std_logic;
  signal sys_clk_ibuf          : std_logic; 
  signal vcc                   : std_logic; 
  signal gnd                   : std_logic; 
  signal clk0                  : std_logic;
  signal clk90		           : std_logic;          
  signal sys_reset             : std_logic;  
  signal dcm_lock              : std_logic;

begin
  
  sys_reset <= (not sys_rst_out) when (RESET_ACTIVE_LOW = '1') else sys_rst_out;

-----------------------------------------------------------------------------
-- Clock generation and reset
-----------------------------------------------------------------------------

  process
  begin
    sys_clk <= not sys_clk;
    wait for (TCYC_SYS_DIV2);
  end process;

  sys_clk_p <= sys_clk;
  sys_clk_n <= not sys_clk;

  process
  begin
    sys_clk200 <= not sys_clk200;
    wait for (TCYC_200);
  end process;

  clk200_p <= sys_clk200;
  clk200_n <= not sys_clk200;

  process
  begin
    sys_rst_n <= '0';
    wait for 200 ns;
    sys_rst_n <= '1';
    wait;
  end process;

    sys_rst_out <= (sys_rst_n) when (RESET_ACTIVE_LOW = '1') else (not sys_rst_n);

  
  lvds_clk_input : IBUFGDS_LVDS_25
    port map(
      I  => sys_clk_p,
      IB => sys_clk_n,
      O  => sys_clk_ibuf
      );

  vcc   <= '1';
  gnd   <= '0';
  clk0  <= clk0_buf;
  clk90 <= clk90_buf;

  DCM_INST1 : DCM
    generic map(
      DLL_FREQUENCY_MODE    => "LOW",
      DUTY_CYCLE_CORRECTION => true
      )
    port map (
      CLKIN    => sys_clk_ibuf,
      CLKFB    => clk0_buf,
      DSSEN    => gnd,
      PSINCDEC => gnd,
      PSEN     => gnd,
      PSCLK    => gnd,
      RST      => sys_reset,
      CLK0     => clk0dcm,
      CLK90    => clk90dcm,
      CLK180   => open,
      CLK270   => open,
      CLK2X    => open,
      CLK2X180 => open,
      CLKDV    => open,
      CLKFX    => open,
      CLKFX180 => open,
      LOCKED   => dcm1_lock,
      PSDONE   => open,
      STATUS   => open
      );

  BUFG_CLK0  : BUFG
    port map (
      O  => clk0_buf,
      I  => clk0dcm
      );
  BUFG_CLK90 : BUFG
    port map (
      O  => clk90_buf,
      I  => clk90dcm
      );

  dcm_lock <= dcm1_lock;


----------------------------------------------------------------------------
-- FPGA memory controller
----------------------------------------------------------------------------

  u_mem_controller : mig_23
    port map (
            
      clk_int                      => clk0,
      clk90_int                    => clk90,
      dcm_lock                     => dcm_lock,
      reset_in_n                   => sys_rst_out,
      cntrl0_ddr_ras_n             => ddr_ras_l_fpga,
      cntrl0_ddr_cas_n             => ddr_cas_l_fpga,
      cntrl0_ddr_we_n              => ddr_we_l_fpga,
      cntrl0_ddr_cs_n              => ddr_cs_l_fpga,
      cntrl0_ddr_cke               => ddr_cke_fpga,
      cntrl0_ddr_dm                => ddr_dm_fpga,
      cntrl0_ddr_dq                => ddr_dq_fpga,
      cntrl0_ddr_dqs               => ddr_dqs_fpga,
      cntrl0_ddr_ck                => ddr_clk_fpga,
      cntrl0_ddr_ck_n              => ddr_clk_n_fpga,
      cntrl0_ddr_ba                => ddr_ba_fpga,
      cntrl0_ddr_a                 => ddr_address_fpga,
      cntrl0_burst_done            => burst_done,
      cntrl0_init_val              => init_done,
      cntrl0_ar_done               => ar_done,
      cntrl0_user_data_valid       => user_data_valid,
      cntrl0_auto_ref_req          => auto_ref_req,
      cntrl0_user_cmd_ack          => user_cmd_ack,
      cntrl0_user_command_register => user_command_register,
      cntrl0_clk_tb                => clk_tb,
      cntrl0_clk90_tb              => clk90_tb,
      cntrl0_sys_rst_tb            => sys_rst_tb,
      cntrl0_sys_rst90_tb          => sys_rst90_tb,
      cntrl0_sys_rst180_tb         => sys_rst180_tb,
      cntrl0_user_output_data      => user_output_data,
      cntrl0_user_input_data       => user_input_data,
      cntrl0_user_input_address    => user_input_address,
      cntrl0_user_data_mask        => user_data_mask,
      cntrl0_rst_dqs_div_in        => rst_dqs_div_loop,
      cntrl0_rst_dqs_div_out       => rst_dqs_div_loop
      );

-----------------------------------------------------------------------------
-- Delay insertion modules for each signal
-- Use standard non-inertial (transport) delay mechanism for unidirectional
-- signals from FPGA to SDRAM
-----------------------------------------------------------------------------

  ddr_address_sdram <= TRANSPORT ddr_address_fpga after TPROP_PCB_CTRL;
  ddr_ba_sdram      <= TRANSPORT ddr_ba_fpga      after TPROP_PCB_CTRL;
  ddr_ras_l_sdram   <= TRANSPORT ddr_ras_l_fpga   after TPROP_PCB_CTRL;
  ddr_cas_l_sdram   <= TRANSPORT ddr_cas_l_fpga   after TPROP_PCB_CTRL;
  ddr_we_l_sdram    <= TRANSPORT ddr_we_l_fpga    after TPROP_PCB_CTRL;
  ddr_cs_l_sdram    <= TRANSPORT ddr_cs_l_fpga    after TPROP_PCB_CTRL;
  ddr_cke_sdram     <= TRANSPORT ddr_cke_fpga     after TPROP_PCB_CTRL;
  ddr_clk_sdram     <= TRANSPORT ddr_clk_fpga     after TPROP_PCB_CTRL;
  ddr_clk_n_sdram   <= TRANSPORT ddr_clk_n_fpga   after TPROP_PCB_CTRL;
  ddr_reset_n_sdram <= TRANSPORT ddr_reset_n_fpga after TPROP_PCB_CTRL;
  ddr_dm_sdram      <= TRANSPORT ddr_dm_fpga      after TPROP_PCB_DATA;
--  command1          <= (ddr_ras_l_fpga & ddr_cas_l_fpga & ddr_we_l_fpga);

  dq_delay: for i in 0 to DATA_WIDTH - 1 generate
    u_delay_dq: WireDelay
      generic map (
        Delay_g => TPROP_PCB_DATA,
        Delay_rd => TPROP_PCB_DATA_RD)
      port map(
        A => ddr_dq_fpga(i),
        B => ddr_dq_sdram(i),
	reset => sys_rst_n);
  end generate;

  dqs_delay: for i in 0 to DATA_STROBE_WIDTH - 1 generate
    u_delay_dqs: WireDelay
      generic map (
        Delay_g => TPROP_DQS,
        Delay_rd => TPROP_DQS_RD)
      port map(
        A => ddr_dqs_fpga(i),
        B => ddr_dqs_sdram(i),
	reset => sys_rst_n);
  end generate;

  -----------------------------------------------------------------------------
  -- Extra one clock pipelining for RDIMM address and 
  -- control signals is implemented here (Implemented external to memory model)
  -----------------------------------------------------------------------------
  
  process (ddr_clk_sdram)
  begin
    if (rising_edge(ddr_clk_sdram(0))) then
      if (ddr_reset_n_sdram = '0') then
        ddr_ras_l_reg <= '1';
        ddr_cas_l_reg <= '1';
        ddr_we_l_reg  <= '1';
        ddr_cs_l_reg  <= '1';
        ddr_cke_reg   <= '0';
      else
        ddr_address_reg <= TRANSPORT ddr_address_sdram after TCYC_SYS_DIV2;
        ddr_ba_reg      <= TRANSPORT ddr_ba_sdram      after TCYC_SYS_DIV2;
        ddr_cke_reg     <= TRANSPORT ddr_cke_sdram     after TCYC_SYS_DIV2;
        ddr_ras_l_reg   <= TRANSPORT ddr_ras_l_sdram   after TCYC_SYS_DIV2;
        ddr_cas_l_reg   <= TRANSPORT ddr_cas_l_sdram   after TCYC_SYS_DIV2;
        ddr_we_l_reg    <= TRANSPORT ddr_we_l_sdram    after TCYC_SYS_DIV2;
        ddr_cs_l_reg    <= TRANSPORT ddr_cs_l_sdram    after TCYC_SYS_DIV2;
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- Memory model instances
  -----------------------------------------------------------------------------
  
  COMP_16 : if (DEVICE_WIDTH = 16) generate
-----------------------------------------------------------------------------
-- if memory part is x16
-----------------------------------------------------------------------------
    REGISTERED_DIMM : if (REG_ENABLE = 1) generate
-----------------------------------------------------------------------------
-- if the memory part is Registered DIMM
-----------------------------------------------------------------------------
      GEN : for i in 0 to (DATA_STROBE_WIDTH/2 - 1) generate
        
        u_mem0 : ddr_model
          port map (
            Dq    => ddr_dq_sdram((16*(i+1))-1 downto i*16),
            Dm    => ddr_dm_sdram((2*(i+1))-1 downto i*2),
            Dqs   => ddr_dqs_sdram((2*(i+1))-1 downto i*2),
            Addr  => ddr_address_reg,
            Ba    => ddr_ba_reg,
            Clk   => ddr_clk_sdram(NO_OF_CS*i/DATA_STROBE_WIDTH),
            Clk_n => ddr_clk_n_sdram(NO_OF_CS*i/DATA_STROBE_WIDTH),
            Cke   => ddr_cke_reg,
            Cs_n  => ddr_cs_l_reg,
            Ras_n => ddr_ras_l_reg,
            Cas_n => ddr_cas_l_reg,
            We_n  => ddr_we_l_reg
            );
      end generate GEN;
    end generate REGISTERED_DIMM;
-----------------------------------------------------------------------------
-- if the memory part is component or unbuffered DIMM
-----------------------------------------------------------------------------
    COMP16_MUL8 : if (((DATA_WIDTH mod 16) /= 0) and (REG_ENABLE = 0)) generate
-----------------------------------------------------------------------------
-- for the memory part x16, if the data width is not multiple
-- of 16, memory models are instantiated for all data with x16
-- memory model and except for MSB data. For the MSB data
-- of 8 bits, all memory data, strobe and mask data signals are
-- replicated to make it as x16 part. For example if the design
-- is generated for data width of 72, memory model x16 parts
-- instantiated for 4 times with data ranging from 0 to 63.
-- For MSB data ranging from 64 to 71, one x16 memory model
-- by replicating the 8-bit data twice and similarly
-- the case with data mask and strobe.
-----------------------------------------------------------------------------
      GEN : for i in 0 to (DATA_WIDTH/16 - 1) generate
        
        u_mem0 : ddr_model
          port map (
            Dq    => ddr_dq_sdram((16*(i+1))-1 downto i*16),
            Dqs   => ddr_dqs_sdram((2*(i+1))-1 downto i*2),
            Addr  => ddr_address_sdram,
            Ba    => ddr_ba_sdram,
            Clk   => ddr_clk_sdram(i),
            Clk_n => ddr_clk_n_sdram(i),
            Cke   => ddr_cke_sdram,
            Cs_n  => ddr_cs_l_sdram,
            Ras_n => ddr_ras_l_sdram,
            Cas_n => ddr_cas_l_sdram,
            We_n  => ddr_we_l_sdram,
            Dm    => ddr_dm_sdram((2*(i+1))-1 downto i*2)
            );
      end generate GEN;

-----------------------------------------------------------------------------      
--Logic to assign the remaining bits of DQ and DQS
-----------------------------------------------------------------------------
      command <= (ddr_ras_l_fpga & ddr_cas_l_fpga & ddr_we_l_fpga);

      process(ddr_clk_fpga)
      begin
        if (rising_edge(ddr_clk_fpga(0))) then
          if (sys_rst_n = '0') then
            enable   <= '0';
            enable_o <= '0';
          elsif (command = "100") then
            enable_o <= '0';
          elsif (command = "101") then
            enable_o <= '1';
          else
            enable_o <= enable_o;
          end if;
          enable     <= enable_o;
        end if;
      end process;

-----------------------------------------------------------------------------
--read
-----------------------------------------------------------------------------
      
      ddr_dq_sdram(DATA_WIDTH - 1 downto DATA_WIDTH - 8) <= dq_vector(7 downto 0)
                                                            when enable = '1'
                                                            else "ZZZZZZZZ";
      ddr_dqs_sdram(DATA_STROBE_WIDTH - 1)               <= dqs_vector(0)
                                                            when enable = '1'
                                                            else 'Z';

-----------------------------------------------------------------------------
--write
-----------------------------------------------------------------------------
      
      dq_vector(7 downto 0)  <= ddr_dq_sdram(DATA_WIDTH - 1 downto DATA_WIDTH - 8)
                                when enable_o = '0' else "ZZZZZZZZ";
      dqs_vector(0)          <= ddr_dqs_sdram(DATA_STROBE_WIDTH - 1)
                                when enable_o = '0' else 'Z';

      dq_vector(15 downto 8) <= dq_vector(7 downto 0);
      dqs_vector(1)          <= dqs_vector(0);
      ddr_dm_8_16 <= ddr_dm_sdram(DATA_MASK_WIDTH - 1) & ddr_dm_sdram(DATA_MASK_WIDTH - 1);
      

      u_mem1 : ddr_model
        port map (
          Dq    => dq_vector,
          Dqs   => dqs_vector,
          Addr  => ddr_address_sdram,
          Ba    => ddr_ba_sdram,
          Clk   => ddr_clk_sdram(CLK_WIDTH - 1),
          Clk_n => ddr_clk_n_sdram(CLK_WIDTH - 1),
          Cke   => ddr_cke_sdram,
          Cs_n  => ddr_cs_l_sdram,
          Ras_n => ddr_ras_l_sdram,
          Cas_n => ddr_cas_l_sdram,
          We_n  => ddr_we_l_sdram,
          Dm    => ddr_dm_8_16
          );
    end generate COMP16_MUL8;

    COMP16_MUL16 : if (((DATA_WIDTH mod 16) = 0) and (REG_ENABLE = 0)) generate
-----------------------------------------------------------------------------
-- if the data width is multiple of 16
-----------------------------------------------------------------------------
      GEN : for i in 0 to ((DATA_STROBE_WIDTH/2) - 1) generate
        
        u_mem0 : ddr_model
          port map (
            Dq    => ddr_dq_sdram((16*(i+1))-1 downto i*16),
            Dqs   => ddr_dqs_sdram((2*(i+1))-1 downto i*2),
            Addr  => ddr_address_sdram,
            Ba    => ddr_ba_sdram,
            Clk   => ddr_clk_sdram(i),
            Clk_n => ddr_clk_n_sdram(i),
            Cke   => ddr_cke_sdram,
            Cs_n  => ddr_cs_l_sdram,
            Ras_n => ddr_ras_l_sdram,
            Cas_n => ddr_cas_l_sdram,
            We_n  => ddr_we_l_sdram,
            Dm    => ddr_dm_sdram((2*(i+1))-1 downto i*2)
            );
      end generate GEN;
    end generate COMP16_MUL16;
  end generate COMP_16;

  COMP_8 : if (DEVICE_WIDTH = 8) generate
-----------------------------------------------------------------------------
-- if the memory part is x8
-----------------------------------------------------------------------------
    REGISTERED_DIMM : if (REG_ENABLE = 1) generate
-----------------------------------------------------------------------------
-- if the memory part is Registered DIMM
-----------------------------------------------------------------------------
      GEN : for i in 0 to (DATA_STROBE_WIDTH - 1) generate
        
        u_mem0 : ddr_model
          port map (
            Dq    => ddr_dq_sdram((8*(i+1))-1 downto i*8),
            Dm    => ddr_dm_sdram(i downto i),
            Dqs   => ddr_dqs_sdram(i downto i),
            Addr  => ddr_address_reg,
            Ba    => ddr_ba_reg,
            Clk   => ddr_clk_sdram(NO_OF_CS*i/DATA_STROBE_WIDTH),
            Clk_n => ddr_clk_n_sdram(NO_OF_CS*i/DATA_STROBE_WIDTH),
            Cke   => ddr_cke_reg,
            Cs_n  => ddr_cs_l_reg,
            Ras_n => ddr_ras_l_reg,
            Cas_n => ddr_cas_l_reg,
            We_n  => ddr_we_l_reg
            );
      end generate GEN;
    end generate REGISTERED_DIMM;
    COMP8_MUL8 : if (REG_ENABLE = 0) generate
-----------------------------------------------------------------------------
-- if the memory part is component or unbuffered DIMM
-----------------------------------------------------------------------------
      GEN : for i in 0 to DATA_STROBE_WIDTH - 1 generate
        
        u_mem0 : ddr_model
          port map (
            Dq    => ddr_dq_sdram((8*(i+1))-1 downto i*8),
            Dqs   => ddr_dqs_sdram(i downto i),
            Addr  => ddr_address_sdram,
            Ba    => ddr_ba_sdram,
            Clk   => ddr_clk_sdram(i),
            Clk_n => ddr_clk_n_sdram(i),
            Cke   => ddr_cke_sdram,
            Cs_n  => ddr_cs_l_sdram,
            Ras_n => ddr_ras_l_sdram,
            Cas_n => ddr_cas_l_sdram,
            We_n  => ddr_we_l_sdram,
            Dm    => ddr_dm_sdram(i downto i)
            );
      end generate GEN;
    end generate COMP8_MUL8;
  end generate COMP_8;

  COMP_4 : if (DEVICE_WIDTH = 4) generate
-----------------------------------------------------------------------------
-- if the memory part is x4
-----------------------------------------------------------------------------
    REGISTERED_DIMM : if (REG_ENABLE = 1) generate
-----------------------------------------------------------------------------
-- if the memory part is Registered DIMM
-----------------------------------------------------------------------------
      GEN : for i in 0 to (DATA_STROBE_WIDTH - 1) generate
        
        u_mem0 : ddr_model
          port map (
            Dq    => ddr_dq_sdram((4*(i+1))-1 downto i*4),
            Dm    => ddr_dm_sdram(i/2 downto i/2),
            Dqs   => ddr_dqs_sdram(i downto i),
            Addr  => ddr_address_reg,
            Ba    => ddr_ba_reg,
            Clk   => ddr_clk_sdram(NO_OF_CS*i/DATA_STROBE_WIDTH),
            Clk_n => ddr_clk_n_sdram(NO_OF_CS*i/DATA_STROBE_WIDTH),
            Cke   => ddr_cke_reg,
            Cs_n  => ddr_cs_l_reg,
            Ras_n => ddr_ras_l_reg,
            Cas_n => ddr_cas_l_reg,
            We_n  => ddr_we_l_reg
            );
      end generate GEN;
    end generate REGISTERED_DIMM;
    COMP4_MUL4 : if (REG_ENABLE = 0) generate
-----------------------------------------------------------------------------
-- if the memory part is component or unbuffered DIMM
-----------------------------------------------------------------------------
      GEN : for i in 0 to DATA_STROBE_WIDTH - 1 generate
        
        u_mem0 : ddr_model
          port map (
            Dq    => ddr_dq_sdram((4*(i+1))-1 downto i*4),
            Dqs   => ddr_dqs_sdram(i downto i),
            Addr  => ddr_address_sdram,
            Ba    => ddr_ba_sdram,
            Clk   => ddr_clk_sdram(i),
            Clk_n => ddr_clk_n_sdram(i),
            Cke   => ddr_cke_sdram,
            Cs_n  => ddr_cs_l_sdram,
            Ras_n => ddr_ras_l_sdram,
            Cas_n => ddr_cas_l_sdram,
            We_n  => ddr_we_l_sdram,
            Dm    => ddr_dm_sdram(i/2 downto i/2)
            );
      end generate GEN;
    end generate COMP4_MUL4;
  end generate COMP_4;

-----------------------------------------------------------------------------
-- synthesizable test bench provided for wotb designs
-----------------------------------------------------------------------------

    test_bench_00 : mig_23_test_bench_0
    port map (
      fpga_clk         => clk_tb,
      fpga_rst90       => sys_rst90_tb,
      fpga_rst180      => sys_rst180_tb,
      clk90            => clk90_tb,
      burst_done       => burst_done,
      init_done        => init_done,
      auto_ref_req     => auto_ref_req,
      ar_done          => ar_done,
      u_ack            => user_cmd_ack,
      u_data_val       => user_data_valid,
      u_data_o         => user_output_data,
      u_addr           => user_input_address,
      u_cmd            => user_command_register,
      u_data_m         => user_data_mask,
      u_data_i         => user_input_data,
      led_error_output => error,
      data_valid_out   =>  data_valid_out
      );

end architecture;
