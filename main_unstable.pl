#!/usr/bin/perl
#Do NOT uncomment any of the comments written. All of them are either used for specifying the use of the next set of code or for debugging;
use strict;
use warnings;
use Tk;
use Tk::PNG;
my $i=0;
#require 'find_datatype.pl';
#require 'extract_data_raw.pl';
#require 'extract_data_matrix.pl';
my $t1 = 60E-09;
my $t2 = 90E-09;
my $oct_out_file = "output.m";
my @datatypes = ();
my @extract_data_raw = ();
my @extract_data_matrix = ();
my $datafile = "I_1_des.plt";
my $oct_x_array = "";
my $oct_y_array = "";
my $size_datatypes;
my $datapoints_size;
my $col = "gate OuterVoltage";
#All the commands to be used in the software are defined below. Do NOT change them for any reason;
COMMAND:	#This is a label for starting a new line for typing in a command;
#print ">>";
#my $cmd =<STDIN>;
#chomp $cmd;
#This command is used for changing the input file containing the data;
#if($cmd eq "change_file")
#{
#		print "Enter name of the data file:";
#		$datafile = <STDIN>;
		chomp $datafile;
		print "Extracting data from $datafile...\n";
		@datatypes = find_datatype($datafile);
		$size_datatypes = @datatypes;
		print "Number of datatypes used is $size_datatypes\n";
		@extract_data_raw = extract_data_raw($datafile);
		@extract_data_matrix = extract_data_matrix($size_datatypes, @extract_data_raw);
		$datapoints_size = @extract_data_raw/$size_datatypes;
		print "Number of datapoints in file is $datapoints_size\n";
		print "Extraction complete\n";
#}
#This is used to plot a graph for the given data file;
#elsif($cmd eq "plot")
#{
	chomp $col;
	print $col;
	my $col_num=0;
	for($i=0;$i<$size_datatypes;$i++)
	{
		#print "$datatypes[$i]---$col\n";
		if($datatypes[$i] eq $col)
		{
			$col_num=$i;
		}
	}
	print $col_num;


	$oct_x_array="x = [";
	$oct_y_array="y = [";
	#The following comments are to test the file. Do not uncomment them unless you have to test the code for a bug;
	#print "Preparing octave output file for writing\n";
	#system("rm $oct_out_file > /dev/null 2>&1");
	#sleep(2);
	#print "Output file prepared.\n";
	if(length($datafile)==0)
	{
		print "Invalid data file\n";
#		goto COMMAND;
	}
#	print "Enter the x axis function\n";
#	my $x_axis = <STDIN>;
#	print "Enter the y axis function\n";
#	my $y_axis = <STDIN>;
	for($i=0;$i<$datapoints_size;$i++)
	{
		$oct_x_array=$oct_x_array."$extract_data_matrix[$i][0],";
	}
	$oct_x_array=substr($oct_x_array, 0, length($oct_x_array)-1);
	$oct_x_array=$oct_x_array."]";
	#print "$oct_x_array\n";

	for($i=0;$i<$datapoints_size;$i++)
	{
		$oct_y_array=$oct_y_array."$extract_data_matrix[$i][$col_num],";
	}
	$oct_y_array=substr($oct_y_array, 0, length($oct_y_array)-1);
	$oct_y_array=$oct_y_array."]";
	#print "$oct_y_array\n";
	print "Generating Octave File...\n";
	open(my $fh, '>', $oct_out_file) or die "Could not open file '$oct_out_file'";
	print $fh "$oct_x_array\n";
	print $fh "$oct_y_array\n";
	print $fh "plot(x,y, '.-')\n";
	print $fh "xlabel(\"$datatypes[0]\")\n";
	print $fh "ylabel(\"$datatypes[$col_num]\")\n";
	close $fh;
	print "Octave file generated successfully. Executing script...\n";
	system("octave --persist output.m &");
#}
#elsif($cmd eq "pnt_plot")
#{
#	$oct_x_array="x_axis = [";
#	$oct_y_array="y_axis = [";
#	if(length($datafile)==0)
#	{
#		print "Invalid data file\n";
#		goto COMMAND;
#	}
#	print "Enter the x axis function\n";
#	my $x_axis = <STDIN>;
#	print "Enter the y axis function\n";
#	my $y_axis = <STDIN>;
#	for($i=0;$i<$datapoints_size;$i++)
#	{
#		$oct_x_array=$oct_x_array."$extract_data_matrix[$i][$x_axis],";
#	}
#	$oct_x_array=substr($oct_x_array, 0, length($oct_x_array)-1);
#	$oct_x_array=$oct_x_array."]";
#	#print "$oct_x_array\n";
#
#	for($i=0;$i<$datapoints_size;$i++)
#	{
#		$oct_y_array=$oct_y_array."$extract_data_matrix[$i][$y_axis],";
#	}
#	$oct_y_array=substr($oct_y_array, 0, length($oct_y_array)-1);
#	$oct_y_array=$oct_y_array."]";
#	#print "$oct_y_array\n";
#	print "Generating Octave File...\n";
#	open(my $fh, '>', $oct_out_file) or die "Could not open file '$oct_out_file'";
#	print $fh "$oct_x_array;\n";
#	print $fh "$oct_y_array;\n";
#	print $fh "sub_x = [x_axis(1), x_axis(2)];\n";
#	print $fh "sub_y = [x_axis(1), y_axis(2)];\n";
#	print $fh "plot(sub_x,sub_y, '.-');\n";
#	print $fh "hold on\n";
#	print $fh "i = 2;\n";
#	print $fh "buttons=1;\n";
#	print $fh "while(buttons==1 && i<length(x_axis))\n";
#	print $fh "disp('pnt_change')\n";
#	print $fh "[x(1),y(1),buttons(1)] = ginput(1);\n";
#	print $fh "i=i+1;\n";
#	print $fh "sub_x=[x_axis(i-1) , x_axis(i)];\n";
#	print $fh "sub_y=[y_axis(i-1) , y_axis(i)];\n";
#	print $fh "plot(sub_x,sub_y, '.-')\n";
#	print $fh "endwhile\n";
#	print $fh "hold off\n";
#	close $fh;
#	my $mw    = new MainWindow;
#	$mw -> geometry ("820x780");
#	my @files = <*png>;
#
#	# make one Photo object and one Button and reuse them.
#	my $shot = $mw->Photo(-file => "$files[0]"); #get first one
#	my $button = $mw->Button(-image => $shot)->pack();
#	
#		my $out;
#		print "Octave file generated successfully. Executing script...\n";
#		open($out, "octave output.m |");
#		$i=2;
#		while (<$out>)
#		{
#			if($i<=7)
#			{
#				$shot->blank; #clear out old image
#	   			$shot->read($files[$i - 1]);
#	   			$mw->update;
#	   			select(undef, undef, undef, .1);	
#	   		}
#			$i=$i+1;
#		}
#		$mw->MainLoop;
#}	
#This command is used for printing data of a certain column in the given data file;
#elsif($cmd eq "print_data")
#{
#	print "Enter data's column number\n";
#	$col = <STDIN>;
#	chomp $col;
#	print "$datatypes[$col]\n";
#	for($i=0;$i<$datapoints_size;$i++)
#	{
#		print "$extract_data_matrix[$i][$col]\n";
#	}
#}
#This command is used for finding the average of data between some specified start and end times;
#elsif($cmd eq "find_average")
#{
	my $count = 0;
	my $sum = 0;
	my $avg;
#	print "Enter data's column number\n";
#	$col = <STDIN>;
	
#	print "Enter start time\n";
#	$t1 = <STDIN>;
#	print "Enter end time\n";
#	$t2 = <STDIN>;
	for($i=0;$i<$datapoints_size;$i++)
	{
		if($extract_data_matrix[$i][0] >= $t1 and $extract_data_matrix[$i][0] <= $t2)
		{
			$count++;
			$sum = $sum + $extract_data_matrix[$i][$col_num];
		}
	}
	$avg = $sum/$count;
	print "Number of data points involved in averaging is $count\n";
	print "Average value of $datatypes[$col_num] in the given time interval is $avg\n";
#This command is used for clearing all previously used commands and output off the display
#elsif($cmd eq "clear")
#{
#	system("clear");
#}
#This command exits from the software and goes into a termainl;
#elsif($cmd eq "exit")
#{
#	exit;
#}
#This provides an error message if the given command is not part of the above specified commands;
#else
#{
#	print "$cmd is an invalid command\n";
#}
#The next line of code goes to the label 'COMMAND' where a new command input starts;
#goto COMMAND;


sub find_datatype
{
my $filename;
($filename) = @_;
# open the file
open MYFILE, "$filename" or die "could not open $filename";
my $string="";
my $true=0;
my $i=0;
# loop line by line until EOF
while(<MYFILE>) {
    #split line in a char array
    my @chars = split //;
    my $char;
    #loop char by char
    for $char(@chars) 
    { 

    	$i++;
    	if($char eq '[')
    	{
    		$true=1;
    	}

    	if($char eq ']')
    	{
    		my $udq=0; #Under Double Quotes. 0 represents 'Not under double quotes' and 1 represents 'Under Double Quotes'
    		my $string = substr $string, 1;
    		my @datatype_arr = ();
			my $datatype = "";
			$i=0;
			my $start = 1;
			my $count = 0;
			my $string_length = length($string);
			for($i=1;$i<$string_length;$i++)
			{
				my $ch = substr($string, $i+1, 1);
				if($ch eq '"' and $udq == 1)
				{
					push @datatype_arr, $datatype;
					$datatype = "";
					$udq=0;
					next;
				}
				if($ch eq '"' and $udq == 0)
				{
					$start = $i+1;
					$udq = 1;
					next;
				}

				if($udq == 1)
				{
					$datatype = $datatype.$ch;
				}

			}
    		return @datatype_arr;
    		exit;
    	}

    	if($true==1)
    	{
    		$string=$string.$char;
    	}

    }
}

# close the file
close MYFILE;
}



sub extract_data_raw
{
my $filename;
($filename) = @_;
# open the file
open MYFILE, "$filename" or die "could not open $filename";
my $string="";
my $true=0;
my $curly_count=0;
my $i=0;
my $wcb=0; #wcb stands for Within Curly Brackets. If its value is one, the character is within curly brackets. If it is zero, the character is outside curly brackets. 
# loop line by line until EOF
while(<MYFILE>) {
    #split line in a char array
    my @chars = split //;
    my $char; 
    #loop char by char
    for $char(@chars) 
    { 
    	if($char eq '{')
    	{
    		$curly_count+=1;
    		if($curly_count==2)
    		{
    		$wcb=1;
    		next;
			}    	
    	}

    	

    	if($char eq '}' and $wcb==1)
    	{
    		$wcb=0;
    		my @data_array = split ' ', $string;
    		return @data_array;
    		exit;
    	}

    	if($wcb==1)
    	{
    		$string = $string.$char;
    	}
    	

    }
}

# close the file
close MYFILE;
}


sub extract_data_matrix
{
    my $i=0;
    my $j=0;
    my @data_raw = @_;
    my $size = $data_raw[0];
    my @data_matrix = ();
    shift @data_raw;
    $i = 0;
    my $element;
    foreach $element (@data_raw)
    {
        if($j==$size)
        {
            $i++;
            $j=0;
        }
        $data_matrix[$i][$j]=$element;
        $j++;
    }
    return @data_matrix;

}