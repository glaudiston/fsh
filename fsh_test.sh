#!/bin/bash
SCRIPT_DIR=$(dirname $(realpath $0))
. $(dirname $(realpath $BASH_SOURCE))/fsh.sh;

# --- MOCKS (Required for the tests to run) ---
getUser() { echo "user_123"; }
getPet() { echo "dog_456"; }
getPetName() { echo "barker"; }

# --- Test Framework ---
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

PASS_COUNT=0
FAIL_COUNT=0

describe() {
    echo -e "\n${BOLD}${BLUE}➔ $1${NC}"
}

it() {
    local desc=$1
    local cmd=$2
    echo -ne "  ${BOLD}it ${NC}$desc... "

    local result="$($cmd)"
    local expected=$RESULT_EXPECTED

    if [ "$result" == "$expected" ]; then
        echo -e "${GREEN}PASS${NC} ✅"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "${RED}FAIL${NC} ❌"
        echo "    ${RED}Expected:${NC} $expected"
        echo "    ${RED}Actual:  ${NC} $result"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

# --- Test Suite ---

describe "Functional Pipelines"
test_pipeline() {
    # Modified iterate to use a simpler condition that works with the provided iterate()
    # Note: iterate() in fsh.sh uses $1 as the counter
    iterate 0 '[ $1 -lt 5 ]' echo |
    filter ' [ $1 -gt 0 ] ' |
    map ' echo { \"id\": $1, \"s\": $1 } ' |
    sort_json .s desc |
    take 1
}
RESULT_EXPECTED='{ "id": 4, "s": 4 }'
it "should generate, filter, map, and sort numbers" test_pipeline

describe "Monoid & Optional Patterns"
test_optional() {
    echo 1 | runOptional getUser | runOptional getPet | runOptional getPetName
}
RESULT_EXPECTED="barker"
it "should resolve a chain of optional values" test_optional

test_flatmap() {
    echo "a" | flatMap "x" "y"
}
RESULT_EXPECTED="ax
ay"
it "should flatten mapped values" test_flatmap

describe "Logging Monads"
test_logs() {
    # Mock functions for logging
    square() { read v; echo $((v * v)); }
    addOne() { read v; echo $((v + 1)); }
    
    echo 2 | withLogs | runWithLogs square | runWithLogs addOne
}
test_logs_compact() {
    test_logs | jq -c .
}
RESULT_EXPECTED='{"result":5,"logs":["square from 2 to get 4","addOne from 4 to get 5"]}'
it "should track transformations" test_logs_compact
