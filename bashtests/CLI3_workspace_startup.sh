#!/bin/bash
# project startup

if [[ ! -d "~/workspace/assets" ]]; then
	mkdir ~/workspace/assets ~/workspace/assets/img
	touch ~/workspace/assets/img/logo.png
fi
if [[ ! -d "~/workspace/css" ]]; then
	mkdir ~/workspace/css
	touch ~/workspace/css/styles.css
fi
if [[ ! -f "~/workspace/index.html" ]]; then
	touch ~/workspace/index.html
fi
if [[ ! -d "~/workspace/test-website" ]]; then
	mkdir ~/workspace/test-website ~/workspace/test-website/img
	touch ~/workspace/test-website/img/logo.png ~/workspace/test-website/index.html
fi
