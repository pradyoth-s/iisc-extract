
sub extract_data_raw(@_)
{
($filename) = @_;
# open the file
open MYFILE, "$filename" or die "could not open $filename";
$string="";
$true=0;
$curly_count=0;
$i=0;
$wcb=0; #wcb stands for Within Curly Brackets. If its value is one, the character is within curly brackets. If it is zero, the character is outside curly brackets. 
# loop line by line until EOF
while(<MYFILE>) {
    #split line in a char array
    @chars = split //;
    
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
    		@data_array = split ' ', $string;
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
1;