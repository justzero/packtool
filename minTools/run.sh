#! /bin/sh
clear
echo "当前路径为: "$PWD
echo -n "请输入导入助手文件夹相对路径位置:";read ZHUSHOU
if [ ! -s "$ZHUSHOU" ]; then
echo "$ZHUSHOU NOT FOUND！"
exit 0
fi
echo -n "请输入导出助手文件夹相对路径位置:";read OUTPUT
echo -n "请输入js版本（chrome/ie）:" ;read JS
IE='ie'
if [ "$JS" = "ie" ]
then 
	filename=extension_2_0_ie.js
else
	filename=extension_2_0.js
fi
echo 'file from: '$PWD$ZHUSHOU'scripts/ \n to: '$PWD$OUTPUT$filename
rm -rf $OUTPUT
mkdir $OUTPUT
mkdir $OUTPUT/css $OUTPUT/script
pt=$(echo $ZHUSHOU | sed 's/\./\\\./g' | sed 's/\_/\\\_/g' | sed 's/\//\\\//g')
echo 's/\$ZHUSHOUPATH\$/'$pt'/g' > reg2
sed -f reg2 < conf.js > config.js
node mintool.js \
&& node ../UglifyJS/bin/uglifyjs min.js > \
$OUTPUT/script/$filename \
&& rm min.* config.js

echo "Start pack & rename css"
reg='s/\<images\>/images\/extension_2_0/g'
fdir=$ZHUSHOU'css/'
echo $reg > reg
find $fdir -name *.css| sed 's/^.*css\///g' | awk '{print ("sed -f reg <",DIRin $1,">",DIRout "css/extension_2_0_" $1)}' DIRin="$fdir" DIRout="$OUTPUT" | sh
rm reg*
