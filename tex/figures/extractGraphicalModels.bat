pdftops -eps -f 1 -l 1 graphicalModels.pdf oneHighThreshold.ps | 
ps2eps -f oneHighThreshold.ps |
gs -dSAFER -dBATCH -dNOPAUSE -dEPSCrop -r600 -sDEVICE=pngalpha -sOutputFile=oneHighThreshold.png oneHighThreshold.eps
pdftops -eps -f 2 -l 2 graphicalModels.pdf twoHighThreshold.ps | 
ps2eps -f twoHighThreshold.ps |
gs -dSAFER -dBATCH -dNOPAUSE -dEPSCrop -r600 -sDEVICE=pngalpha -sOutputFile=twoHighThreshold.png twoHighThreshold.eps
pdftops -eps -f 3 -l 3 graphicalModels.pdf weaponPriming.ps | 
ps2eps -f weaponPriming.ps |
gs -dSAFER -dBATCH -dNOPAUSE -dEPSCrop -r600 -sDEVICE=pngalpha -sOutputFile=weaponPriming.png weaponPriming.eps