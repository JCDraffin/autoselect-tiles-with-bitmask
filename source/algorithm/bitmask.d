module algorithm.bitmask;



	//our simple display printing function. This prints a 2d array of characters as a roguelike map.
	public static void PrintScreen(wchar[] videoBuffer)
	{
        import std;
		writefln("%(%c%)", videoBuffer);
	}

public static wchar[] BitMask(wchar[][] value, wchar testCondition)
{	
	
	wchar Conversion(ubyte scan)
	{
		//simple hack solution to a problem.
		const ubyte HACK = 0b_1010_0101;
		scan = scan | HACK; 
		wchar result = '█'; //We need a fall back result. Undo the hard code ASP.
		switch(scan)
		{
			result = result; break;

			case 0b_0000_1010 | HACK: result = TileWChar._9; break;
			case 0b_0001_0010 | HACK: result = TileWChar._7; break;
			case 0b_0100_0010 | HACK: result = TileWChar._4_6; break;
			case 0b_0001_1010 | HACK: result = TileWChar._8; break;
			case 0b_0100_1010 | HACK: result = TileWChar._6; break;
			case 0b_0101_0010 | HACK: result = TileWChar._4; break;
			case 0b_0101_1010 | HACK: result = TileWChar._5; break;

			case 0b_0001_1000 | HACK: result = TileWChar._2_8; break;
			case 0b_0100_1000 | HACK: result = TileWChar._3; break;
			case 0b_0101_1000 | HACK: result = TileWChar._2; break;

			case 0b_0101_0000 | HACK: result = TileWChar._1; break;
            
            default: result = result; break;
		}
		return result;
	} 

	ubyte ScanNeighbors(wchar testCondition, int xloc, int yloc, wchar[][] array)
	{
		ubyte result;
		
		//Check the neighbors adjancent to the tile
		for(int y = yloc - 1; y <= yloc+1; y++ ){
			for(int x = xloc + 1; x >= xloc-1; x-- )
			{	
				//if checking itself, just skip.
				if(y == yloc && x == xloc){
					continue;
				}

				result = cast(ubyte)(result << 1);

				//if scanning out side the arrays' bounds, just skip but increment.
				if(y < 0 || x < 0 || y >= array.length || x >= array.length)
				{
					continue; // yes we have to scan for this. Other wise the next if statement might throw an exception error.
				//if we find out target
				} else if (array[y][x] == testCondition)
				{
					
					result = cast(ubyte)(result + 1);
				}
			}
		}
		return result;
	}
	wchar[] Compress2DArrayTo1D(wchar[][] value ){
	wchar[] result;
	foreach (array; value)
	{
		result = result ~ array ~ '\n';
	}
	result = result[0..$-1];
	return result;
	}
	
	import utility;


	wchar[][] buffer = dup2d(value); 
	foreach (y,array; value)
	{
		
		foreach (x,element; array)
		{
			if(testCondition == element)
			{
				ubyte scanTarget = ScanNeighbors(testCondition, cast(int)x,cast(int)y, value);
				buffer[y][x] = Conversion( scanTarget );		
			}
		}	
	}
	

	return Compress2DArrayTo1D(buffer);
}
























































public static bool TestBitmaskingResult(wchar[] example, wchar[] result)
{

    assert(example.length == result.length);
        
    foreach (i,whatever; example)
    {
        assert(example[i] == result[i]);
    }

	return true;
}
public static void PrintUnittest (wchar[] src )
{

    import std;
	writeln("-------------------------------------------------------------");
	PrintScreen(src);
	writeln("-------------------------------------------------------------");
}


//1x1
unittest
{

	wchar[][] sample = [['█']];
	wchar[] convert = BitMask(sample,'█');
	PrintUnittest(convert);
	wchar[] result = ['█'];
	assert(TestBitmaskingResult(convert,result));

}

//2x2
unittest
{
	wchar[][] sample = [['█','█'],['█','█']];
	wchar[] convert = BitMask(sample,'█');
	PrintUnittest(convert);
	wchar[] result = ['╔','╗','\n','╚','╝'];
	assert(convert == result);

}

//3x3 middle gone
unittest
{
	wchar[][] sample = [
		['█','█','█'],
		['█','▒','█'],
		['█','█','█']
		];
	wchar[] convert = BitMask(sample,'█');
	PrintUnittest(convert);
	wchar[] result = ['╔','═','╗','\n','║','▒','║','\n','╚','═','╝'];
	assert(convert == result);

}

// 3x3
unittest
{
	wchar[][] sample = [['█','█','█'],['█','█','█'],['█','█','█']];
	wchar[] convert = BitMask(sample,'█');
	PrintUnittest(convert);
	wchar[] result = ['╔','╦','╗','\n','╠','╬','╣','\n','╚','╩','╝'];
	assert(convert == result);

}

//5x5
unittest
{
	wchar[][] sample = [
		['█','█','█','█','█'],
		['█','▒','▒','▒','█'],
		['█','▒','█','▒','█'],
		['█','▒','▒','▒','█'],
		['█','█','█','█','█']
		];
	wchar[] convert = BitMask(sample,'█');
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
	wchar[][] sample = [
		['█','█','█','█','█','█','█'],
		['█','▒','█','█','█','▒','█'],
		['█','▒','█','█','█','▒','█'],
		['█','▒','█','█','█','▒','█'],
		['█','▒','█','█','█','▒','█'],
		['█','▒','█','█','█','▒','█'],
		['█','█','█','█','█','█','█'],
	];
	wchar[] convert = BitMask(sample,'█');
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
	 FLOOR_STONE = '▒', 

	// WALL_1_CORNER_BOTTOM_LEFT = '╚',
	// WALL_2_CORNER_BOTTOM = '═',
	// WALL_3_CORNER_BOTTOM_RIGHT = '╝',
	// WALL_4_CORNER_LEFT = '║',

	// WALL_6_CORNER_RIGHT = '║',
	// WALL_7_CORNER_UPPER_LEFT = '╔',
	// WALL_8_CORNER_UPPER = '═',
	// WALL_9_CORNER_UPPER_RIGHT = '╗'

}