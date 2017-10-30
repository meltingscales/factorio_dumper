@ECHO OFF

SET path1="E:\Games\Steam\steamapps\common\Factorio\bin\x64\factorio.exe"
SET path2="C:\Program Files (x86)\Steam\steamapps\common\Factorio\bin\x64\factorio.exe"
SET moddir="C:\Users\henryfbp\Documents\GitHub"


IF EXIST %path1% (
  %path1% --mod-directory %moddir%.
)
IF EXIST %path2% (
  %path2% --mod-directory %moddir%.
)



echo "seeya!"
echo "btw, if this is closing with no output, either:"
echo
echo "use a non-steam copy of factorio,"
echo "!OR!"
echo "go to Steam\steam.exe, right-click and select properties,"
echo "and click the 'run as admin' box."
echo "now every time you are prompted to allow, click deny."

pause
exit
