url_list=$1

for line in $(cat $url_list); do
echo $line;
(wget -m $line.json && cd $line;
cat .json | python3 -m json.tool > tmp && mv tmp .json;
dos2unix .json;
echo Done with this one.);
done

#commit this run
(cd ..; # move to repo base folder
git status;
#git add .;
#git commit -m "Updated www.reddit.com/r/stories/" -m ""$(cat $url_list)""
#git push origin master
);
