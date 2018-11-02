url_list=$1

for line in $(cat $url_list); do
  timestamp=$(date +%s);
  echo '['$timestamp']' Working on $line;
  (cd ..; #change to repo base
  echo '['$timestamp']' Getting json file...;
  wget -m $line.json;
  echo '['$timestamp']' Got file...;
  cd $line;
  echo '['$timestamp']' Changed to dir: $(pwd);
  echo '['$timestamp']' Beautify json...;
  cat .json | python3 -m json.tool > tmp && mv tmp .json;
  echo '['$timestamp']' Fix line endings...;
  dos2unix .json;
  echo '['$timestamp']' Sleeping a little...;
  sleep 2;
  echo '['$timestamp']' Done.;);
done

#commit this run
cd ..; # move to repo base folder
echo '['$timestamp']' Commiting this run...;
git add .;
git commit -m "Updated www.reddit.com/r/incest/" -m ""$(cat tools/$url_list)"";
git push origin master;
