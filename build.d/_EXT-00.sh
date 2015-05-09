displayMessage "[Ext - Init]"

for ext in "${EXTS[@]}"
do
  displayAndExec "\\ Download EXT archive      " "wget -N ${ext} -P SRC/EXT/"
done

cd SRC/EXT/

for file in *.*
do
  displayMessage "\\ Extracting $file"
  extract $file
done

cd ../..
