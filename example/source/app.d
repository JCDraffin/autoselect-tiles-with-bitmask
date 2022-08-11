import std.stdio;
import com.github.jcdraffin.bitmask;
void main()
{
    writeln("==========================================");
    writeln("Example program to build this algorithm");
    


    auto flags = [true, true, true];

    if(flags[0])exampleSimpleShape();
    if(flags[1])exampleRogue();
    if(flags[2])exampleStress();
}
/++
 + Test method to check shapes can be bitmasked
 +
 +
 +
 + Author: J.C. Draffin
 + Version: 1.0
 +
 +/
static void exampleSimpleShape()
{

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
        printScreen(bitMask!(wchar)(shape, standardTileArray()));
}
/++
 + Test method to see if bitmask can be used in roguelike-like text description
 +
 +
 +
 + Author: J.C. Draffin
 + Version: 1.0
 +
 +/
static void exampleRogue()
{

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
        import com.github.jcdraffin.utility:dup2d;
        wchar[][] writable = dup2d!wchar(roguelikeExampleBuffer);
        writable[y][x] = '@';
        writefln!"----------";
        printScreen(writable);
        writefln!"==========\n%s"(singleElementBitMask!(wchar,string)(writable,description,'█',x,y));


    }
}
/++
 + Test method to stress the bitmask algorithm. Used for speed, or multithreading test.
 ++++WARNING: Don't multi-thread. Massive reduction in speed++++
 +
 +
 +
 + Author: J.C. Draffin
 + Version: 1.0
 +
 +/
static void exampleStress()
{


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


    import std.datetime.stopwatch:StopWatch;
    StopWatch watch;
    watch.start();
    printScreen(bitMask!wchar(stressBuffer,standardTileArray()));
    watch.stop();
    writefln!"The time was: %sms"(watch.peek().total!"msecs");



}
