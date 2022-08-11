module com.github.jcdraffin.bitmask;

//our simple display printing function. This prints a 2d array of characters as a roguelike map.
public static void printScreen(wchar[] videoBuffer)
{
    import std:writefln;

    writefln("%(%c%)", videoBuffer);
}
//simplify the conversion of 2d array to 1d for printScreen. 
public static void printScreen(wchar[][] videoBuffer)
{
 
    printScreen(compress2DWCharArrayTo1D(videoBuffer,));
}

@safe public static D[][] bitMask(D)(D[][] value, D[][] tiles)
{

 
    import std.range : array;
    import std.algorithm.iteration: joiner;

    D[][] buffer = dup2d(value);
    foreach(i, element;  value.joiner().array)
    {
     int x = cast(int)(i%value[0].length), y = cast(int)(i/value[0].length);
            foreach (tileset; tiles)
            {
                D testCondition = tileset[0];
                if (testCondition == element)
                    buffer[y][x] = singleElementBitMask!(D,D)(value, tileset, testCondition,x,y); 
            }
    }

    return buffer;
}

@safe public static T singleElementBitMask(D,T)(D[][] value, T[] tiles, D testCondition, int atX, int atY)
{


    T Conversion(ubyte scan, T[] tileset)
    {
        return tileset[scan];
    }

    ubyte ScanNeighbors(D testCondition, int xloc, int yloc, D[][] array)
    {
        int[][] cord = [
            [xloc + 0, xloc - 1, xloc + 1, xloc + 0],
            [yloc - 1, yloc + 0, yloc + 0, yloc + 1]
        ];

        ubyte result = 0;

        //Check the neighbors adjacent to the tile
        for (int i = cast(int) cord[0].length - 1; i > -1; i--)
        {
        	
        
            const int x = cord[0][i];
            const int y = cord[1][i];
            result = cast(ubyte)(result << 1);

            //if scanning out side the arrays' bounds, just skip but increment.
            if (y < 0 || x < 0 || y >= array.length || x >= array[0].length)
            {
                continue; // yes we have to scan for this. Other wise the next if statement might throw an exception error.
                //if we find out target
            }
            else if (array[y][x] == testCondition)
            {
                result = cast(ubyte)(result + 1);           
            }
        }
        return result;
    }

    const ubyte scanTarget = ScanNeighbors(testCondition, atX, atY, value);
    return Conversion(scanTarget, tiles);

}


//we have to roll our own fuction to copy without refrences an array with 2 deepness.
public static T[][] dup2d(T)(T[][] target)
{
    //we need a copy of the first arrary's size. This is the simpliest way.
    wchar[][] result =  target.dup;

    foreach (i,array; result)
    {
        result[i] = target[i].dup;// copys the second level.
    }

    return result;

}

wchar[] compress2DWCharArrayTo1D(wchar[][] value )
{
    wchar[] result;
	foreach (array; value)
	    result = result ~ array ~ '\n';
	result = result[0..$-1];
	return result;
}



///////////////////////
///UNIT TESTING CODE///
///////////////////////


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










private static bool testBitmaskingResult(wchar[] example, wchar[] result)
{

    assert(example.length == result.length);

    foreach (i, whatever; example)
    {
        assert(example[i] == result[i]);
    }

    return true;
}

private static void printUnittest(wchar[] src)
{

    import std:writeln;

    writeln("-------------------------------------------------------------");
    printScreen(src);
    writeln("-------------------------------------------------------------");
}

private static void unittestShapeWchar(wchar[][] sample, wchar[] result)
{
     

    wchar[] convert = compress2DWCharArrayTo1D(bitMask!wchar(sample, standardTileArray()));
    printUnittest(convert);

    assert(testBitmaskingResult(convert, result));
}

//1x1
unittest
{
    unittestShapeWchar([['█', '█'], ['█', '█']], [
            '╔', '╗', '\n', '╚', '╝'
            ]);
}

//2x2
unittest
{
    unittestShapeWchar([['█']], ['█']);
}

//3x3 middle gone
unittest
{
    unittestShapeWchar([
            ['█', '█', '█'], ['█', '▒', '█'], ['█', '█', '█']
            ], [
            '╔', '═', '╗', '\n', '║', '▒', '║', '\n', '╚', '═',
            '╝'
            ]);
}

// 3x3
unittest
{
    unittestShapeWchar([
            ['█', '█', '█'], ['█', '█', '█'], ['█', '█', '█']
            ], [
            '╔', '╦', '╗', '\n', '╠', '╬', '╣', '\n', '╚', '╩','╝'
            ]);
}

//5x5
unittest
{

    unittestShapeWchar([
            ['█', '█', '█', '█', '█'],
            ['█', '■', '■', '■', '█'],
            ['█', '■', '█', '■', '█'],
            ['█', '■', '■', '■', '█'],
            ['█', '█', '█', '█', '█']
            ], [
            '╔', '═', '═', '═', '╗', '\n',
            '║', '▒', '▒', '▒', '║', '\n',
            '║', '▒', '█', '▒', '║', '\n',
            '║', '▒', '▒', '▒', '║', '\n',
            '╚', '═', '═', '═', '╝'
            ]);
}

//7x7
unittest
{

    unittestShapeWchar([
            ['█', '█', '█', '█', '█', '█', '█'],
            ['█', '■', '█', '█', '█', '■', '█'],
            ['█', '■', '█', '█', '█', '■', '█'],
            ['█', '■', '█', '█', '█', '■', '█'],
            ['█', '■', '█', '█', '█', '■', '█'],
            ['█', '■', '█', '█', '█', '■', '█'],
            ['█', '█', '█', '█', '█', '█', '█'],
            ], [
            '╔', '═', '╦', '╦', '╦', '═', '╗', '\n',
            '║', '▒', '╠', '╬', '╣', '▒', '║', '\n', 
            '║', '▒', '╠', '╬', '╣', '▒', '║', '\n',
            '║', '▒', '╠', '╬', '╣', '▒', '║', '\n',
            '║', '▒', '╠', '╬', '╣', '▒', '║', '\n',
            '║', '▒', '╠', '╬', '╣', '▒', '║', '\n',
            '╚', '═', '╩', '╩', '╩', '═', '╝'
            ]);
}

//7x7 testing multi tileset.
unittest
{

    unittestShapeWchar([
            ['█', '█', '█', '█', '█', '█', '█'],
            ['█', '■', '■', '■', '█', '█', '█'],
            ['█', '■', '█', '■', '█', '■', '█'],
            ['█', '■', '█', '■', '■', '■', '█'],
            ['█', '■', '■', '█', '█', '■', '█'],
            ['█', '■', '■', '■', '■', '■', '█'],
            ['█', '█', '█', '█', '█', '█', '█'],
            ], [
            '╔', '═', '═', '═', '╦', '╦', '╗', '\n',
            '║', '▒', '▒', '▒', '╠', '╩', '╣', '\n', 
            '║', '▒', '▄', '▒', '▀', '▒', '║', '\n',
            '║', '▒', '▀', '▒', '▒', '▒', '║', '\n',
            '║', '▒', '▒', '«', '»', '▒', '║', '\n',
            '║', '▒', '▒', '▒', '▒', '▒', '║', '\n',
            '╚', '═', '═', '═', '═', '═', '╝'
            ]);
}


public wchar[][] standardTileArray()
{
    return 
    [
        [
            '█',   //0x_0000_0000
            '▀',   //0x_0000_0001
            '»',   //0x_0000_0010
            '╝',   //0x_0000_0011
            '«',   //0x_0000_0100
            '╚',   //0x_0000_0101
            '═',   //0x_0000_0110
            '╩',   //0x_0000_0111
            '▄',   //0x_0000_1000
            '║',   //0x_0000_1001
            '╗',   //0x_0000_1010
            '╣',   //0x_0000_1011
            '╔',   //0x_0000_1100
            '╠',   //0x_0000_1101
            '╦',   //0x_0000_1110
            '╬'    //0x_0000_1111
        ],
        [
            '■', 
            '▒',
            '▒',
            '▒',
            '▒',
            '▒',
            '▒',
            '▒',
            '▒',
            '▒',
            '▒',
            '▒',
            '▒',
            '▒',
            '▒',
            '▒'
        ]
    ];
}
