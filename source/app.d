import std.stdio;
import algorithm.bitmask;
void main()
{
    writeln("==========================================");
    writeln("Example program to build this algorithm");
    
    wchar[][][] sampler = [
        [['█']], [['█', '█'], ['█', '█']],

        [['█', '█', '█'], ['█', '▒', '█'], ['█', '█', '█']],

        [['█', '█', '█'], ['█', '█', '█'], ['█', '█', '█']],

        [
            ['█', '█', '█', '█', '█'],
            ['█', '▒', '▒', '▒', '█'],
            ['█', '▒', '█', '▒', '█'],
            ['█', '▒', '▒', '▒', '█'],
            ['█', '█', '█', '█', '█']
        ],

        [
            ['█', '█', '█', '█', '█', '█', '█'],
            ['█', '▒', '█', '█', '█', '▒', '█'],
            ['█', '▒', '█', '█', '█', '▒', '█'],
            ['█', '▒', '█', '█', '█', '▒', '█'],
            ['█', '▒', '█', '█', '█', '▒', '█'],
            ['█', '▒', '█', '█', '█', '▒', '█'],
            ['█', '█', '█', '█', '█', '█', '█']
        ]
    ];

    foreach (wchar[][] shape; sampler)
        PrintScreen(BitMask!(wchar)(shape, StandardTileArray()));

    wchar[][] roguelikeExampleBuffer = 
    [
        ['█', '█', '█', '█', '█'],
        ['█', '▒', '▒', '▒', '█'],
        ['█', '▒', '▒', '▒', '█'],
        ['█', '▒', '▒', '▒', '█'],
        ['█', '█', '█', '█', '█']
    ];
    string[] description = [
        "I'm in the open. I can move anywhere.",
        "I'm at a pillar .  i can only move  W, E, or S",
        "I'm at a pillar .  i can only move N, E, or S",
        "I'm in a corner.   I can only move E or S",
        "I'm at a pillar .  i can only move N, W, or S",
        "I'm in a corner.   I can only move W or S",
        "I'm in a hallway.  I can only move N or S",
        "I'm in a dead end. I can only move SOUTH",
        "I'm at a pillar .  i can only move N, W, or E",
        "I'm in a hallway.  I can only move W or E",
        "I'm in a corner.   I can only move N or E",
        "I'm in a dead end. I can only move EAST",
        "I'm in a corner.   I can only move N or W",
        "I'm in a dead end and  can only move WEST",
        "I'm in a dead end and  can only move NORTH",
        "?????????????????????????????????????????", 

        ];


    // int i = 1;
    for(int i = 0; i < 9; i++)
    {
        int x = (i%3)+1, y = (i/3)+1;
        import utility;
        wchar[][] writable = utility.dup2d!wchar(roguelikeExampleBuffer);
        writable[y][x] = '@';  
        writefln!"----------";
        PrintScreen(writable);
        writefln!"==========\n%s"(SingleElementBitMask!(wchar,string)(writable,description,'█',x,y));
       

    }


    wchar[]   row = new wchar[135];
    wchar[][] stressBuffer;

    foreach (i, element; row)
    {
        row[i] = '█';
    }

    for(int i = 0; i < 1_000; i++)
    {
        stressBuffer ~= row;
    }


    import std.datetime.stopwatch;
    StopWatch watch;
    watch.start();
    PrintScreen(BitMask!wchar(stressBuffer,StandardTileArray()));
    watch.stop();
    writefln!"The time was: %sms"(watch.peek().total!"msecs");

}