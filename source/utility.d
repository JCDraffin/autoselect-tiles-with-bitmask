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