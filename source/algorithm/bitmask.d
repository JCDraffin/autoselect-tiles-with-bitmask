module algorithm.bitmask;



	//our simple display printing function. This prints a 2d array of characters as a roguelike map.
	public static void PrintScreen(wchar[] videoBuffer)
	{
        import std;
		writefln("%(%c%)", videoBuffer);
	}


	 
	//used for simple rule construction. bits will match numberpad locations.
	const ubyte _1bit =	0b00000001;
	const ubyte _2bit =	0b00000010;
	const ubyte _3bit =	0b00000100;
	const ubyte _4bit =	0b00001000;
	//DO NOTE, WE SKIP _5bit. This makes the last bit in a byte _9bit
	//In the use context, _5bit would be a self test, which is useless, and we need the extra bit else where.
	const ubyte _6bit =	0b00010000;
	const ubyte _7bit =	0b00100000;
	const ubyte _8bit =	0b01000000;
	const ubyte _9bit =	0b10000000;
		

public static wchar[] BitMask(wchar[][] value, wchar testCondition)
{	
	
	wchar Conversion(ubyte scan)
	{
		//simple hack solution to a problem.
		const ubyte HACK = _9bit | _7bit | _1bit | _3bit; // this should be 165 or 0b1010_0101
		scan = scan | HACK; 
		wchar result = '█'; //█ 
		switch(scan)
		{
			result = result; break;

			case _2bit | _4bit | HACK: result = TileWChar._9; break;
			case _2bit | _6bit | HACK: result = TileWChar._7; break;
			case _2bit | _8bit | HACK: result = TileWChar._4_6; break;
			case _2bit | _4bit | _6bit | HACK: result = TileWChar._8; break;
			case _2bit | _4bit | _8bit | HACK: result = TileWChar._6; break;
			case _2bit | _6bit | _8bit | HACK: result = TileWChar._4; break;
			case _2bit | _4bit | _6bit | _8bit | HACK: result = TileWChar._5; break;

			case _4bit | _6bit | HACK: result = TileWChar._2_8; break;
			case _4bit | _8bit | HACK: result = TileWChar._3; break;
			case _4bit | _6bit | _8bit | HACK: result = TileWChar._2; break;

			case _6bit | _8bit | HACK: result = TileWChar._1; break;
            
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