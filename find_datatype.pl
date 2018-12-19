
sub find_datatype(@_)
{
($filename) = @_;
# open the file
open MYFILE, "$filename" or die "could not open $filename";
$string="";
$true=0;
$i=0;
# loop line by line until EOF
while(<MYFILE>) {
    #split line in a char array
    @chars = split //;
    
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
    		$udq=0; #Under Double Quotes. 0 represents 'Not under double quotes' and 1 represents 'Under Double Quotes'
    		$string = substr $string, 1;
    		@datatype_arr = ();
			$datatype = "";
			$i=0;
			$start = 1;
			$count = 0;
			$string_length = length($string);
			for($i=1;$i<$string_length;$i++)
			{
				$ch = substr($string, $i+1, 1);
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
	

1;