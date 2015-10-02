#! /usr/bin/fish
echo "##########################"
echo "# plug.dj avatar creator #"
echo "##########################"

function exists
    type $argv >/dev/null ^/dev/null
end

if not exists convert
    echo "FATAL ERROR: ImageMagick is required! (`convert` not found)"
    exit 1
else if not exists jq
    echo "FATAL ERROR: stedolan's JSON parser is required! (`jq` not found)"
    exit 1
else if not exists gifsicle
    echo "WARNING: Gifsicle is optionally needed to compress the gifs"
end

set avatars (jq 'keys | .[]' -r data.json)
mkdir frames
mkdir standing
mkdir standing-cropped
mkdir DJing
mkdir dancing

echo
for avatar in $avatars
    mkdir frames/$avatar >/dev/null
    set avatar_data (jq ".[\"$avatar\"][]" -r data.json)
    if echo $avatar | grep 'dragon' >/dev/null
        echo - [dragon] $avatar
        rm frames/$avatar/*
        convert avatars/{$avatar}b.$avatar_data[2].png -crop 440x220 frames/$avatar/front.png
        convert avatars/{$avatar}dj.$avatar_data[3].png -crop 340x220 frames/$avatar/dj.png
        convert -delay 180 -page +0+0 -dispose previous  frames/$avatar/front-0.png \
            -delay 10 -page +0+0 -dispose previous  frames/$avatar/front-1.png \
            -delay 10 -page +0+0 -dispose previous  frames/$avatar/front-2.png \
            -delay 10 -page +0+0 -dispose previous  frames/$avatar/front-3.png \
            -loop 0 standing/$avatar.gif
        convert standing/$avatar.gif -crop 150x150+175+40 +repage standing-cropped/$avatar.gif
        convert -delay 10 -loop 0 -page +0+0 -dispose previous  frames/$avatar/front-(seq 4 23).png dancing/$avatar.gif
        convert -delay 10 -loop 0 -page +0+0 -dispose previous  frames/$avatar/dj-*.png DJing/$avatar.gif

    else if echo $avatar | grep '\-e01' >/dev/null
        echo - [epic] $avatar
        rm frames/$avatar/*
        convert avatars/{$avatar}b.$avatar_data[2].png -crop 220x220 frames/$avatar/front.png
        convert avatars/{$avatar}dj.$avatar_data[3].png -crop 220x275 frames/$avatar/dj.png
        convert -delay 180 -page +0+0 -dispose previous  frames/$avatar/front-0.png \
          -delay 10 -page +0+0 -dispose previous  frames/$avatar/front-1.png \
          -delay 10 -page +0+0 -dispose previous  frames/$avatar/front-2.png \
          -delay 10 -page +0+0 -dispose previous  frames/$avatar/front-3.png \
          -loop 0 standing/$avatar.gif
        if echo $avatar | grep diner-e01 >/dev/null
            convert standing/$avatar.gif -crop 150x150+35+40 +repage standing-cropped/$avatar.gif
        else
            convert standing/$avatar.gif -crop 150x150+35+20 +repage standing-cropped/$avatar.gif
        end
        convert -delay 10 -loop 0 -page +0+0 -dispose previous  frames/$avatar/front-(seq 4 23).png dancing/$avatar.gif
        convert -delay 10 -loop 0 -page +0+0 -dispose previous  frames/$avatar/dj-*.png DJing/$avatar.gif

    else #if false
        echo - $avatar
        convert avatars/{$avatar}b.$avatar_data[2].png -crop 220x220 frames/$avatar/front.png
        convert avatars/{$avatar}dj.$avatar_data[3].png -crop 170x220 frames/$avatar/dj.png
        convert -delay 180 -page +0+0 -dispose previous  frames/$avatar/front-0.png \
            -delay 10 -page +0+0 -dispose previous  frames/$avatar/front-1.png \
            -delay 10 -page +0+0 -dispose previous  frames/$avatar/front-2.png \
            -delay 10 -page +0+0 -dispose previous  frames/$avatar/front-3.png \
            -loop 0 standing/$avatar.gif
        convert standing/$avatar.gif -crop 150x150+35+30 +repage standing-cropped/$avatar.gif
        convert -delay 0 -loop 0 -page +0+0 -dispose previous  frames/$avatar/front-(seq 4 23).png dancing/$avatar.gif
        convert -delay 10 -loop 0 -page +0+0 -dispose previous  frames/$avatar/dj-*.png DJing/$avatar.gif
    end
end


# old avatars
echo == old avatars
pushd old
set avatars animal0(seq 1 9) animal1(seq 0 4) lucha0(seq 1 8) monster0(seq 1 5) revolvr space0(seq 1 6) su01 su02 tastycat tastycat02 warrior0(seq 1 4)
mkdir frames
mkdir DJing
mkdir dancing

echo
echo $avatars
echo
for avatar in $avatars
    echo - $avatar
    mkdir frames/$avatar >/dev/null
    convert avatars/{$avatar}.*.png -crop 150x150 frames/$avatar/front.png
    convert -delay 10 -loop 0 -page +0+0 -dispose previous  frames/$avatar/front-(seq 1 10).png dancing/$avatar.gif

    convert avatars/{$avatar}dj.*.png -crop 170x220 frames/$avatar/dj.png
    convert -delay 10 -loop 0 -page +0+0 -dispose previous  frames/$avatar/dj-(seq 1 10).png DJing/$avatar.gif
end
popd

echo == optimizing
if exists gifsicle
    for avatar in standing/* standing-cropped/* dancing/* DJing/* old/dancing/* old/DJing/*
        gifsicle -O2 $avatar -o $avatar
    end
else
    echo "skipping (gifsicle missing)"
end