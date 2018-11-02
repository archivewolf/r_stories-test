sub_reddit=$1
sr=$sub_reddit
base_url=https://www.reddit.com/r/$sub_reddit/

echo $(date +%s) >> $sr.url.txt

getJson() {
  timestamp=$(date +%s);
  if [ -z "$1" ]
  then
    echo "[$timestamp] Initial download...";
    #1 get initial json
    wget -O $sr-$timestamp.json $base_url.json;
  else
    echo "[$timestamp] Downloading next: $1";
    wget -O $sr-$timestamp.json $base_url.json'?count=25&after='$after_tag
  fi
  #2 extract "after" tag
  after_tag=$(cat $sr-$timestamp.json | jq .data.after | sed -e 's/^"//' -e 's/"$//');
  echo "[$timestamp] Extracted: $after_tag";
  #2 extract urls & save to url file
  echo "[$timestamp] Extracting links...";
  for i in {0..26}; do echo $i; cat $sr-$timestamp.json | jq .data.children[$i].data.permalink | sed -e 's/^"//' -e 's/"$//' >> $sr.url.txt; done;
  echo "[$timestamp] Extracted: $after_tag";
  #3 get json with after tag
  getJson $after_tag;
};

getJson
