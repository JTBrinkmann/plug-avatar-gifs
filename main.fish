#! /usr/bin/fish
echo "##########################"
echo "# plug.dj avatar creator #"
echo "##########################"

set avatars (jq 'keys | .[]' -r data.json)
mkdir frames >/dev/null

# explode frames
if false
	echo
	echo == exploding frames
	for avatar in $avatars
		echo - $avatar
		set avatar_data (jq ".[\"$avatar\"][]" -r data.json)
		mkdir frames/$avatar >/dev/null
		convert avatars/{$avatar}b.$avatar_data[2].png -crop 220x220 frames/$avatar/front.png
		convert avatars/{$avatar}dj.$avatar_data[3].png -crop 170x220 frames/$avatar/dj.png
	end

	# converting to gif
	echo
	echo == creating gifs standing
	mkdir standing >/dev/null
	for avatar in $avatars
		echo - $avatar
		convert -delay 180 -page +0+0 -dispose previous  frames/$avatar/front-0.png \
			-delay 10 -page +0+0 -dispose previous  frames/$avatar/front-1.png \
			-delay 10 -page +0+0 -dispose previous  frames/$avatar/front-2.png \
			-delay 10 -page +0+0 -dispose previous  frames/$avatar/front-3.png \
			-loop 0 standing/$avatar.gif
	end
end

echo
echo == creating gifs standing cropped
mkdir standing-cropped >/dev/null
for avatar in $avatars
	echo - $avatar
	convert standing/$avatar.gif -crop 150x150+40+30 standing-cropped/$avatar.gif
end

echo
echo == creating gifs dancing
mkdir dancing >/dev/null
for avatar in $avatars
	echo - $avatar
	convert -delay 10 -loop 0 -page +0+0 -dispose previous  frames/$avatar/front-(seq 4 23).png dancing/$avatar.gif
end

echo
echo == creating gifs DJing
mkdir DJing >/dev/null
for avatar in $avatars
	echo - $avatar
	convert -delay 10 -loop 0 -page +0+0 -dispose previous  frames/$avatar/dj-*.png DJing/$avatar.gif
end