--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2006 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- The following code must appear in the VHDL architecture header:

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
component mig_23
 port(
      cntrl0_ddr_dq                 : inout std_logic_vector(31 downto 0);
      cntrl0_ddr_a                  : out   std_logic_vector(12 downto 0);
      cntrl0_ddr_ba                 : out   std_logic_vector(1 downto 0);
      cntrl0_ddr_cke                : out   std_logic;
      cntrl0_ddr_cs_n               : out   std_logic;
      cntrl0_ddr_ras_n              : out   std_logic;
      cntrl0_ddr_cas_n              : out   std_logic;
      cntrl0_ddr_we_n               : out   std_logic;
      cntrl0_ddr_dm                 : out   std_logic_vector(3 downto 0);
      cntrl0_rst_dqs_div_in         : in    std_logic;
      cntrl0_rst_dqs_div_out        : out   std_logic;
      reset_in_n                    : in    std_logic;
      cntrl0_burst_done             : in    std_logic;
      cntrl0_init_val               : out   std_logic;
      cntrl0_ar_done                : out   std_logic;
      cntrl0_user_data_valid        : out   std_logic;
      cntrl0_auto_ref_req           : out   std_logic;
      cntrl0_user_cmd_ack           : out   std_logic;
      cntrl0_user_command_register  : in    std_logic_vector(2 downto 0);
      cntrl0_clk_tb                 : out   std_logic;
      cntrl0_clk90_tb               : out   std_logic;
      cntrl0_sys_rst_tb             : out   std_logic;
      cntrl0_sys_rst90_tb           : out   std_logic;
      cntrl0_sys_rst180_tb          : out   std_logic;
      cntrl0_user_data_mask         : in    std_logic_vector(7 downto 0);
      cntrl0_user_output_data       : out   std_logic_vector(63 downto 0);
      cntrl0_user_input_data        : in    std_logic_vector(63 downto 0);
      cntrl0_user_input_address     : in    std_logic_vector(24 downto 0);
      clk_int                       : in    std_logic;
      clk90_int                     : in    std_logic;
      dcm_lock                      : in    std_logic;
      cntrl0_ddr_dqs                : inout std_logic_vector(3 downto 0);
      cntrl0_ddr_ck                 : out   std_logic_vector(1 downto 0);
      cntrl0_ddr_ck_n               : out   std_logic_vector(1 downto 0)

);
end component;

-- Synplicity black box declaration
attribute syn_black_box : boolean;
attribute syn_black_box of mig_23: component is true;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
u_mig_23 :mig_23
       port map (
      cntrl0_ddr_dq                 => cntrl0_ddr_dq,
      cntrl0_ddr_a                  => cntrl0_ddr_a,
      cntrl0_ddr_ba                 => cntrl0_ddr_ba,
      cntrl0_ddr_cke                => cntrl0_ddr_cke,
      cntrl0_ddr_cs_n               => cntrl0_ddr_cs_n,
      cntrl0_ddr_ras_n              => cntrl0_ddr_ras_n,
      cntrl0_ddr_cas_n              => cntrl0_ddr_cas_n,
      cntrl0_ddr_we_n               => cntrl0_ddr_we_n,
      cntrl0_ddr_dm                 => cntrl0_ddr_dm,
      cntrl0_rst_dqs_div_in         => cntrl0_rst_dqs_div_in,
      cntrl0_rst_dqs_div_out        => cntrl0_rst_dqs_div_out,
      reset_in_n                    => reset_in_n,
      cntrl0_burst_done             => cntrl0_burst_done,
      cntrl0_init_val               => cntrl0_init_val,
      cntrl0_ar_done                => cntrl0_ar_done,
      cntrl0_user_data_valid        => cntrl0_user_data_valid,
      cntrl0_auto_ref_req           => cntrl0_auto_ref_req,
      cntrl0_user_cmd_ack           => cntrl0_user_cmd_ack,
      cntrl0_user_command_register  => cntrl0_user_command_register,
      cntrl0_clk_tb                 => cntrl0_clk_tb,
      cntrl0_clk90_tb               => cntrl0_clk90_tb,
      cntrl0_sys_rst_tb             => cntrl0_sys_rst_tb,
      cntrl0_sys_rst90_tb           => cntrl0_sys_rst90_tb,
      cntrl0_sys_rst180_tb          => cntrl0_sys_rst180_tb,
      cntrl0_user_data_mask         => cntrl0_user_data_mask,
      cntrl0_user_output_data       => cntrl0_user_output_data,
      cntrl0_user_input_data        => cntrl0_user_input_data,
      cntrl0_user_input_address     => cntrl0_user_input_address,
      clk_int                       => clk_int,
      clk90_int                     => clk90_int,
      dcm_lock                      => dcm_lock,
      cntrl0_ddr_dqs                => cntrl0_ddr_dqs,
      cntrl0_ddr_ck                 => cntrl0_ddr_ck,
      cntrl0_ddr_ck_n               => cntrl0_ddr_ck_n
);

-- INST_TAG_END ------ End INSTANTIATION Template ------------

-- You must compile the wrapper file mig_23.vhd when simulating
-- the core, mig_23. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

