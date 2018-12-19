
sub extract_data_matrix(@_)
{
    $i=0;
    @data_raw = @_;
    $size = $data_raw[0];
    @data_matrix = ();
    shift @data_raw;
    $i = 0;
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
1;