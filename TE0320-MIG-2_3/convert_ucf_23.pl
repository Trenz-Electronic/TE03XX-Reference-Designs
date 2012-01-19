#!/usr/local/bin/perl -w
#******************************************************************************
#
#       XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
#       AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
#       SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
#       OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
#       APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
#       THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
#       AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
#       FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
#       WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
#       IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
#       REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
#       INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
#       FOR A PARTICULAR PURPOSE.
#
#       (c) Copyright 2007 Xilinx Inc.
#       All rights reserved.
#
#
#******************************************************************************
use strict;
use Getopt::Long;

# global variables
my %options;
my $mem_type;
my $input_file;
my $mhs_file;
my $output_file;
my $answer;
my %mpmc = ();
my %mhs_inst = ();
my %mhs_port = ();
my $mpmc_core = "mpmc_core_0";
my $mpmc_full_phy_path;
my $mpmc_phy;
my $mpmc_inst;
my $mih;
my $mig;
my $mig_pin_prefix = "cntrl0";
my $count;
my %conversions;
my $linenew;
my $saveline = '';
my $clk_period;

my $usage = "This program converts a MIG .ucf file to an EDK .ucf file

example usage: 
\tconvert_ucf.pl [--mhs <MHS file>] <Mig UCF>  <Output UCF>

where:
<mhs file> is an optional mhs file to read to parse the pin names
<input_file> is the name of the .ucf file from the MIG tool (v2.0. v2.1, v2.2 only)
<output_file> is the desired name of the output .ucf file. 
If no <output_file> name is given, the <output_file> will be named system.ucf\n\n";

GetOptions ( "mhs=s" => \$mhs_file ) or die $usage;

if ($#ARGV != 1)
{
    die $usage;
}

$input_file = $ARGV[0];
$output_file = $ARGV[1];

# TODO: sanity check
if ($ARGV[1])
{
}
if ($ARGV[2])
{
}

open (IN, $input_file) ||
    die "ERROR: Couldn't open input data file $input_file\n\n$usage";

if (defined $mhs_file) { 
    open (MHS, $mhs_file) ||
        die "ERROR: Couldn't open input data file $mhs_file\n\n$usage";
}
$answer = "";

while ((-e $output_file) && ($answer ne "y"))
{
    while (!(($answer eq "y") || ($answer eq "n")))
    {
        print "$output_file already exists, do you want to overwrite the existing file? (y/n)";
        $answer = <STDIN>;
        $answer =~ s/\s*$//g;
        $answer = lc($answer);
    }
    if ($answer eq "n")
    {
        print "please enter a new name for the output file: ";
        $output_file = <STDIN>;
        $output_file =~ s/\s*$//g;
    }

}
 
open (OUT, ">$output_file") ||
    die "ERROR: Couldn't open output file\n";

# Read MHS to get the pin names and parameters, set $mem_type and $mpmc_inst

if (defined $mhs_file)  {
    # First Pass in MHS to get MPMC Instances
    while (<MHS>)
    {
        if (m/^\s*BEGIN\s*mpmc/i..m/^\s*END/i) {
            chomp;
            if (m/^\s*BEGIN\s*mpmc/i) { 
                # create new hash
                %mhs_inst = ();

                # Fill in default memory type
               $mhs_inst{ 'PARAMETER' }{ 'C_MEM_TYPE' } = "DDR2";
               # Fill in default memory
               $mhs_inst{ 'PARAMETER' }{ 'C_MPMC_CLK0_PERIOD_PS' } = "10000";

            } elsif (m/^\s*END/i) { 
                if (defined $mhs_inst{'PARAMETER'}{'INSTANCE'}) {
                    my $inst = $mhs_inst{'PARAMETER'}{'INSTANCE'};
                    # hack until i find a beter way to do the thing below
                    #$mpmc{ $mhs_inst{'PARAMETER'}{'INSTANCE'} } = %mhs_inst;
                    foreach my $keyword (keys %mhs_inst) { 
                        foreach my $key (keys %{$mhs_inst{$keyword}}) { 
                            $mpmc{ $inst }{ $keyword }{ $key } = $mhs_inst{$keyword}{$key};
                        }
                    }
               }
               else {
                   die "Error reading MHS: No instance name found.";
               }

            }
            elsif (m/^\s*(\w+)\s+(\S+)\s*=\s*(\S+).*/)
            {
                my $keyword;
                my $id;
                my $value;

                ($keyword = uc($_)) =~ s/^\s*(\w+)\s+(\S+)\s*=\s*(\S+)/$1/;
                ($id = uc($_)) =~ s/^\s*(\S+)\s+(\S+)\s*=\s*(\S+)/$2/;
                ($value = $_) =~ s/^\s*(\S+)\s+(\S+)\s*=\s*(\S+)/$3/;
                $mhs_inst{ $keyword }{ $id } = $value;
                #print "Middle $mhs_inst{ 'PARAMETER' }{ 'C_MEM_TYPE' }\n";
                #print "$keyword->$id = $value\n";
            }
        }

    }

    # Second Pass in MHS to get External Ports of the mhs
    seek MHS,0,0; 
    while (<MHS>)
    {
        chomp;
        if (m/^\s*BEGIN\s*/i..m/^\s*END/i) {
            # Do nothing if inside an instance
        }
        elsif (m/^\s*(port)\s+(\S+)\s*=\s*(\S+).*/i)
        {
           my $name;
           my $value;
           ($name = $_) =~ s/^\s*(port)\s+(\S+)\s*=\s*(\w+).*/$2/i;
           ($value = $_) =~ s/^\s*(port)\s+(\S+)\s*=\s*(\w+).*/$3/i;
           # store this hash {Internal Port Name} = External Port Name hash for easy lookup
           $mhs_port{ $value }{ 'NAME' } = $name;

           # get attributes so we know if it is a vector or not
           my @attr = split(',');
           shift @attr;

           foreach my $attr (@attr) {
               my $attr_name;
               my $attr_val;
               ($attr_name = $attr) =~ s/\s*(\S+)\s*=\s*(\S+)\s*/$1/;
               ($attr_val = $attr) =~ s/\s*(\S+)\s*=\s*(\S+)\s*/$2/;
               $mhs_port{ $value }{ uc($attr_name) } = $attr_val;
           }
        }

    }
    close MHS;

    # If more than 1 instance of mpmc, pick one.
    if (keys(%mpmc) > 1)
    {
        $answer = 0;

        while ($answer < 1 or $answer > keys(%mpmc))
        {
            print "MPMC Instances found in \"$mhs_file\":\n";
            $count = 1;
            foreach my $inst (sort keys %mpmc) 
            {
                print "\t" . $count . ") " . $inst . "\n";
                $count++;
            }
            print "Multiple MPMC instances found in MHS file.  Please choose the instance the file \"$input_file\" corresponds to (1-" . keys (%mpmc) . "): ";
            $answer = <STDIN>;
            chomp $answer;
            unless ($answer =~ m/^[0-9]+$/) {
                $answer = 0;
            }
        }

    } 

    $count = 1;

    foreach my $inst (sort keys %mpmc) 
    {
        if (((keys %mpmc) == 1) or ($count == $answer)) 
        {
            $mpmc_inst = $inst;
        }
        $count++;
    }

    print "Set MPMC Instance to " . $mpmc_inst . "\n";

    $mem_type = uc($mpmc{$mpmc_inst}{ 'PARAMETER' }{ 'C_MEM_TYPE' });
    print "Mem Type is $mem_type\n";

    unless ($mem_type eq "DDR2" or $mem_type eq "DDR")  
    {
        die "Memory type \"$mem_type\" is not supported for this script.\n"
    }
    $clk_period = $mpmc{$mpmc_inst}->{ 'PARAMETER' }{ 'C_MPMC_CLK0_PERIOD_PS'} ;
    print "Clk Period is $clk_period ps";
}
else
{
    $mpmc_inst = "*";
    $mem_type = "DDR*";
    $clk_period = 3000; # defaulting to worst case speed of 333MHz
}


# Useful for debugging to print out the table of mpmc ports/parameters
#foreach my $mi (sort (keys %mpmc)) 
#{   
#    $mpmc_inst = $mi;
#    $mih = $mpmc{$mpmc_inst};
#    print "Instance $mpmc_inst\n";
#    $mem_type = uc($mpmc{$mpmc_inst}{ 'PARAMETER' }{ 'C_MEM_TYPE' });
#    print "Mem Type is $mem_type\n";
#    foreach my $keyword (keys %{$mih}) {
#        print $keyword . "\n";
#        foreach my $val  (keys %{$mih->{$keyword}}) {
#                print "$keyword $val = $mpmc{$mpmc_inst}->{$keyword}->{$val}" . "\n";
#        }
#    }
#    
#}

# set parameters for this design
$mpmc_phy = "gen_??_" . lc($mem_type) . "_phy.mpmc_phy_if_0";
$mpmc_full_phy_path = "*/$mpmc_inst/$mpmc_core/$mpmc_phy";
$mig = $mig_pin_prefix . "_" . $mem_type;

## BEGIN Constraints Modifications##

# Comment out Clock/Reset/debug Constraints
$conversions{qr|(net.*sys_clk)|i} = "#\$1";
$conversions{qr|(timespec\s*"ts_sys_clk\w*")|i} = "#\$1";
$conversions{qr|(.*clk_dcm0)|i} = "#\$1";
$conversions{qr|(.*clk200)|i} = "#\$1";
$conversions{qr/(NET.*(reset_in_n|sys_rst))/i} = "#\$1";
$conversions{qr/NET\s*"((${mig_pin_prefix}_)?(led_error_output1|data_valid_out|(phy_)?init_done))"/} = "#NET  \"\$1\$2\"";   
$conversions{qr|^(.*idelay)|} = "#\$1";

# Top level conversions
$conversions{qr|infrastructure_top(0)?|} = "$mpmc_full_phy_path/infrastructure";
$conversions{qr/(top_00|main_00\/top0)/} = "$mpmc_full_phy_path";
$conversions{qr|u_ddr(1)?_top(_0)?/u_mem_if_top/u_phy_top|} = "$mpmc_full_phy_path";
# The line below is used if we want to include idelayctrl in the ucf.
#$conversions{qr/(\*idelay_ctrl0|u_ddr_idelay_ctrl)?\/IDELAY(CTRL)?_INST\[(\d+)\]\.u_idelayctrl/} = "*/$mpmc_inst/gen_instantiate_idelayctrls[\$3].idelayctrl0";

# Spartan3 Phy Specific
# Convert suffixes on modules
$conversions{qr|(/data_path)(0)?|} = "\$1";
$conversions{qr|(/data_read)(0)?|} = "\$1";
$conversions{qr|(/data_read_controller)(0)?|} = "\$1";
$conversions{qr|(/cal_top)(0)?|} = "\$1";
$conversions{qr|(/cal_ctl)(0)?|} = "\$1";
$conversions{qr|(/cal_ctl)(0)?"|} = "\$1*\"";
$conversions{qr|(/tap_dly)(0)?/|} = "\$1/";
$conversions{qr|(/tap_dly)(0)?"|} = "\$1*\"";
$conversions{qr|(_controller)(0)?/gen_wr_addr|} = "/gen_wr_addr";

# Transformations done here.  S3 Has major structural changes
$conversions{qr|/l(\d+)|} = "/gen_no_sim.l\$1";  # Transform '/l0' to '/gen_no_sim.l0'
$conversions{qr|gen_tap1|} = "gen_no_sim.gen_tap1";  # Transform 'gen_tap1' to '/gen_no_sim.gen_tap1'
$conversions{qr|/controller(0)?/rst_dqs_div_r|} = "/dqs_div/dqs_rst_ff";  
$conversions{qr|gen_delay\*dqs_delay_col\*/delay\*|} = "gen_dqs[*]*u_dqs_delay_col*/delay*";
$conversions{qr|gen_strobe\[(\d+)\]\.strobe(_n)*/fifo_bit(\d+)|} = "gen_data[\$1]*strobe0\$2/gen_data[\$3]*u_fifo_bit";
$conversions{qr|gen_delay\[(\d+)\]\.dqs_delay_col(\d+)/(\w+)|} = "gen_dqs[\$1]*u_dqs_delay_col\$2/gen_delay.\$3";
$conversions{qr|fifo_(\d+)_wr_addr_inst/bit(\d+)|} = "u_fifo_\$1_wr_addr/gen_addr[\$2].u_addr_bit";
$conversions{qr|gen_wr_en\[(\d+)\]\.fifo_(\d+)_wr_en_inst|} = "gen_wr[\$1].u_fifo_\$2_wr_en/*";
$conversions{qr|(rst_dqs_div_delayed)/(\w+[^*]")|} = ".\$1/gen_delay.\$2";
$conversions{qr|(rst_dqs_div_delayed)/(\w+\*")|} = ".\$1/\$2";
$conversions{qr|data_read(0)?/fifo\*_wr_en\*|} = "fifo*_wr_en*";
$conversions{qr|fifo\*_wr_addr\[\*\]|} = "fifo*_wr_addr_out*";

##Virtex-4 DDR specific
$conversions{qr|(/iobs_0)(0)?|} = "\$1";
$conversions{qr|(/tap_logic_0)(0)?|} = "\$1";
$conversions{qr|v4_dqs_iob(\d)|} = "gen_v4_phy_dqs_iob[\$1].";
$conversions{qr|(^.*data_tap_gp\d)|} = "#\$1";

#Virtex-5 Specific
# DDR2
$conversions{qr|"TS_SYS_CLK"\s*\*\s*4|} = ($clk_period * 4) . " ps";
$conversions{qr|U_PHY|} = ($clk_period * 4) . " ps";
$conversions{qr|\*/u_phy_calib/|} = "$mpmc_full_phy_path/u_phy_io_0/u_phy_calib_0/";
$conversions{qr|\*/u_phy_init/|} = "$mpmc_full_phy_path/u_phy_init_0/";
$conversions{qr|\*/u_phy_io/|} = "$mpmc_full_phy_path/u_phy_io_0/";
$conversions{qr|^(.*TNM_RDEN_SEL_MUX)|} = "#\$1";

# Pin names conversion
# Convert the MIG pin names to the external pin names specified in the MHS. 
# Some of these are more complicated to convert when moving from vector to non-vectors and vice-versa
if (defined $mhs_file) {
    if (defined $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CLK"}}{ 'VEC' }) {
        $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_CK([^\w])|i}     = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CLK"}}{ 'NAME' } . "\$2";
        $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_CK_N|i}          = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CLK_N" }}{ 'NAME' };
    }
    else
    {
        $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_CK(\s*\[.\])?|i}     = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CLK"}}{ 'NAME' };
        $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_CK_N(\s*\[.\])?|i}          = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CLK_N" }}{ 'NAME' };
    }
    $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_DQS_N|i}         = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "DDR2_DQS_N"}}{ 'NAME' } if (defined $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_DQS_N"});
    $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_DQS([^\w])|i}    = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_DQS"}}{ 'NAME' } . "\$2";
    $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_DQ([^\w])|i}     = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_DQ"}}{ 'NAME' }  . "\$2";
    $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_a|i}             = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_ADDR"}}{ 'NAME' };
    $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_BA|i}            = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_BANKADDR"}}{ 'NAME' };
    #$conversions{qr|(${mig_pin_prefix}_)?${mem_type}_CKE|i}           = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CE"}}{ 'NAME' };
    if (defined $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CE"}}{ 'VEC' } and ($mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CE"}}{ 'VEC' } =~ m/\[0+:0+\]/)) {
        $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_CKE(\[.\])?|i}           = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CE"}}{ 'NAME' } . "[0]";
    }
    elsif (defined $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CE"}}{ 'VEC' }) {
        $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_CKE|i}           = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CE"}}{ 'NAME' };
    }
    else {
        $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_CKE(\s*\[.\])?|i}           = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CE"}}{ 'NAME' };
    }
    if (defined $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CS_N"}}{ 'VEC' } and ($mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CS_N"}}{ 'VEC' } =~ m/\[0+:0+\]/)) {
        $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_CS_N(\[.\])?|i}          = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CS_N"}}{ 'NAME' } . "[0]";
    }
    elsif (defined $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CS_N"}}{ 'VEC' }) {
        $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_CS_N|i}          = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CS_N"}}{ 'NAME' };
    }
    else {
        $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_CS_N(\s*\[.\])?|i}          = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CS_N"}}{ 'NAME' };
    }
         
    $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_RAS_N|i}         = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_RAS_N"}}{ 'NAME' };
    $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_CAS_N|i}         = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_CAS_N"}}{ 'NAME' };
    $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_WE_N|i}          = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_WE_N"}}{ 'NAME' };
    if (defined $mpmc{$mpmc_inst}->{ 'PORT' }{ "DDR2_ODT"}) { 
        if (defined $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_ODT"}}{ 'VEC' } and ($mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_ODT"}}{ 'VEC' } =~ m/\[0+:0+\]/)) {
            $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_ODT(\[.\])?|i}           = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "DDR2_ODT"}}{ 'NAME' } . "[0]";
        }
        elsif (defined $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_ODT"}}{ 'VEC' }) {
            $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_ODT|i}           = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "DDR2_ODT"}}{ 'NAME' }; 
        }
        else {
            $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_ODT(\s*\[.\])?|i}           = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "DDR2_ODT"}}{ 'NAME' };
        }
    } 
    $conversions{qr|(${mig_pin_prefix}_)?${mem_type}_DM|i}            = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_DM"}}{ 'NAME' };
    $conversions{qr|${mig_pin_prefix}_rst_dqs_div_in|}  = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_DQS_DIV_I"}}{ 'NAME' } if defined $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_DQS_DIV_I"} and defined $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_DQS_DIV_I"}}{ 'NAME' };
    $conversions{qr|${mig_pin_prefix}_rst_dqs_div_out|} = $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_DQS_DIV_O"}}{ 'NAME' } if defined $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_DQS_DIV_O"} and defined $mhs_port{ $mpmc{$mpmc_inst}->{ 'PORT' }{ "${mem_type}_DQS_DIV_O"}}{ 'NAME' };
}

seek IN,0,0; #Restart the input file for the modification pass

while (<IN>)                   #go through the data file
{
    $linenew = $_;
    chomp($linenew);
    if (m/^\s*[^#][^;]+\s*$/) {  # match if we have a valid line and it is not terminated by semicolon
        $saveline =  $saveline . $linenew;
        $_ = '';
    }
    elsif ($saveline ne '') {
        $_ = $saveline . " " . $_  . "\n";
        $saveline = '';
    }
    else {
        $saveline = '';
    }

    # We will comment out all the lines between these two pieces of text
    if(/paths are constrained to get rid of unconstrained paths/../Calibration Circuit Constraints/)
    {
        s/^/#/ig;
    }
#    print $line;
    foreach my $key (reverse sort (keys %conversions))
    {
        #   print $key . "\n";
        if (/$key/i)
        {
            my $one = $1;
            my $two = $2;
            my $thr = $3;
            my $mod_value = $conversions{$key};
            $one = "" if not defined $one;
            $two = "" if not defined $two;
            $thr = "" if not defined $thr;
            $mod_value =~ s/\$1/$one/ig;
            $mod_value =~ s/\$2/$two/ig;
            $mod_value =~ s/\$3/$thr/ig;
            s/$key/$mod_value/ig;
        }
    }
    print OUT;
}


close (IN);
close (OUT);
print "\nConversion complete.\n";
if (defined $mhs_file) 
{
    print "  Please check UCF file memory port names to ensure they match MHS file external port names.\n";
}
else 
{
    print "  Please modify UCF file memory port names to match MHS file external port names.\n";
    print "  Please modify UCF file clock names (for example: \"*/mpmc_core_0/Clk0\") to match the synthesis name for the outputs of the clock generator module or the DCM's that generate these clocks.\n";
}
