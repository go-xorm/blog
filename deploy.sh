cp -r $GOPATH/src/github.com/go-xiaohei/pugo/template/ ./template/
pugo build --theme="uno" --dest="$GOPATH/src/github.com/go-xorm/go-xorm.github.io"
cd $GOPATH/src/github.com/go-xorm/go-xorm.github.io
git add --all
git commit -m "updated"
git push origin master
notify "blog updated successfully"
