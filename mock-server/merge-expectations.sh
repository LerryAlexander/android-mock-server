#!/bin/bash
 cat `find mock-server/mocks/* -name \*.json -type f \( ! -name initializer.json \)` | jq -s 'flatten' > mock-server/initializer.json