import std.stdio;

void main()
{
	writeln("==========================================");
	writeln("Example program to build this algorithm");
	Prog p = new Prog();

}

public class Prog
{
	//our simple display printing function. This prints a 2d array of characters as a roguelike map.
	public static void PrintScreen(wchar[] videoBuffer)
	{
		writefln("%(%c%)", videoBuffer);
	}

}

public static wchar[] BitMask(wchar[][] value)
{	wchar[] result;
	foreach (array; value)
	{
		result = result ~ array ~ '\n';
	}
	result = result[0..$-1];
	return result;
}

public static bool TestBitmaskingResult(wchar[] example, wchar[] result)
{
	return example == result;
}
public static void PrintUnittest (wchar[] src )
{
	writeln("-------------------------------------------------------------");
	Prog.PrintScreen(src);
	writeln("-------------------------------------------------------------");
}


//1x1
unittest
{

	wchar[][] sample = [['█']];
	wchar[] convert = BitMask(sample);
	PrintUnittest(convert);
	wchar[] result = ['█'];
	assert(TestBitmaskingResult(convert, result));

}

//2x2
unittest
{
	wchar[][] sample = [['█','█'],['█','█']];
	wchar[] convert = BitMask(sample);
	PrintUnittest(convert);
	wchar[] result = ['╔','╗','\n','╚','╝'];
	assert(TestBitmaskingResult(convert, result));

}

//3x3 middle gone
unittest
{
	wchar[][] sample = [
		['█','█','█'],
		['█','▒','█'],
		['█','█','█']
		];
	wchar[] convert = BitMask(sample);
	PrintUnittest(convert);
	wchar[] result = ['╔','═','╗','\n','║','▒','║','\n','╚','═','╝'];
	assert(TestBitmaskingResult(convert, result));

}

// 3x3
unittest
{
	wchar[][] sample = [['█','█','█'],['█','█','█'],['█','█','█']];
	wchar[] convert = BitMask(sample);
	PrintUnittest(convert);
	wchar[] result = ['╔','╦','╗','\n','║','╬','║','\n','╚','╩','╝'];
	assert(TestBitmaskingResult(convert, result));

}

//5x5
unittest
{
	wchar[][] sample = [
		['█','█','█','█','█'],
		['█','█','█','█','█'],
		['█','█','█','█','█'],
		['█','█','█','█','█'],
		['█','█','█','█','█']
		];
	wchar[] convert = BitMask(sample);
	PrintUnittest(convert);
	wchar[] result = ['█'];
	assert(TestBitmaskingResult(convert, result));

}

//7x7
unittest
{
	wchar[][] sample = [['█']];
	wchar[] convert = BitMask(sample);
	PrintUnittest(convert);
	wchar[] result = ['█'];
	assert(TestBitmaskingResult(convert, result));

}

//
unittest
{

}

//
unittest
{

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
