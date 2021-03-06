#!/bin/bash
#
# Wrapper script to run all 3 phases of downloading, analyzing, and 
# inserting tweets into Splunk.
#


# Errors are fatal
set -e

if test ! "$1"
then
	echo "! "
	echo "! Syntax: $0 username"
	echo "! "
	echo "! Specify a Twitter username to download and analyize Tweets from."
	echo "! "
	echo "! NOTE: The username IS case-sensitive!"
	echo "! "
	exit 1
fi


USERNAME=$1


./0-fetch-tweets -u $USERNAME -n 3200
./1-analyze-sentiment -u $USERNAME -n 3200

#
# Delete all existing Splunk events for this user.
# Obviously, this is specific to my Mac.
#
echo "# "
echo "# Deleting all Splunk events for this user..."
echo "# "
/Applications/Splunk/bin/splunk search "index=main sourcetype=twitter username=${USERNAME} |delete"

./2-ingest-into-splunk -u $USERNAME


