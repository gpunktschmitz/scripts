#!/bin/bash

# initial source: https://blogs.subhamk.com/pages/add_shadow_to_screenshots.html
# adjustments from: https://stackoverflow.com/a/7136561

convert "$1" \( +clone -background black -shadow 80x3+2+2 \) +swap -background transparent -layers merge +repage "$1"
