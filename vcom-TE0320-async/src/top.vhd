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
-- Create Date: 10.04.2013
-- Design Name: TE03XX VCOM
-- Module Name: top - RTL 
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
-------------------------------------------------------------------------------
entity top is
port ( 
	sys_clk				: in    STD_LOGIC;
	sys_rst_n			: in    STD_LOGIC;	-- aclive high
	LED					: out   STD_LOGIC_VECTOR(3 downto 0);
	USB_FD_pin			: inout STD_LOGIC_VECTOR(7 downto 0);
	USB_FLAGA_pin		: in    STD_LOGIC;
	USB_FLAGB_pin		: in    STD_LOGIC;
	USB_FLAGC_pin		: in    STD_LOGIC;
	USB_FLAGD_pin		: in    STD_LOGIC;
	USB_SLWR_pin		: out   STD_LOGIC;
	USB_SLRD_pin		: out   STD_LOGIC;
	USB_SLOE_pin		: out   STD_LOGIC;
	USB_PKTEND_pin		: out   STD_LOGIC;
	USB_FIFOADR_pin		: out   STD_LOGIC_VECTOR(1 downto 0);
	USB_IFCLK_pin		: in    STD_LOGIC
);
end top;
-------------------------------------------------------------------------------
architecture RTL of top is
-------------------------------------------------------------------------------
component fx2_interface is
port ( 
	USB_FD_I			: in  STD_LOGIC_VECTOR(7 downto 0);
	USB_FD_O			: out STD_LOGIC_VECTOR(7 downto 0);
	USB_FD_T			: out STD_LOGIC;
	USB_FLAGA_pin		: in  STD_LOGIC;
	USB_FLAGB_pin		: in  STD_LOGIC;
	USB_FLAGC_pin		: in  STD_LOGIC;
	USB_FLAGD_pin		: in  STD_LOGIC;
	USB_SLWR_pin		: out STD_LOGIC;
	USB_SLRD_pin		: out STD_LOGIC;
	USB_SLOE_pin		: out STD_LOGIC;
	USB_PKTEND_pin		: out STD_LOGIC;
	USB_FIFOADR_pin		: out STD_LOGIC_VECTOR(1 downto 0);
	USB_IFCLK_pin		: in  STD_LOGIC;
	
	tx_data				: in  STD_LOGIC_VECTOR(7 downto 0);
	tx_empty			: in  STD_LOGIC;
	tx_rd				: out STD_LOGIC;
	tx_last				: in  STD_LOGIC;
	
	rx_data				: out STD_LOGIC_VECTOR(7 downto 0);
	rx_full				: in  STD_LOGIC;
	rx_wr				: out STD_LOGIC
);
end component fx2_interface;

component fifo_512x9
port (
    clk 	: IN  STD_LOGIC;
    din 	: IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
    wr_en 	: IN  STD_LOGIC;
    rd_en 	: IN  STD_LOGIC;
    dout 	: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
    full 	: OUT STD_LOGIC;
    empty 	: OUT STD_LOGIC
  );
end component;


component user_engine is
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
end component user_engine;

-- Signals
signal USB_FD_O				: STD_LOGIC_VECTOR( 7 downto 0);
signal USB_FD_T				: STD_LOGIC;
signal usb_clk				: STD_LOGIC;
signal user2fx_f_data		: STD_LOGIC_VECTOR(8 downto 0);
signal user2fx_f_empty		: STD_LOGIC;
signal user2fx_f_rd			: STD_LOGIC;
signal user2fx_f_last		: STD_LOGIC;
signal fx2user_f_data		: STD_LOGIC_VECTOR(7 downto 0);
signal fx2user_f_full		: STD_LOGIC;
signal fx2user_f_wr			: STD_LOGIC;
signal user2fx_u_data		: STD_LOGIC_VECTOR(7 downto 0);
signal user2fx_b_data		: STD_LOGIC_VECTOR(8 downto 0);
signal user2fx_u_full		: STD_LOGIC;
signal user2fx_u_wr			: STD_LOGIC;
signal user2fx_u_last		: STD_LOGIC;
signal fx2user_u_data		: STD_LOGIC_VECTOR(8 downto 0);
signal fx2user_b_data		: STD_LOGIC_VECTOR(8 downto 0);
signal fx2user_u_empty		: STD_LOGIC;
signal fx2user_u_rd			: STD_LOGIC;
-------------------------------------------------------------------------------
begin
-------------------------------------------------------------------------------
-- Glue logic
USB_FD_pin		<= "ZZZZZZZZ" when USB_FD_T = '1' else USB_FD_O;

fx2_intf: fx2_interface
port map( 
	USB_FD_I			=> USB_FD_pin,
	USB_FD_O			=> USB_FD_O,
	USB_FD_T			=> USB_FD_T,
	USB_FLAGA_pin		=> USB_FLAGA_pin,
	USB_FLAGB_pin		=> USB_FLAGB_pin,
	USB_FLAGC_pin		=> USB_FLAGC_pin,
	USB_FLAGD_pin		=> USB_FLAGD_pin,
	USB_SLWR_pin		=> USB_SLWR_pin,
	USB_SLRD_pin		=> USB_SLRD_pin,
	USB_SLOE_pin		=> USB_SLOE_pin,
	USB_PKTEND_pin		=> USB_PKTEND_pin,
	USB_FIFOADR_pin		=> USB_FIFOADR_pin,
	USB_IFCLK_pin		=> USB_IFCLK_pin,
	tx_data				=> user2fx_f_data(7 downto 0),
	tx_empty			=> user2fx_f_empty,
	tx_rd				=> user2fx_f_rd,
	tx_last				=> user2fx_f_data(8),
	rx_data				=> fx2user_f_data(7 downto 0),
	rx_full				=> fx2user_f_full,
	rx_wr				=> fx2user_f_wr
);

fx2user_b_data	<= '0' & fx2user_f_data;
fx2user_fifo_inst: fifo_512x9
port map(
    clk 				=> USB_IFCLK_pin,
    din 				=> fx2user_b_data, 
    wr_en 				=> fx2user_f_wr,
    rd_en 				=> fx2user_u_rd,
    dout 				=> fx2user_u_data,
    full 				=> fx2user_f_full,
    empty 				=> fx2user_u_empty
);

user2fx_fifo_inst: fifo_512x9
port map(
    clk 				=> USB_IFCLK_pin,
    din 				=> user2fx_b_data,
    wr_en 				=> user2fx_u_wr,
    rd_en 				=> user2fx_f_rd,
    dout 				=> user2fx_f_data,
    full 				=> user2fx_u_full,
    empty 				=> user2fx_f_empty
);

user2fx_b_data	<= user2fx_u_last & user2fx_u_data;

user_engine_inst: user_engine
port map( 
    clk					=> USB_IFCLK_pin,
    fx2user_rd			=> fx2user_u_rd,
    fx2user_data		=> fx2user_u_data(7 downto 0),
    fx2user_empty		=> fx2user_u_empty,
    user2fx_data		=> user2fx_u_data,
    user2fx_last		=> user2fx_u_last,
    user2fx_wr 			=> user2fx_u_wr,
    user2fx_full 		=> user2fx_u_full,
	led					=> LED
);
-------------------------------------------------------------------------------
end RTL;
