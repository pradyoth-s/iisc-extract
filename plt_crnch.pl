my $path = "/home/hynd/Desktop/testing/ERROR";
my $col_name_1 = "time";
my $col_name_2 = "d OuterVoltage";
my $col_name_3 = "d TotalCurrent";
my $t1 = 60E-09;
my $t2 = 80E-09;


use strict;
#From here, all required files are searched for and then stored in an array in an ascending order numerically
my @file_array = ();
my $fh;
my $row;
my $pwd = system("pwd > pwd");
open(my $fh, "pwd")
or die "Could not open file 'pwd'!";
while($row = <$fh>)
{
	$pwd = $row;
}
my $file;
my $i = 0;
my $j = 0;
my $length;
my @datatypes = ();
my $size_datatypes = 0;
my @extract_data_raw = ();
my @extract_data_matrix = ();
my $datapoints_size = 0;
my $prefix = "C";
my $file_out = "$prefix".".csv";
my @avg1 = ();
my @avg2 = ();
my @avg3 = ();
my $file_num = 0;
my $col1;
my $col2;
my $col3;
my @fp = ();#File prefix
my @fs = ();#File suffix
my @ui = ();#Underscore index
my $uc;#Underscore count
system("cd $path; ls | grep $prefix > filenames.txt");
$path = $path;
open(my $fh, "$path/filenames.txt")
or die "Could not open file 'filenames.txt' $!";
while ($row = <$fh>) 
{
chomp $row;
$uc=0;
$length = length($row);
for($j=0;$j<$length;$j++)
{
	if((substr $row, $j, 1) eq "_" && $uc<2)
	{
		$ui[$uc]=$j;
		$uc++;
	}
}
$fp[$i] = substr $row, 0, $ui[0]+1;
$fs[$i] = substr $row, $ui[1], $length - $ui[1] + 1;
$row = substr $row, $ui[0]+1, $ui[1]-$ui[0]-1;
$file_array[$i]=$row;
$i++;
}
@file_array = sort { $a <=> $b } @file_array;
for($i=0;$i<scalar(@file_array);$i++)
{
	$file_array[$i] = $file_array[$i] . "$fs[$i]";
	$file_array[$i] = "$fp[$i]" . $file_array[$i];
}
print "Files read are-";
print "@file_array\n";
#Searching and storing of files complete

#Here, data is extracted from the files and average is found


foreach $file (@file_array)
{
	#Data is being extracted from each file
	print "Extracting data from $file...\n";
	@datatypes = find_datatype($file);
	$size_datatypes = @datatypes;
	print "Number of datatypes used is $size_datatypes\n";
	@extract_data_raw = extract_data_raw($file);
	@extract_data_matrix = extract_data_matrix($size_datatypes, @extract_data_raw);
	$datapoints_size = @extract_data_raw/$size_datatypes;
	print "Number of datapoints in file is $datapoints_size\n";
	print "Extraction complete\n";
	#Extraction complete
	for($i=0;$i<$size_datatypes;$i++)
	{
		if($datatypes[$i] eq $col_name_1)
		{
			$col1=$i;
		}
		if($datatypes[$i] eq $col_name_2)
		{
			$col2=$i;
		}
		if($datatypes[$i] eq $col_name_3)
		{
			$col3=$i;
		}
	}
	my $count = 0;
	my $sum1 = 0;
	my $sum2 = 0;
	my $sum3 = 0;
	$i=0;
	for($i=0;$i<$datapoints_size;$i=$i+1)
	{
		if($extract_data_matrix[$i][0] >= $t1 and $extract_data_matrix[$i][0] <= $t2)
		{
			$count++;
			$sum1 = $sum1 + $extract_data_matrix[$i][$col1];
			$sum2 = $sum2 + $extract_data_matrix[$i][$col2];
			$sum3 = $sum3 + $extract_data_matrix[$i][$col3];
		}
	}
	$avg1[$file_num] = $sum1/$count;
	$avg2[$file_num] = $sum2/$count;
	
	$avg3[$file_num] = $sum3/$count;
	$file_num++;
}
#Finding average for all input files complete
print "Found average for all files\n";
system("rm $path/filenames.txt");

print "Preparing to print data to output file $file_out...\n";
open(my $fh, '>', $file_out) or die "Could not open file '$file_out'";
#The next line is a statement used for finding out the number of files involved. It could've as easily been @avg2 or @avg3 or any other equivalent statement
$file_num = @avg1;
print "Printing data to file...\n";
for($i=0;$i<$file_num;$i++)
{
	print $fh "$avg1[$i],$avg2[$i],$avg3[$i]\n";
}
close $fh;
print "Writing to output file complete...\n";
my $filename;

system("cd $pwd");
sub find_datatype
{
$filename;
($filename) = @_;
# open the file
open MYFILE, "$path/$filename" or die "could not open $filename";
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
sub extract_data_raw
{
my $filename;
($filename) = @_;
# open the file
open MYFILE, "$path/$filename" or die "could not open $filename";
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
# close the file
close MYFILE;
}
print "Quitting script\n";
