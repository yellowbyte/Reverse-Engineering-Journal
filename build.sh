#!/bin/bash

pushd .tests/
py.test test_links.py
popd
