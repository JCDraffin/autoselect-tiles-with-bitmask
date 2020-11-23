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

    PrintScreen(Compress2DWCharArrayTo1D(videoBuffer,));
}

public static D[][] BitMask(D)(D[][] value, D[][] tiles)
{

    D Conversion(ubyte scan, D[] tileset)
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

        //Check the neighbors adjancent to the tile
        for (int i = cast(int) cord[0].length - 1; i > -1; i--)
        {
        	
        
            int x = cord[0][i];
            int y = cord[1][i];
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

    import utility : dup2d;
    import std.range;
    import std.algorithm.iteration;

    wchar[][] buffer = dup2d(value);
    foreach(i, element;  value.joiner().array)
    {
     int x = cast(int)(i%value[0].length), y = cast(int)(i/value[0].length);
            foreach (tileset; (tiles))
            {
                D testCondition = tileset[0];
                if (testCondition == element)
                {
                    ubyte scanTarget = ScanNeighbors(testCondition, x, y, value);
                    buffer[y][x] = Conversion(scanTarget, tileset);
                }
            }
    }

    return buffer;
}























///////////////////////
///UNIT TESTING CODE///
///////////////////////

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

private static void UnittestShapeWchar(wchar[][] sample, wchar[] result)
{
    import utility;

    wchar[] convert = Compress2DWCharArrayTo1D(BitMask!wchar(sample, StandardTileArray()));
    PrintUnittest(convert);

    assert(TestBitmaskingResult(convert, result));
}

//1x1
unittest
{
    UnittestShapeWchar([['█', '█'], ['█', '█']], [
            '╔', '╗', '\n', '╚', '╝'
            ]);
}

//2x2
unittest
{
    UnittestShapeWchar([['█']], ['█']);
}

//3x3 middle gone
unittest
{
    UnittestShapeWchar([
            ['█', '█', '█'], ['█', '▒', '█'], ['█', '█', '█']
            ], [
            '╔', '═', '╗', '\n', '║', '▒', '║', '\n', '╚', '═',
            '╝'
            ]);
}

// 3x3
unittest
{
    UnittestShapeWchar([
            ['█', '█', '█'], ['█', '█', '█'], ['█', '█', '█']
            ], [
            '╔', '╦', '╗', '\n', '╠', '╬', '╣', '\n', '╚', '╩','╝'
            ]);
}

//5x5
unittest
{

    UnittestShapeWchar([
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

    UnittestShapeWchar([
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

//7x7 testing single bit characters.
unittest
{

    UnittestShapeWchar([
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


public wchar[][] StandardTileArray()
{
    return 
    [
        [
            TileWChar.wall, //0x_0000_0000
            TileWChar._N,   //0x_0000_0001
            TileWChar._W,   //0x_0000_0010
            TileWChar._3,   //0x_0000_0011
            TileWChar._E,   //0x_0000_0100
            TileWChar._1,   //0x_0000_0101
            TileWChar._2_8, //0x_0000_0110
            TileWChar._2,   //0x_0000_0111
            TileWChar._S,   //0x_0000_1000
            TileWChar._4_6, //0x_0000_1001
            TileWChar._9,   //0x_0000_1010
            TileWChar._6,   //0x_0000_1011
            TileWChar._7,   //0x_0000_1100
            TileWChar._4,   //0x_0000_1101
            TileWChar._8,   //0x_0000_1110
            TileWChar._5    //0x_0000_1111
        ],
        [
            TileWChar.FLOOR_BASIC, 
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE,
            TileWChar.FLOOR_STONE
        ]
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
    _N = '▀',
    _W = '»',
    _E = '«',
    _S = '▄',
    wall = '█',

    // FLOOR_CLEAN = '▓',
    // FLOOR_PEBBLE = '░',
    FLOOR_BASIC = '■',
    FLOOR_STONE = '▒', // WALL_1_CORNER_BOTTOM_LEFT = '╚',
    // WALL_2_CORNER_BOTTOM = '═',
    // WALL_3_CORNER_BOTTOM_RIGHT = '╝',
    // WALL_4_CORNER_LEFT = '║',

    // WALL_6_CORNER_RIGHT = '║',
    // WALL_7_CORNER_UPPER_LEFT = '╔',
    // WALL_8_CORNER_UPPER = '═',
    // WALL_9_CORNER_UPPER_RIGHT = '╗'

}
