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
pause
exit
