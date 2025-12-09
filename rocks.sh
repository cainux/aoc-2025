#!/bin/sh
eval $(luarocks path)
luarocks install --local lulu
luarocks install --local penlight
