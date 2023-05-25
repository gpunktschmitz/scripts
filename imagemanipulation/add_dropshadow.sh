#!/bin/bash

# source: https://blogs.subhamk.com/pages/add_shadow_to_screenshots.html

convert "$1" \( +clone -background black -shadow 57x15+0+13 \) +swap -background transparent -layers merge +repage "$1"
