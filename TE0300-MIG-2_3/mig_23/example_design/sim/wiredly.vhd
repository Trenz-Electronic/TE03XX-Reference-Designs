--*****************************************************************************
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
-- Copyright (c) 2007 Xilinx, Inc. All rights reserved.
--
-- This copyright and support notice must be retained as part 
-- of this text at all times.
--*****************************************************************************
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : 2.3
--  \   \        Application        : MIG
--  /   /        Filename           : wiredly.vhd
-- /___/   /\    Date Last Modified : $Date: 2008/08/12 15:32:22 $
-- \   \  /  \   Date Created       : Mon Jun 18 2007
--  \___\/\___\
--
-- Device      : SPARTAN
-- Design Name : DDR
-- Description: This module provide
--   the definition of a zero ohm component (A, B).
--
--   The applications of this component include:
--     . Normal operation of a jumper wire (data flowing in both directions)
--
--   The component consists of 2 ports:
--      . Port A: One side of the pass-through switch
--      . Port B: The other side of the pass-through switch

--   The model is sensitive to transactions on all ports.  Once a
--   transaction is detected, all other transactions are ignored
--   for that simulation time (i.e. further transactions in that
--   delta time are ignored).
--
-- Model Limitations and Restrictions:
--   Signals asserted on the ports of the error injector should not have
--   transactions occuring in multiple delta times because the model
--   is sensitive to transactions on port A, B ONLY ONCE during
--   a simulation time.  Thus, once fired, a process will
--   not refire if there are multiple transactions occuring in delta times.
--   This condition may occur in gate level simulations with
--   ZERO delays because transactions may occur in multiple delta times.
--*****************************************************************************

library IEEE;
use IEEE.Std_Logic_1164.all;

entity WireDelay is
  generic (
     Delay_g : time;
     Delay_rd : time);
  port
    (A     : inout Std_Logic;
     B     : inout Std_Logic;
     reset : in Std_Logic
     );
end WireDelay;


architecture WireDelay_a of WireDelay is

  signal A_r     : Std_Logic;
  signal B_r     : Std_Logic;
  signal line_en : Std_Logic;

begin

  A <= A_r;
  B <= B_r;

  ABC0_Lbl: process (reset, A, B)
  begin
    if (reset = '0') then
      line_en <= '0';
    else 
      if (A /= A_r) then
        line_en <= '0';
      elsif (B_r /= B) then
        line_en <= '1';
      else 
        line_en <= line_en;
      end if;
    end if;

  end process ABC0_Lbl;

 lnenab: process (reset, line_en, A, B)
   begin
    if (reset = '0') then
      A_r <= 'Z';
      B_r <= 'Z';
    elsif (line_en = '1') then
      A_r <= TRANSPORT B AFTER Delay_rd;
      B_r <= 'Z';
    else 
      B_r <= TRANSPORT A AFTER Delay_g;
      A_r <= 'Z';
    end if;
   end process;

end WireDelay_a;
