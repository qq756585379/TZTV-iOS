DIR=$(dirname $0)
cd $DIR/TZTV
pod install
open $DIR/TZTV/TZTV.xcworkspace
exit
