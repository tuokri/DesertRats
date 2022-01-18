class DRCheatManager extends ROCheatManager within DRPlayerController;

exec function God()
{
    Super.God();

    if (bGodDR)
    {
        bGodDR = False;
    }
    else
    {
        bGodDR = True;
    }
}
