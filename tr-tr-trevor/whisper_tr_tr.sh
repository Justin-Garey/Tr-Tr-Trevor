#!/bin/env sh

model="tiny"
language="English"

while true; do 
	files="$( /bin/ls | tr ' ' '\n' | grep "_processing_" | sort | uniq | head -1)"
	if [ $files ]; then
		echo "There are files to encode. the first is $files"

		oldestfile="$files"
		outfilename="$( echo ${oldestfile} | sed -E 's/[0-9]*_processing_([0-9]*)\.pcm/transcribed_\1/g' )"
		outfileprevious="${outfilename}.msg"
		messagefile="message.txt"

		echo "Encoding . . ."
		ffmpeg -y -f s16le -ar 96k -ac 1 -i ${oldestfile} "tmp.wav" &> /dev/null

		echo "Whispering . . ."
		whisper "tmp.wav" --language ${language} --model ${model} > ${outfilename} 2> /dev/null

		cat ${outfilename} ${outfileprevious} | uniq -u > $messagefile

		echo "Cleaning up . . ."
		rm ${oldestfile}

		echo "Done with ${oldestfile}"
	else
		# echo "Waiting for something to do"
		sleep 5
	fi
done
