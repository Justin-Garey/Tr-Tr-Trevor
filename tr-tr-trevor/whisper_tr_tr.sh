#!/bin/env sh

model="tiny"
language="English"

while true; do 
	files="$( /bin/ls | grep "_processing_" | sort -r )"
	if [[ $files ]]; then
		echo "There are files to encode."

		oldestfile="$( echo ${files} | head -1 )"
		outfilename="$( echo ${oldestfile} | sed -E 's/[0-9]*_processing_([0-9]*)/transcribed_\1/g' )"

		echo "Encoding . . ."
		ffmpeg -y -f s16le -ar 96k -ac 1 -i ${oldestfile} "tmp.wav"

		echo "Whispering . . ."
		whisper "tmp.wav" --language ${language} --model ${model} >> "${outfilename}"

		echo "Cleaning up . . ."
		rm ${oldestfile}

		echo "Done with ${oldestfile}"
	else
		echo "Waiting for something to do"
		sleep 5
	fi
done
