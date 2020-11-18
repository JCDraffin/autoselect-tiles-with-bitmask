module utility;

//we have to roll our own fuction to copy without refrences an array with 2 deepness.
public static wchar[][] dup2d(wchar[][] target)
{
    //we need a copy of the first arrary's size. This is the simpliest way.
    wchar[][] result =  target.dup;

    foreach (i,array; result)
    {
        result[i] = target[i].dup;// copys the second level.
    }

    return result;

}

wchar[] Compress2DWCharArrayTo1D(wchar[][] value )
{
    wchar[] result;
	foreach (array; value)
	    result = result ~ array ~ '\n';
	result = result[0..$-1];
	return result;
}


unittest 
{
    wchar[][] a = [['x','x'],['x','x']]; 
    wchar[][] b = a.dup; 
    wchar[][] c = dup2d(a);

    a[0][0] = 'y';
    b[1][1] = 'z';

    c[0][1] = 'z';
    c[1][0] = 'y';

    assert (a[1][1] != c[1][1] );
    assert (b[0][0] != c[0][0] );

    assert (a[1][0] != c[1][0] );
    assert (b[0][1] != c[0][1] );
}

