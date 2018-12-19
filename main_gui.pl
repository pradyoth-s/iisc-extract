#!/usr/bin/perl
#Do NOT uncomment any of the comments written. All of them are either used for specifying the use of the next set of code or for debugging;
use strict;
use warnings;
use Tk;
use Tk::PNG;
use Tk::Frame;
my $i=0;
require 'find_datatype.pl';
require 'extract_data_raw.pl';
require 'extract_data_matrix.pl';
my $oct_out_file = "output.m";
my @datatypes = ();
my @extract_data_raw = ();
my @extract_data_matrix = ();
my $datafile = "";
my $oct_x_array = "";
my $oct_y_array = "";
my $size_datatypes;
my $datapoints_size;
my $col;
my $cmd;
my $filename;
my $mw = new MainWindow;
$mw -> geometry ("820x780");
my $change_file_button = $mw->Button(-text => "Change input file", -command => sub {exec_commands("change_file");})->pack();
my $plot_window =  $mw->Frame->pack();
my $x_axis_entry = $plot_window -> Entry(-text => "X axis number") -> pack();
my $y_axis_entry = $plot_window -> Entry(-text => "Y axis number") -> pack();
my $plot_button = $mw->Button(-text => "Plot", -command => sub {exec_commands("plot");})->pack();
my $pnt_plot_button = $mw->Button(-text => "Point Plot", -command => sub {exec_commands("pnt_plot");})->pack();
my $main_exit = $mw->Button(-text => "Exit", -command => sub{exec_commands("exit");})->pack();
$mw -> MainLoop;
sub exec_commands
{
	($cmd) = @_;
	print ">>";
	chomp $cmd;
	#This command is used for changing the input file containing the data;
	if($cmd eq "change_file")
	{
			print "$cmd\n";
			$datafile = $mw->getOpenFile();
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
	}
	#This is used to plot a graph for the given data file;
	elsif($cmd eq "plot")
	{
		my $x_axis = $x_axis_entry -> get();
		my $y_axis = $y_axis_entry -> get();

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
		}
		for($i=0;$i<$datapoints_size;$i++)
		{
			$oct_x_array=$oct_x_array."$extract_data_matrix[$i][$x_axis],";
		}
		$oct_x_array=substr($oct_x_array, 0, length($oct_x_array)-1);
		$oct_x_array=$oct_x_array."]";
		#print "$oct_x_array\n";

		for($i=0;$i<$datapoints_size;$i++)
		{
			$oct_y_array=$oct_y_array."$extract_data_matrix[$i][$y_axis],";
		}
		$oct_y_array=substr($oct_y_array, 0, length($oct_y_array)-1);
		$oct_y_array=$oct_y_array."]";
		#print "$oct_y_array\n";
		print "Generating Octave File...\n";
		open(my $fh, '>', $oct_out_file) or die "Could not open file '$oct_out_file'";
		print $fh "$oct_x_array\n";
		print $fh "$oct_y_array\n";
		print $fh "plot(x,y, '.-')\n";
		print $fh "xlabel(\"$datatypes[$x_axis]\")\n";
		print $fh "ylabel(\"$datatypes[$y_axis]\")\n";
		close $fh;
		print "Octave file generated successfully. Executing script...\n";
		system("octave --persist output.m &");
	}
	elsif($cmd eq "pnt_plot")
	{
		$oct_x_array="x_axis = [";
		$oct_y_array="y_axis = [";
		if(length($datafile)==0)
		{
			print "Invalid data file\n";
		}
		my $x_axis = $x_axis_entry -> get();
		my $y_axis = $y_axis_entry -> get();
		for($i=0;$i<$datapoints_size;$i++)
		{
			$oct_x_array=$oct_x_array."$extract_data_matrix[$i][$x_axis],";
		}
		$oct_x_array=substr($oct_x_array, 0, length($oct_x_array)-1);
		$oct_x_array=$oct_x_array."]";
		#print "$oct_x_array\n";

		for($i=0;$i<$datapoints_size;$i++)
		{
			$oct_y_array=$oct_y_array."$extract_data_matrix[$i][$y_axis],";
		}
		$oct_y_array=substr($oct_y_array, 0, length($oct_y_array)-1);
		$oct_y_array=$oct_y_array."]";
		#print "$oct_y_array\n";
		print "Generating Octave File...\n";
		open(my $fh, '>', $oct_out_file) or die "Could not open file '$oct_out_file'";
		print $fh "$oct_x_array;\n";
		print $fh "$oct_y_array;\n";
		print $fh "sub_x = [x_axis(1), x_axis(2)];\n";
		print $fh "sub_y = [x_axis(1), y_axis(2)];\n";
		print $fh "plot(sub_x,sub_y, '.-');\n";
		print $fh "hold on\n";
		print $fh "i = 2;\n";
		print $fh "buttons=1;\n";
		print $fh "while(buttons==1 && i<length(x_axis))\n";
		print $fh "disp('pnt_change')\n";
		print $fh "[x(1),y(1),buttons(1)] = ginput(1);\n";
		print $fh "i=i+1;\n";
		print $fh "sub_x=[x_axis(i-1) , x_axis(i)];\n";
		print $fh "sub_y=[y_axis(i-1) , y_axis(i)];\n";
		print $fh "plot(sub_x,sub_y, '.-')\n";
		print $fh "endwhile\n";
		print $fh "hold off\n";
		close $fh;
		my $mw    = new MainWindow;
		$mw -> geometry ("820x780");
		my @files = <*png>;

		# make one Photo object and one Button and reuse them.
		my $shot = $mw->Photo(-file => "$files[0]"); #get first one
		my $button = $mw->Button(-image => $shot)->pack();
		my $exit_button = $mw->Button(-text => "Exit", -command => sub {exit;})->pack();
		
			my $out;
			print "Octave file generated successfully. Executing script...\n";
			open($out, "octave output.m |");
			$i=2;
			while (<$out>)
			{
				if($i<=7)
				{
					$shot->blank; #clear out old image
		   			$shot->read($files[$i - 1]);
		   			$mw->update;
		   			select(undef, undef, undef, .1);	
		   		}
				$i=$i+1;
			}
			$mw->MainLoop;
	}	
	#This command is used for printing data of a certain column in the given data file;
	elsif($cmd eq "print_data")
	{
		print "Enter data's column number\n";
		$col = <STDIN>;
		chomp $col;
		print "$datatypes[$col]\n";
		for($i=0;$i<$datapoints_size;$i++)
		{
			print "$extract_data_matrix[$i][$col]\n";
		}
	}
	#This command is used for finding the average of data between some specified start and end times;
	elsif($cmd eq "find_average")
	{
		my $t1;
		my $t2;
		my $count = 0;
		my $sum = 0;
		my $avg;
		print "Enter data's column number\n";
		$col = <STDIN>;
		chomp $col;
		print "Enter start time\n";
		$t1 = <STDIN>;
		print "Enter end time\n";
		$t2 = <STDIN>;
		for($i=0;$i<$datapoints_size;$i++)
		{
			if($extract_data_matrix[$i][0] >= $t1 and $extract_data_matrix[$i][0] <= $t2)
			{
				$count++;
				$sum = $sum + $extract_data_matrix[$i][$col];
			}
		}
		$avg = $sum/$count;
		print "Number of data points involved is $count\n";
		print "Average value of $datatypes[$col] in the given time interval is $avg\n";

	}
	#This command is used for clearing all previously used commands and output off the display
	elsif($cmd eq "clear")
	{
		system("clear");
	}
	#This command exits from the software and goes into a termainl;
	elsif($cmd eq "exit")
	{
		exit;
	}
	#This provides an error message if the given command is not part of the above specified commands;
	else
	{
		print "$cmd is an invalid command\n";
	}
}