module algorithm.bitmask;

    //our simple display printing function. This prints a 2d array of characters as a roguelike map.
public static void PrintScreen(wchar[] videoBuffer)
{
    import std;

    writefln("%(%c%)", videoBuffer);
}
//simplify the conversion of 2d array to 1d for PrintScreen. 
public static void PrintScreen(wchar[][] videoBuffer)
{
    import utility;

    PrintScreen(Compress2DWCharArrayTo1D(BitMask!(wchar)(videoBuffer, StandardTileArray())));
}

public static wchar[][] BitMask(D)(wchar[][] value, D[] tiles)
{	
    
    wchar Conversion(ubyte scan)
    {

        return tiles[scan];
        }

    ubyte ScanNeighbors(wchar testCondition, int xloc, int yloc, wchar[][] array)
    {
        int[][] cord = [
            [xloc + 0, xloc - 1, xloc + 1, xloc + 0],
            [yloc - 1, yloc + 0, yloc + 0, yloc + 1]
        ];
        
        ubyte result = 0;

        //Check the neighbors adjancent to the tile
        for (int i = cast(int) cord[0].length - 1; i > -1; i--)
            {	
            int x = cord[0][i];
            int y = cord[1][i];
                result = cast(ubyte)(result << 1);

                //if scanning out side the arrays' bounds, just skip but increment.
            if (y < 0 || x < 0 || y >= array.length || x >= array.length)
                {
                    continue; // yes we have to scan for this. Other wise the next if statement might throw an exception error.
                //if we find out target
            }
            else if (array[y][x] == testCondition)
                {
                    
                    result = cast(ubyte)(result + 1);
                }
            }
        import std;

        writefln!"result was %b"(result);
        return result;
    }

    import utility;

    wchar[][] buffer = dup2d(value); 
    foreach (y, array; value)
    {
        foreach (x, element; array)
        {
            D testCondition = tiles[0];
            if (testCondition == element)
            {
                ubyte scanTarget = ScanNeighbors(testCondition, cast(int) x, cast(int) y, value);
                buffer[y][x] = Conversion(scanTarget);
            }
        }	
    }
    
    return buffer;
}
























































public static bool TestBitmaskingResult(wchar[] example, wchar[] result)
{

    assert(example.length == result.length);
        
    foreach (i, whatever; example)
    {
        assert(example[i] == result[i]);
    }

    return true;
}

public static void PrintUnittest(wchar[] src)
{

    import std;

    writeln("-------------------------------------------------------------");
    PrintScreen(src);
    writeln("-------------------------------------------------------------");
}


//1x1
unittest
{
    import utility;
    wchar[][] sample = [['█']];
    wchar[] convert = Compress2DWCharArrayTo1D(BitMask(sample,'█'));
    PrintUnittest(convert);
    wchar[] result = ['█'];
    assert(TestBitmaskingResult(convert,result));

}

//2x2
unittest
{
    import utility;
    wchar[][] sample = [['█','█'],['█','█']];
    wchar[] convert = Compress2DWCharArrayTo1D(BitMask(sample,'█'));
    PrintUnittest(convert);
    wchar[] result = ['╔','╗','\n','╚','╝'];
    assert(convert == result);

}

//3x3 middle gone
unittest
{
    import utility;
    wchar[][] sample = [
        ['█','█','█'],
        ['█','▒','█'],
        ['█','█','█']
        ];
    wchar[] convert = Compress2DWCharArrayTo1D(BitMask(sample,'█'));
    PrintUnittest(convert);
    wchar[] result = ['╔','═','╗','\n','║','▒','║','\n','╚','═','╝'];
    assert(convert == result);

}

// 3x3
unittest
{
    import utility;
    wchar[][] sample = [['█','█','█'],['█','█','█'],['█','█','█']];
    wchar[] convert = Compress2DWCharArrayTo1D(BitMask(sample,'█'));
    PrintUnittest(convert);
    wchar[] result = ['╔','╦','╗','\n','╠','╬','╣','\n','╚','╩','╝'];
    assert(convert == result);

}

//5x5
unittest
{
    import utility;
    wchar[][] sample = [
        ['█','█','█','█','█'],
        ['█','▒','▒','▒','█'],
        ['█','▒','█','▒','█'],
        ['█','▒','▒','▒','█'],
        ['█','█','█','█','█']
        ];
    wchar[] convert = Compress2DWCharArrayTo1D(BitMask(sample,'█'));
    PrintUnittest(convert);
    wchar[] result = [
        '╔','═','═','═','╗','\n',
        '║','▒','▒','▒','║','\n',
        '║','▒','█','▒','║','\n',
        '║','▒','▒','▒','║','\n',
        '╚','═','═','═','╝'
        ];
    assert(convert == result);

}

//7x7
unittest
{
    import utility;
    wchar[][] sample = [
        ['█','█','█','█','█','█','█'],
        ['█','▒','█','█','█','▒','█'],
        ['█','▒','█','█','█','▒','█'],
        ['█','▒','█','█','█','▒','█'],
        ['█','▒','█','█','█','▒','█'],
        ['█','▒','█','█','█','▒','█'],
        ['█','█','█','█','█','█','█'],
    ];
    wchar[] convert = Compress2DWCharArrayTo1D(BitMask(sample,'█'));
    PrintUnittest(convert);
    wchar[] result = [
        '╔','═','╦','╦','╦','═','╗','\n',
        '║','▒','╠','╬','╣','▒','║','\n',
        '║','▒','╠','╬','╣','▒','║','\n',
        '║','▒','╠','╬','╣','▒','║','\n',
        '║','▒','╠','╬','╣','▒','║','\n',
        '║','▒','╠','╬','╣','▒','║','\n',
        '╚','═','╩','╩','╩','═','╝'	
        ];
    assert(convert == result);

}

public wchar[] StandardTileArray()
{

    // _9 and _1
    return [
        TileWChar.wall, //0x_0000_0000
        'n', //0x_0000_0001
        'w', //0x_0000_0010
        TileWChar._3, //0x_0000_0011
        'e', //0x_0000_0100
        TileWChar._1, //0x_0000_0101
        TileWChar._2_8, //0x_0000_0110
        TileWChar._2, //0x_0000_0111
        's', //0x_0000_1000
        TileWChar._4_6, //0x_0000_1001
        TileWChar._9, //0x_0000_1010
        TileWChar._6, //0x_0000_1011
        TileWChar._7, //0x_0000_1100
        TileWChar._4, //0x_0000_1101
        TileWChar._8, //0x_0000_1110
        TileWChar._5 //0x_0000_1111
    ];
}

public enum TileWChar : wchar
{

    // FLOOR_CLEAN = '▓',
    // FLOOR_PEBBLE = '░',
    // FLOOR_STONE = '▒', 

    _1 = '╚',
    _2 = '╩',
    _3 = '╝',
    _4 = '╠',
    _5 = '╬',
    _6 = '╣',
    _7 = '╔',
    _8 = '╦',
    _9 = '╗',

    _2_8 = '═',
    _4_6 = '║',
    wall = '█',
    // FLOOR_CLEAN = '▓',
    // FLOOR_PEBBLE = '░',
    FLOOR_STONE = '▒',// WALL_1_CORNER_BOTTOM_LEFT = '╚',
    // WALL_2_CORNER_BOTTOM = '═',
    // WALL_3_CORNER_BOTTOM_RIGHT = '╝',
    // WALL_4_CORNER_LEFT = '║',

    // WALL_6_CORNER_RIGHT = '║',
    // WALL_7_CORNER_UPPER_LEFT = '╔',
    // WALL_8_CORNER_UPPER = '═',
    // WALL_9_CORNER_UPPER_RIGHT = '╗'

}